Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADAF1CAB44
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgEHMmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgEHMl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 389C121835;
        Fri,  8 May 2020 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941717;
        bh=DhElWUnJuyF6ZplEmiqhWawJeWoKKGBe42iI3FjfasE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXP4AwnVc2NCMWdl+9dCTMBgQbM8ltuZdGlNFYfcerWkLsmH/QnQuGsGvcCPDHNwP
         zMxZf5us57/pLa5ZUmXGLuAmC8smb09XaLHGTJ1KNdnW4jPdYnYDugornLYuZCVoVk
         rkCNDalE5SbH08ns8KQetkXXar7+iWbIakECdU0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.4 142/312] clk: rockchip: Revert "clk: rockchip: reset init state before mmc card initialization"
Date:   Fri,  8 May 2020 14:32:13 +0200
Message-Id: <20200508123134.463790536@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 4715f81afc342996f680b08c944a712d9cbef11b upstream.

This reverts commit 7a03fe6f48f3 ("clk: rockchip: reset init state
before mmc card initialization").

Though not totally obvious from the commit message nor from the source
code, that commit appears to be trying to reset the "_drv" MMC clocks to
90 degrees (note that the "_sample" MMC clocks have a shift of 0 so are
not touched).

The major problem here is that it doesn't properly reset things.  The
phase is a two bit field and the commit only touches one of the two
bits.  Thus the commit had the following affect:
- phase   0  => phase  90
- phase  90  => phase  90
- phase 180  => phase 270
- phase 270  => phase 270

Things get even weirder if you happen to have a bootloader that was
actually using delay elements (should be no reason to, but you never
know), since those are additional bits that weren't touched by the
original patch.

This is unlikely to be what we actually want.  Checking on rk3288-veyron
devices, I can see that the bootloader leaves these clocks as:
- emmc:  phase 180
- sdmmc: phase 90
- sdio0: phase 90

Thus on rk3288-veyron devices the commit we're reverting had the effect
of changing the eMMC clock to phase 270.  This probably explains the
scattered reports I've heard of eMMC devices not working on some veyron
devices when using the upstream kernel.

The original commit was presumably made because previously the kernel
didn't touch the "_drv" phase at all and relied on whatever value was
there when the kernel started.  If someone was using a bootloader that
touched the "_drv" phase then, indeed, we should have code in the kernel
to fix that.  ...and also, to get ideal timings, we should also have the
kernel change the phase depending on the speed mode.  In fact, that's
the subject of a recent patch I posted at
<https://patchwork.kernel.org/patch/9075141/>.

Ideally, we should take both the patch posted to dw_mmc and this
revert.  Since those will likely go through different trees, here I
describe behavior with the combos:

1. Just this revert: likely will fix rk3288-veyron eMMC on some devices
   + other cases; might break someone with a strange bootloader that
   sets the phase to 0 or one that uses delay elements (pretty
   unpredicable what would happen in that case).
2. Just dw_mmc patch: fixes everyone.  Effectly the dw_mmc patch will
   totally override the broken patch and fix everything.
3. Both patches: fixes everyone.  Once dw_mmc is initting properly then
   any defaults from the clock code doesn't mattery.

Fixes: 7a03fe6f48f3 ("clk: rockchip: reset init state before mmc card initialization")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[emmc and sdmmc still work on all current boards in mainline after this
revert, so they should take precedence over any out-of-tree board that
will hopefully again get fixed with the better upcoming dw_mmc change.]
Signed-off-by: Heiko Stuebner <heiko@sntech.de>

---
 drivers/clk/rockchip/clk-mmc-phase.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/clk/rockchip/clk-mmc-phase.c
+++ b/drivers/clk/rockchip/clk-mmc-phase.c
@@ -41,8 +41,6 @@ static unsigned long rockchip_mmc_recalc
 #define ROCKCHIP_MMC_DEGREE_MASK 0x3
 #define ROCKCHIP_MMC_DELAYNUM_OFFSET 2
 #define ROCKCHIP_MMC_DELAYNUM_MASK (0xff << ROCKCHIP_MMC_DELAYNUM_OFFSET)
-#define ROCKCHIP_MMC_INIT_STATE_RESET 0x1
-#define ROCKCHIP_MMC_INIT_STATE_SHIFT 1
 
 #define PSECS_PER_SEC 1000000000000LL
 
@@ -183,15 +181,6 @@ struct clk *rockchip_clk_register_mmc(co
 	mmc_clock->reg = reg;
 	mmc_clock->shift = shift;
 
-	/*
-	 * Assert init_state to soft reset the CLKGEN
-	 * for mmc tuning phase and degree
-	 */
-	if (mmc_clock->shift == ROCKCHIP_MMC_INIT_STATE_SHIFT)
-		writel(HIWORD_UPDATE(ROCKCHIP_MMC_INIT_STATE_RESET,
-				     ROCKCHIP_MMC_INIT_STATE_RESET,
-				     mmc_clock->shift), mmc_clock->reg);
-
 	clk = clk_register(NULL, &mmc_clock->hw);
 	if (IS_ERR(clk))
 		goto err_free;


