Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFE1395DFD
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhEaNws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhEaNur (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08576162F;
        Mon, 31 May 2021 13:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467930;
        bh=SLvqaojeofwp8GZw65DhfTi37SwMU3e5Yhve4mFHEco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4ufZt9TOOmxtkjImLcAiTztMqgXzhq7hblvZxnlfgGIQyODrBSiqe2UWOMYFafr1
         qmELZINEzi2iu5PtSt75FQid/AfAW0YBPq4iBpes+7Nb+gxXp5oJM/gcUxFFS0qAhO
         +UTHmdSWiydO0LVHJOyoLlLY+UpuJ2xoqsW5P4NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+636c58f40a86b4a879e7@syzkaller.appspotmail.com,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH 5.10 054/252] misc/uss720: fix memory leak in uss720_probe
Date:   Mon, 31 May 2021 15:11:59 +0200
Message-Id: <20210531130659.817655580@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit dcb4b8ad6a448532d8b681b5d1a7036210b622de upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/uss720.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -736,6 +736,7 @@ static int uss720_probe(struct usb_inter
 	parport_announce_port(pp);
 
 	usb_set_intfdata(intf, pp);
+	usb_put_dev(usbdev);
 	return 0;
 
 probe_abort:


