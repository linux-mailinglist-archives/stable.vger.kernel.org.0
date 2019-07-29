Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E784579466
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfG2TbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729709AbfG2TbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:31:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE7221773;
        Mon, 29 Jul 2019 19:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428666;
        bh=ZrwcrDWPK5yJpXj3jRuqmuZVxOYlfYoF/tZGNepahu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgdM88yadFaCB1vsFtQVVNAApnlteAdzi4DknRfN99aPqPJm2GNcv+mND6Bofxwz8
         ahnHMgSjoRG+dKCs5F27ueMwdeTrON/E97mIUfVHeS1bBtbSpBvAqpMpBurxIEFFyb
         ekxDnG5+NO7GY96MK9ktTbo16T73355k4snsZifQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@ispras.ru>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 108/293] floppy: fix out-of-bounds read in next_valid_format
Date:   Mon, 29 Jul 2019 21:19:59 +0200
Message-Id: <20190729190832.933147012@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index 4c6c20376a83..a4f630ef2b75 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3386,6 +3386,20 @@ static int fd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
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
@@ -3512,6 +3526,8 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int
 		SUPBOUND(size, strlen((const char *)outparam) + 1);
 		break;
 	case FDSETDRVPRM:
+		if (!valid_floppy_drive_params(inparam.dp.autodetect))
+			return -EINVAL;
 		*UDP = inparam.dp;
 		break;
 	case FDGETDRVPRM:
@@ -3709,6 +3725,8 @@ static int compat_setdrvprm(int drive,
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



