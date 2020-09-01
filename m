Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5188B259795
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbgIAQQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgIAPeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5B9A216C4;
        Tue,  1 Sep 2020 15:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974475;
        bh=u8zMHey+yOMxaEFYU2TU2BQcMfx2dnwt8ZGCM9UlWV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UqPsOcinEdpXmbm/QHzH9x8Oax9/RXv1ARhWJ9ZRGPV49lKCLwzmvI13217FSz6vC
         QN4K16UMSibuNJab2xJKw4uuhR9dOfcVzJDjYTYqzQSxeSU1OirU+6mvAfLVjo5j9e
         Z8bc+9JeTcR1DX/TRnX+imsV/+YwgGHsVGYfsoy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        syzbot+c2c3302f9c601a4b1be2@syzkaller.appspotmail.com
Subject: [PATCH 5.4 189/214] USB: yurex: Fix bad gfp argument
Date:   Tue,  1 Sep 2020 17:11:09 +0200
Message-Id: <20200901151002.006490673@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit f176ede3a3bde5b398a6777a7f9ff091baa2d3ff upstream.

The syzbot fuzzer identified a bug in the yurex driver: It passes
GFP_KERNEL as a memory-allocation flag to usb_submit_urb() at a time
when its state is TASK_INTERRUPTIBLE, not TASK_RUNNING:

do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000370c7c68>] prepare_to_wait+0xb1/0x2a0 kernel/sched/wait.c:247
WARNING: CPU: 1 PID: 340 at kernel/sched/core.c:7253 __might_sleep+0x135/0x190
kernel/sched/core.c:7253
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 340 Comm: syz-executor677 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 panic+0x2aa/0x6e1 kernel/panic.c:231
 __warn.cold+0x20/0x50 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x41/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:__might_sleep+0x135/0x190 kernel/sched/core.c:7253
Code: 65 48 8b 1c 25 40 ef 01 00 48 8d 7b 10 48 89 fe 48 c1 ee 03 80 3c 06 00 75
2b 48 8b 73 10 48 c7 c7 e0 9e 06 86 e8 ed 12 f6 ff <0f> 0b e9 46 ff ff ff e8 1f
b2 4b 00 e9 29 ff ff ff e8 15 b2 4b 00
RSP: 0018:ffff8881cdb77a28 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8881c6458000 RCX: 0000000000000000
RDX: ffff8881c6458000 RSI: ffffffff8129ec93 RDI: ffffed1039b6ef37
RBP: ffffffff86fdade2 R08: 0000000000000001 R09: ffff8881db32f54f
R10: 0000000000000000 R11: 0000000030343354 R12: 00000000000001f2
R13: 0000000000000000 R14: 0000000000000068 R15: ffffffff83c1b1aa
 slab_pre_alloc_hook.constprop.0+0xea/0x200 mm/slab.h:498
 slab_alloc_node mm/slub.c:2816 [inline]
 slab_alloc mm/slub.c:2900 [inline]
 kmem_cache_alloc_trace+0x46/0x220 mm/slub.c:2917
 kmalloc include/linux/slab.h:554 [inline]
 dummy_urb_enqueue+0x7a/0x880 drivers/usb/gadget/udc/dummy_hcd.c:1251
 usb_hcd_submit_urb+0x2b2/0x22d0 drivers/usb/core/hcd.c:1547
 usb_submit_urb+0xb4e/0x13e0 drivers/usb/core/urb.c:570
 yurex_write+0x3ea/0x820 drivers/usb/misc/yurex.c:495

This patch changes the call to use GFP_ATOMIC instead of GFP_KERNEL.

Reported-and-tested-by: syzbot+c2c3302f9c601a4b1be2@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200810182954.GB307778@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/yurex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -492,7 +492,7 @@ static ssize_t yurex_write(struct file *
 	prepare_to_wait(&dev->waitq, &wait, TASK_INTERRUPTIBLE);
 	dev_dbg(&dev->interface->dev, "%s - submit %c\n", __func__,
 		dev->cntl_buffer[0]);
-	retval = usb_submit_urb(dev->cntl_urb, GFP_KERNEL);
+	retval = usb_submit_urb(dev->cntl_urb, GFP_ATOMIC);
 	if (retval >= 0)
 		timeout = schedule_timeout(YUREX_WRITE_TIMEOUT);
 	finish_wait(&dev->waitq, &wait);


