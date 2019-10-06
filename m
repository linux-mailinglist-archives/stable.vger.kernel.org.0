Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43B1CD054
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 12:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfJFKTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 06:19:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39799 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbfJFKTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 06:19:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 830BA20CB2;
        Sun,  6 Oct 2019 06:19:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 06 Oct 2019 06:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ladBD/
        dcraNLTZW85m6P2C8YePcHzvQDPpJmVC4Of10=; b=tZdH9KCHDXzC6uJ2gWT0wy
        lpbMKJjZWF5w6rKZP2KT0sGv1iIuzh+0aal++CcMhU33y1hu8tUXPwgdAsgBDgY6
        TcTLstVY6XaZKj8vxluxlG3DLo8CTLx7oovJDnE+KwMCLWI9Uil8RMgj/CwM0seK
        3KV+t6rVjfZLu+iwsUGshrxSvkYaRNlvP71MGGNGG1BEgMLXBtz8rWC6xj7HylUv
        TjVqDGTtO3QrFdPCzP9uRBjpdDJtB6JARTPJpmDKz5QEEvjYPRyucF7d1jVS8nPA
        4TpIUDwp861xfx7f4eQ+m4EIc18rKFgWMVKjlism/4WwpM8UE9UbBSlGl7OY9p7w
        ==
X-ME-Sender: <xms:x7-ZXdRA9Skxn9IUsxe678zRhHxNBiT4-Rea0Euwun0Rf8MyA5z3TA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheehgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:x7-ZXbAHQHKkZuF-Fu6Lk8_MZ9Ch1R6XA4nDub7O-KOGoZMX8Rd7RQ>
    <xmx:x7-ZXd1SFqTswthwPzFzDqHAt_kAfiKSfj73P-7J6X6cIVo6oYtuDA>
    <xmx:x7-ZXZXfrgRVU5edd10-K6x7q9af2oDGNiH2j-E0E2Xkr909ofQk7g>
    <xmx:x7-ZXV2O22Snyr-zfTZsINvtRTtZyjshK1Cyp9o0Nzhz8xmT2MM7-A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9DD198005C;
        Sun,  6 Oct 2019 06:19:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ovl: filter of trusted xattr results in audit" failed to apply to 3.18-stable tree
To:     salyzyn@android.com, mszeredi@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Oct 2019 12:19:49 +0200
Message-ID: <1570357189135205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 3.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c2e9f346b815841f9bed6029ebcb06415caf640 Mon Sep 17 00:00:00 2001
From: Mark Salyzyn <salyzyn@android.com>
Date: Thu, 29 Aug 2019 11:30:14 -0700
Subject: [PATCH] ovl: filter of trusted xattr results in audit

When filtering xattr list for reading, presence of trusted xattr
results in a security audit log.  However, if there is other content
no errno will be set, and if there isn't, the errno will be -ENODATA
and not -EPERM as is usually associated with a lack of capability.
The check does not block the request to list the xattrs present.

Switch to ns_capable_noaudit to reflect a more appropriate check.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: linux-security-module@vger.kernel.org
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org # v3.18+
Fixes: a082c6f680da ("ovl: filter trusted xattr for non-admin")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7663aeb85fa3..bc14781886bf 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -383,7 +383,8 @@ static bool ovl_can_list(const char *s)
 		return true;
 
 	/* Never list trusted.overlay, list other trusted for superuser only */
-	return !ovl_is_private_xattr(s) && capable(CAP_SYS_ADMIN);
+	return !ovl_is_private_xattr(s) &&
+	       ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
 }
 
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)

