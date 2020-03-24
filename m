Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DE2190C84
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 12:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgCXLb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 07:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbgCXLb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 07:31:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32882070A;
        Tue, 24 Mar 2020 11:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585049517;
        bh=hYUqExzcNj8UsG9Zp6+wz96+2AtMvxFk5pkMaYndbqQ=;
        h=Subject:To:From:Date:From;
        b=yLENMt1bPjNO9Dmceih5aKPwV9WiLh69fQEl8HvSp8uCbl3FdER4Wv0iHH3R0cEOT
         ZwYiGS1l/MvhQBFQR8oubRc0T0tqvfz7+PR5RS8XvAWr9jvMu/04w+V4l1jgRMm18q
         IKhX8f1/0p7q3HFEfOo7bGQLeS7dI+kg+HODaZ28=
Subject: patch "vt: fix use after free in function "vc_do_resize"" added to tty-testing
To:     yebin10@huawei.com, gregkh@linuxfoundation.org, jslaby@suse.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 24 Mar 2020 12:31:55 +0100
Message-ID: <1585049515157141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: fix use after free in function "vc_do_resize"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 313a7425f23320844169046d83d8996c98fd8b1d Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Mon, 2 Mar 2020 19:28:56 +0800
Subject: vt: fix use after free in function "vc_do_resize"

Fix CVE-2020-8647 (https://nvd.nist.gov/vuln/detail/CVE-2020-8647),
detail description about this CVE is in bugzilla
"https://bugzilla.kernel.org/show_bug.cgi?id=206359".

error information:
BUG: KASan: use after free in vc_do_resize+0x49e/0xb30 at addr ffff88000016b9c0
Read of size 2 by task syz-executor.3/24164
page:ffffea0000005ac0 count:0 mapcount:0 mapping:          (null) index:0x0
page flags: 0xfffff00000000()
page dumped because: kasan: bad access detected
CPU: 0 PID: 24164 Comm: syz-executor.3 Not tainted 3.10.0-862.14.2.1.x86_64+ #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 [<ffffffffb059f309>] dump_stack+0x1e/0x20
 [<ffffffffaf8af957>] kasan_report+0x577/0x950
 [<ffffffffaf8ae652>] __asan_load2+0x62/0x80
 [<ffffffffafe3728e>] vc_do_resize+0x49e/0xb30
 [<ffffffffafe3795c>] vc_resize+0x3c/0x60
 [<ffffffffafe1d80d>] vt_ioctl+0x16ed/0x2670
 [<ffffffffafe0089a>] tty_ioctl+0x46a/0x1a10
 [<ffffffffaf92db3d>] do_vfs_ioctl+0x5bd/0xc40
 [<ffffffffaf92e2f2>] SyS_ioctl+0x132/0x170
 [<ffffffffb05c9b1b>] system_call_fastpath+0x22/0x27

In function vc_do_resize:
......
if (vc->vc_y > new_rows) {
	.......
	old_origin += first_copied_row * old_row_size;
} else
	first_copied_row = 0;
end = old_origin + old_row_size * min(old_rows, new_rows);
......
while (old_origin < end) {
	scr_memcpyw((unsigned short *) new_origin,
		    (unsigned short *) old_origin, rlth);
	if (rrem)
		scr_memsetw((void *)(new_origin + rlth),
			    vc->vc_video_erase_char, rrem);
	old_origin += old_row_size;
	new_origin += new_row_size;
}
......

We can see that before calculate variable "end" may update variable
"old_origin" with "old_origin += first_copied_row * old_row_size",
variable "end" is equal to "old_origin + (first_copied_row +
min(old_rows, new_rows))* old_row_size", it's possible that
"first_copied_row + min(old_rows, new_rows)" large than "old_rows".  So
when call scr_memcpyw function cpoy data from origin buffer to new
buffer in "while" loop, which "old_origin" may large than real old
buffer end. Now, we calculate origin buffer end before update
"old_origin" to avoid illegal memory access.

Cc: Jiri Slaby <jslaby@suse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ye Bin <yebin10@huawei.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=206359
Link: https://lore.kernel.org/r/20200302112856.1101-1-yebin10@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index bbc26d73209a..60e60611141a 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1231,6 +1231,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	old_origin = vc->vc_origin;
 	new_origin = (long) newscreen;
 	new_scr_end = new_origin + new_screen_size;
+	end = old_origin + old_row_size * min(old_rows, new_rows);
 
 	if (vc->vc_y > new_rows) {
 		if (old_rows - vc->vc_y < new_rows) {
@@ -1249,7 +1250,6 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 		old_origin += first_copied_row * old_row_size;
 	} else
 		first_copied_row = 0;
-	end = old_origin + old_row_size * min(old_rows, new_rows);
 
 	vc_uniscr_copy_area(new_uniscr, new_cols, new_rows,
 			    get_vc_uniscr(vc), rlth/2, first_copied_row,
-- 
2.25.2


