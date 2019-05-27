Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB55D2B402
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 14:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfE0MEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 08:04:06 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51261 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfE0MEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 08:04:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0B81455F;
        Mon, 27 May 2019 08:04:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 May 2019 08:04:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=edOdIY
        VMHeUDE6LVrcw0ELEXBHtC3ackiM/D2Eni6V4=; b=PXsbdh36yH31VAnEJlXPuO
        H9eqmp1GVP8tDQRHFWwu6Yvu8B9ly5K20oph9MhraVRfWL3ps3ETrw9BWYUYJmTw
        808cGo8lMxvot7mfMDTxoFfBYsB7p1rGQ+iAZ0KZQAySjnSSRJafW39pgCKbUp+6
        14yr5dNyQzuWb4vrqCHyQ8EKItvtQHXPtLa1WHjC7PPMnsXOiELZbz0174phHrHR
        pl5XwPSjLv5o/69eGkewpV36qYn66qSZjGKFOWDOclmFd/ATrIKDWqlFmTZfpSGo
        mazXa5WPtDehDpRj9NxgOUib84XmMK9x5lAlayX3GS4x3RI9CbtsSNOXGNPVLlcA
        ==
X-ME-Sender: <xms:NNLrXMZJhpRZmugoGRlzxBLllIK78pa7VqmwiZRk91lm1SwWuQQrwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepie
X-ME-Proxy: <xmx:NNLrXO85bHRaZ-DdJLBLlFshVLFuOKT7TSusuESRllgiuSv7ayuTMg>
    <xmx:NNLrXJN7gBoVMewUeK0oUzK75RCDr0mUG_4Osr_OJc0oEzmKmLArNA>
    <xmx:NNLrXBRQOsV0-uDAfnDCnTucpLE10ZFF1kYOZUHiig6LZ0l1OQkvzg>
    <xmx:NNLrXAg3O7zncn22Ko657KzAAd9J2eEGYic2QHgD95ePvhpkVZDiQQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D1AB80062;
        Mon, 27 May 2019 08:04:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] selinux: do not report error on connect(AF_UNSPEC)" failed to apply to 5.1-stable tree
To:     pabeni@redhat.com, paul@paul-moore.com, tdeseyn@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 May 2019 14:04:01 +0200
Message-ID: <155895864122599@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
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

