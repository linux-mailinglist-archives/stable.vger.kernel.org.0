Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E70C69CD98
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjBTNut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjBTNus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5AD1E1F0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF4F760E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9539BC433D2;
        Mon, 20 Feb 2023 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901046;
        bh=g848u4o9ncfEAR5peV39K3nG38LS/yOUM1fz5v5wUVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnuXKG3z8gtlEPi8/3COnqGuvMx5Mo16wB5F7V5H68rS22kCbL+sAzPhUieIGBLl5
         VQFXlOcB2rO9DuKKcoX5qiHPEjCfnQm4oAXOml82GHDrgjI936GfGptPpYDWmChtpP
         +emZ7mHOBm/TRtw9plfi7bgXDulsJreze0PaOL+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/83] mptcp: fix locking for in-kernel listener creation
Date:   Mon, 20 Feb 2023 14:35:34 +0100
Message-Id: <20230220133553.718260408@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit ad2171009d968104ccda9dc517f5a3ba891515db ]

For consistency, in mptcp_pm_nl_create_listen_socket(), we need to
call the __mptcp_nmpc_socket() under the msk socket lock.

Note that as a side effect, mptcp_subflow_create_socket() needs a
'nested' lockdep annotation, as it will acquire the subflow (kernel)
socket lock under the in-kernel listener msk socket lock.

The current lack of locking is almost harmless, because the relevant
socket is not exposed to the user space, but in future we will add
more complexity to the mentioned helper, let's play safe.

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 10 ++++++----
 net/mptcp/subflow.c    |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2b1b40199c617..3a1e8f2388665 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -891,8 +891,8 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 {
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
-	struct mptcp_sock *msk;
 	struct socket *ssock;
+	struct sock *newsk;
 	int backlog = 1024;
 	int err;
 
@@ -901,13 +901,15 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (err)
 		return err;
 
-	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk) {
+	newsk = entry->lsk->sk;
+	if (!newsk) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	ssock = __mptcp_nmpc_socket(msk);
+	lock_sock(newsk);
+	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
+	release_sock(newsk);
 	if (!ssock) {
 		err = -EINVAL;
 		goto out;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 15dbaa202c7cf..b0e9548f00bf1 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1570,7 +1570,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	if (err)
 		return err;
 
-	lock_sock(sf->sk);
+	lock_sock_nested(sf->sk, SINGLE_DEPTH_NESTING);
 
 	/* the newly created socket has to be in the same cgroup as its parent */
 	mptcp_attach_cgroup(sk, sf->sk);
-- 
2.39.0



