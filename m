Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E842A56B7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbgKCVag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732795AbgKCU6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E05C7223BF;
        Tue,  3 Nov 2020 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437081;
        bh=EdS+kfzuRkMqmalH/7Aic7ywWj8smr3+f8rIv9f6dZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOGZyu5TZ4MJZU1Of87kTDsKvVOW+hh5p+bioNESJyRWUTVqNMJlKF6NTunA4Ln/i
         CKTKSGpDBhHyLtUZa7jRlkLpn0cslDqaHGa55tmFSXfOffZ5XIAFAhmzMint26WhRM
         71HnC7o+bULG6ZPJW3j04Gw6YGSd/3304m5h9W5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.4 138/214] usb: dwc3: core: dont trigger runtime pm when remove driver
Date:   Tue,  3 Nov 2020 21:36:26 +0100
Message-Id: <20201103203303.766688450@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 266d0493900ac5d6a21cdbe6b1624ed2da94d47a upstream.

No need to trigger runtime pm in driver removal, otherwise if user
disable auto suspend via sys file, runtime suspend may be entered,
which will call dwc3_core_exit() again and there will be clock disable
not balance warning:

[ 2026.820154] xhci-hcd xhci-hcd.0.auto: remove, state 4
[ 2026.825268] usb usb2: USB disconnect, device number 1
[ 2026.831017] xhci-hcd xhci-hcd.0.auto: USB bus 2 deregistered
[ 2026.836806] xhci-hcd xhci-hcd.0.auto: remove, state 4
[ 2026.842029] usb usb1: USB disconnect, device number 1
[ 2026.848029] xhci-hcd xhci-hcd.0.auto: USB bus 1 deregistered
[ 2026.865889] ------------[ cut here ]------------
[ 2026.870506] usb2_ctrl_root_clk already disabled
[ 2026.875082] WARNING: CPU: 0 PID: 731 at drivers/clk/clk.c:958
clk_core_disable+0xa0/0xa8
[ 2026.883170] Modules linked in: dwc3(-) phy_fsl_imx8mq_usb [last
unloaded: dwc3]
[ 2026.890488] CPU: 0 PID: 731 Comm: rmmod Not tainted
5.8.0-rc7-00280-g9d08cca-dirty #245
[ 2026.898489] Hardware name: NXP i.MX8MQ EVK (DT)
[ 2026.903020] pstate: 20000085 (nzCv daIf -PAN -UAO BTYPE=--)
[ 2026.908594] pc : clk_core_disable+0xa0/0xa8
[ 2026.912777] lr : clk_core_disable+0xa0/0xa8
[ 2026.916958] sp : ffff8000121b39a0
[ 2026.920271] x29: ffff8000121b39a0 x28: ffff0000b11f3700
[ 2026.925583] x27: 0000000000000000 x26: ffff0000b539c700
[ 2026.930895] x25: 000001d7e44e1232 x24: ffff0000b76fa800
[ 2026.936208] x23: ffff0000b76fa6f8 x22: ffff800008d01040
[ 2026.941520] x21: ffff0000b539ce00 x20: ffff0000b7105000
[ 2026.946832] x19: ffff0000b7105000 x18: 0000000000000010
[ 2026.952144] x17: 0000000000000001 x16: 0000000000000000
[ 2026.957456] x15: ffff0000b11f3b70 x14: ffffffffffffffff
[ 2026.962768] x13: ffff8000921b36f7 x12: ffff8000121b36ff
[ 2026.968080] x11: ffff8000119e1000 x10: ffff800011bf26d0
[ 2026.973392] x9 : 0000000000000000 x8 : ffff800011bf3000
[ 2026.978704] x7 : ffff800010695d68 x6 : 0000000000000252
[ 2026.984016] x5 : ffff0000bb9881f0 x4 : 0000000000000000
[ 2026.989327] x3 : 0000000000000027 x2 : 0000000000000023
[ 2026.994639] x1 : ac2fa471aa7cab00 x0 : 0000000000000000
[ 2026.999951] Call trace:
[ 2027.002401]  clk_core_disable+0xa0/0xa8
[ 2027.006238]  clk_core_disable_lock+0x20/0x38
[ 2027.010508]  clk_disable+0x1c/0x28
[ 2027.013911]  clk_bulk_disable+0x34/0x50
[ 2027.017758]  dwc3_core_exit+0xec/0x110 [dwc3]
[ 2027.022122]  dwc3_suspend_common+0x84/0x188 [dwc3]
[ 2027.026919]  dwc3_runtime_suspend+0x74/0x9c [dwc3]
[ 2027.031712]  pm_generic_runtime_suspend+0x28/0x40
[ 2027.036419]  genpd_runtime_suspend+0xa0/0x258
[ 2027.040777]  __rpm_callback+0x88/0x140
[ 2027.044526]  rpm_callback+0x20/0x80
[ 2027.048015]  rpm_suspend+0xd0/0x418
[ 2027.051503]  __pm_runtime_suspend+0x58/0xa0
[ 2027.055693]  dwc3_runtime_idle+0x7c/0x90 [dwc3]
[ 2027.060224]  __rpm_callback+0x88/0x140
[ 2027.063973]  rpm_idle+0x78/0x150
[ 2027.067201]  __pm_runtime_idle+0x58/0xa0
[ 2027.071130]  dwc3_remove+0x64/0xc0 [dwc3]
[ 2027.075140]  platform_drv_remove+0x28/0x48
[ 2027.079239]  device_release_driver_internal+0xf4/0x1c0
[ 2027.084377]  driver_detach+0x4c/0xd8
[ 2027.087954]  bus_remove_driver+0x54/0xa8
[ 2027.091877]  driver_unregister+0x2c/0x58
[ 2027.095799]  platform_driver_unregister+0x10/0x18
[ 2027.100509]  dwc3_driver_exit+0x14/0x1408 [dwc3]
[ 2027.105129]  __arm64_sys_delete_module+0x178/0x218
[ 2027.109922]  el0_svc_common.constprop.0+0x68/0x160
[ 2027.114714]  do_el0_svc+0x20/0x80
[ 2027.118031]  el0_sync_handler+0x88/0x190
[ 2027.121953]  el0_sync+0x140/0x180
[ 2027.125267] ---[ end trace 027f4f8189958f1f ]---
[ 2027.129976] ------------[ cut here ]------------

Fixes: fc8bb91bc83e ("usb: dwc3: implement runtime PM")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1581,9 +1581,9 @@ static int dwc3_remove(struct platform_d
 	dwc3_core_exit(dwc);
 	dwc3_ulpi_exit(dwc);
 
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_allow(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	dwc3_free_event_buffers(dwc);
 	dwc3_free_scratch_buffers(dwc);


