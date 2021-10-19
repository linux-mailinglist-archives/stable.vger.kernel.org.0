Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299B8432FCF
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 09:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbhJSHmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 03:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232782AbhJSHms (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 03:42:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06FD960FD9;
        Tue, 19 Oct 2021 07:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634629236;
        bh=XVBnLyg9cLx/7MUaazQ/yw46yZ8G+deZl+re/XgRML4=;
        h=Subject:To:From:Date:From;
        b=ESMH4SyIvOL6zVj0b/rZi2kSOuxPv9eaDbpwCMoFUYIkngKLfOG3b+UG6fe9/YImY
         dt2aU6iKziIroLQyzSmnJrcbNz2ocPPs32uWDUMPZkKT2nKyAE31HtPt9DrVqnuKcU
         bWTfF6YxT0Ea//+bN8FT3CGe5iK5Lj953rm4R/4k=
Subject: patch "char: xillybus: fix msg_ep UAF in xillyusb_probe()" added to char-misc-testing
To:     william.xuanziyang@huawei.com, eli.billauer@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 19 Oct 2021 09:40:34 +0200
Message-ID: <1634629234247225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    char: xillybus: fix msg_ep UAF in xillyusb_probe()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 15c9a359094ec6251578b02387436bc64f11a477 Mon Sep 17 00:00:00 2001
From: Ziyang Xuan <william.xuanziyang@huawei.com>
Date: Sat, 16 Oct 2021 13:20:47 +0800
Subject: char: xillybus: fix msg_ep UAF in xillyusb_probe()

When endpoint_alloc() return failed in xillyusb_setup_base_eps(),
'xdev->msg_ep' will be freed but not set to NULL. That lets program
enter fail handling to cleanup_dev() in xillyusb_probe(). Check for
'xdev->msg_ep' is invalid in cleanup_dev() because 'xdev->msg_ep' did
not set to NULL when was freed. So the UAF problem for 'xdev->msg_ep'
is triggered.

==================================================================
BUG: KASAN: use-after-free in fifo_mem_release+0x1f4/0x210
CPU: 0 PID: 166 Comm: kworker/0:2 Not tainted 5.15.0-rc5+ #19
Call Trace:
 dump_stack_lvl+0xe2/0x152
 print_address_description.constprop.0+0x21/0x140
 ? fifo_mem_release+0x1f4/0x210
 kasan_report.cold+0x7f/0x11b
 ? xillyusb_probe+0x530/0x700
 ? fifo_mem_release+0x1f4/0x210
 fifo_mem_release+0x1f4/0x210
 ? __sanitizer_cov_trace_pc+0x1d/0x50
 endpoint_dealloc+0x35/0x2b0
 cleanup_dev+0x90/0x120
 xillyusb_probe+0x59a/0x700
...

Freed by task 166:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0x109/0x140
 kfree+0x117/0x4c0
 xillyusb_probe+0x606/0x700

Set 'xdev->msg_ep' to NULL after being freed in xillyusb_setup_base_eps()
to fix the UAF problem.

Fixes: a53d1202aef1 ("char: xillybus: Add driver for XillyUSB (Xillybus variant for USB)")
Cc: stable <stable@vger.kernel.org>
Acked-by: Eli Billauer <eli.billauer@gmail.com>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/r/20211016052047.1611983-1-william.xuanziyang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/xillybus/xillyusb.c b/drivers/char/xillybus/xillyusb.c
index e7f88f35c702..dc3551796e5e 100644
--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -1912,6 +1912,7 @@ static int xillyusb_setup_base_eps(struct xillyusb_dev *xdev)
 
 dealloc:
 	endpoint_dealloc(xdev->msg_ep); /* Also frees FIFO mem if allocated */
+	xdev->msg_ep = NULL;
 	return -ENOMEM;
 }
 
-- 
2.33.1


