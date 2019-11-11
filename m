Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86727F7DD6
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfKKSzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbfKKSzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:55:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C0C22196E;
        Mon, 11 Nov 2019 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498521;
        bh=6JSxThNfxtm254c6JHX8hVjle8LLxf1U0UOHfiDCluQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JX78csduWR1MWpG15XTGbcRLlOuWSIHJF2hpHy5HGLrktLks9+A3l+p7Pd1TNrZDQ
         dPF3VgWD2kyQx4V7gKq4O02KzE0nzzZ5O152WgEP1vMG5Rpje8MwU/UvpFl4EfJBqk
         GvytuPOpzoNzipbwMbiJmzag6EDESbvIog+VVDrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 142/193] usb: gadget: configfs: fix concurrent issue between composite APIs
Date:   Mon, 11 Nov 2019 19:28:44 +0100
Message-Id: <20191111181511.631810059@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 1a1c851bbd706ea9f3a9756c2d3db28523506d3b ]

We meet several NULL pointer issues if configfs_composite_unbind
and composite_setup (or composite_disconnect) are running together.
These issues occur when do the function switch stress test, the
configfs_compsoite_unbind is called from user mode by
echo "" to /sys/../UDC entry, and meanwhile, the setup interrupt
or disconnect interrupt occurs by hardware. The composite_setup
will get the cdev from get_gadget_data, but configfs_composite_unbind
will set gadget data as NULL, so the NULL pointer issue occurs.
This concurrent is hard to reproduce by native kernel, but can be
reproduced by android kernel.

In this commit, we introduce one spinlock belongs to structure
gadget_info since we can't use the same spinlock in usb_composite_dev
due to exclusive running together between composite_setup and
configfs_composite_unbind. And one bit flag 'unbind' to indicate the
code is at unbind routine, this bit is needed due to we release the
lock at during configfs_composite_unbind sometimes, and composite_setup
may be run at that time.

Several oops:

oops 1:
android_work: sent uevent USB_STATE=CONNECTED
configfs-gadget gadget: super-speed config #1: b
android_work: sent uevent USB_STATE=CONFIGURED
init: Received control message 'start' for 'adbd' from pid: 3515 (system_server)
Unable to handle kernel NULL pointer dereference at virtual address 0000002a
init: Received control message 'stop' for 'adbd' from pid: 3375 (/vendor/bin/hw/android.hardware.usb@1.1-servic)
Mem abort info:
  Exception class = DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgd = ffff8008f1b7f000
[000000000000002a] *pgd=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 4 PID: 2457 Comm: irq/125-5b11000 Not tainted 4.14.98-07846-g0b40a9b-dirty #16
Hardware name: Freescale i.MX8QM MEK (DT)
task: ffff8008f2a98000 task.stack: ffff00000b7b8000
PC is at composite_setup+0x44/0x1508
LR is at android_setup+0xb8/0x13c
pc : [<ffff0000089ffb3c>] lr : [<ffff000008a032fc>] pstate: 800001c5
sp : ffff00000b7bbb80
x29: ffff00000b7bbb80 x28: ffff8008f2a3c010
x27: 0000000000000001 x26: 0000000000000000                                                          [1232/1897]
audit: audit_lost=25791 audit_rate_limit=5 audit_backlog_limit=64
x25: 00000000ffffffa1 x24: ffff8008f2a3c010
audit: rate limit exceeded
x23: 0000000000000409 x22: ffff000009c8e000
x21: ffff8008f7a8b428 x20: ffff00000afae000
x19: ffff0000089ff000 x18: 0000000000000000
x17: 0000000000000000 x16: ffff0000082b7c9c
x15: 0000000000000000 x14: f1866f5b952aca46
x13: e35502e30d44349c x12: 0000000000000008
x11: 0000000000000008 x10: 0000000000000a30
x9 : ffff00000b7bbd00 x8 : ffff8008f2a98a90
x7 : ffff8008f27a9c90 x6 : 0000000000000001
x5 : 0000000000000000 x4 : 0000000000000001
x3 : 0000000000000000 x2 : 0000000000000006
x1 : ffff0000089ff8d0 x0 : 732a010310b9ed00

