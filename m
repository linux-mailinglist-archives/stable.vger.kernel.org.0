Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2769856FBBC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiGKJew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiGKJd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:33:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5C21055E;
        Mon, 11 Jul 2022 02:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC663B80E76;
        Mon, 11 Jul 2022 09:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49208C34115;
        Mon, 11 Jul 2022 09:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531083;
        bh=eflLSHmdQJmlx3Jr8ZLDE+HE6JQPzKLnL+kk1obFACA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyxAmWIBOYeRgAWd7dNQpGXMr4aNRnrIrLDdbkH5G6Q1qIqCa72IQgQgfMArZRQqj
         LigVBTUFYsXA31dInYjhyUnnz9zry3h0qEwd/usLbJNonasfjEjdYBOzUb9zjQvMNT
         rWKyY2VTB9svAIGYxEyBNg3JlUUOgmQscZEMAOcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 091/112] mptcp: Acquire the subflow socket lock before modifying MP_PRIO flags
Date:   Mon, 11 Jul 2022 11:07:31 +0200
Message-Id: <20220711090552.154216495@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

[ Upstream commit a657430260e5437df16004c8c317821d946b5ead ]

When setting up a subflow's flags for sending MP_PRIO MPTCP options, the
subflow socket lock was not held while reading and modifying several
struct members that are also read and modified in mptcp_write_options().

Acquire the subflow socket lock earlier and send the MP_PRIO ACK with
that lock already acquired. Add a new variant of the
mptcp_subflow_send_ack() helper to use with the subflow lock held.

Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 5 ++++-
 net/mptcp/protocol.c   | 9 +++++++--
 net/mptcp/protocol.h   | 1 +
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 88077ea02ed3..3384569f73b8 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -721,11 +721,13 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct mptcp_addr_info local;
+		bool slow;
 
 		local_address((struct sock_common *)ssk, &local);
 		if (!addresses_equal(&local, addr, addr->port))
 			continue;
 
+		slow = lock_sock_fast(ssk);
 		if (subflow->backup != bkup)
 			msk->last_snd = NULL;
 		subflow->backup = bkup;
@@ -733,7 +735,8 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		subflow->request_bkup = bkup;
 
 		pr_debug("send ack for mp_prio");
-		mptcp_subflow_send_ack(ssk);
+		__mptcp_subflow_send_ack(ssk);
+		unlock_sock_fast(ssk, slow);
 
 		return 0;
 	}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 713077eef04a..b0fb1fc0bd4a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -506,13 +506,18 @@ static bool tcp_can_send_ack(const struct sock *ssk)
 	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE | TCPF_LISTEN));
 }
 
+void __mptcp_subflow_send_ack(struct sock *ssk)
+{
+	if (tcp_can_send_ack(ssk))
+		tcp_send_ack(ssk);
+}
+
 void mptcp_subflow_send_ack(struct sock *ssk)
 {
 	bool slow;
 
 	slow = lock_sock_fast(ssk);
-	if (tcp_can_send_ack(ssk))
-		tcp_send_ack(ssk);
+	__mptcp_subflow_send_ack(ssk);
 	unlock_sock_fast(ssk, slow);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2aab5aff6bcd..ad36a05aa67d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -584,6 +584,7 @@ void __init mptcp_subflow_init(void);
 void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
+void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_subflow_queue_clean(struct sock *ssk);
-- 
2.35.1



