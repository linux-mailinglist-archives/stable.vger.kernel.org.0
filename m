Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78F429BC54
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802409AbgJ0PsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758183AbgJ0PS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:18:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D39020728;
        Tue, 27 Oct 2020 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811906;
        bh=bTbXeaSUUJjjNZ3irmxSRiAwKGJsYIbIChZWk9p/miQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcqXUV99ga0/QLvuFXoxqu+U2trjn4rtfymYFoLyMIi/g2kT0p8aQc0JE7JdwQ0x6
         iKzLoLw5zwmSubS+v/Qy9GiX6qmnfyg4QzxNFkgDNtG6EegaxHB6ErYvi4P8LeFFcU
         tV4+YdYVO5BzKGMKVTVEOLWHHPp2nWjULuc6aXyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 007/757] mptcp: subflows garbage collection
Date:   Tue, 27 Oct 2020 14:44:17 +0100
Message-Id: <20201027135450.868591758@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0e4f35d7880157ceccf0a58377d778b02762af82 ]

The msk can close MP_JOIN subflows if the initial handshake
fails. Currently such subflows are kept alive in the
conn_list until the msk itself is closed.

Beyond the wasted memory, we could end-up sending the
DATA_FIN and the DATA_FIN ack on such socket, even after a
reset.

Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   17 +++++++++++++++++
 net/mptcp/protocol.h |    1 +
 net/mptcp/subflow.c  |    6 ++++++
 3 files changed, 24 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1383,6 +1383,20 @@ static void pm_work(struct mptcp_sock *m
 	spin_unlock_bh(&msk->pm.lock);
 }
 
+static void __mptcp_close_subflow(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow, *tmp;
+
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		if (inet_sk_state_load(ssk) != TCP_CLOSE)
+			continue;
+
+		__mptcp_close_ssk((struct sock *)msk, ssk, subflow, 0);
+	}
+}
+
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -1400,6 +1414,9 @@ static void mptcp_worker(struct work_str
 	mptcp_clean_una(sk);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
+	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		__mptcp_close_subflow(msk);
+
 	__mptcp_move_skbs(msk);
 
 	if (msk->pm.status)
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -90,6 +90,7 @@
 #define MPTCP_WORK_RTX		2
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
+#define MPTCP_WORK_CLOSE_SUBFLOW 5
 
 struct mptcp_options_received {
 	u64	sndr_key;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -272,9 +272,15 @@ static bool subflow_thmac_valid(struct m
 
 void mptcp_subflow_reset(struct sock *ssk)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct sock *sk = subflow->conn;
+
 	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
+	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
+	    schedule_work(&mptcp_sk(sk)->work))
+		sock_hold(sk);
 }
 
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)


