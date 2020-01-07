Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481431331C1
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgAGVDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbgAGVDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E4B2081E;
        Tue,  7 Jan 2020 21:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431024;
        bh=A8/USBmkSkhkGJpjD95UcftyPX90xIyjumz4w2pKB8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0RYmetGg3duUpzMd55kEEZbcEDYUwV+UVv6VoRsoZFEcmSBvyB3MIdr1xbma/Eci
         DWNwNSZTSvvyUSiyDC8daLm6h3HTxtSi6gfk6B0n5wfQ6i4lU37oLDQKPUi4ujTMRp
         Lw9u1yybEP6UJbra73aiSj7NMLRYLFoPluQrNerE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Anand Moon <linux.amoon@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.4 167/191] arm64: dts: meson: odroid-c2: Disable usb_otg bus to avoid power failed warning
Date:   Tue,  7 Jan 2020 21:54:47 +0100
Message-Id: <20200107205341.929685849@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

commit 72c9b5f6f75fbc6c47e0a2d02bc3838a2a47c90a upstream.

usb_otg bus needs to get initialize from the u-boot to be configured
to used as power source to SBC or usb otg port will get configured
as host device. Right now this support is missing in the u-boot and
phy driver so to avoid power failed warning, we would disable this
feature  until proper fix is found.

