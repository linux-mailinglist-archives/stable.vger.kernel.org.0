Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAF52F694
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfE3E5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbfE3DJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:56 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A498C24493;
        Thu, 30 May 2019 03:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185795;
        bh=e7YpTiI/R85tFaDldvpcVyKXKZReWeOqdmOkGxnT2Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuLboCVibiVk44/JLL43f56dCG1aGBBVtpNOWOGw55Es0Ed1oUxNgjmL1yjSfWRfb
         X8JENA72lzfq4YBcNYn3xZLoJboIbvQ4JC/tHy/QVcokhNRPdtkkkFrc/Wyb7KdlTP
         S0gTlsikM5lthzPi3GXXLNvyNRkx44FPT77iWuXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 071/405] usb: dwc3: move synchronize_irq() out of the spinlock protected block
Date:   Wed, 29 May 2019 20:01:09 -0700
Message-Id: <20190530030544.519906721@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 41a91c606e7d2b74358a944525267cc451c271e8 ]

dwc3_gadget_suspend() is called under dwc->lock spinlock. In such context
calling synchronize_irq() is not allowed. Move the problematic call out
of the protected block to fix the following kernel BUG during system
suspend:

BUG: sleeping function called from invalid context at kernel/irq/manage.c:112
in_atomic(): 1, irqs_disabled(): 128, pid: 1601, name: rtcwake
6 locks held by rtcwake/1601:
 #0: f70ac2a2 (sb_writers#7){.+.+}, at: vfs_write+0x130/0x16c
 #1: b5fe1270 (&of->mutex){+.+.}, at: kernfs_fop_write+0xc0/0x1e4
 #2: 7e597705 (kn->count#60){.+.+}, at: kernfs_fop_write+0xc8/0x1e4
 #3: 8b3527d0 (system_transition_mutex){+.+.}, at: pm_suspend+0xc4/0xc04
 #4: fc7f1c42 (&dev->mutex){....}, at: __device_suspend+0xd8/0x74c
 #5: 4b36507e (&(&dwc->lock)->rlock){....}, at: dwc3_gadget_suspend+0x24/0x3c
irq event stamp: 11252
hardirqs last  enabled at (11251): [<c09c54a4>] _raw_spin_unlock_irqrestore+0x6c/0x74
hardirqs last disabled at (11252): [<c09c4d44>] _raw_spin_lock_irqsave+0x1c/0x5c
softirqs last  enabled at (9744): [<c0102564>] __do_softirq+0x3a4/0x66c
softirqs last disabled at (9737): [<c0128528>] irq_exit+0x140/0x168
Preemption disabled at:
[<00000000>]   (null)
CPU: 7 PID: 1601 Comm: rtcwake Not tainted
5.0.0-rc3-next-20190122-00039-ga3f4ee4f8a52 #5252
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[<c01110f0>] (unwind_backtrace) from [<c010d120>] (show_stack+0x10/0x14)
[<c010d120>] (show_stack) from [<c09a4d04>] (dump_stack+0x90/0xc8)
[<c09a4d04>] (dump_stack) from [<c014c700>] (___might_sleep+0x22c/0x2c8)
[<c014c700>] (___might_sleep) from [<c0189d68>] (synchronize_irq+0x28/0x84)
[<c0189d68>] (synchronize_irq) from [<c05cbbf8>] (dwc3_gadget_suspend+0x34/0x3c)
[<c05cbbf8>] (dwc3_gadget_suspend) from [<c05bd020>] (dwc3_suspend_common+0x154/0x410)
[<c05bd020>] (dwc3_suspend_common) from [<c05bd34c>] (dwc3_suspend+0x14/0x2c)
[<c05bd34c>] (dwc3_suspend) from [<c051c730>] (platform_pm_suspend+0x2c/0x54)
[<c051c730>] (platform_pm_suspend) from [<c05285d4>] (dpm_run_callback+0xa4/0x3dc)
[<c05285d4>] (dpm_run_callback) from [<c0528a40>] (__device_suspend+0x134/0x74c)
[<c0528a40>] (__device_suspend) from [<c052c508>] (dpm_suspend+0x174/0x588)
[<c052c508>] (dpm_suspend) from [<c0182134>] (suspend_devices_and_enter+0xc0/0xe74)
[<c0182134>] (suspend_devices_and_enter) from [<c0183658>] (pm_suspend+0x770/0xc04)
[<c0183658>] (pm_suspend) from [<c0180ddc>] (state_store+0x6c/0xcc)
[<c0180ddc>] (state_store) from [<c09a9a70>] (kobj_attr_store+0x14/0x20)
[<c09a9a70>] (kobj_attr_store) from [<c02d6800>] (sysfs_kf_write+0x4c/0x50)
[<c02d6800>] (sysfs_kf_write) from [<c02d594c>] (kernfs_fop_write+0xfc/0x1e4)
[<c02d594c>] (kernfs_fop_write) from [<c02593d8>] (__vfs_write+0x2c/0x160)
[<c02593d8>] (__vfs_write) from [<c0259694>] (vfs_write+0xa4/0x16c)
[<c0259694>] (vfs_write) from [<c0259870>] (ksys_write+0x40/0x8c)
[<c0259870>] (ksys_write) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
Exception stack(0xed55ffa8 to 0xed55fff0)
...

Fixes: 01c10880d242 ("usb: dwc3: gadget: synchronize_irq dwc irq in suspend")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   | 2 ++
 drivers/usb/dwc3/gadget.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f944cea4056bc..72110a8c49d68 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1600,6 +1600,7 @@ static int dwc3_suspend_common(struct dwc3 *dwc, pm_message_t msg)
 		spin_lock_irqsave(&dwc->lock, flags);
 		dwc3_gadget_suspend(dwc);
 		spin_unlock_irqrestore(&dwc->lock, flags);
+		synchronize_irq(dwc->irq_gadget);
 		dwc3_core_exit(dwc);
 		break;
 	case DWC3_GCTL_PRTCAP_HOST:
@@ -1632,6 +1633,7 @@ static int dwc3_suspend_common(struct dwc3 *dwc, pm_message_t msg)
 			spin_lock_irqsave(&dwc->lock, flags);
 			dwc3_gadget_suspend(dwc);
 			spin_unlock_irqrestore(&dwc->lock, flags);
+			synchronize_irq(dwc->irq_gadget);
 		}
 
 		dwc3_otg_exit(dwc);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e293400cc6e95..2bb0ff9608d30 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3384,8 +3384,6 @@ int dwc3_gadget_suspend(struct dwc3 *dwc)
 	dwc3_disconnect_gadget(dwc);
 	__dwc3_gadget_stop(dwc);
 
-	synchronize_irq(dwc->irq_gadget);
-
 	return 0;
 }
 
-- 
2.20.1



