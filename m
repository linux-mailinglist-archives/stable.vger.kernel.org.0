Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E0769446B
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 12:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjBML2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 06:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjBML2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 06:28:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED131E048
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 03:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9591DB81190
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 11:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD42EC433D2;
        Mon, 13 Feb 2023 11:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676287696;
        bh=901QjL4KT7/F/kPuLl6+CDnXOWUX6vPXrQPBVoIZJus=;
        h=Subject:To:Cc:From:Date:From;
        b=OA0xe5zYcNwFtg5rpoBWCLr5n+x1gx0+tdFH48KhuiuFCQCtlLFDqY1vA4bqYzUlN
         t7cSGTBZU+/3pWsUt78Y+T2LfqCnWXVEf0UeDM/ecZ8aOTuDkKxR5Ndy9zOTfU0/f+
         9XzJFEv5QfT1HJ8jYh8z5eKo6lWE+IUDxU3z01KQ=
Subject: FAILED: patch "[PATCH] mptcp: fix locking for setsockopt corner-case" failed to apply to 6.1-stable tree
To:     pabeni@redhat.com, davem@davemloft.net,
        matthieu.baerts@tessares.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Feb 2023 12:28:13 +0100
Message-ID: <1676287693156237@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

21e43569685d ("mptcp: fix locking for setsockopt corner-case")
d3d429047cc6 ("mptcp: sockopt: make 'tcp_fastopen_connect' generic")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 21e43569685de4ad773fb060c11a15f3fd5e7ac4 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 7 Feb 2023 14:04:14 +0100
Subject: [PATCH] mptcp: fix locking for setsockopt corner-case

We need to call the __mptcp_nmpc_socket(), and later subflow socket
access under the msk socket lock, or e.g. a racing connect() could
change the socket status under the hood, with unexpected results.

Fixes: 54635bd04701 ("mptcp: add TCP_FASTOPEN_CONNECT socket option")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index d4b1e6ec1b36..7f2c3727ab23 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -760,14 +760,21 @@ static int mptcp_setsockopt_v4(struct mptcp_sock *msk, int optname,
 static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
 					  sockptr_t optval, unsigned int optlen)
 {
+	struct sock *sk = (struct sock *)msk;
 	struct socket *sock;
+	int ret = -EINVAL;
 
 	/* Limit to first subflow, before the connection establishment */
+	lock_sock(sk);
 	sock = __mptcp_nmpc_socket(msk);
 	if (!sock)
-		return -EINVAL;
+		goto unlock;
 
-	return tcp_setsockopt(sock->sk, level, optname, optval, optlen);
+	ret = tcp_setsockopt(sock->sk, level, optname, optval, optlen);
+
+unlock:
+	release_sock(sk);
+	return ret;
 }
 
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,

