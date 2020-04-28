Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B0A1BCBD6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 21:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgD1TAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 15:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729105AbgD1S17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23112085B;
        Tue, 28 Apr 2020 18:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098478;
        bh=oejTAAoP9GYkwSOZhVRStKNLtfzkpCadGE700Kd+gpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u06eEgJMFZBN0aR1VfYrzFqUy/EmntHJ1BZym1px+MJfKYyUenb14kJbc9KlrrR3r
         wlmEIfTrbp019XeuBvCHNQ4Sa3NhcXgzQBpvHoSGJHXUWT+KYuxvUzhBvK0/S2vXiI
         3WyeIUiVdKYEqSprOXRccHROjXXx4vxEmZwDK+Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 056/167] net: stmmac: dwmac-meson8b: Add missing boundary to RGMII TX clock array
Date:   Tue, 28 Apr 2020 20:23:52 +0200
Message-Id: <20200428182232.075649708@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit f0212a5ebfa6cd789ab47666b9cc169e6e688732 ]

Running with KASAN on a VIM3L systems leads to the following splat
when probing the Ethernet device:

==================================================================
BUG: KASAN: global-out-of-bounds in _get_maxdiv+0x74/0xd8
Read of size 4 at addr ffffa000090615f4 by task systemd-udevd/139
CPU: 1 PID: 139 Comm: systemd-udevd Tainted: G            E     5.7.0-rc1-00101-g8624b7577b9c #781
Hardware name: amlogic w400/w400, BIOS 2020.01-rc5 03/12/2020
Call trace:
 dump_backtrace+0x0/0x2a0
 show_stack+0x20/0x30
 dump_stack+0xec/0x148
 print_address_description.isra.12+0x70/0x35c
 __kasan_report+0xfc/0x1d4
 kasan_report+0x4c/0x68
 __asan_load4+0x9c/0xd8
 _get_maxdiv+0x74/0xd8
 clk_divider_bestdiv+0x74/0x5e0
 clk_divider_round_rate+0x80/0x1a8
 clk_core_determine_round_nolock.part.9+0x9c/0xd0
 clk_core_round_rate_nolock+0xf0/0x108
 clk_hw_round_rate+0xac/0xf0
 clk_factor_round_rate+0xb8/0xd0
 clk_core_determine_round_nolock.part.9+0x9c/0xd0
 clk_core_round_rate_nolock+0xf0/0x108
 clk_core_round_rate_nolock+0xbc/0x108
 clk_core_set_rate_nolock+0xc4/0x2e8
 clk_set_rate+0x58/0xe0
 meson8b_dwmac_probe+0x588/0x72c [dwmac_meson8b]
 platform_drv_probe+0x78/0xd8
 really_probe+0x158/0x610
 driver_probe_device+0x140/0x1b0
 device_driver_attach+0xa4/0xb0
 __driver_attach+0xcc/0x1c8
 bus_for_each_dev+0xf4/0x168
 driver_attach+0x3c/0x50
 bus_add_driver+0x238/0x2e8
 driver_register+0xc8/0x1e8
 __platform_driver_register+0x88/0x98
 meson8b_dwmac_driver_init+0x28/0x1000 [dwmac_meson8b]
 do_one_initcall+0xa8/0x328
 do_init_module+0xe8/0x368
 load_module+0x3300/0x36b0
 __do_sys_finit_module+0x120/0x1a8
 __arm64_sys_finit_module+0x4c/0x60
 el0_svc_common.constprop.2+0xe4/0x268
 do_el0_svc+0x98/0xa8
 el0_svc+0x24/0x68
 el0_sync_handler+0x12c/0x318
 el0_sync+0x158/0x180

The buggy address belongs to the variable:
 div_table.63646+0x34/0xfffffffffffffa40 [dwmac_meson8b]

Memory state around the buggy address:
 ffffa00009061480: fa fa fa fa 00 00 00 01 fa fa fa fa 00 00 00 00
 ffffa00009061500: 05 fa fa fa fa fa fa fa 00 04 fa fa fa fa fa fa
>ffffa00009061580: 00 03 fa fa fa fa fa fa 00 00 00 00 00 00 fa fa
                                                             ^
 ffffa00009061600: fa fa fa fa 00 01 fa fa fa fa fa fa 01 fa fa fa
 ffffa00009061680: fa fa fa fa 00 01 fa fa fa fa fa fa 04 fa fa fa
==================================================================

Digging into this indeed shows that the clock divider array is
lacking a final fence, and that the clock subsystems goes in the
weeds. Oh well.

Let's add the empty structure that indicates the end of the array.

Fixes: bd6f48546b9c ("net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -119,6 +119,7 @@ static int meson8b_init_rgmii_tx_clk(str
 		{ .div = 5, .val = 5, },
 		{ .div = 6, .val = 6, },
 		{ .div = 7, .val = 7, },
+		{ /* end of array */ }
 	};
 
 	clk_configs = devm_kzalloc(dev, sizeof(*clk_configs), GFP_KERNEL);


