Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE49B694476
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBML3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBML3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:29:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546D283DE
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:28:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D025B80E8E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 11:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA80C433D2;
        Mon, 13 Feb 2023 11:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676287734;
        bh=cV8ZV6OgR61zRsef9MBHQWqqMD8Nnsg5MPT6Jijpl/0=;
        h=Subject:To:Cc:From:Date:From;
        b=LiNbYgELms3rCH+0VR6359RQ2CLY3s1FEVbueZ2kZ41PrDs1/muUXAGlOd4RVuoTM
         9juDO6qxbTWunqQ9VIrhhXXZ3lzoP84ZcKTLrNc8tMnfYe2/NkkJfSWfD08ZEKYOOT
         SZ2kqkCO1mohxb4CbFdR3XS/Pw9GlsORKFNH3vNc=
Subject: FAILED: patch "[PATCH] mptcp: fix locking for in-kernel listener creation" failed to apply to 6.1-stable tree
To:     pabeni@redhat.com, davem@davemloft.net,
        matthieu.baerts@tessares.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 12:28:52 +0100
Message-ID: <167628773212369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ad2171009d96 ("mptcp: fix locking for in-kernel listener creation")
976d302fb616 ("mptcp: deduplicate error paths on endpoint creation")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ad2171009d968104ccda9dc517f5a3ba891515db Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 7 Feb 2023 14:04:15 +0100
Subject: [PATCH] mptcp: fix locking for in-kernel listener creation

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

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2ea7eae43bdb..10fe9771a852 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -998,8 +998,8 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 {
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
-	struct mptcp_sock *msk;
 	struct socket *ssock;
+	struct sock *newsk;
 	int backlog = 1024;
 	int err;
 
@@ -1008,11 +1008,13 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (err)
 		return err;
 
-	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk)
+	newsk = entry->lsk->sk;
+	if (!newsk)
 		return -EINVAL;
 
-	ssock = __mptcp_nmpc_socket(msk);
+	lock_sock(newsk);
+	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
+	release_sock(newsk);
 	if (!ssock)
 		return -EINVAL;
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ec54413fb31f..a3e5026bee5b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1679,7 +1679,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 	if (err)
 		return err;
 
-	lock_sock(sf->sk);
+	lock_sock_nested(sf->sk, SINGLE_DEPTH_NESTING);
 
 	/* the newly created socket has to be in the same cgroup as its parent */
 	mptcp_attach_cgroup(sk, sf->sk);

