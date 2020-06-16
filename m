Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3651FB864
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733123AbgFPPzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732800AbgFPPzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:55:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB65D20882;
        Tue, 16 Jun 2020 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322953;
        bh=LWiefAQnaU3ygsFB7gOSKpm+9Fax1oNFwgGN2tI46bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVZQDYO4r0XR5TRNOwHNW2Q1Y3s0AxbIZ2f/07Y9X45m58cgXOIOonECzvQb7CTaW
         G6dHzVxnYKc8mhKaHXrId3yLTkBh6GFrgTwQ03Q1+C7VRnOSoxvVXvS/FQ5UvBwyIN
         k2eQQYUxZ6Ex4tppJSh7F2ZP3c7HQURZ2zh9T6i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        syzbot+9505af1ae303dabdc646@syzkaller.appspotmail.com
Subject: [PATCH 5.6 137/161] ath9k: Fix use-after-free Read in htc_connect_service
Date:   Tue, 16 Jun 2020 17:35:27 +0200
Message-Id: <20200616153112.890095438@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit ced21a4c726bdc60b1680c050a284b08803bc64c upstream.

The skb is consumed by htc_send_epid, so it needn't release again.

The case reported by syzbot:

https://lore.kernel.org/linux-usb/000000000000590f6b05a1c05d15@google.com
usb 1-1: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
usb 1-1: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size:
51008
usb 1-1: Service connection timeout for: 256
==================================================================
BUG: KASAN: use-after-free in atomic_read
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:134
[inline]
BUG: KASAN: use-after-free in skb_unref include/linux/skbuff.h:1042
[inline]
BUG: KASAN: use-after-free in kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
Read of size 4 at addr ffff8881d0957994 by task kworker/1:2/83

Call Trace:
kfree_skb+0x32/0x3d0 net/core/skbuff.c:692
htc_connect_service.cold+0xa9/0x109
drivers/net/wireless/ath/ath9k/htc_hst.c:282
ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
ath9k_init_htc_services.constprop.0+0xb4/0x650
drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
ath9k_htc_probe_device+0x25a/0x1d80
drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
ath9k_htc_hw_init+0x31/0x60
drivers/net/wireless/ath/ath9k/htc_hst.c:501
ath9k_hif_usb_firmware_cb+0x26b/0x500
drivers/net/wireless/ath/ath9k/hif_usb.c:1187
request_firmware_work_func+0x126/0x242
drivers/base/firmware_loader/main.c:976
process_one_work+0x94b/0x1620 kernel/workqueue.c:2264
worker_thread+0x96/0xe20 kernel/workqueue.c:2410
kthread+0x318/0x420 kernel/kthread.c:255
ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 83:
kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2814
__alloc_skb+0xba/0x5a0 net/core/skbuff.c:198
alloc_skb include/linux/skbuff.h:1081 [inline]
htc_connect_service+0x2cc/0x840
drivers/net/wireless/ath/ath9k/htc_hst.c:257
ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
ath9k_init_htc_services.constprop.0+0xb4/0x650
drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
ath9k_htc_probe_device+0x25a/0x1d80
drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
ath9k_htc_hw_init+0x31/0x60
drivers/net/wireless/ath/ath9k/htc_hst.c:501
ath9k_hif_usb_firmware_cb+0x26b/0x500
drivers/net/wireless/ath/ath9k/hif_usb.c:1187
request_firmware_work_func+0x126/0x242
drivers/base/firmware_loader/main.c:976
process_one_work+0x94b/0x1620 kernel/workqueue.c:2264
worker_thread+0x96/0xe20 kernel/workqueue.c:2410
kthread+0x318/0x420 kernel/kthread.c:255
ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 0:
kfree_skb+0x102/0x3d0 net/core/skbuff.c:690
ath9k_htc_txcompletion_cb+0x1f8/0x2b0
drivers/net/wireless/ath/ath9k/htc_hst.c:356
hif_usb_regout_cb+0x10b/0x1b0
drivers/net/wireless/ath/ath9k/hif_usb.c:90
__usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
__do_softirq+0x21e/0x950 kernel/softirq.c:292

Reported-and-tested-by: syzbot+9505af1ae303dabdc646@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200404041838.10426-2-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    3 ---
 drivers/net/wireless/ath/ath9k/wmi.c     |    1 -
 2 files changed, 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -170,7 +170,6 @@ static int htc_config_pipe_credits(struc
 	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
 	if (!time_left) {
 		dev_err(target->dev, "HTC credit config timeout\n");
-		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
@@ -206,7 +205,6 @@ static int htc_setup_complete(struct htc
 	time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
 	if (!time_left) {
 		dev_err(target->dev, "HTC start timeout\n");
-		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
@@ -279,7 +277,6 @@ int htc_connect_service(struct htc_targe
 	if (!time_left) {
 		dev_err(target->dev, "Service connection timeout for: %d\n",
 			service_connreq->service_id);
-		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -336,7 +336,6 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
 		mutex_unlock(&wmi->op_mutex);
-		kfree_skb(skb);
 		return -ETIMEDOUT;
 	}
 


