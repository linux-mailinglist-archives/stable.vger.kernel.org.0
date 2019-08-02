Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED8B7F2BB
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405414AbfHBJuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391477AbfHBJpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 682782087E;
        Fri,  2 Aug 2019 09:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739118;
        bh=3rJFkMkaF6i6+N+CP0PMLPJyRCQ20v0GyX5nZVhhU28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5/O5LZhr8DI3kyUMypb2MFOY3WyXctE3UydQwgmVUaIyxwNKjhOB8P0/AavoIgvs
         6UiLr8YmvX6OIRiHbvKR0LjM0cKYplybhVG7S7qoz+jxzhWqQwOJKqHFJzD0PkYW1Q
         vFj7F7iaKQnXeb6TwqN47mTF1fbpZe4b/NIpGWrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@ispras.ru>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 106/223] floppy: fix invalid pointer dereference in drive_name
Date:   Fri,  2 Aug 2019 11:35:31 +0200
Message-Id: <20190802092246.115916000@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/floppy.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3384,7 +3384,8 @@ static int fd_getgeo(struct block_device
 	return 0;
 }
 
-static bool valid_floppy_drive_params(const short autodetect[8])
+static bool valid_floppy_drive_params(const short autodetect[8],
+		int native_format)
 {
 	size_t floppy_type_size = ARRAY_SIZE(floppy_type);
 	size_t i = 0;
@@ -3395,6 +3396,9 @@ static bool valid_floppy_drive_params(co
 			return false;
 	}
 
+	if (native_format < 0 || native_format >= floppy_type_size)
+		return false;
+
 	return true;
 }
 
@@ -3524,7 +3528,8 @@ static int fd_locked_ioctl(struct block_
 		SUPBOUND(size, strlen((const char *)outparam) + 1);
 		break;
 	case FDSETDRVPRM:
-		if (!valid_floppy_drive_params(inparam.dp.autodetect))
+		if (!valid_floppy_drive_params(inparam.dp.autodetect,
+				inparam.dp.native_format))
 			return -EINVAL;
 		*UDP = inparam.dp;
 		break;
@@ -3723,7 +3728,7 @@ static int compat_setdrvprm(int drive,
 		return -EPERM;
 	if (copy_from_user(&v, arg, sizeof(struct compat_floppy_drive_params)))
 		return -EFAULT;
-	if (!valid_floppy_drive_params(v.autodetect))
+	if (!valid_floppy_drive_params(v.autodetect, v.native_format))
 		return -EINVAL;
 	mutex_lock(&floppy_mutex);
 	UDP->cmos = v.cmos;


