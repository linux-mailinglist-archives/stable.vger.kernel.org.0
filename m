Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C748A4F2C69
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241770AbiDEIfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbiDEIUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187AFBF509;
        Tue,  5 Apr 2022 01:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A98E060B0E;
        Tue,  5 Apr 2022 08:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23E6C385A0;
        Tue,  5 Apr 2022 08:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146319;
        bh=LlfPEpuO2RmOjuU3Q2iGNRyCQCE6XCPmkT3/gfEHe7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnWyKLbTGyj3VeR3gNb8vTl9L9NcjnP/vFn2mvp4noALl/mbOGT5RIGkMwMoPTIst
         N+aibvTr1asrnaqCUr7Auhmb9G4+wQXZqKxGtx2DUBbeaZv1fHPj2OJkEB/9IYeZlR
         5bz1QgBHzv4gE6PX65aWfegOXMwEof18CJcUydAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0722/1126] clk: qcom: ipq8074: fix PCI-E clock oops
Date:   Tue,  5 Apr 2022 09:24:29 +0200
Message-Id: <20220405070428.784853325@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit bf8f5182b8f59309809b41c1d1730ed9ca6134b1 ]

Fix PCI-E clock related kernel oops that are caused by a missing clock
parent.

pcie0_rchng_clk_src has num_parents set to 2 but only one parent is
actually set via parent_hws, it should also have "XO" defined.
This will cause the kernel to panic on a NULL pointer in
clk_core_get_parent_by_index().

So, to fix this utilize clk_parent_data to provide gcc_xo_gpll0 parent
data.
Since there is already an existing static const char * const gcc_xo_gpll0[]
used to provide the same parents via parent_names convert those users to
clk_parent_data as well.

Without this earlycon is needed to even catch the OOPS as it will reset
the board before serial is initialized with the following:

[    0.232279] Unable to handle kernel paging request at virtual address 0000a00000000000
[    0.232322] Mem abort info:
[    0.239094]   ESR = 0x96000004
[    0.241778]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.244908]   SET = 0, FnV = 0
[    0.250377]   EA = 0, S1PTW = 0
[    0.253236]   FSC = 0x04: level 0 translation fault
[    0.256277] Data abort info:
[    0.261141]   ISV = 0, ISS = 0x00000004
[    0.264262]   CM = 0, WnR = 0
[    0.267820] [0000a00000000000] address between user and kernel address ranges
[    0.270954] Internal error: Oops: 96000004 [#1] SMP
[    0.278067] Modules linked in:
[    0.282751] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.10 #0
[    0.285882] Hardware name: Xiaomi AX3600 (DT)
[    0.292043] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.296299] pc : clk_core_get_parent_by_index+0x68/0xec
[    0.303067] lr : __clk_register+0x1d8/0x820
[    0.308273] sp : ffffffc01111b7d0
[    0.312438] x29: ffffffc01111b7d0 x28: 0000000000000000 x27: 0000000000000040
[    0.315919] x26: 0000000000000002 x25: 0000000000000000 x24: ffffff8000308800
[    0.323037] x23: ffffff8000308850 x22: ffffff8000308880 x21: ffffff8000308828
[    0.330155] x20: 0000000000000028 x19: ffffff8000309700 x18: 0000000000000020
[    0.337272] x17: 000000005cc86990 x16: 0000000000000004 x15: ffffff80001d9d0a
[    0.344391] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000006
[    0.351508] x11: 0000000000000003 x10: 0101010101010101 x9 : 0000000000000000
[    0.358626] x8 : 7f7f7f7f7f7f7f7f x7 : 6468626f5e626266 x6 : 17000a3a403c1b06
[    0.365744] x5 : 061b3c403a0a0017 x4 : 0000000000000000 x3 : 0000000000000001
[    0.372863] x2 : 0000a00000000000 x1 : 0000000000000001 x0 : ffffff8000309700
[    0.379982] Call trace:
[    0.387091]  clk_core_get_parent_by_index+0x68/0xec
[    0.389351]  __clk_register+0x1d8/0x820
[    0.394210]  devm_clk_hw_register+0x5c/0xe0
[    0.398030]  devm_clk_register_regmap+0x44/0x8c
[    0.402198]  qcom_cc_really_probe+0x17c/0x1d0
[    0.406711]  qcom_cc_probe+0x34/0x44
[    0.411224]  gcc_ipq8074_probe+0x18/0x30
[    0.414869]  platform_probe+0x68/0xe0
[    0.418776]  really_probe.part.0+0x9c/0x30c
[    0.422336]  __driver_probe_device+0x98/0x144
[    0.426329]  driver_probe_device+0x44/0x11c
[    0.430842]  __device_attach_driver+0xb4/0x120
[    0.434836]  bus_for_each_drv+0x68/0xb0
[    0.439349]  __device_attach+0xb0/0x170
[    0.443081]  device_initial_probe+0x14/0x20
[    0.446901]  bus_probe_device+0x9c/0xa4
[    0.451067]  device_add+0x35c/0x834
[    0.454886]  of_device_add+0x54/0x64
[    0.458360]  of_platform_device_create_pdata+0xc0/0x100
[    0.462181]  of_platform_bus_create+0x114/0x370
[    0.467128]  of_platform_bus_create+0x15c/0x370
[    0.471641]  of_platform_populate+0x50/0xcc
[    0.476155]  of_platform_default_populate_init+0xa8/0xc8
[    0.480324]  do_one_initcall+0x50/0x1b0
[    0.485877]  kernel_init_freeable+0x234/0x29c
[    0.489436]  kernel_init+0x24/0x120
[    0.493948]  ret_from_fork+0x10/0x20
[    0.497253] Code: d50323bf d65f03c0 f94002a2 b4000302 (f9400042)
[    0.501079] ---[ end trace 4ca7e1129da2abce ]---

