Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1691B1FE87E
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFRCtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbgFRBJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19E6021D7E;
        Thu, 18 Jun 2020 01:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442584;
        bh=YGX0lrnfxqvr/T0mkwVDpFrgfYUGjzlfvTyPYgsITqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByQITHnCSDbR7BToO+0RZvFIIgKGpv+vqRMOSLCnxbV7pHChj8PsZ8U+xNLN6P3Pv
         uuhYnwag/CnCKRQehEBg2IAVSk8B4tD+fCXvXG2RJ76XWADz7NYJOilJzTjwM/sdD8
         2L1fvN3tutiXIayo8kViPhvmH/tY8QIg+ZcEsW/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quanyang Wang <quanyang.wang@windriver.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Tejas Patel <tejas.patel@xilinx.com>,
        Jolly Shah <jolly.shah@xilinx.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 075/388] clk: zynqmp: fix memory leak in zynqmp_register_clocks
Date:   Wed, 17 Jun 2020 21:02:52 -0400
Message-Id: <20200618010805.600873-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit 58b0fb86260063f86afecaebf4056c876fff2a19 ]

This is detected by kmemleak running on zcu102 board:

unreferenced object 0xffffffc877e48180 (size 128):
comm "swapper/0", pid 1, jiffies 4294892909 (age 315.436s)
hex dump (first 32 bytes):
64 70 5f 76 69 64 65 6f 5f 72 65 66 5f 64 69 76 dp_video_ref_div
31 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1...............
backtrace:
[<00000000c9be883b>] __kmalloc_track_caller+0x200/0x380
[<00000000f02c3809>] kvasprintf+0x7c/0x100
[<00000000e51dde4d>] kasprintf+0x60/0x80
[<0000000092298b05>] zynqmp_register_clocks+0x29c/0x398
[<00000000faaff182>] zynqmp_clock_probe+0x3cc/0x4c0
[<000000005f5986f0>] platform_drv_probe+0x58/0xa8
[<00000000d5810136>] really_probe+0xd8/0x2a8
[<00000000f5b671be>] driver_probe_device+0x5c/0x100
[<0000000038f91fcf>] __device_attach_driver+0x98/0xb8
[<000000008a3f2ac2>] bus_for_each_drv+0x74/0xd8
[<000000001cb2783d>] __device_attach+0xe0/0x140
[<00000000c268031b>] device_initial_probe+0x24/0x30
[<000000006998de4b>] bus_probe_device+0x9c/0xa8
[<00000000647ae6ff>] device_add+0x3c0/0x610
[<0000000071c14bb8>] of_device_add+0x40/0x50
[<000000004bb5d132>] of_platform_device_create_pdata+0xbc/0x138

This is because that when num_nodes is larger than 1, clk_out is
allocated using kasprintf for these nodes but only the last node's
clk_out is freed.

Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Tejas Patel <tejas.patel@xilinx.com>
Signed-off-by: Jolly Shah <jolly.shah@xilinx.com>
Link: https://lkml.kernel.org/r/1583185843-20707-5-git-send-email-jolly.shah@xilinx.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynqmp/clkc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/zynqmp/clkc.c b/drivers/clk/zynqmp/clkc.c
index 10e89f23880b..b66c3a62233a 100644
--- a/drivers/clk/zynqmp/clkc.c
+++ b/drivers/clk/zynqmp/clkc.c
@@ -558,7 +558,7 @@ static struct clk_hw *zynqmp_register_clk_topology(int clk_id, char *clk_name,
 {
 	int j;
 	u32 num_nodes, clk_dev_id;
-	char *clk_out = NULL;
+	char *clk_out[MAX_NODES];
 	struct clock_topology *nodes;
 	struct clk_hw *hw = NULL;
 
@@ -572,16 +572,16 @@ static struct clk_hw *zynqmp_register_clk_topology(int clk_id, char *clk_name,
 		 * Intermediate clock names are postfixed with type of clock.
 		 */
 		if (j != (num_nodes - 1)) {
-			clk_out = kasprintf(GFP_KERNEL, "%s%s", clk_name,
+			clk_out[j] = kasprintf(GFP_KERNEL, "%s%s", clk_name,
 					    clk_type_postfix[nodes[j].type]);
 		} else {
-			clk_out = kasprintf(GFP_KERNEL, "%s", clk_name);
+			clk_out[j] = kasprintf(GFP_KERNEL, "%s", clk_name);
 		}
 
 		if (!clk_topology[nodes[j].type])
 			continue;
 
-		hw = (*clk_topology[nodes[j].type])(clk_out, clk_dev_id,
+		hw = (*clk_topology[nodes[j].type])(clk_out[j], clk_dev_id,
 						    parent_names,
 						    num_parents,
 						    &nodes[j]);
@@ -590,9 +590,12 @@ static struct clk_hw *zynqmp_register_clk_topology(int clk_id, char *clk_name,
 				     __func__,  clk_dev_id, clk_name,
 				     PTR_ERR(hw));
 
-		parent_names[0] = clk_out;
+		parent_names[0] = clk_out[j];
 	}
-	kfree(clk_out);
+
+	for (j = 0; j < num_nodes; j++)
+		kfree(clk_out[j]);
+
 	return hw;
 }
 
-- 
2.25.1

