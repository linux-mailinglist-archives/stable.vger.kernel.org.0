Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350132A51A9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgKCUm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:42:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730592AbgKCUmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:42:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF04C223AC;
        Tue,  3 Nov 2020 20:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436173;
        bh=OciS+22kPt/cqDa1LKTGI61esaQCpAFxigNTqlL3T+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA/2ElpcZwp7cJHB/fsLohpL1i1i1L0hux1UP0LPeiqLONBEHecri9uYmzOnFZEne
         4wfHyZyUwmAkQ3z21FQYAocRkcTaG61OrcH4onOD8xBuqPHNxVK9Zvxj1GDsrZrUXX
         1Ei4SjrAC+sGJxBxhFIEk5wajmYQT1WHehayF3Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 133/391] usb: dwc3: core: do not queue work if dr_mode is not USB_DR_MODE_OTG
Date:   Tue,  3 Nov 2020 21:33:04 +0100
Message-Id: <20201103203355.803855607@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

[ Upstream commit dc336b19e82d0454ea60270cd18fbb4749e162f6 ]

Do not try to queue a drd work if dr_mode is not USB_DR_MODE_OTG
because the work is not inited, this may be triggered by user try
to change mode file of debugfs on a single role port, which will
cause below kernel dump:
[   60.115529] ------------[ cut here ]------------
[   60.120166] WARNING: CPU: 1 PID: 627 at kernel/workqueue.c:1473
__queue_work+0x46c/0x520
[   60.128254] Modules linked in:
[   60.131313] CPU: 1 PID: 627 Comm: sh Not tainted
5.7.0-rc4-00022-g914a586-dirty #135
[   60.139054] Hardware name: NXP i.MX8MQ EVK (DT)
[   60.143585] pstate: a0000085 (NzCv daIf -PAN -UAO)
[   60.148376] pc : __queue_work+0x46c/0x520
[   60.152385] lr : __queue_work+0x314/0x520
[   60.156393] sp : ffff8000124ebc40
[   60.159705] x29: ffff8000124ebc40 x28: ffff800011808018
[   60.165018] x27: ffff800011819ef8 x26: ffff800011d39980
[   60.170331] x25: ffff800011808018 x24: 0000000000000100
[   60.175643] x23: 0000000000000013 x22: 0000000000000001
[   60.180955] x21: ffff0000b7c08e00 x20: ffff0000b6c31080
[   60.186267] x19: ffff0000bb99bc00 x18: 0000000000000000
[   60.191579] x17: 0000000000000000 x16: 0000000000000000
[   60.196891] x15: 0000000000000000 x14: 0000000000000000
[   60.202202] x13: 0000000000000000 x12: 0000000000000000
[   60.207515] x11: 0000000000000000 x10: 0000000000000040
[   60.212827] x9 : ffff800011d55460 x8 : ffff800011d55458
[   60.218138] x7 : ffff0000b7800028 x6 : 0000000000000000
[   60.223450] x5 : ffff0000b7800000 x4 : 0000000000000000
[   60.228762] x3 : ffff0000bb997cc0 x2 : 0000000000000001
[   60.234074] x1 : 0000000000000000 x0 : ffff0000b6c31088
[   60.239386] Call trace:
[   60.241834]  __queue_work+0x46c/0x520
[   60.245496]  queue_work_on+0x6c/0x90
[   60.249075]  dwc3_set_mode+0x48/0x58
[   60.252651]  dwc3_mode_write+0xf8/0x150
[   60.256489]  full_proxy_write+0x5c/0xa8
[   60.260327]  __vfs_write+0x18/0x40
[   60.263729]  vfs_write+0xdc/0x1c8
[   60.267045]  ksys_write+0x68/0xf0
[   60.270360]  __arm64_sys_write+0x18/0x20
[   60.274286]  el0_svc_common.constprop.0+0x68/0x160
[   60.279077]  do_el0_svc+0x20/0x80
[   60.282394]  el0_sync_handler+0x10c/0x178
[   60.286403]  el0_sync+0x140/0x180
[   60.289716] ---[ end trace 70b155582e2b7988 ]---

Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 2f9f4ad562d4e..6dd02a8802f4b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -121,9 +121,6 @@ static void __dwc3_set_mode(struct work_struct *work)
 	int ret;
 	u32 reg;
 
-	if (dwc->dr_mode != USB_DR_MODE_OTG)
-		return;
-
 	pm_runtime_get_sync(dwc->dev);
 
 	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_OTG)
@@ -209,6 +206,9 @@ void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
 {
 	unsigned long flags;
 
+	if (dwc->dr_mode != USB_DR_MODE_OTG)
+		return;
+
 	spin_lock_irqsave(&dwc->lock, flags);
 	dwc->desired_dr_role = mode;
 	spin_unlock_irqrestore(&dwc->lock, flags);
-- 
2.27.0



