Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32312C9CBC
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388242AbgLAJAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387583AbgLAJAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:00:07 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85A8722210;
        Tue,  1 Dec 2020 08:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813166;
        bh=iOrJ3ZzUQIQ8q8Ox9QHU72nvkQcVzjD4UgV0MnCl7Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cU3PslkNs5NjZ3W3/YI/S9LQ3BCpBy80N4iypfYS090GEf62tELziIlmyI9ZLG4Zk
         ZaiSgLGFmJu2fU5cXwC4L/nC2myykKkxO12BGbggJ9f7Ae7CdF2JEzTQuFCebbiS6e
         4q99ENeYkE+L4RTnSYn4W/PCFmA1Wzo+z0vPSOq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/50] phy: tegra: xusb: Fix dangling pointer on probe failure
Date:   Tue,  1 Dec 2020 09:53:25 +0100
Message-Id: <20201201084648.319742063@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit eb9c4dd9bdfdebaa13846c16a8c79b5b336066b6 ]

If, for some reason, the xusb PHY fails to probe, it leaves
a dangling pointer attached to the platform device structure.

This would normally be harmless, but the Tegra XHCI driver then
goes and extract that pointer from the PHY device. Things go
downhill from there:

    8.752082] [004d554e5145533c] address between user and kernel address ranges
[    8.752085] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    8.752088] Modules linked in: max77620_regulator(E+) xhci_tegra(E+) sdhci_tegra(E+) xhci_hcd(E) sdhci_pltfm(E) cqhci(E) fixed(E) usbcore(E) scsi_mod(E) sdhci(E) host1x(E+)
[    8.752103] CPU: 4 PID: 158 Comm: systemd-udevd Tainted: G S      W   E     5.9.0-rc7-00298-gf6337624c4fe #1980
[    8.752105] Hardware name: NVIDIA Jetson TX2 Developer Kit (DT)
[    8.752108] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
[    8.752115] pc : kobject_put+0x1c/0x21c
[    8.752120] lr : put_device+0x20/0x30
[    8.752121] sp : ffffffc012eb3840
[    8.752122] x29: ffffffc012eb3840 x28: ffffffc010e82638
[    8.752125] x27: ffffffc008d56440 x26: 0000000000000000
[    8.752128] x25: ffffff81eb508200 x24: 0000000000000000
[    8.752130] x23: ffffff81eb538800 x22: 0000000000000000
[    8.752132] x21: 00000000fffffdfb x20: ffffff81eb538810
[    8.752134] x19: 3d4d554e51455300 x18: 0000000000000020
[    8.752136] x17: ffffffc008d00270 x16: ffffffc008d00c94
[    8.752138] x15: 0000000000000004 x14: ffffff81ebd4ae90
[    8.752140] x13: 0000000000000000 x12: ffffff81eb86a4e8
[    8.752142] x11: ffffff81eb86a480 x10: ffffff81eb862fea
[    8.752144] x9 : ffffffc01055fb28 x8 : ffffff81eb86a4a8
[    8.752146] x7 : 0000000000000001 x6 : 0000000000000001
[    8.752148] x5 : ffffff81dff8bc38 x4 : 0000000000000000
[    8.752150] x3 : 0000000000000001 x2 : 0000000000000001
[    8.752152] x1 : 0000000000000002 x0 : 3d4d554e51455300
[    8.752155] Call trace:
[    8.752157]  kobject_put+0x1c/0x21c
[    8.752160]  put_device+0x20/0x30
[    8.752164]  tegra_xusb_padctl_put+0x24/0x3c
[    8.752170]  tegra_xusb_probe+0x8b0/0xd10 [xhci_tegra]
[    8.752174]  platform_drv_probe+0x60/0xb4
[    8.752176]  really_probe+0xf0/0x504
[    8.752179]  driver_probe_device+0x100/0x170
[    8.752181]  device_driver_attach+0xcc/0xd4
[    8.752183]  __driver_attach+0xb0/0x17c
[    8.752185]  bus_for_each_dev+0x7c/0xd4
[    8.752187]  driver_attach+0x30/0x3c
[    8.752189]  bus_add_driver+0x154/0x250
[    8.752191]  driver_register+0x84/0x140
[    8.752193]  __platform_driver_register+0x54/0x60
[    8.752197]  tegra_xusb_init+0x40/0x1000 [xhci_tegra]
[    8.752201]  do_one_initcall+0x54/0x2d0
[    8.752205]  do_init_module+0x68/0x29c
[    8.752207]  load_module+0x2178/0x26c0
[    8.752209]  __do_sys_finit_module+0xb0/0x120
[    8.752211]  __arm64_sys_finit_module+0x2c/0x40
[    8.752215]  el0_svc_common.constprop.0+0x80/0x240
[    8.752218]  do_el0_svc+0x30/0xa0
[    8.752220]  el0_svc+0x18/0x50
[    8.752223]  el0_sync_handler+0x90/0x318
[    8.752225]  el0_sync+0x158/0x180
[    8.752230] Code: a9bd7bfd 910003fd a90153f3 aa0003f3 (3940f000)
[    8.752232] ---[ end trace 90f6c89d62d85ff5 ]---

Reset the pointer on probe failure fixes the issue.

Fixes: 53d2a715c2403 ("phy: Add Tegra XUSB pad controller support")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201013095820.311376-1-maz@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/tegra/xusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index 11aa5902a9ac1..9c55e0f45ea8a 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -912,6 +912,7 @@ remove_pads:
 reset:
 	reset_control_assert(padctl->rst);
 remove:
+	platform_set_drvdata(pdev, NULL);
 	soc->ops->remove(padctl);
 	return err;
 }
-- 
2.27.0