[    2.716048] phy phy-c0000000.phy.0: USB ID detect failed!
[    2.720186] phy phy-c0000000.phy.0: phy poweron failed --> -22
[    2.726001] ------------[ cut here ]------------
[    2.730583] WARNING: CPU: 0 PID: 12 at drivers/regulator/core.c:2039 _regulator_put+0x3c/0xe8
[    2.738983] Modules linked in:
[    2.742005] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.2.9-1-ARCH #1
[    2.748643] Hardware name: Hardkernel ODROID-C2 (DT)
[    2.753566] Workqueue: events deferred_probe_work_func
[    2.758649] pstate: 60000005 (nZCv daif -PAN -UAO)
[    2.763394] pc : _regulator_put+0x3c/0xe8
[    2.767361] lr : _regulator_put+0x3c/0xe8
[    2.771326] sp : ffff000011aa3a50
[    2.774604] x29: ffff000011aa3a50 x28: ffff80007ed1b600
[    2.779865] x27: ffff80007f7036a8 x26: ffff80007f7036a8
[    2.785126] x25: 0000000000000000 x24: ffff000011a44458
[    2.790387] x23: ffff000011344218 x22: 0000000000000009
[    2.795649] x21: ffff000011aa3b68 x20: ffff80007ed1b500
[    2.800910] x19: ffff80007ed1b500 x18: 0000000000000010
[    2.806171] x17: 000000005be5943c x16: 00000000f1c73b29
[    2.811432] x15: ffffffffffffffff x14: ffff0000117396c8
[    2.816694] x13: ffff000091aa37a7 x12: ffff000011aa37af
[    2.821955] x11: ffff000011763000 x10: ffff000011aa3730
[    2.827216] x9 : 00000000ffffffd0 x8 : ffff000010871760
[    2.832477] x7 : 00000000000000d0 x6 : ffff0000119d151b
[    2.837739] x5 : 000000000000000f x4 : 0000000000000000
[    2.843000] x3 : 0000000000000000 x2 : 38104b2678c20100
[    2.848261] x1 : 0000000000000000 x0 : 0000000000000024
[    2.853523] Call trace:
[    2.855940]  _regulator_put+0x3c/0xe8
[    2.859562]  regulator_put+0x34/0x48
[    2.863098]  regulator_bulk_free+0x40/0x58
[    2.867153]  devm_regulator_bulk_release+0x24/0x30
[    2.871896]  release_nodes+0x1f0/0x2e0
[    2.875604]  devres_release_all+0x64/0xa4
[    2.879571]  really_probe+0x1c8/0x3e0
[    2.883194]  driver_probe_device+0xe4/0x138
[    2.887334]  __device_attach_driver+0x90/0x110
[    2.891733]  bus_for_each_drv+0x8c/0xd8
[    2.895527]  __device_attach+0xdc/0x160
[    2.899322]  device_initial_probe+0x24/0x30
[    2.903463]  bus_probe_device+0x9c/0xa8
[    2.907258]  deferred_probe_work_func+0xa0/0xf0
[    2.911745]  process_one_work+0x1b4/0x408
[    2.915711]  worker_thread+0x54/0x4b8
[    2.919334]  kthread+0x12c/0x130
[    2.922526]  ret_from_fork+0x10/0x1c
[    2.926060] ---[ end trace 51a68f4c0035d6c0 ]---
[    2.930691] ------------[ cut here ]------------
[    2.935242] WARNING: CPU: 0 PID: 12 at drivers/regulator/core.c:2039 _regulator_put+0x3c/0xe8
[    2.943653] Modules linked in:
[    2.946675] CPU: 0 PID: 12 Comm: kworker/0:1 Tainted: G        W         5.2.9-1-ARCH #1
[    2.954694] Hardware name: Hardkernel ODROID-C2 (DT)
[    2.959613] Workqueue: events deferred_probe_work_func
[    2.964700] pstate: 60000005 (nZCv daif -PAN -UAO)
[    2.969445] pc : _regulator_put+0x3c/0xe8
[    2.973412] lr : _regulator_put+0x3c/0xe8
[    2.977377] sp : ffff000011aa3a50
[    2.980655] x29: ffff000011aa3a50 x28: ffff80007ed1b600
[    2.985916] x27: ffff80007f7036a8 x26: ffff80007f7036a8
[    2.991177] x25: 0000000000000000 x24: ffff000011a44458
[    2.996439] x23: ffff000011344218 x22: 0000000000000009
[    3.001700] x21: ffff000011aa3b68 x20: ffff80007ed1bd00
[    3.006961] x19: ffff80007ed1bd00 x18: 0000000000000010
[    3.012222] x17: 000000005be5943c x16: 00000000f1c73b29
[    3.017484] x15: ffffffffffffffff x14: ffff0000117396c8
[    3.022745] x13: ffff000091aa37a7 x12: ffff000011aa37af
[    3.028006] x11: ffff000011763000 x10: ffff000011aa3730
[    3.033267] x9 : 00000000ffffffd0 x8 : ffff000010871760
[    3.038528] x7 : 00000000000000fd x6 : ffff0000119d151b
[    3.043790] x5 : 000000000000000f x4 : 0000000000000000
[    3.049051] x3 : 0000000000000000 x2 : 38104b2678c20100
[    3.054312] x1 : 0000000000000000 x0 : 0000000000000024
[    3.059574] Call trace:
[    3.061991]  _regulator_put+0x3c/0xe8
[    3.065613]  regulator_put+0x34/0x48
[    3.069149]  regulator_bulk_free+0x40/0x58
[    3.073203]  devm_regulator_bulk_release+0x24/0x30
[    3.077947]  release_nodes+0x1f0/0x2e0
[    3.081655]  devres_release_all+0x64/0xa4
[    3.085622]  really_probe+0x1c8/0x3e0
[    3.089245]  driver_probe_device+0xe4/0x138
[    3.093385]  __device_attach_driver+0x90/0x110
[    3.097784]  bus_for_each_drv+0x8c/0xd8
[    3.101578]  __device_attach+0xdc/0x160
[    3.105373]  device_initial_probe+0x24/0x30
[    3.109514]  bus_probe_device+0x9c/0xa8
[    3.113309]  deferred_probe_work_func+0xa0/0xf0
[    3.117796]  process_one_work+0x1b4/0x408
[    3.121762]  worker_thread+0x54/0x4b8
[    3.125384]  kthread+0x12c/0x130
[    3.128575]  ret_from_fork+0x10/0x1c
[    3.132110] ---[ end trace 51a68f4c0035d6c1 ]---
[    3.136753] dwc2: probe of c9000000.usb failed with error -22

Fixes: 5a0803bd5ae2 ("ARM64: dts: meson-gxbb-odroidc2: Enable USB Nodes")
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
@@ -296,7 +296,7 @@
 };
 
 &usb0_phy {
-	status = "okay";
+	status = "disabled";
 	phy-supply = <&usb_otg_pwr>;
 };
 
@@ -306,7 +306,7 @@
 };
 
 &usb0 {
-	status = "okay";
+	status = "disabled";
 };
 
 &usb1 {


