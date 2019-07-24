Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B477465E
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbfGYFlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390784AbfGYFlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:41:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E559322BF5;
        Thu, 25 Jul 2019 05:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033309;
        bh=2aEr7WWYA8Y0U79x/9EAC5oOpX9nKKrXz/zsHy13mGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4FXEn+iiPCa+8r17Vmlegk8JNkeM4S0Ihu0bOIkTOJHQQKMF+68el321T+E7yovX
         GfqHKXM3QCTU86D9MS+kdnw92LzNXEIugdLY9T+6I4ccFDSrmAxC18E7yKh3sIpgKw
         e8pXvcTT2V4FjSUPX52Q38tIDUB/uxIyJpPJvwHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@ispras.ru>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/271] floppy: fix invalid pointer dereference in drive_name
Date:   Wed, 24 Jul 2019 21:20:31 +0200
Message-Id: <20190724191709.058727058@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9b04609b784027968348796a18f601aed9db3789 ]

This fixes the invalid pointer dereference in the drive_name function of
the floppy driver.

The native_format field of the struct floppy_drive_params is used as
floppy_type array index in the drive_name function.  Thus, the field
should be checked the same way as the autodetect field.

To trigger the bug, one could use a value out of range and set the drive
parameters with the FDSETDRVPRM ioctl.  Next, FDGETDRVTYP ioctl should
be used to call the drive_name.  A floppy disk is not required to be
inserted.

CAP_SYS_ADMIN is required to call FDSETDRVPRM.

The patch adds the check for a value of the native_format field to be in
the '0 <= x < ARRAY_SIZE(floppy_type)' range of the floppy_type array
indices.

The bug was found by syzkaller.

Signed-off-by: Denis Efremov <efremov@ispras.ru>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index dd49737effbf..8d69a8af8b78 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3391,7 +3391,8 @@ static int fd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static bool valid_floppy_drive_params(const short autodetect[8])
+static bool valid_floppy_drive_params(const short autodetect[8],
+		int native_format)
 {
 	size_t floppy_type_size = ARRAY_SIZE(floppy_type);
 	size_t i = 0;
@@ -3402,6 +3403,9 @@ static bool valid_floppy_drive_params(const short autodetect[8])
 			return false;
 	}
 
+	if (native_format < 0 || native_format >= floppy_type_size)
+		return false;
+
 	return true;
 }
 
@@ -3531,7 +3535,8 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int
 		SUPBOUND(size, strlen((const char *)outparam) + 1);
 		break;
 	case FDSETDRVPRM:
-		if (!valid_floppy_drive_params(inparam.dp.autodetect))
+		if (!valid_floppy_drive_params(inparam.dp.autodetect,
+				inparam.dp.native_format))
 			return -EINVAL;
 		*UDP = inparam.dp;
 		break;
@@ -3730,7 +3735,7 @@ static int compat_setdrvprm(int drive,
 		return -EPERM;
 	if (copy_from_user(&v, arg, sizeof(struct compat_floppy_drive_params)))
 		return -EFAULT;
-	if (!valid_floppy_drive_params(v.autodetect))
+	if (!valid_floppy_drive_params(v.autodetect, v.native_format))
 		return -EINVAL;
 	mutex_lock(&floppy_mutex);
 	UDP->cmos = v.cmos;
-- 
2.20.1



