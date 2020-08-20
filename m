Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B8D24B8B4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbgHTLZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbgHTKG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:06:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 066F920738;
        Thu, 20 Aug 2020 10:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917987;
        bh=HJjCP81rywixE/GLZjXGg0JY6wNzwcv1jdYMv2+9i1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmxpLf/BUgKprFx5AAaB+Qy9AdCqozqlGBoB4zHiy8AAEIoGZuHsQHdLzZJFKEpSR
         /3sJOKTjqWkyLc/LlV4+vQAxHZf7uzaB1RF1AyzmtBvtKs0LreAXZegy0hF4RcKZ9+
         9eUwcoVra51stjAYDeis9GfspuK4up9wu57qE7rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.14 014/228] mtd: properly check all write ioctls for permissions
Date:   Thu, 20 Aug 2020 11:19:49 +0200
Message-Id: <20200820091608.243525016@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f7e6b19bc76471ba03725fe58e0c218a3d6266c3 upstream.

When doing a "write" ioctl call, properly check that we have permissions
to do so before copying anything from userspace or anything else so we
can "fail fast".  This includes also covering the MEMWRITE ioctl which
previously missed checking for this.

Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[rw: Fixed locking issue]
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/mtdchar.c |   56 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 9 deletions(-)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -372,9 +372,6 @@ static int mtdchar_writeoob(struct file
 	uint32_t retlen;
 	int ret = 0;
 
-	if (!(file->f_mode & FMODE_WRITE))
-		return -EPERM;
-
 	if (length > 4096)
 		return -EINVAL;
 
@@ -681,6 +678,48 @@ static int mtdchar_ioctl(struct file *fi
 			return -EFAULT;
 	}
 
+	/*
+	 * Check the file mode to require "dangerous" commands to have write
+	 * permissions.
+	 */
+	switch (cmd) {
+	/* "safe" commands */
+	case MEMGETREGIONCOUNT:
+	case MEMGETREGIONINFO:
+	case MEMGETINFO:
+	case MEMREADOOB:
+	case MEMREADOOB64:
+	case MEMLOCK:
+	case MEMUNLOCK:
+	case MEMISLOCKED:
+	case MEMGETOOBSEL:
+	case MEMGETBADBLOCK:
+	case MEMSETBADBLOCK:
+	case OTPSELECT:
+	case OTPGETREGIONCOUNT:
+	case OTPGETREGIONINFO:
+	case OTPLOCK:
+	case ECCGETLAYOUT:
+	case ECCGETSTATS:
+	case MTDFILEMODE:
+	case BLKPG:
+	case BLKRRPART:
+		break;
+
+	/* "dangerous" commands */
+	case MEMERASE:
+	case MEMERASE64:
+	case MEMWRITEOOB:
+	case MEMWRITEOOB64:
+	case MEMWRITE:
+		if (!(file->f_mode & FMODE_WRITE))
+			return -EPERM;
+		break;
+
+	default:
+		return -ENOTTY;
+	}
+
 	switch (cmd) {
 	case MEMGETREGIONCOUNT:
 		if (copy_to_user(argp, &(mtd->numeraseregions), sizeof(int)))
@@ -728,9 +767,6 @@ static int mtdchar_ioctl(struct file *fi
 	{
 		struct erase_info *erase;
 
-		if(!(file->f_mode & FMODE_WRITE))
-			return -EPERM;
-
 		erase=kzalloc(sizeof(struct erase_info),GFP_KERNEL);
 		if (!erase)
 			ret = -ENOMEM;
@@ -1051,9 +1087,6 @@ static int mtdchar_ioctl(struct file *fi
 		ret = 0;
 		break;
 	}
-
-	default:
-		ret = -ENOTTY;
 	}
 
 	return ret;
@@ -1097,6 +1130,11 @@ static long mtdchar_compat_ioctl(struct
 		struct mtd_oob_buf32 buf;
 		struct mtd_oob_buf32 __user *buf_user = argp;
 
+		if (!(file->f_mode & FMODE_WRITE)) {
+			ret = -EPERM;
+			break;
+		}
+
 		if (copy_from_user(&buf, argp, sizeof(buf)))
 			ret = -EFAULT;
 		else


