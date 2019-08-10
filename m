Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924E488D3B
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfHJUn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54438 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbfHJUnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:55 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-00058O-Ba; Sat, 10 Aug 2019 21:43:51 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003jv-Lg; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Denis Efremov" <efremov@ispras.ru>, "Willy Tarreau" <w@1wt.eu>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.686847966@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 140/157] floppy: fix invalid pointer dereference in
 drive_name
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov <efremov@ispras.ru>

commit 9b04609b784027968348796a18f601aed9db3789 upstream.

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
[bwh: Backported to 3.16: Drop changes in compat_setdrvprm(), as compat
 ioctls go via fd_ioctl_locked() after translation in compat_ioctl.c.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3383,7 +3383,8 @@ static int fd_getgeo(struct block_device
 	return 0;
 }
 
-static bool valid_floppy_drive_params(const short autodetect[8])
+static bool valid_floppy_drive_params(const short autodetect[8],
+		int native_format)
 {
 	size_t floppy_type_size = ARRAY_SIZE(floppy_type);
 	size_t i = 0;
@@ -3394,6 +3395,9 @@ static bool valid_floppy_drive_params(co
 			return false;
 	}
 
+	if (native_format < 0 || native_format >= floppy_type_size)
+		return false;
+
 	return true;
 }
 
@@ -3523,7 +3527,8 @@ static int fd_locked_ioctl(struct block_
 		SUPBOUND(size, strlen((const char *)outparam) + 1);
 		break;
 	case FDSETDRVPRM:
-		if (!valid_floppy_drive_params(inparam.dp.autodetect))
+		if (!valid_floppy_drive_params(inparam.dp.autodetect,
+				inparam.dp.native_format))
 			return -EINVAL;
 		*UDP = inparam.dp;
 		break;

