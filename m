Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4222694478
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBML3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjBML3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:29:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4574EF4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45E2ACE1720
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 11:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D4FC433EF;
        Mon, 13 Feb 2023 11:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676287744;
        bh=b1OFo/vdkUN1TZLtBR9BeeTYMRx7FP3mZF3unlC7dxs=;
        h=Subject:To:Cc:From:Date:From;
        b=RXT1WXilKtg/f8SjYuTy93RBvTx0f+4QnX3UM91rCl63uQ3qyz5iuVBUcYs7FPG/r
         ItTcWAdWOz7Q31vVilWusqCBaAB/cRUKQfhpylRi5PhRB+aShGC1PkUnaXINyziWSi
         RKBLzLo7X5b9BrxWNPJ63kYTIdNQ9ASRGx2vN8Fg=
Subject: FAILED: patch "[PATCH] mptcp: fix locking for in-kernel listener creation" failed to apply to 5.15-stable tree
To:     pabeni@redhat.com, davem@davemloft.net,
        matthieu.baerts@tessares.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 12:28:53 +0100
Message-ID: <1676287733201145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ad2171009d96 ("mptcp: fix locking for in-kernel listener creation")
976d302fb616 ("mptcp: deduplicate error paths on endpoint creation")
3eb9a6b6503c ("mptcp: account memory allocation in mptcp_nl_cmd_add_addr() to user")
d045b9eb95a9 ("mptcp: introduce implicit endpoints")
33397b83eee6 ("selftests: mptcp: add backup with port testcase")
09f12c3ab7a5 ("mptcp: allow to use port and non-signal in set_flags")
6a0653b96f5d ("selftests: mptcp: add fullmesh setting tests")
327b9a94e2a8 ("selftests: mptcp: more stable join tests-cases")

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

