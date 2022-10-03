Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3BE5F2978
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiJCHUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiJCHSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:18:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A4A42AE7;
        Mon,  3 Oct 2022 00:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A881B80E6D;
        Mon,  3 Oct 2022 07:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041B3C433B5;
        Mon,  3 Oct 2022 07:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781267;
        bh=jJalopGYV6q6cOGGw0IxdJG9dao0UUZll3cdpcsRMnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8gFaW9uaar26Ap0mTTGRqwXtNno18Ekxty5jM77DChIfpa4OGjkE0xCBU+/bQR1/
         gpNl1n/1W6luZrbxOknkNQhZiLZMRXF1XWSeRjo2GKtcxs3H2wRG6FiKAmu4pl1PEn
         g+b5chxSGCmSsNIFp7iyQy7NNnhJvVXgdsMEK+7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 059/101] clk: microchip: mpfs: fix clk_cfg array bounds violation
Date:   Mon,  3 Oct 2022 09:10:55 +0200
Message-Id: <20221003070725.935137420@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 5da39ac5d648cdbfdfa8bea0e0cde279ded5c7c2 ]

There is an array bounds violation present during clock registration,
triggered by current code by only specific toolchains. This seems to
fail gracefully in v6.0-rc1, using a toolchain build from the riscv-
gnu-toolchain repo and with clang-15, and life carries on. While
converting the driver to use standard clock structs/ops, kernel panics
were seen during boot when built with clang-15:

[    0.581754] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000b1
[    0.591520] Oops [#1]
[    0.594045] Modules linked in:
[    0.597435] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc1-00011-g8e1459cf4eca #1
[    0.606188] Hardware name: Microchip PolarFire-SoC Icicle Kit (DT)
[    0.613012] epc : __clk_register+0x4a6/0x85c
[    0.617759]  ra : __clk_register+0x49e/0x85c
[    0.622489] epc : ffffffff803faf7c ra : ffffffff803faf74 sp : ffffffc80400b720
[    0.630466]  gp : ffffffff810e93f8 tp : ffffffe77fe60000 t0 : ffffffe77ffb3800
[    0.638443]  t1 : 000000000000000a t2 : ffffffffffffffff s0 : ffffffc80400b7c0
[    0.646420]  s1 : 0000000000000001 a0 : 0000000000000001 a1 : 0000000000000000
[    0.654396]  a2 : 0000000000000001 a3 : 0000000000000000 a4 : 0000000000000000
[    0.662373]  a5 : ffffffff803a5810 a6 : 0000000200000022 a7 : 0000000000000006
[    0.670350]  s2 : ffffffff81099d48 s3 : ffffffff80d6e28e s4 : 0000000000000028
[    0.678327]  s5 : ffffffff810ed3c8 s6 : ffffffff810ed3d0 s7 : ffffffe77ffbc100
[    0.686304]  s8 : ffffffe77ffb1540 s9 : ffffffe77ffb1540 s10: 0000000000000008
[    0.694281]  s11: 0000000000000000 t3 : 00000000000000c6 t4 : 0000000000000007
[    0.702258]  t5 : ffffffff810c78c0 t6 : ffffffe77ff88cd0
[    0.708125] status: 0000000200000120 badaddr: 00000000000000b1 cause: 000000000000000d
[    0.716869] [<ffffffff803fb892>] devm_clk_hw_register+0x62/0xaa
[    0.723420] [<ffffffff80403412>] mpfs_clk_probe+0x1e0/0x244

In v6.0-rc1 and later, this issue is visible without the follow on
patches doing the conversion using toolchains provided by our Yocto
meta layer too.

It fails on "clk_periph_timer" - which uses a different parent, that it
tries to find using the macro:
\#define PARENT_CLK(PARENT) (&mpfs_cfg_clks[CLK_##PARENT].cfg.hw)

If parent is RTCREF, so the macro becomes: &mpfs_cfg_clks[33].cfg.hw
which is well beyond the end of the array. Amazingly, builds with GCC
11.1 see no problem here, booting correctly and hooking the parent up
etc. Builds with clang-15 do not, with the above panic.

Change the macro to use specific offsets depending on the parent rather
than the dt-binding's clock IDs.

Fixes: 1c6a7ea32b8c ("clk: microchip: mpfs: add RTCREF clock control")
CC: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220909123123.2699583-2-conor.dooley@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/microchip/clk-mpfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/microchip/clk-mpfs.c b/drivers/clk/microchip/clk-mpfs.c
index 070c3b896559..f0f9c9a1cc48 100644
--- a/drivers/clk/microchip/clk-mpfs.c
+++ b/drivers/clk/microchip/clk-mpfs.c
@@ -239,6 +239,11 @@ static const struct clk_ops mpfs_clk_cfg_ops = {
 	.hw.init = CLK_HW_INIT(_name, _parent, &mpfs_clk_cfg_ops, 0),			\
 }
 
+#define CLK_CPU_OFFSET		0u
+#define CLK_AXI_OFFSET		1u
+#define CLK_AHB_OFFSET		2u
+#define CLK_RTCREF_OFFSET	3u
+
 static struct mpfs_cfg_hw_clock mpfs_cfg_clks[] = {
 	CLK_CFG(CLK_CPU, "clk_cpu", "clk_msspll", 0, 2, mpfs_div_cpu_axi_table, 0,
 		REG_CLOCK_CONFIG_CR),
@@ -362,7 +367,7 @@ static const struct clk_ops mpfs_periph_clk_ops = {
 				  _flags),					\
 }
 
-#define PARENT_CLK(PARENT) (&mpfs_cfg_clks[CLK_##PARENT].hw)
+#define PARENT_CLK(PARENT) (&mpfs_cfg_clks[CLK_##PARENT##_OFFSET].hw)
 
 /*
  * Critical clocks:
-- 
2.35.1



