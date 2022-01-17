Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4917C490658
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 12:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiAQLBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 06:01:24 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:52318 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbiAQLBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 06:01:23 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 20HB1F8i105933;
        Mon, 17 Jan 2022 05:01:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1642417275;
        bh=APcufelCvvtQ92C4lwDeP/wnCcE/tCVes1IRHyTJzUY=;
        h=From:To:CC:Subject:Date;
        b=I1walgYssduKSqfJZfAo656o1GDfaStLuK+EZyGTKO4SJjAiw4+BaNuuozjwlvYf5
         X0CDHQrR0w7GDAP0jVa/600BNn2stCIQpA1SL3d0OufEwQKkQNoozsOZZoqf/7ua0P
         e8K1NSJYF0zc9N++PgNtqrR3e7UZZW0D+N39Uvf4=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 20HB1FKd111167
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Jan 2022 05:01:15 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 17
 Jan 2022 05:01:14 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 17 Jan 2022 05:01:14 -0600
Received: from a0393678-lt.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 20HB1Ase115422;
        Mon, 17 Jan 2022 05:01:11 -0600
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Swapnil Jakhade <sjakhade@cadence.com>,
        <linux-phy@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] phy: ti: Fix "BUG: KASAN: global-out-of-bounds in _get_maxdiv" issue
Date:   Mon, 17 Jan 2022 16:31:08 +0530
Message-ID: <20220117110108.4117-1-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

_get_table_maxdiv() tries to access "clk_div_table" array out of bound
defined in phy-j721e-wiz.c. Add a sentinel entry to prevent
the following global-out-of-bounds error reported by enabling KASAN.

[    9.552392] BUG: KASAN: global-out-of-bounds in _get_maxdiv+0xc0/0x148
[    9.558948] Read of size 4 at addr ffff8000095b25a4 by task kworker/u4:1/38
[    9.565926]
[    9.567441] CPU: 1 PID: 38 Comm: kworker/u4:1 Not tainted 5.16.0-116492-gdaadb3bd0e8d-dirty #360
[    9.576242] Hardware name: Texas Instruments J721e EVM (DT)
[    9.581832] Workqueue: events_unbound deferred_probe_work_func
[    9.587708] Call trace:
[    9.590174]  dump_backtrace+0x20c/0x218
[    9.594038]  show_stack+0x18/0x68
[    9.597375]  dump_stack_lvl+0x9c/0xd8
[    9.601062]  print_address_description.constprop.0+0x78/0x334
[    9.606830]  kasan_report+0x1f0/0x260
[    9.610517]  __asan_load4+0x9c/0xd8
[    9.614030]  _get_maxdiv+0xc0/0x148
[    9.617540]  divider_determine_rate+0x88/0x488
[    9.622005]  divider_round_rate_parent+0xc8/0x124
[    9.626729]  wiz_clk_div_round_rate+0x54/0x68
[    9.631113]  clk_core_determine_round_nolock+0x124/0x158
[    9.636448]  clk_core_round_rate_nolock+0x68/0x138
[    9.641260]  clk_core_set_rate_nolock+0x268/0x3a8
[    9.645987]  clk_set_rate+0x50/0xa8
[    9.649499]  cdns_sierra_phy_init+0x88/0x248
[    9.653794]  phy_init+0x98/0x108
[    9.657046]  cdns_pcie_enable_phy+0xa0/0x170
[    9.661340]  cdns_pcie_init_phy+0x250/0x2b0
[    9.665546]  j721e_pcie_probe+0x4b8/0x798
[    9.669579]  platform_probe+0x8c/0x108
[    9.673350]  really_probe+0x114/0x630
[    9.677037]  __driver_probe_device+0x18c/0x220
[    9.681505]  driver_probe_device+0xac/0x150
[    9.685712]  __device_attach_driver+0xec/0x170
[    9.690178]  bus_for_each_drv+0xf0/0x158
[    9.694124]  __device_attach+0x184/0x210
[    9.698070]  device_initial_probe+0x14/0x20
[    9.702277]  bus_probe_device+0xec/0x100
[    9.706223]  deferred_probe_work_func+0x124/0x180
[    9.710951]  process_one_work+0x4b0/0xbc0
[    9.714983]  worker_thread+0x74/0x5d0
[    9.718668]  kthread+0x214/0x230
[    9.721919]  ret_from_fork+0x10/0x20
[    9.725520]
[    9.727032] The buggy address belongs to the variable:
[    9.732183]  clk_div_table+0x24/0x440

Fixes: 091876cc35 ("phy: ti: j721e-wiz: Add support for WIZ module present in TI J721E SoC")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/ti/phy-j721e-wiz.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index b3384c31637a..da546c35d1d5 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -233,6 +233,7 @@ static const struct clk_div_table clk_div_table[] = {
 	{ .val = 1, .div = 2, },
 	{ .val = 2, .div = 4, },
 	{ .val = 3, .div = 8, },
+	{ /* sentinel */ },
 };
 
 static const struct wiz_clk_div_sel clk_div_sel[] = {
-- 
2.17.1

