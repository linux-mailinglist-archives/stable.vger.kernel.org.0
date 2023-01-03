Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D91265BBFD
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbjACISJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbjACIRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:17:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FE8E022
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C483E611FA
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA668C433D2;
        Tue,  3 Jan 2023 08:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733836;
        bh=mKQkF8W+cn/u5RKKe6dUctZZYP5RMhBvPQWAL6bU1so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmCTZMKoRu0BJ28YiHFtrfbiiaoDTlxTVVH5ZZ02mEtnC6iB5UIG6jA603AHcGMKi
         vMA75wlRNrktQyf37qOgNwYkM0yXK+MmbhzrVmB7vsTogbDBUXbAptBsxWBO+105No
         4wzPsCem0CJGa27/IQeUMYQElNgXurxLT7Dfu7oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 58/63] net: remove cmsg restriction from io_uring based send/recvmsg calls
Date:   Tue,  3 Jan 2023 09:14:28 +0100
Message-Id: <20230103081312.102177994@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit e54937963fa249595824439dc839c948188dea83 ]

No need to restrict these anymore, as the worker threads are direct
clones of the original task. Hence we know for a fact that we can
support anything that the regular task can.

Since the only user of proto_ops->flags was to flag PROTO_CMSG_DATA_ONLY,
kill the member and the flag definition too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/net.h |    3 ---
 net/ipv4/af_inet.c  |    1 -
 net/ipv6/af_inet6.c |    1 -
 net/socket.c        |   10 ----------
 4 files changed, 15 deletions(-)

--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -42,8 +42,6 @@ struct net;
 #define SOCK_PASSCRED		3
 #define SOCK_PASSSEC		4
 
-#define PROTO_CMSG_DATA_ONLY	0x0001
-
 #ifndef ARCH_HAS_SOCKET_TYPES
 /**
  * enum sock_type - Socket types
@@ -138,7 +136,6 @@ typedef int (*sk_read_actor_t)(read_desc
 
 struct proto_ops {
 	int		family;
-	unsigned int	flags;
 	struct module	*owner;
 	int		(*release)   (struct socket *sock);
 	int		(*bind)	     (struct socket *sock,
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1017,7 +1017,6 @@ static int inet_compat_ioctl(struct sock
 
 const struct proto_ops inet_stream_ops = {
 	.family		   = PF_INET,
-	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet_release,
 	.bind		   = inet_bind,
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -661,7 +661,6 @@ int inet6_recvmsg(struct socket *sock, s
 
 const struct proto_ops inet6_stream_ops = {
 	.family		   = PF_INET6,
-	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
--- a/net/socket.c
+++ b/net/socket.c
@@ -2419,10 +2419,6 @@ static int ___sys_sendmsg(struct socket
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 			unsigned int flags)
 {
-	/* disallow ancillary data requests from this path */
-	if (msg->msg_control || msg->msg_controllen)
-		return -EINVAL;
-
 	return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
 
@@ -2631,12 +2627,6 @@ long __sys_recvmsg_sock(struct socket *s
 			struct user_msghdr __user *umsg,
 			struct sockaddr __user *uaddr, unsigned int flags)
 {
-	if (msg->msg_control || msg->msg_controllen) {
-		/* disallow ancillary data reqs unless cmsg is plain data */
-		if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
-			return -EINVAL;
-	}
-
 	return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
 }
 


