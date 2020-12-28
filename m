Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906632E3FDE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506456AbgL1Op1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506447AbgL1Op0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:45:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8214207CF;
        Mon, 28 Dec 2020 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166685;
        bh=8r8pfW3kW1OAGDdCmSeyKwa37PHvNQoO4Jzf+T1Dx8o=;
        h=Subject:To:From:Date:From;
        b=01La07FLV49xWK5q4eJT2TwOgi7syXmljHo9RDbMUxvNNZvjuIoCF/p2GkwsOsopR
         daari8xNgByjqtCt0RWrCotMZttJWKelZjMV4WwYPPsX5lSBm+O/zdj9qnrC6NNdMM
         yL6qtuouOH+Sp3xK992X3Kk8rcEbs0crK+aqhkgA=
Subject: patch "usb: gadget: Fix spinlock lockup on usb_function_deactivate" added to usb-linus
To:     sallenki@codeaurora.org, gregkh@linuxfoundation.org,
        peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:46:03 +0100
Message-ID: <160916676346169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: Fix spinlock lockup on usb_function_deactivate

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5cc35c224a80aa5a5a539510ef049faf0d6ed181 Mon Sep 17 00:00:00 2001
From: Sriharsha Allenki <sallenki@codeaurora.org>
Date: Wed, 2 Dec 2020 18:32:20 +0530
Subject: usb: gadget: Fix spinlock lockup on usb_function_deactivate

There is a spinlock lockup as part of composite_disconnect
when it tries to acquire cdev->lock as part of usb_gadget_deactivate.
This is because the usb_gadget_deactivate is called from
usb_function_deactivate with the same spinlock held.

This would result in the below call stack and leads to stall.

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu:     3-...0: (1 GPs behind) idle=162/1/0x4000000000000000
softirq=10819/10819 fqs=2356
 (detected by 2, t=5252 jiffies, g=20129, q=3770)
 Task dump for CPU 3:
 task:uvc-gadget_wlhe state:R  running task     stack:    0 pid:  674 ppid:
 636 flags:0x00000202
 Call trace:
  __switch_to+0xc0/0x170
  _raw_spin_lock_irqsave+0x84/0xb0
  composite_disconnect+0x28/0x78
  configfs_composite_disconnect+0x68/0x70
  usb_gadget_disconnect+0x10c/0x128
  usb_gadget_deactivate+0xd4/0x108
  usb_function_deactivate+0x6c/0x80
  uvc_function_disconnect+0x20/0x58
  uvc_v4l2_release+0x30/0x88
  v4l2_release+0xbc/0xf0
  __fput+0x7c/0x230
  ____fput+0x14/0x20
  task_work_run+0x88/0x140
  do_notify_resume+0x240/0x6f0
  work_pending+0x8/0x200

Fix this by doing an unlock on cdev->lock before the usb_gadget_deactivate
call from usb_function_deactivate.

The same lockup can happen in the usb_gadget_activate path. Fix that path
as well.

Reported-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/linux-usb/20201102094936.GA29581@b29397-desktop/
Tested-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201202130220.24926-1-sallenki@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index c6d455f2bb92..1a556a628971 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -392,8 +392,11 @@ int usb_function_deactivate(struct usb_function *function)
 
 	spin_lock_irqsave(&cdev->lock, flags);
 
-	if (cdev->deactivations == 0)
+	if (cdev->deactivations == 0) {
+		spin_unlock_irqrestore(&cdev->lock, flags);
 		status = usb_gadget_deactivate(cdev->gadget);
+		spin_lock_irqsave(&cdev->lock, flags);
+	}
 	if (status == 0)
 		cdev->deactivations++;
 
@@ -424,8 +427,11 @@ int usb_function_activate(struct usb_function *function)
 		status = -EINVAL;
 	else {
 		cdev->deactivations--;
-		if (cdev->deactivations == 0)
+		if (cdev->deactivations == 0) {
+			spin_unlock_irqrestore(&cdev->lock, flags);
 			status = usb_gadget_activate(cdev->gadget);
+			spin_lock_irqsave(&cdev->lock, flags);
+		}
 	}
 
 	spin_unlock_irqrestore(&cdev->lock, flags);
-- 
2.29.2


