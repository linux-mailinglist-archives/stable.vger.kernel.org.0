Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805D329B609
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796553AbgJ0PT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796551AbgJ0PTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37932064B;
        Tue, 27 Oct 2020 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811963;
        bh=s2phftmKQIlEEG4cQmP/dhj5SXlMPIO0hqcEuT0/oa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1dadHtoPqUv8HCit0zv/fNf3m3zzmDY1ZNDbpiYSvBBAdTV/Grq5uwEhQ591eX2l
         ILNIFljijBygZ1VQJiHjP/EO6C8E8LgkX2dzfQMp/XuKr41bjx9ybTp4B47Q8n9Ulb
         9bhlvRqtHdg1wiqvWKezWy9x46rL0VKxZbY2ZRPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 013/757] net: mptcp: make DACK4/DACK8 usage consistent among all subflows
Date:   Tue, 27 Oct 2020 14:44:23 +0100
Message-Id: <20201027135451.150922855@linuxfoundation.org>
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

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 37198e93ced70733f0b993dff28b7c33857e254f ]

using packetdrill it's possible to observe the same MPTCP DSN being acked
by different subflows with DACK4 and DACK8. This is in contrast with what
specified in RFC8684 §3.3.2: if an MPTCP endpoint transmits a 64-bit wide
DSN, it MUST be acknowledged with a 64-bit wide DACK. Fix 'use_64bit_ack'
variable to make it a property of MPTCP sockets, not TCP subflows.

Fixes: a0c1d0eafd1e ("mptcp: Use 32-bit DATA_ACK when possible")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |    2 +-
 net/mptcp/protocol.h |    2 +-
 net/mptcp/subflow.c  |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -516,7 +516,7 @@ static bool mptcp_established_options_ds
 		return ret;
 	}
 
-	if (subflow->use_64bit_ack) {
+	if (READ_ONCE(msk->use_64bit_ack)) {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
 		opts->ext_copy.data_ack = READ_ONCE(msk->ack_seq);
 		opts->ext_copy.ack64 = 1;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -203,6 +203,7 @@ struct mptcp_sock {
 	bool		fully_established;
 	bool		rcv_data_fin;
 	bool		snd_data_fin_enable;
+	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct list_head conn_list;
@@ -295,7 +296,6 @@ struct mptcp_subflow_context {
 		backup : 1,
 		data_avail : 1,
 		rx_eof : 1,
-		use_64bit_ack : 1, /* Set when we received a 64-bit DSN */
 		can_ack : 1;	    /* only after processing the remote a key */
 	u32	remote_nonce;
 	u64	thmac;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -781,12 +781,11 @@ static enum mapping_status get_mapping_s
 	if (!mpext->dsn64) {
 		map_seq = expand_seq(subflow->map_seq, subflow->map_data_len,
 				     mpext->data_seq);
-		subflow->use_64bit_ack = 0;
 		pr_debug("expanded seq=%llu", subflow->map_seq);
 	} else {
 		map_seq = mpext->data_seq;
-		subflow->use_64bit_ack = 1;
 	}
+	WRITE_ONCE(mptcp_sk(subflow->conn)->use_64bit_ack, !!mpext->dsn64);
 
 	if (subflow->map_valid) {
 		/* Allow replacing only with an identical map */


