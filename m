Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1221D4F68
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 15:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgEONmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 09:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgEONmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 09:42:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F00D20657;
        Fri, 15 May 2020 13:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589550150;
        bh=+uZhB8AwYuzg1buYgPe1+LFPtRcIRJQEJJlMAhaZfl8=;
        h=Subject:To:From:Date:From;
        b=dwOpqnACTOFsK/wsgLydE+WBDv70fBfBgjo+P0RpT8U/OETLJ3sN574n8IqaMT6Q0
         QTul4UqlkdJAiczlSBBbdCTj5cpkkTRj5iu2hGJq7H098peqJJ/JSOoYtmv2o8NOzS
         FmC9DftANKje/PCAeOEMEVCchbJDNd1zHmWt9aDM=
Subject: patch "USB: gadget: fix illegal array access in binding with UDC" added to usb-linus
To:     kt0755@gmail.com, balbi@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 May 2020 15:42:28 +0200
Message-ID: <1589550148151173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: fix illegal array access in binding with UDC

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 15753588bcd4bbffae1cca33c8ced5722477fe1f Mon Sep 17 00:00:00 2001
From: Kyungtae Kim <kt0755@gmail.com>
Date: Sun, 10 May 2020 05:43:34 +0000
Subject: USB: gadget: fix illegal array access in binding with UDC

FuzzUSB (a variant of syzkaller) found an illegal array access
using an incorrect index while binding a gadget with UDC.

Reference: https://www.spinics.net/lists/linux-usb/msg194331.html

This bug occurs when a size variable used for a buffer
is misused to access its strcpy-ed buffer.
Given a buffer along with its size variable (taken from user input),
from which, a new buffer is created using kstrdup().
Due to the original buffer containing 0 value in the middle,
the size of the kstrdup-ed buffer becomes smaller than that of the original.
So accessing the kstrdup-ed buffer with the same size variable
triggers memory access violation.

The fix makes sure no zero value in the buffer,
by comparing the strlen() of the orignal buffer with the size variable,
so that the access to the kstrdup-ed buffer is safe.

BUG: KASAN: slab-out-of-bounds in gadget_dev_desc_UDC_store+0x1ba/0x200
drivers/usb/gadget/configfs.c:266
Read of size 1 at addr ffff88806a55dd7e by task syz-executor.0/17208

CPU: 2 PID: 17208 Comm: syz-executor.0 Not tainted 5.6.8 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xce/0x128 lib/dump_stack.c:118
 print_address_description.constprop.4+0x21/0x3c0 mm/kasan/report.c:374
 __kasan_report+0x131/0x1b0 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 gadget_dev_desc_UDC_store+0x1ba/0x200 drivers/usb/gadget/configfs.c:266
 flush_write_buffer fs/configfs/file.c:251 [inline]
 configfs_write_file+0x2f1/0x4c0 fs/configfs/file.c:283
 __vfs_write+0x85/0x110 fs/read_write.c:494
 vfs_write+0x1cd/0x510 fs/read_write.c:558
 ksys_write+0x18a/0x220 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write fs/read_write.c:620 [inline]
 __x64_sys_write+0x73/0xb0 fs/read_write.c:620
 do_syscall_64+0x9e/0x510 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Kyungtae Kim <kt0755@gmail.com>
Reported-and-tested-by: Kyungtae Kim <kt0755@gmail.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200510054326.GA19198@pizza01
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 32b637e3e1fa..6a9aa4413d64 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -260,6 +260,9 @@ static ssize_t gadget_dev_desc_UDC_store(struct config_item *item,
 	char *name;
 	int ret;
 
+	if (strlen(page) < len)
+		return -EOVERFLOW;
+
 	name = kstrdup(page, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
-- 
2.26.2


