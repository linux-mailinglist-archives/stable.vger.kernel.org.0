Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B662DA27
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 13:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbiKQMFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 07:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239760AbiKQMFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 07:05:05 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CE65EF81;
        Thu, 17 Nov 2022 04:05:03 -0800 (PST)
Received: (Authenticated sender: foss@0leil.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 98CCB6000F;
        Thu, 17 Nov 2022 12:04:58 +0000 (UTC)
From:   Quentin Schulz <foss+kernel@0leil.net>
To:     Stephen Boyd <sboyd@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Xing Zheng <zhengxing@rock-chips.com>,
        Michael Turquette <mturquette@baylibre.com>
Cc:     Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        stable@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: rockchip: rk3399: allow clk_cifout to force clk_cifout_src to reparent
Date:   Thu, 17 Nov 2022 13:04:31 +0100
Message-Id: <20221117-rk3399-cifout-set-rate-parent-v1-0-432548d04081@theobroma-systems.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.10.1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

clk_cifout is derived from clk_cifout_src through an integer divider
limited to 32. clk_cifout_src is a child of either cpll, gpll or npll
without any possibility of a divider of any sort. The default clock
parent is cpll.

Let's allow clk_cifout to ask its parent clk_cifout_src to reparent in
order to find the real closest possible rate for clk_cifout and not one
derived from cpll only.

Cc: stable@vger.kernel.org # 4.10+
Fixes: fd8bc829336a ("clk: rockchip: fix the rk3399 cifout clock")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
---
clk: rockchip: rk3399: allow clk_cifout to force clk_cifout_src to reparent

This used to be correct before v4.10 but commit fd8bc829336a ("clk: rockchip:
fix the rk3399 cifout clock") incorrectly removed this ability while reworking
it.

Note: this has been tested on top of v6.0.2 only but no changes were made to
this driver since. As for older stable releases, the git context seems identical
and there does not seem to have been any logical change introduced since v4.10
so it should be pretty safe to apply.

To: Michael Turquette <mturquette@baylibre.com>
To: Stephen Boyd <sboyd@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
To: Xing Zheng <zhengxing@rock-chips.com>
Cc: linux-clk@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/rockchip/clk-rk3399.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3399.c b/drivers/clk/rockchip/clk-rk3399.c
index 306910a3a0d38..9ebd6c451b3db 100644
--- a/drivers/clk/rockchip/clk-rk3399.c
+++ b/drivers/clk/rockchip/clk-rk3399.c
@@ -1263,7 +1263,7 @@ static struct rockchip_clk_branch rk3399_clk_branches[] __initdata = {
 			RK3399_CLKSEL_CON(56), 6, 2, MFLAGS,
 			RK3399_CLKGATE_CON(10), 7, GFLAGS),
 
-	COMPOSITE_NOGATE(SCLK_CIF_OUT, "clk_cifout", mux_clk_cif_p, 0,
+	COMPOSITE_NOGATE(SCLK_CIF_OUT, "clk_cifout", mux_clk_cif_p, CLK_SET_RATE_PARENT,
 			 RK3399_CLKSEL_CON(56), 5, 1, MFLAGS, 0, 5, DFLAGS),
 
 	/* gic */

---
base-commit: cc675d22e422442f6d230654a55a5fc5682ea018
change-id: 20221117-rk3399-cifout-set-rate-parent-1fbf0173ef2d

Best regards,
-- 
Quentin Schulz <quentin.schulz@theobroma-systems.com>
