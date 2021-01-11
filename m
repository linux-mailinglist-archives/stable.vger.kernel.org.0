Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E3A2F1453
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732650AbhAKNRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:17:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732644AbhAKNRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 310AD229C4;
        Mon, 11 Jan 2021 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371013;
        bh=jo4RtVvdmWtVgWNCwYhEMwcWPnuklUH9D2hsuT5/PuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXvQzC797zPpPEhWfE/3lMFHYyJOYmm/2UVG9xKQ0CiRKQDP99+t98y+cXFXxvkh5
         rPHH/1focqjzJ5P+2vTBDXOXmysm2CTya5ZcFK8ksLErX2LmQzszbGNjPcR3Ekvu8L
         btvHOklclKgRQYF19A6QdBORuWlQuxOI9zd7v2Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Sriharsha Allenki <sallenki@codeaurora.org>
Subject: [PATCH 5.10 104/145] usb: gadget: Fix spinlock lockup on usb_function_deactivate
Date:   Mon, 11 Jan 2021 14:02:08 +0100
Message-Id: <20210111130053.525476779@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriharsha Allenki <sallenki@codeaurora.org>

commit 5cc35c224a80aa5a5a539510ef049faf0d6ed181 upstream.

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
 drivers/usb/gadget/composite.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -392,8 +392,11 @@ int usb_function_deactivate(struct usb_f
 
 	spin_lock_irqsave(&cdev->lock, flags);
 
-	if (cdev->deactivations == 0)
+	if (cdev->deactivations == 0) {
+		spin_unlock_irqrestore(&cdev->lock, flags);
 		status = usb_gadget_deactivate(cdev->gadget);
+		spin_lock_irqsave(&cdev->lock, flags);
+	}
 	if (status == 0)
 		cdev->deactivations++;
 
@@ -424,8 +427,11 @@ int usb_function_activate(struct usb_fun
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