X7: 0xffff8008f27a9c10:
9c10  00000002 00000000 00000001 00000000 13110000 ffff0000 00000002 00208040
9c30  00000000 00000000 00000000 00000000 00000000 00000005 00000029 00000000
9c50  00051778 00000001 f27a8e00 ffff8008 00000005 00000000 00000078 00000078
9c70  00000078 00000000 09031d48 ffff0000 00100000 00000000 00400000 00000000
9c90  00000001 00000000 00000000 00000000 00000000 00000000 ffefb1a0 ffff8008
9cb0  f27a9ca8 ffff8008 00000000 00000000 b9d88037 00000173 1618a3eb 00000001
9cd0  870a792a 0000002e 16188fe6 00000001 0000242b 00000000 00000000 00000000
using random self ethernet address
9cf0  019a4646 00000000 000547f3 00000000 ecfd6c33 00000002 00000000
using random host ethernet address
 00000000

X8: 0xffff8008f2a98a10:
8a10  00000000 00000000 f7788d00 ffff8008 00000001 00000000 00000000 00000000
8a30  eb218000 ffff8008 f2a98000 ffff8008 f2a98000 ffff8008 09885000 ffff0000
8a50  f34df480 ffff8008 00000000 00000000 f2a98648 ffff8008 09c8e000 ffff0000
8a70  fff2c800 ffff8008 09031d48 ffff0000 0b7bbd00 ffff0000 0b7bbd00 ffff0000
8a90  080861bc ffff0000 00000000 00000000 00000000 00000000 00000000 00000000
8ab0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
8ad0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
8af0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

X21: 0xffff8008f7a8b3a8:
b3a8  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
b3c8  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
b3e8  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
b408  00000000 00000000 00000000 00000000 00000000 00000000 00000001 00000000
b428  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
b448  0053004d 00540046 00300031 00010030 eb07b520 ffff8008 20011201 00000003
b468  e418d109 0104404e 00010302 00000000 eb07b558 ffff8008 eb07b558 ffff8008
b488  f7a8b488 ffff8008 f7a8b488 ffff8008 f7a8b300 ffff8008 00000000 00000000

X24: 0xffff8008f2a3bf90:
bf90  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfb0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfd0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bff0  00000000 00000000 00000000 00000000 f76c8010 ffff8008 f76c8010 ffff8008
c010  00000000 00000000 f2a3c018 ffff8008 f2a3c018 ffff8008 08a067dc ffff0000
c030  f2a5a000 ffff8008 091c3650 ffff0000 f716fd18 ffff8008 f716fe30 ffff8008
c050  f2ce4a30 ffff8008 00000000 00000005 00000000 00000000 095d1568 ffff0000
c070  f76c8010 ffff8008 f2ce4b00 ffff8008 095cac68 ffff0000 f2a5a028 ffff8008

X28: 0xffff8008f2a3bf90:
bf90  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfb0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfd0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bff0  00000000 00000000 00000000 00000000 f76c8010 ffff8008 f76c8010 ffff8008
c010  00000000 00000000 f2a3c018 ffff8008 f2a3c018 ffff8008 08a067dc ffff0000
c030  f2a5a000 ffff8008 091c3650 ffff0000 f716fd18 ffff8008 f716fe30 ffff8008
c050  f2ce4a30 ffff8008 00000000 00000005 00000000 00000000 095d1568 ffff0000
c070  f76c8010 ffff8008 f2ce4b00 ffff8008 095cac68 ffff0000 f2a5a028 ffff8008

Process irq/125-5b11000 (pid: 2457, stack limit = 0xffff00000b7b8000)
Call trace:
Exception stack(0xffff00000b7bba40 to 0xffff00000b7bbb80)
ba40: 732a010310b9ed00 ffff0000089ff8d0 0000000000000006 0000000000000000
ba60: 0000000000000001 0000000000000000 0000000000000001 ffff8008f27a9c90
ba80: ffff8008f2a98a90 ffff00000b7bbd00 0000000000000a30 0000000000000008
baa0: 0000000000000008 e35502e30d44349c f1866f5b952aca46 0000000000000000
bac0: ffff0000082b7c9c 0000000000000000 0000000000000000 ffff0000089ff000
bae0: ffff00000afae000 ffff8008f7a8b428 ffff000009c8e000 0000000000000409
bb00: ffff8008f2a3c010 00000000ffffffa1 0000000000000000 0000000000000001
bb20: ffff8008f2a3c010 ffff00000b7bbb80 ffff000008a032fc ffff00000b7bbb80
bb40: ffff0000089ffb3c 00000000800001c5 ffff00000b7bbb80 732a010310b9ed00
bb60: ffffffffffffffff ffff0000080f777c ffff00000b7bbb80 ffff0000089ffb3c
[<ffff0000089ffb3c>] composite_setup+0x44/0x1508
[<ffff000008a032fc>] android_setup+0xb8/0x13c
[<ffff0000089bd9a8>] cdns3_ep0_delegate_req+0x44/0x70
[<ffff0000089bdff4>] cdns3_check_ep0_interrupt_proceed+0x33c/0x654
[<ffff0000089bca44>] cdns3_device_thread_irq_handler+0x4b0/0x4bc
[<ffff0000089b77b4>] cdns3_thread_irq+0x48/0x68
[<ffff000008145bf0>] irq_thread_fn+0x28/0x88
[<ffff000008145e38>] irq_thread+0x13c/0x228
[<ffff0000080fed70>] kthread+0x104/0x130
[<ffff000008085064>] ret_from_fork+0x10/0x18

