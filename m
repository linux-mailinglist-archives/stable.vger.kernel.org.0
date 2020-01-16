Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A956B13FF9C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgAPXYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730066AbgAPXYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BDFD2072E;
        Thu, 16 Jan 2020 23:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217054;
        bh=5jCLxx3Rwe6TZPOs6dpI1oxqJLHtu7QOJCkhfkEuc64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnNiYe5rISY8YEavO/RMvJH2NTr05h9dj9VE5Hjn6fND0TbBlOgGbVtAXPvdLgGTl
         qpDBR5SG4EH/aFJHl8Mxlkzg8WgLsjYPaUhJkVE3jNeKXJcxQN6TyR7sgrR0Zlsjm/
         Ih5MB0jvOnlhd98PrWovMCWwJjnlZYojaAxeMX98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.4 129/203] gfs2: add compat_ioctl support
Date:   Fri, 17 Jan 2020 00:17:26 +0100
Message-Id: <20200116231756.453956408@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 8d0980704842e8a68df2c3164c1c165e5c7ebc08 upstream.

Out of the four ioctl commands supported on gfs2, only FITRIM
works in compat mode.

Add a proper handler based on the ext4 implementation.

Fixes: 6ddc5c3ddf25 ("gfs2: getlabel support")
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -6,6 +6,7 @@
 
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/compat.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
@@ -354,6 +355,31 @@ static long gfs2_ioctl(struct file *filp
 	return -ENOTTY;
 }
 
+#ifdef CONFIG_COMPAT
+static long gfs2_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	switch(cmd) {
+	/* These are just misnamed, they actually get/put from/to user an int */
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+	/* Keep this list in sync with gfs2_ioctl */
+	case FITRIM:
+	case FS_IOC_GETFSLABEL:
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return gfs2_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+}
+#else
+#define gfs2_compat_ioctl NULL
+#endif
+
 /**
  * gfs2_size_hint - Give a hint to the size of a write request
  * @filep: The struct file
@@ -1294,6 +1320,7 @@ const struct file_operations gfs2_file_f
 	.write_iter	= gfs2_file_write_iter,
 	.iopoll		= iomap_dio_iopoll,
 	.unlocked_ioctl	= gfs2_ioctl,
+	.compat_ioctl	= gfs2_compat_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
@@ -1309,6 +1336,7 @@ const struct file_operations gfs2_file_f
 const struct file_operations gfs2_dir_fops = {
 	.iterate_shared	= gfs2_readdir,
 	.unlocked_ioctl	= gfs2_ioctl,
+	.compat_ioctl	= gfs2_compat_ioctl,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
@@ -1325,6 +1353,7 @@ const struct file_operations gfs2_file_f
 	.write_iter	= gfs2_file_write_iter,
 	.iopoll		= iomap_dio_iopoll,
 	.unlocked_ioctl	= gfs2_ioctl,
+	.compat_ioctl	= gfs2_compat_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
@@ -1338,6 +1367,7 @@ const struct file_operations gfs2_file_f
 const struct file_operations gfs2_dir_fops_nolock = {
 	.iterate_shared	= gfs2_readdir,
 	.unlocked_ioctl	= gfs2_ioctl,
+	.compat_ioctl	= gfs2_compat_ioctl,
 	.open		= gfs2_open,
 	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,