Fixes: f0cfcf1a ("clk: qcom: ipq8074: Add missing clocks for pcie")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211220114119.465247-1-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index 108fe27bee10..b09d99343e09 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -60,11 +60,6 @@ static const struct parent_map gcc_xo_gpll0_gpll0_out_main_div2_map[] = {
 	{ P_GPLL0_DIV2, 4 },
 };
 
-static const char * const gcc_xo_gpll0[] = {
-	"xo",
-	"gpll0",
-};
-
 static const struct parent_map gcc_xo_gpll0_map[] = {
 	{ P_XO, 0 },
 	{ P_GPLL0, 1 },
@@ -956,6 +951,11 @@ static struct clk_rcg2 blsp1_uart6_apps_clk_src = {
 	},
 };
 
+static const struct clk_parent_data gcc_xo_gpll0[] = {
+	{ .fw_name = "xo" },
+	{ .hw = &gpll0.clkr.hw },
+};
+
 static const struct freq_tbl ftbl_pcie_axi_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(200000000, P_GPLL0, 4, 0, 0),
@@ -969,7 +969,7 @@ static struct clk_rcg2 pcie0_axi_clk_src = {
 	.parent_map = gcc_xo_gpll0_map,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "pcie0_axi_clk_src",
-		.parent_names = gcc_xo_gpll0,
+		.parent_data = gcc_xo_gpll0,
 		.num_parents = 2,
 		.ops = &clk_rcg2_ops,
 	},
@@ -1016,7 +1016,7 @@ static struct clk_rcg2 pcie1_axi_clk_src = {
 	.parent_map = gcc_xo_gpll0_map,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "pcie1_axi_clk_src",
-		.parent_names = gcc_xo_gpll0,
+		.parent_data = gcc_xo_gpll0,
 		.num_parents = 2,
 		.ops = &clk_rcg2_ops,
 	},
@@ -1330,7 +1330,7 @@ static struct clk_rcg2 nss_ce_clk_src = {
 	.parent_map = gcc_xo_gpll0_map,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "nss_ce_clk_src",
-		.parent_names = gcc_xo_gpll0,
+		.parent_data = gcc_xo_gpll0,
 		.num_parents = 2,
 		.ops = &clk_rcg2_ops,
 	},
@@ -4329,8 +4329,7 @@ static struct clk_rcg2 pcie0_rchng_clk_src = {
 	.parent_map = gcc_xo_gpll0_map,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "pcie0_rchng_clk_src",
-		.parent_hws = (const struct clk_hw *[]) {
-				&gpll0.clkr.hw },
+		.parent_data = gcc_xo_gpll0,
 		.num_parents = 2,
 		.ops = &clk_rcg2_ops,
 	},
-- 
2.34.1



