Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAAF38C676
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 14:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhEUM1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 08:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhEUM1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 08:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86A5613B6;
        Fri, 21 May 2021 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621599988;
        bh=4anekDOfgmvQ/XFQAJAZKH3jDLoY12HNPcWAJqdcThU=;
        h=Subject:To:From:Date:From;
        b=YCRHd6sLmnxUvEtpDLg6am5Wi7Mqsd3IkXSHRmaX+w8eRnTe1GZh8YuQWTMkVLosT
         dgWSJF3E0mbeyxYopABAraYnPaHgx31ypyHTXStI3SWUEcBB3JxG1s8EVg6VKeyG0l
         Vv6PCRwr3AEvm3UJ4m8Q+bPw7LxxHpj32JuuhDxQ=
Subject: patch "misc/uss720: fix memory leak in uss720_probe" added to usb-linus
To:     mudongliangabcd@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 21 May 2021 14:26:17 +0200
Message-ID: <1621599977185168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc/uss720: fix memory leak in uss720_probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dcb4b8ad6a448532d8b681b5d1a7036210b622de Mon Sep 17 00:00:00 2001
From: Dongliang Mu <mudongliangabcd@gmail.com>
Date: Fri, 14 May 2021 20:43:48 +0800
Subject: misc/uss720: fix memory leak in uss720_probe

uss720_probe forgets to decrease the refcount of usbdev in uss720_probe.
Fix this by decreasing the refcount of usbdev by usb_put_dev.

BUG: memory leak
unreferenced object 0xffff888101113800 (size 2048):
  comm "kworker/0:1", pid 7, jiffies 4294956777 (age 28.870s)
  hex dump (first 32 bytes):
    ff ff ff ff 31 00 00 00 00 00 00 00 00 00 00 00  ....1...........
    00 00 00 00 00 00 00 00 00 00 00 00 03 00 00 00  ................
  backtrace:
    [<ffffffff82b8e822>] kmalloc include/linux/slab.h:554 [inline]
    [<ffffffff82b8e822>] kzalloc include/linux/slab.h:684 [inline]
    [<ffffffff82b8e822>] usb_alloc_dev+0x32/0x450 drivers/usb/core/usb.c:582
    [<ffffffff82b98441>] hub_port_connect drivers/usb/core/hub.c:5129 [inline]
    [<ffffffff82b98441>] hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
    [<ffffffff82b98441>] port_event drivers/usb/core/hub.c:5509 [inline]
    [<ffffffff82b98441>] hub_event+0x1171/0x20c0 drivers/usb/core/hub.c:5591
    [<ffffffff81259229>] process_one_work+0x2c9/0x600 kernel/workqueue.c:2275
    [<ffffffff81259b19>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2421
    [<ffffffff81261228>] kthread+0x178/0x1b0 kernel/kthread.c:292
    [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Fixes: 0f36163d3abe ("[PATCH] usb: fix uss720 schedule with interrupts off")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+636c58f40a86b4a879e7@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Link: https://lore.kernel.org/r/20210514124348.6587-1-mudongliangabcd@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/uss720.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index b5d661644263..748139d26263 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -736,6 +736,7 @@ static int uss720_probe(struct usb_interface *intf,
 	parport_announce_port(pp);
 
 	usb_set_intfdata(intf, pp);
+	usb_put_dev(usbdev);
 	return 0;
 
 probe_abort:
-- 
2.31.1


