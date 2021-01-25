Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FF7302ACE
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbhAYSxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731220AbhAYSxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D57020E65;
        Mon, 25 Jan 2021 18:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600752;
        bh=OHuGWLiqVjEfP/SkSGDW3//Gl3dPojRa5qulbOcmW3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2M2YnutswuP6HrxKZp+I0oS5bd+xVixE+McfN76B5YiXch/HXhv7fxX8lufYIhaax
         Zu/xGG/NvPoH0YhKysRWL6S+0cSJ9Kkhx1aV4WpfA8NW2hjKnMP7a8lf7cAcE58foK
         SvzaIolS1/C2Orb5YteL8LfyrG537Qpsg3/FnwOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.10 138/199] usb: cdns3: imx: fix writing read-only memory issue
Date:   Mon, 25 Jan 2021 19:39:20 +0100
Message-Id: <20210125183222.041032751@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 92cbdb923c17544684c2dd3be9f8636617898a44 upstream.

The memory for struct clk_bulk_data should not be static which will be written
during the clk_bulk_get. It fixed below oops when loading cdns3-imx as module.

[   17.272605] Unable to handle kernel write to read-only memory at virtual address ffff8000092a5398
[   17.299730] Mem abort info:
[   17.313542] unregister ISI channel: mxc_isi.4
[   17.324076]   ESR = 0x9600004f
[   17.344658]   EC = 0x25: DABT (current EL), IL = 32 bits
[   17.402055]   SET = 0, FnV = 0
[   17.404321] mxs_phy 5b100000.usbphy: supply phy-3p0 not found, using dummy regulator
[   17.405121]   EA = 0, S1PTW = 0
[   17.405133] Data abort info:
[   17.496231]   ISV = 0, ISS = 0x0000004f
[   17.510871]   CM = 0, WnR = 1
[   17.533542] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000081ea5000
[   17.545709] [ffff8000092a5398] pgd=00000008bffff003, p4d=00000008bffff003, pud=00000008bfffe003, pmd=0000000885041003, pte=006000088513b783
[   17.573521] Internal error: Oops: 9600004f [#1] PREEMPT SMP
[   17.579113] Modules linked in: usbmisc_imx phy_mxs_usb phy_cadence_salvo cdns3_imx(+) tcpci imx8_media_dev(C) caam error
[   17.590044] CPU: 2 PID: 253 Comm: systemd-udevd Tainted: G         C        5.10.0-rc4-04445-g11f3c3a29d0-dirty #19
[   17.600488] Hardware name: Freescale i.MX8QXP MEK (DT)
[   17.605633] pstate: 20000005 (nzCv daif -PAN -UAO -TCO BTYPE=--)
[   17.611662] pc : __clk_bulk_get+0x48/0x130
[   17.615786] lr : clk_bulk_get+0x18/0x20
[   17.619634] sp : ffff80001369b880
[   17.622953] x29: ffff80001369b880 x28: 0000000000000013
[   17.628277] x27: 0000000000000100 x26: ffff00080553b100
[   17.633602] x25: ffff80001229b4d8 x24: 0000000000000000
[   17.638928] x23: ffff000800665410 x22: 0000000000000005
[   17.644275] x21: ffff8000092a5390 x20: ffff000800665400
[   17.649605] x19: ffff000804e6f980 x18: 000000005b110000
[   17.654946] x17: 0000000000000000 x16: 0000000000000000
[   17.660274] x15: ffff800011989100 x14: 0000000000000000
[   17.665599] x13: ffff800013ce1000 x12: ffff800013ca1000
[   17.670924] x11: 000000005b110000 x10: 0000000000000000
[   17.676249] x9 : ffff8000106c5a30 x8 : ffff000804e6fa00
[   17.681575] x7 : 0000000000000000 x6 : 000000000000003f
[   17.686901] x5 : 0000000000000040 x4 : ffff80001369b8b0
[   17.692228] x3 : ffff8000092a5398 x2 : ffff8000092a5390
[   17.697574] x1 : ffff8000092a53e8 x0 : 0000000000000004
[   17.702905] Call trace:
[   17.705366]  __clk_bulk_get+0x48/0x130
[   17.709125]  clk_bulk_get+0x18/0x20
[   17.712620]  devm_clk_bulk_get+0x58/0xb8
[   17.716563]  cdns_imx_probe+0x84/0x1f0 [cdns3_imx]
[   17.721363]  platform_drv_probe+0x58/0xa8
[   17.725381]  really_probe+0xec/0x4c8
[   17.728967]  driver_probe_device+0xf4/0x160
[   17.733160]  device_driver_attach+0x74/0x80
[   17.737355]  __driver_attach+0xa4/0x170
[   17.741202]  bus_for_each_dev+0x74/0xc8
[   17.745043]  driver_attach+0x28/0x30
[   17.748620]  bus_add_driver+0x144/0x228
[   17.752462]  driver_register+0x68/0x118
[   17.756308]  __platform_driver_register+0x4c/0x58
[   17.761022]  cdns_imx_driver_init+0x24/0x1000 [cdns3_imx]
[   17.766434]  do_one_initcall+0x48/0x2c0
[   17.770280]  do_init_module+0x5c/0x220
[   17.774029]  load_module+0x210c/0x2858
[   17.777784]  __do_sys_finit_module+0xb8/0x120
[   17.782148]  __arm64_sys_finit_module+0x24/0x30
[   17.786691]  el0_svc_common.constprop.0+0x70/0x168
[   17.791497]  do_el0_svc+0x28/0x88
[   17.794822]  el0_sync_handler+0x158/0x160
[   17.798833]  el0_sync+0x140/0x180
[   17.802158] Code: aa0203f5 91002043 8b205021 a90153f3 (f801047f)

Cc: <stable@vger.kernel.org>
Fixes: 1e056efab993 ("usb: cdns3: add NXP imx8qm glue layer")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/cdns3/cdns3-imx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-imx.c
+++ b/drivers/usb/cdns3/cdns3-imx.c
@@ -184,7 +184,11 @@ static int cdns_imx_probe(struct platfor
 	}
 
 	data->num_clks = ARRAY_SIZE(imx_cdns3_core_clks);
-	data->clks = (struct clk_bulk_data *)imx_cdns3_core_clks;
+	data->clks = devm_kmemdup(dev, imx_cdns3_core_clks,
+				sizeof(imx_cdns3_core_clks), GFP_KERNEL);
+	if (!data->clks)
+		return -ENOMEM;
+
 	ret = devm_clk_bulk_get(dev, data->num_clks, data->clks);
 	if (ret)
 		return ret;


