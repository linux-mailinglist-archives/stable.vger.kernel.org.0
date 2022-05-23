Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFFC531C75
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbiEWRe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbiEWRct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7BD6345;
        Mon, 23 May 2022 10:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 349D6B811FF;
        Mon, 23 May 2022 17:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D36EC385A9;
        Mon, 23 May 2022 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326854;
        bh=BkwxpHcOxOEqZ97C+zcVcrK3VZuqEqDMwOlx6I9X0pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECH6DjmY9fJEYWad2WRO8oqSK7zo2iOAr2bUBI6Ob35wCOTXs0yHVvXAhBAWSaoff
         +nsKixAAKFUxu0pD4e6uuFoG7HMgVX53o588urqZBFpJRCt0I3mXy2zgBvQOEcuw+2
         PlntQvNajMnII2fKvBBSKIx+Px60kbE6zq+SyGQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 079/158] mptcp: fix subflow accounting on close
Date:   Mon, 23 May 2022 19:03:56 +0200
Message-Id: <20220523165844.141773273@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 95d686517884a403412b000361cee2b08b2ed1e6 ]

If the PM closes a fully established MPJ subflow or the subflow
creation errors out in it's early stage the subflows counter is
not bumped accordingly.

This change adds the missing accounting, additionally taking care
of updating accordingly the 'accept_subflow' flag.

Fixes: a88c9e496937 ("mptcp: do not block subflows creation on errors")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c       |  5 ++---
 net/mptcp/protocol.h | 14 ++++++++++++++
 net/mptcp/subflow.c  | 12 +++++++++---
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 7bea318ac5f2..1eb83cbe8aae 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -178,14 +178,13 @@ void mptcp_pm_subflow_check_next(struct mptcp_sock *msk, const struct sock *ssk,
 	struct mptcp_pm_data *pm = &msk->pm;
 	bool update_subflows;
 
-	update_subflows = (ssk->sk_state == TCP_CLOSE) &&
-			  (subflow->request_join || subflow->mp_join);
+	update_subflows = subflow->request_join || subflow->mp_join;
 	if (!READ_ONCE(pm->work_pending) && !update_subflows)
 		return;
 
 	spin_lock_bh(&pm->lock);
 	if (update_subflows)
-		pm->subflows--;
+		__mptcp_pm_close_subflow(msk);
 
 	/* Even if this subflow is not really established, tell the PM to try
 	 * to pick the next ones, if possible.
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 85317ce38e3f..a1c845eb47bd 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -835,6 +835,20 @@ unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk);
 
+/* called under PM lock */
+static inline void __mptcp_pm_close_subflow(struct mptcp_sock *msk)
+{
+	if (--msk->pm.subflows < mptcp_pm_get_subflows_max(msk))
+		WRITE_ONCE(msk->pm.accept_subflow, true);
+}
+
+static inline void mptcp_pm_close_subflow(struct mptcp_sock *msk)
+{
+	spin_lock_bh(&msk->pm.lock);
+	__mptcp_pm_close_subflow(msk);
+	spin_unlock_bh(&msk->pm.lock);
+}
+
 void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_sockopt_sync_locked(struct mptcp_sock *msk, struct sock *ssk);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bea47a1180dc..1d4d84efe8f5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1380,20 +1380,20 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	struct sockaddr_storage addr;
 	int remote_id = remote->id;
 	int local_id = loc->id;
+	int err = -ENOTCONN;
 	struct socket *sf;
 	struct sock *ssk;
 	u32 remote_token;
 	int addrlen;
 	int ifindex;
 	u8 flags;
-	int err;
 
 	if (!mptcp_is_fully_established(sk))
-		return -ENOTCONN;
+		goto err_out;
 
 	err = mptcp_subflow_create_socket(sk, &sf);
 	if (err)
-		return err;
+		goto err_out;
 
 	ssk = sf->sk;
 	subflow = mptcp_subflow_ctx(ssk);
@@ -1456,6 +1456,12 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 failed:
 	subflow->disposable = 1;
 	sock_release(sf);
+
+err_out:
+	/* we account subflows before the creation, and this failures will not
+	 * be caught by sk_state_change()
+	 */
+	mptcp_pm_close_subflow(msk);
 	return err;
 }
 
-- 
2.35.1



