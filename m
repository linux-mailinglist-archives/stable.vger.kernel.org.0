Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AECC738EA
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388798AbfGXTes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389115AbfGXTes (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:34:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2310C2238C;
        Wed, 24 Jul 2019 19:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996887;
        bh=SYxnJyk4RjHZkdvp/bc8OP9PAli/rQDxIMRvvTDJe2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GNwiMa3mSFf3f3FAvb5kJlylOEqa/ccbzFZAnarxern3wwCJwZks8RHZ72SD/qNd
         SEEdHBBlEgH46A92ZaNb4QZCrysaZ+JoKZzlXjkYPdjafgBHGTPAo2DobJqyXdET9o
         O4zr53dwz5rBN36TvTO8HtCwlRxYpBnK6xbInLRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@ispras.ru>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 249/413] floppy: fix out-of-bounds read in next_valid_format
Date:   Wed, 24 Jul 2019 21:19:00 +0200
Message-Id: <20190724191753.446996167@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5635f897ed83fd539df78e98ba69ee91592f9bb8 ]

This fixes a global out-of-bounds read access in the next_valid_format
function of the floppy driver.

The values from autodetect field of the struct floppy_drive_params are
used as indices for the floppy_type array in the next_valid_format
function 'floppy_type[DP->autodetect[probed_format]].sect'.

To trigger the bug, one could use a value out of range and set the drive
parameters with the FDSETDRVPRM ioctl.  A floppy disk is not required to
be inserted.

CAP_SYS_ADMIN is required to call FDSETDRVPRM.

The patch adds the check for values of the autodetect field to be in the
'0 <= x < ARRAY_SIZE(floppy_type)' range of the floppy_type array indices.

The bug was found by syzkaller.

Signed-off-by: Denis Efremov <efremov@ispras.ru>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 51246bc9709a..b70d6e103a57 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3380,6 +3380,20 @@ static int fd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
+static bool valid_floppy_drive_params(const short autodetect[8])
+{
+	size_t floppy_type_size = ARRAY_SIZE(floppy_type);
+	size_t i = 0;
+
+	for (i = 0; i < 8; ++i) {
+		if (autodetect[i] < 0 ||
+		    autodetect[i] >= floppy_type_size)
+			return false;
+	}
+
+	return true;
+}
+
 static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		    unsigned long param)
 {
@@ -3506,6 +3520,8 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int
 		SUPBOUND(size, strlen((const char *)outparam) + 1);
 		break;
 	case FDSETDRVPRM:
+		if (!valid_floppy_drive_params(inparam.dp.autodetect))
+			return -EINVAL;
 		*UDP = inparam.dp;
 		break;
 	case FDGETDRVPRM:
@@ -3703,6 +3719,8 @@ static int compat_setdrvprm(int drive,
 		return -EPERM;
 	if (copy_from_user(&v, arg, sizeof(struct compat_floppy_drive_params)))
 		return -EFAULT;
+	if (!valid_floppy_drive_params(v.autodetect))
+		return -EINVAL;
 	mutex_lock(&floppy_mutex);
 	UDP->cmos = v.cmos;
 	UDP->max_dtr = v.max_dtr;
-- 
2.20.1