oops2:
composite_disconnect: Calling disconnect on a Gadget that is                      not connected
android_work: did not send uevent (0 0           (null))
init: Received control message 'stop' for 'adbd' from pid: 3359 (/vendor/bin/hw/android.hardware.usb@1.1-service.imx)
init: Sending signal 9 to service 'adbd' (pid 22343) process group...
------------[ cut here ]------------
audit: audit_lost=180038 audit_rate_limit=5 audit_backlog_limit=64
audit: rate limit exceeded
WARNING: CPU: 0 PID: 3468 at kernel_imx/drivers/usb/gadget/composite.c:2009 composite_disconnect+0x80/0x88
Modules linked in:
CPU: 0 PID: 3468 Comm: HWC-UEvent-Thre Not tainted 4.14.98-07846-g0b40a9b-dirty #16
Hardware name: Freescale i.MX8QM MEK (DT)
task: ffff8008f2349c00 task.stack: ffff00000b0a8000
PC is at composite_disconnect+0x80/0x88
LR is at composite_disconnect+0x80/0x88
pc : [<ffff0000089ff9b0>] lr : [<ffff0000089ff9b0>] pstate: 600001c5
sp : ffff000008003dd0
x29: ffff000008003dd0 x28: ffff8008f2349c00
x27: ffff000009885018 x26: ffff000008004000
Timeout for IPC response!
x25: ffff000009885018 x24: ffff000009c8e280
x23: ffff8008f2d98010 x22: 00000000000001c0
x21: ffff8008f2d98394 x20: ffff8008f2d98010
x19: 0000000000000000 x18: 0000e3956f4f075a
fxos8700 4-001e: i2c block read acc failed
x17: 0000e395735727e8 x16: ffff00000829f4d4
x15: ffffffffffffffff x14: 7463656e6e6f6320
x13: 746f6e2009090920 x12: 7369207461687420
x11: 7465676461472061 x10: 206e6f207463656e
x9 : 6e6f637369642067 x8 : ffff000009c8e280
x7 : ffff0000086ca6cc x6 : ffff000009f15e78
x5 : 0000000000000000 x4 : 0000000000000000
x3 : ffffffffffffffff x2 : c3f28b86000c3900
x1 : c3f28b86000c3900 x0 : 000000000000004e

X20: 0xffff8008f2d97f90:
7f90  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7fb0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
libprocessgroup: Failed to kill process cgroup uid 0 pid 22343 in 215ms, 1 processes remain
7fd0
Timeout for IPC response!
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
using random self ethernet address
7ff0  00000000 00000000 00000000 00000000 f76c8010 ffff8008 f76c8010 ffff8008
8010  00000100 00000000 f2d98018 ffff8008 f2d98018 ffff8008 08a067dc
using random host ethernet address
 ffff0000
8030  f206d800 ffff8008 091c3650 ffff0000 f7957b18 ffff8008 f7957730 ffff8008
8050  f716a630 ffff8008 00000000 00000005 00000000 00000000 095d1568 ffff0000
8070  f76c8010 ffff8008 f716a800 ffff8008 095cac68 ffff0000 f206d828 ffff8008

X21: 0xffff8008f2d98314:
8314  ffff8008 00000000 00000000 00000000 00000000 00000000 00000000 00000000
8334  00000000 00000000 00000000 00000000 00000000 08a04cf4 ffff0000 00000000
8354  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
8374  00000000 00000000 00000000 00001001 00000000 00000000 00000000 00000000
8394  e4bbe4bb 0f230000 ffff0000 0afae000 ffff0000 ae001000 00000000 f206d400
Timeout for IPC response!
83b4  ffff8008 00000000 00000000 f7957b18 ffff8008 f7957718 ffff8008 f7957018
83d4  ffff8008 f7957118 ffff8008 f7957618 ffff8008 f7957818 ffff8008 f7957918
83f4  ffff8008 f7957d18 ffff8008 00000000 00000000 00000000 00000000 00000000

X23: 0xffff8008f2d97f90:
7f90  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7fb0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7fd0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
7ff0  00000000 00000000 00000000 00000000 f76c8010 ffff8008 f76c8010 ffff8008
8010  00000100 00000000 f2d98018 ffff8008 f2d98018 ffff8008 08a067dc ffff0000
8030  f206d800 ffff8008 091c3650 ffff0000 f7957b18 ffff8008 f7957730 ffff8008
8050  f716a630 ffff8008 00000000 00000005 00000000 00000000 095d1568 ffff0000
8070  f76c8010 ffff8008 f716a800 ffff8008 095cac68 ffff0000 f206d828 ffff8008

X28: 0xffff8008f2349b80:
9b80  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9ba0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9bc0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9be0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9c00  00000022 00000000 ffffffff ffffffff 00010001 00000000 00000000 00000000
9c20  0b0a8000 ffff0000 00000002 00404040 00000000 00000000 00000000 00000000
9c40  00000001 00000000 00000001 00000000 001ebd44 00000001 f390b800 ffff8008
9c60  00000000 00000001 00000070 00000070 00000070 00000000 09031d48 ffff0000

Call trace:
Exception stack(0xffff000008003c90 to 0xffff000008003dd0)
3c80:                                   000000000000004e c3f28b86000c3900
3ca0: c3f28b86000c3900 ffffffffffffffff 0000000000000000 0000000000000000
3cc0: ffff000009f15e78 ffff0000086ca6cc ffff000009c8e280 6e6f637369642067
3ce0: 206e6f207463656e 7465676461472061 7369207461687420 746f6e2009090920
3d00: 7463656e6e6f6320 ffffffffffffffff ffff00000829f4d4 0000e395735727e8
3d20: 0000e3956f4f075a 0000000000000000 ffff8008f2d98010 ffff8008f2d98394
3d40: 00000000000001c0 ffff8008f2d98010 ffff000009c8e280 ffff000009885018
3d60: ffff000008004000 ffff000009885018 ffff8008f2349c00 ffff000008003dd0
3d80: ffff0000089ff9b0 ffff000008003dd0 ffff0000089ff9b0 00000000600001c5
3da0: ffff8008f33f2cd8 0000000000000000 0000ffffffffffff 0000000000000000
init: Received control message 'start' for 'adbd' from pid: 3359 (/vendor/bin/hw/android.hardware.usb@1.1-service.imx)
3dc0: ffff000008003dd0 ffff0000089ff9b0
[<ffff0000089ff9b0>] composite_disconnect+0x80/0x88
[<ffff000008a044d4>] android_disconnect+0x3c/0x68
[<ffff0000089ba9f8>] cdns3_device_irq_handler+0xfc/0x2c8
[<ffff0000089b84c0>] cdns3_irq+0x44/0x94
[<ffff00000814494c>] __handle_irq_event_percpu+0x60/0x24c
[<ffff000008144c0c>] handle_irq_event+0x58/0xc0
[<ffff00000814873c>] handle_fasteoi_irq+0x98/0x180
[<ffff000008143a10>] generic_handle_irq+0x24/0x38
[<ffff000008144170>] __handle_domain_irq+0x60/0xac
[<ffff0000080819c4>] gic_handle_irq+0xd4/0x17c

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 110 ++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 0251299428946..33852c2b29d1a 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -61,6 +61,8 @@ struct gadget_info {
 	bool use_os_desc;
 	char b_vendor_code;
 	char qw_sign[OS_STRING_QW_SIGN_LEN];
+	spinlock_t spinlock;
+	bool unbind;
 };
 
 static inline struct gadget_info *to_gadget_info(struct config_item *item)
@@ -1244,6 +1246,7 @@ static int configfs_composite_bind(struct usb_gadget *gadget,
 	int				ret;
 
 	/* the gi->lock is hold by the caller */
+	gi->unbind = 0;
 	cdev->gadget = gadget;
 	set_gadget_data(gadget, cdev);
 	ret = composite_dev_prepare(composite, cdev);
@@ -1376,31 +1379,128 @@ static void configfs_composite_unbind(struct usb_gadget *gadget)
 {
 	struct usb_composite_dev	*cdev;
 	struct gadget_info		*gi;
+	unsigned long flags;
 
 	/* the gi->lock is hold by the caller */
 
 	cdev = get_gadget_data(gadget);
 	gi = container_of(cdev, struct gadget_info, cdev);
+	spin_lock_irqsave(&gi->spinlock, flags);
+	gi->unbind = 1;
+	spin_unlock_irqrestore(&gi->spinlock, flags);
 
 	kfree(otg_desc[0]);
 	otg_desc[0] = NULL;
 	purge_configs_funcs(gi);
 	composite_dev_cleanup(cdev);
 	usb_ep_autoconfig_reset(cdev->gadget);
+	spin_lock_irqsave(&gi->spinlock, flags);
 	cdev->gadget = NULL;
 	set_gadget_data(gadget, NULL);
+	spin_unlock_irqrestore(&gi->spinlock, flags);
+}
+
+static int configfs_composite_setup(struct usb_gadget *gadget,
+		const struct usb_ctrlrequest *ctrl)
+{
+	struct usb_composite_dev *cdev;
+	struct gadget_info *gi;
+	unsigned long flags;
+	int ret;
+
+	cdev = get_gadget_data(gadget);
+	if (!cdev)
+		return 0;
+
+	gi = container_of(cdev, struct gadget_info, cdev);
+	spin_lock_irqsave(&gi->spinlock, flags);
+	cdev = get_gadget_data(gadget);
+	if (!cdev || gi->unbind) {
+		spin_unlock_irqrestore(&gi->spinlock, flags);
+		return 0;
+	}
+
+	ret = composite_setup(gadget, ctrl);
+	spin_unlock_irqrestore(&gi->spinlock, flags);
+	return ret;
+}
+
+static void configfs_composite_disconnect(struct usb_gadget *gadget)
+{
+	struct usb_composite_dev *cdev;
+	struct gadget_info *gi;
+	unsigned long flags;
+
+	cdev = get_gadget_data(gadget);
+	if (!cdev)
+		return;
+
+	gi = container_of(cdev, struct gadget_info, cdev);
+	spin_lock_irqsave(&gi->spinlock, flags);
+	cdev = get_gadget_data(gadget);
+	if (!cdev || gi->unbind) {
+		spin_unlock_irqrestore(&gi->spinlock, flags);
+		return;
+	}
+
+	composite_disconnect(gadget);
+	spin_unlock_irqrestore(&gi->spinlock, flags);
+}
+
+static void configfs_composite_suspend(struct usb_gadget *gadget)
+{
+	struct usb_composite_dev *cdev;
+	struct gadget_info *gi;
+	unsigned long flags;
+
+	cdev = get_gadget_data(gadget);
+	if (!cdev)
+		return;
+
+	gi = container_of(cdev, struct gadget_info, cdev);
+	spin_lock_irqsave(&gi->spinlock, flags);
+	cdev = get_gadget_data(gadget);
+	if (!cdev || gi->unbind) {
+		spin_unlock_irqrestore(&gi->spinlock, flags);
+		return;
+	}
+
+	composite_suspend(gadget);
+	spin_unlock_irqrestore(&gi->spinlock, flags);
+}
+
+static void configfs_composite_resume(struct usb_gadget *gadget)
+{
+	struct usb_composite_dev *cdev;
+	struct gadget_info *gi;
+	unsigned long flags;
+
+	cdev = get_gadget_data(gadget);
+	if (!cdev)
+		return;
+
+	gi = container_of(cdev, struct gadget_info, cdev);
+	spin_lock_irqsave(&gi->spinlock, flags);
+	cdev = get_gadget_data(gadget);
+	if (!cdev || gi->unbind) {
+		spin_unlock_irqrestore(&gi->spinlock, flags);
+		return;
+	}
+
+	composite_resume(gadget);
+	spin_unlock_irqrestore(&gi->spinlock, flags);
 }
 
 static const struct usb_gadget_driver configfs_driver_template = {
 	.bind           = configfs_composite_bind,
 	.unbind         = configfs_composite_unbind,
 
-	.setup          = composite_setup,
-	.reset          = composite_disconnect,
-	.disconnect     = composite_disconnect,
+	.setup          = configfs_composite_setup,
+	.reset          = configfs_composite_disconnect,
+	.disconnect     = configfs_composite_disconnect,
 
-	.suspend	= composite_suspend,
-	.resume		= composite_resume,
+	.suspend	= configfs_composite_suspend,
+	.resume		= configfs_composite_resume,
 
 	.max_speed	= USB_SPEED_SUPER,
 	.driver = {
-- 
2.20.1



