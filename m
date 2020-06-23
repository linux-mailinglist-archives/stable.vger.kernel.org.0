Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94E42065B9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388355AbgFWUK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388213AbgFWUKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:10:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B09220707;
        Tue, 23 Jun 2020 20:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943016;
        bh=X1zmRIQzunuZkpm02VUcFkM7W8vrlvLe2V2q5DL0U5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2OUHun87ky22n4XIye1qlDwcxf35i10X1+CUSW/i7364BcW0OoTb3RzA7CgCXn4ch
         KC2FlRgNkUes09YJc3FQnataX4zld5i2jRdmkAonJSyKIQtgESxWL8HObxVT0W7lJD
         w66lFFfGITPqMQRpjBbvDOkDGXphLNuP2XDfDUEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Qais Yousef <qais.yousef@arm.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 226/477] usb/ohci-platform: Fix a warning when hibernating
Date:   Tue, 23 Jun 2020 21:53:43 +0200
Message-Id: <20200623195418.263092617@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 1cb3b0095c3d0bb96912bfbbce4fc006d41f367c ]

The following warning was observed when attempting to suspend to disk
using a USB flash as a swap device.

[  111.779649] ------------[ cut here ]------------
[  111.788382] URB (____ptrval____) submitted while active
[  111.796646] WARNING: CPU: 3 PID: 365 at drivers/usb/core/urb.c:363 usb_submit_urb+0x3d8/0x590
[  111.805417] Modules linked in:
[  111.808584] CPU: 3 PID: 365 Comm: kworker/3:2 Not tainted 5.6.0-rc6-00002-gdfd1731f9a3e-dirty #545
[  111.817796] Hardware name: ARM Juno development board (r2) (DT)
[  111.823896] Workqueue: usb_hub_wq hub_event
[  111.828217] pstate: 60000005 (nZCv daif -PAN -UAO)
[  111.833156] pc : usb_submit_urb+0x3d8/0x590
[  111.837471] lr : usb_submit_urb+0x3d8/0x590
[  111.841783] sp : ffff800018de38b0
[  111.845205] x29: ffff800018de38b0 x28: 0000000000000003
[  111.850682] x27: ffff000970530b20 x26: ffff8000133fd000
[  111.856159] x25: ffff8000133fd000 x24: ffff800018de3b38
[  111.861635] x23: 0000000000000004 x22: 0000000000000c00
[  111.867112] x21: 0000000000000000 x20: 00000000fffffff0
[  111.872589] x19: ffff0009704e7a00 x18: ffffffffffffffff
[  111.878065] x17: 00000000a7c8f4bc x16: 000000002af33de8
[  111.883542] x15: ffff8000133fda88 x14: 0720072007200720
[  111.889019] x13: 0720072007200720 x12: 0720072007200720
[  111.894496] x11: 0000000000000000 x10: 00000000a5286134
[  111.899973] x9 : 0000000000000002 x8 : ffff000970c837a0
[  111.905449] x7 : 0000000000000000 x6 : ffff800018de3570
[  111.910926] x5 : 0000000000000001 x4 : 0000000000000003
[  111.916401] x3 : 0000000000000000 x2 : ffff800013427118
[  111.921879] x1 : 9d4e965b4b7d7c00 x0 : 0000000000000000
[  111.927356] Call trace:
[  111.929892]  usb_submit_urb+0x3d8/0x590
[  111.933852]  hub_activate+0x108/0x7f0
[  111.937633]  hub_resume+0xac/0x148
[  111.941149]  usb_resume_interface.isra.10+0x60/0x138
[  111.946265]  usb_resume_both+0xe4/0x140
[  111.950225]  usb_runtime_resume+0x24/0x30
[  111.954365]  __rpm_callback+0xdc/0x138
[  111.958236]  rpm_callback+0x34/0x98
[  111.961841]  rpm_resume+0x4a8/0x720
[  111.965445]  rpm_resume+0x50c/0x720
[  111.969049]  __pm_runtime_resume+0x4c/0xb8
[  111.973276]  usb_autopm_get_interface+0x28/0x60
[  111.977948]  hub_event+0x80/0x16d8
[  111.981466]  process_one_work+0x2a4/0x748
[  111.985604]  worker_thread+0x48/0x498
[  111.989387]  kthread+0x13c/0x140
[  111.992725]  ret_from_fork+0x10/0x18
[  111.996415] irq event stamp: 354
[  111.999756] hardirqs last  enabled at (353): [<ffff80001019ea1c>] console_unlock+0x504/0x5b8
[  112.008441] hardirqs last disabled at (354): [<ffff8000100a95d0>] do_debug_exception+0x1a8/0x258
[  112.017479] softirqs last  enabled at (350): [<ffff8000100818a4>] __do_softirq+0x4bc/0x568
[  112.025984] softirqs last disabled at (343): [<ffff8000101145a4>] irq_exit+0x144/0x150
[  112.034129] ---[ end trace dc96030b9cf6c8a3 ]---

The problem was tracked down to a missing call to
pm_runtime_set_active() on resume in ohci-platform.

Link: https://lore.kernel.org/lkml/20200323143857.db5zphxhq4hz3hmd@e107158-lin.cambridge.arm.com/
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
CC: Tony Prisk <linux@prisktech.co.nz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mathias Nyman <mathias.nyman@intel.com>
CC: Oliver Neukum <oneukum@suse.de>
CC: linux-arm-kernel@lists.infradead.org
CC: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20200518154931.6144-1-qais.yousef@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-platform.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index 7addfc2cbadce..4a8456f12a73d 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -299,6 +299,11 @@ static int ohci_platform_resume(struct device *dev)
 	}
 
 	ohci_resume(hcd, false);
+
+	pm_runtime_disable(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
-- 
2.25.1



