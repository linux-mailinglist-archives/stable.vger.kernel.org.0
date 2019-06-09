Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA48B3A48F
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfFIJpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:45:41 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:49271 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727979AbfFIJpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 05:45:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3A8202A4;
        Sun,  9 Jun 2019 05:45:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 05:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=z9xanv
        BtZldIUygkecLC4/LMpk3QHvCLySc/Cy1UZxU=; b=itG+bsBCA88HS6fPF33bRJ
        f69PHVCXkM+YNbUUAkKZwycX3zLc98LGYQEfHne4lHTx+7qX7G1E6R4IQMXt7Ms2
        nr1fcaDnmjylurGEPS9ycDC+cLUeUiUEp3oPbGua2l23StKJhDxzZuuHKOAzOViF
        +GJJ+oXpEx4xeqw8FZeUHC+uGNcZGc3+ZnjVUSe6TBr5GqxXOT5xdFZBjO9LusQc
        eAz7PR8cRftAkvS57/BkyZmwaWwNDoudzznm5XnKYqwhxrB2Lv8O73fb4A2zIqVx
        jPeQWPUbU8wExKocUp26MN9pEBqMnLcwMMu5qUC3r+ekh1QLfw9lpjIB6tOfiW1w
        ==
X-ME-Sender: <xms:Q9X8XLIlqTZTqck7cXXKetvwYMEuN_lPsn7itE6EYPmLckMFx9pW0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Q9X8XDbuH_tc-ntWzy9pM3LLSq9LUjiu0ky1nMYiBThqlUP0y5_2aQ>
    <xmx:Q9X8XOvdD8wdM4AZN52aJyADzB4FR_jH8iHSCDTBXGkJmecRkwCv2A>
    <xmx:Q9X8XIuoxZHc6WYTU9G7z2uSjBs9kJ0yipgpE8txZvlofKzWZTdPOQ>
    <xmx:Q9X8XAbCf7jNiqn4zb9UabzuVuG7v3duk7mGBaESHfj7U32GFjAyLA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 386A08005B;
        Sun,  9 Jun 2019 05:45:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls" failed to apply to 4.19-stable tree
To:     amir73il@gmail.com, david@fromorbit.com, mszeredi@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 11:45:29 +0200
Message-ID: <156007352917012@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b21d9c435f935014d3e3fa6914f2e4fbabb0e94d Mon Sep 17 00:00:00 2001
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 26 May 2019 09:28:25 +0300
Subject: [PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls

They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.

This used to work in kernel pre v4.19, before stacked file ops
introduced the ovl_ioctl whitelist.

Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 540a8b845145..340a6ad45914 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -426,7 +426,8 @@ static unsigned int ovl_get_inode_flags(struct inode *inode)
 	return ovl_iflags;
 }
 
-static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
+static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
+				unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
@@ -456,7 +457,7 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned long arg)
 	if (ret)
 		goto unlock;
 
-	ret = ovl_real_ioctl(file, FS_IOC_SETFLAGS, arg);
+	ret = ovl_real_ioctl(file, cmd, arg);
 
 	ovl_copyflags(ovl_inode_real(inode), inode);
 unlock:
@@ -474,11 +475,13 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
+	case FS_IOC_FSGETXATTR:
 		ret = ovl_real_ioctl(file, cmd, arg);
 		break;
 
 	case FS_IOC_SETFLAGS:
-		ret = ovl_ioctl_set_flags(file, arg);
+	case FS_IOC_FSSETXATTR:
+		ret = ovl_ioctl_set_flags(file, cmd, arg);
 		break;
 
 	default:

