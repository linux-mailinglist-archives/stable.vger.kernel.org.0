Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D68134BB8
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgAHTqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43576 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730433AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oy-D3; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnV-Gk; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Winter Wang" <wente.wang@nxp.com>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>
Date:   Wed, 08 Jan 2020 19:43:36 +0000
Message-ID: <lsq.1578512578.562941192@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 38/63] usb: gadget: configfs: add mutex lock before
 unregister gadget
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Winter Wang <wente.wang@nxp.com>

commit cee51c33f52ebf673a088a428ac0fecc33ab77fa upstream.

There may be a race condition if f_fs calls unregister_gadget_item in
ffs_closed() when unregister_gadget is called by UDC store at the same time.
this leads to a kernel NULL pointer dereference:

[  310.644928] Unable to handle kernel NULL pointer dereference at virtual address 00000004
[  310.645053] init: Service 'adbd' is being killed...
[  310.658938] pgd = c9528000
[  310.662515] [00000004] *pgd=19451831, *pte=00000000, *ppte=00000000
[  310.669702] Internal error: Oops: 817 [#1] PREEMPT SMP ARM
[  310.675211] Modules linked in:
[  310.678294] CPU: 0 PID: 1537 Comm: ->transport Not tainted 4.1.15-03725-g793404c #2
[  310.685958] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  310.692493] task: c8e24200 ti: c945e000 task.ti: c945e000
[  310.697911] PC is at usb_gadget_unregister_driver+0xb4/0xd0
[  310.703502] LR is at __mutex_lock_slowpath+0x10c/0x16c
[  310.708648] pc : [<c075efc0>]    lr : [<c0bfb0bc>]    psr: 600f0113
<snip..>
[  311.565585] [<c075efc0>] (usb_gadget_unregister_driver) from [<c075e2b8>] (unregister_gadget_item+0x1c/0x34)
[  311.575426] [<c075e2b8>] (unregister_gadget_item) from [<c076fcc8>] (ffs_closed+0x8c/0x9c)
[  311.583702] [<c076fcc8>] (ffs_closed) from [<c07736b8>] (ffs_data_reset+0xc/0xa0)
[  311.591194] [<c07736b8>] (ffs_data_reset) from [<c07738ac>] (ffs_data_closed+0x90/0xd0)
[  311.599208] [<c07738ac>] (ffs_data_closed) from [<c07738f8>] (ffs_ep0_release+0xc/0x14)
[  311.607224] [<c07738f8>] (ffs_ep0_release) from [<c023e030>] (__fput+0x80/0x1d0)
[  311.614635] [<c023e030>] (__fput) from [<c014e688>] (task_work_run+0xb0/0xe8)
[  311.621788] [<c014e688>] (task_work_run) from [<c010afdc>] (do_work_pending+0x7c/0xa4)
[  311.629718] [<c010afdc>] (do_work_pending) from [<c010770c>] (work_pending+0xc/0x20)

for functions using functionFS, i.e. android adbd will close /dev/usb-ffs/adb/ep0
when usb IO thread fails, but switch adb from on to off also triggers write
"none" > UDC. These 2 operations both call unregister_gadget, which will lead
to the panic above.

add a mutex before calling unregister_gadget for api used in f_fs.

Signed-off-by: Winter Wang <wente.wang@nxp.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/configfs.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1551,7 +1551,9 @@ void unregister_gadget_item(struct confi
 {
 	struct gadget_info *gi = to_gadget_info(item);
 
+	mutex_lock(&gi->lock);
 	unregister_gadget(gi);
+	mutex_unlock(&gi->lock);
 }
 EXPORT_SYMBOL_GPL(unregister_gadget_item);
 

