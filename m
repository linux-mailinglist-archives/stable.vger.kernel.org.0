Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33F24086D
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHJPVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgHJPVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:21:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060D92075D;
        Mon, 10 Aug 2020 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072861;
        bh=Nn+bQBHPyRbZAZycSa5N0hcKvQctVS7s3iooCst5c9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8FM7LNmKXNofWeNkh/Wiph+cKP/JG7q81PrLF2u5ubWPpXwMIsXi1ShPXvmNt6oY
         8PvV8zv9zodJ72VrIW9csrr/JcgQiLP5lB79Bgdy0wrahYBJUIC7JfcMUFDZEl/QPP
         W4n2RJKiyBiTLXDeEvmPtsnGxBGBOotPusObsLbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.8 24/38] mtd: properly check all write ioctls for permissions
Date:   Mon, 10 Aug 2020 17:19:14 +0200
Message-Id: <20200810151805.080238265@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
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
@@ -355,9 +355,6 @@ static int mtdchar_writeoob(struct file
 	uint32_t retlen;
 	int ret = 0;
 
-	if (!(file->f_mode & FMODE_WRITE))
-		return -EPERM;
-
 	if (length > 4096)
 		return -EINVAL;
 
@@ -643,6 +640,48 @@ static int mtdchar_ioctl(struct file *fi
 
 	pr_debug("MTD_ioctl\n");
 
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
@@ -690,9 +729,6 @@ static int mtdchar_ioctl(struct file *fi
 	{
 		struct erase_info *erase;
 
-		if(!(file->f_mode & FMODE_WRITE))
-			return -EPERM;
-
 		erase=kzalloc(sizeof(struct erase_info),GFP_KERNEL);
 		if (!erase)
 			ret = -ENOMEM;
@@ -985,9 +1021,6 @@ static int mtdchar_ioctl(struct file *fi
 		ret = 0;
 		break;
 	}
-
-	default:
-		ret = -ENOTTY;
 	}
 
 	return ret;
@@ -1031,6 +1064,11 @@ static long mtdchar_compat_ioctl(struct
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


