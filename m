Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF042B437
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 14:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfE0ME6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 08:04:58 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60657 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726724AbfE0MEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 08:04:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A36BD571;
        Mon, 27 May 2019 08:04:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 27 May 2019 08:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xi5ehs
        +ghYk0vf8y5ui7ECFw0nKsIw6Tv6T/mnIqg0k=; b=ZnrREfCXPzsIhzsAmF6mqz
        CX6pCzRBIhlQ6MwKFSi/IwwVG40xWJmCeOIJU+aBfIH83ZJsv1Fo017dZiYmApqr
        K8e+lgoj6uRerYnCs/mENGRpPYhBqqynQ536+wy+qhagbyjdZop3XP109ODuwXJN
        A+QAzPl1fUGdsF9i5FwWpSle6qCYFHT2rCcXzYIKfmEkx6RUF8Dg6Px2sY9HxXn2
        s2TzzaUOiwYUpggBKtOIZradyda/W136zzH2XeC0yk3VAIF+kCjQHoNsF06yazx4
        uSVxu7uFcQrd2WysM7QTlOnk37UM+IWQ6LOtAt2qIlKgbQHqaTTuwbNZplIvz/Bg
        ==
X-ME-Sender: <xms:PtLrXBSVU8MpJt-SUVyF_3m1nlMPMw9KZGeEXxgCgefpnP6oZrbCFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepke
X-ME-Proxy: <xmx:PtLrXOeyZwAsOrSrW66O7dVqakMcRLapwctooe3Wz9w0FrLzy0n4PQ>
    <xmx:PtLrXAoRmt4G_9_LrGgClJML1-OG_or_0Gu-armAol_u79GF4ZDaBA>
    <xmx:PtLrXP-sDXiKLd5QQoi8XUDqqwEtwvaB8su7MED1uDvPd8O8QmfzgQ>
    <xmx:PtLrXInJf2nFd65IDC2DA38ZTnmbyVzWvEg-I8nyRDmqXtzn767Ydg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB656380085;
        Mon, 27 May 2019 08:04:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] selinux: do not report error on connect(AF_UNSPEC)" failed to apply to 5.0-stable tree
To:     pabeni@redhat.com, paul@paul-moore.com, tdeseyn@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 14:04:02 +0200
Message-ID: <1558958642101119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05174c95b83f8aca0c47b87115abb7a6387aafa5 Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 10 May 2019 19:12:33 +0200
Subject: [PATCH] selinux: do not report error on connect(AF_UNSPEC)

calling connect(AF_UNSPEC) on an already connected TCP socket is an
established way to disconnect() such socket. After commit 68741a8adab9
("selinux: Fix ltp test connect-syscall failure") it no longer works
and, in the above scenario connect() fails with EAFNOSUPPORT.

Fix the above explicitly early checking for AF_UNSPEC family, and
returning success in that case.

Reported-by: Tom Deseyn <tdeseyn@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
Suggested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c61787b15f27..3ec702cf46ca 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4637,6 +4637,14 @@ static int selinux_socket_connect_helper(struct socket *sock,
 	err = sock_has_perm(sk, SOCKET__CONNECT);
 	if (err)
 		return err;
+	if (addrlen < offsetofend(struct sockaddr, sa_family))
+		return -EINVAL;
+
+	/* connect(AF_UNSPEC) has special handling, as it is a documented
+	 * way to disconnect the socket
+	 */
+	if (address->sa_family == AF_UNSPEC)
+		return 0;
 
 	/*
 	 * If a TCP, DCCP or SCTP socket, check name_connect permission
@@ -4657,8 +4665,6 @@ static int selinux_socket_connect_helper(struct socket *sock,
 		 * need to check address->sa_family as it is possible to have
 		 * sk->sk_family = PF_INET6 with addr->sa_family = AF_INET.
 		 */
-		if (addrlen < offsetofend(struct sockaddr, sa_family))
-			return -EINVAL;
 		switch (address->sa_family) {
 		case AF_INET:
 			addr4 = (struct sockaddr_in *)address;

