Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62571574B4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgBJMf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgBJMfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:25 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09C7724680;
        Mon, 10 Feb 2020 12:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338125;
        bh=+67AOZnVfdIJWZiAg1xe49VtFLE3pLReAXONsLs8af4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBqLQ7G0HuXVhOVt0DMl6VCjyjNUZPBUHTbT4SNdh9wu7e38V4npRKoC50daiAEWh
         KwtuSaO7w6xq0XLRVZ/tudzZU9RBtiu3Tx61rh+AhoYeUOWBW43M95C5B3PNjXRFTa
         WeoyN5nCwC1gxTO5Y3WDdRpMKRfjLz/7a1bQzQrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.19 064/195] ubifs: Reject unsupported ioctl flags explicitly
Date:   Mon, 10 Feb 2020 04:32:02 -0800
Message-Id: <20200210122312.110055682@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

commit 2fe8b2d5578d7d142982e3bf62e4c0caf8b8fe02 upstream.

Reject unsupported ioctl flags explicitly, so the following command
on a regular ubifs file will fail:
	chattr +d ubifs_file

And xfstests generic/424 will pass.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -28,6 +28,11 @@
 #include <linux/mount.h>
 #include "ubifs.h"
 
+/* Need to be kept consistent with checked flags in ioctl2ubifs() */
+#define UBIFS_SUPPORTED_IOCTL_FLAGS \
+	(FS_COMPR_FL | FS_SYNC_FL | FS_APPEND_FL | \
+	 FS_IMMUTABLE_FL | FS_DIRSYNC_FL)
+
 /**
  * ubifs_set_inode_flags - set VFS inode flags.
  * @inode: VFS inode to set flags for
@@ -169,6 +174,9 @@ long ubifs_ioctl(struct file *file, unsi
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
+		if (flags & ~UBIFS_SUPPORTED_IOCTL_FLAGS)
+			return -EOPNOTSUPP;
+
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~FS_DIRSYNC_FL;
 


