Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E47541302
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357564AbiFGTzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358868AbiFGTxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EB8AFB1B;
        Tue,  7 Jun 2022 11:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C33A7B82368;
        Tue,  7 Jun 2022 18:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3324CC385A2;
        Tue,  7 Jun 2022 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626167;
        bh=+zI6OmQ/T0upi5tdS+NukdBVJYLETxXO2Rr9cGXDaX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvJepqPfEUVShOUirAW0MPD99pDELsDyMvUmHb7OkJUvcPmpiYpe1K+QEOCMnxDJL
         2sTyNiEXE4An4k76wbYFzCYci1DzM3XZUn8A3uUBJPjBhtkwxp7a/1RvUyIfjLCcQb
         T+4NK8mkjq1ZriAke6EciXYzGe7DHuI3MZIZ0JPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 254/772] mptcp: reset the packet scheduler on incoming MP_PRIO
Date:   Tue,  7 Jun 2022 18:57:26 +0200
Message-Id: <20220607164956.509615065@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 43f5b111d1ff16161ce60e19aeddb999cb6f0b01 ]

When an incoming MP_PRIO option changes the backup
status of any subflow, we need to reset the packet
scheduler status, or the next send could keep using
the previously selected subflow, without taking in account
the new priorities.

Reported-by: Davide Caratti <dcaratti@redhat.com>
Fixes: 40453a5c61f4 ("mptcp: add the incoming MP_PRIO support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c       | 19 +++++++++++++++----
 net/mptcp/protocol.c |  2 ++
 net/mptcp/protocol.h |  1 +
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 1eb83cbe8aae..770c4e36c776 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -261,14 +261,25 @@ void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 	spin_unlock_bh(&pm->lock);
 }
 
-void mptcp_pm_mp_prio_received(struct sock *sk, u8 bkup)
+void mptcp_pm_mp_prio_received(struct sock *ssk, u8 bkup)
 {
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct sock *sk = subflow->conn;
+	struct mptcp_sock *msk;
 
 	pr_debug("subflow->backup=%d, bkup=%d\n", subflow->backup, bkup);
-	subflow->backup = bkup;
+	msk = mptcp_sk(sk);
+	if (subflow->backup != bkup) {
+		subflow->backup = bkup;
+		mptcp_data_lock(sk);
+		if (!sock_owned_by_user(sk))
+			msk->last_snd = NULL;
+		else
+			__set_bit(MPTCP_RESET_SCHEDULER,  &msk->cb_flags);
+		mptcp_data_unlock(sk);
+	}
 
-	mptcp_event(MPTCP_EVENT_SUB_PRIORITY, mptcp_sk(subflow->conn), sk, GFP_ATOMIC);
+	mptcp_event(MPTCP_EVENT_SUB_PRIORITY, msk, ssk, GFP_ATOMIC);
 }
 
 void mptcp_pm_mp_fail_received(struct sock *sk, u64 fail_seq)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7e8083d6f033..4a50906f4d8f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3098,6 +3098,8 @@ static void mptcp_release_cb(struct sock *sk)
 			__mptcp_set_connected(sk);
 		if (__test_and_clear_bit(MPTCP_ERROR_REPORT, &msk->cb_flags))
 			__mptcp_error_report(sk);
+		if (__test_and_clear_bit(MPTCP_RESET_SCHEDULER, &msk->cb_flags))
+			msk->last_snd = NULL;
 	}
 
 	__mptcp_update_rmem(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 46b343a0b17e..2ae8276b82fc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -124,6 +124,7 @@
 #define MPTCP_RETRANSMIT	4
 #define MPTCP_FLUSH_JOIN_LIST	5
 #define MPTCP_CONNECTED		6
+#define MPTCP_RESET_SCHEDULER	7
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
-- 
2.35.1



