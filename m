Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0406DCA33
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 19:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjDJRtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 13:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjDJRtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 13:49:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50D626A2
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 10:49:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8081861360
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 17:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D5FC433D2;
        Mon, 10 Apr 2023 17:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681148976;
        bh=KHGLoLzePgFno5kP1PXHsbUCi4D8chj8OEYjuqhhaGA=;
        h=Subject:To:Cc:From:Date:From;
        b=HX2UfkWq9tYbYnmUg1LkyT0UVPDcA3fy5zO93ISDXw0MEHiktscUdtzBxsxYpqHx8
         uYpi9mpEA/EWGx3b/5EicFqdslJ4LYaceloqD+OuPF8wiozqHWukBL7082WS5daAS5
         XRKcYfdzaTLnHKWYC1SE1WaMETmLNeP3sTM3ISvA=
Subject: FAILED: patch "[PATCH] clk: imx: imx8mp: add shared clk gate for usb suspend clk" failed to apply to 5.15-stable tree
To:     jun.li@nxp.com, abel.vesa@linaro.org,
        alexander.stein@ew.tq-group.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Apr 2023 19:49:34 +0200
Message-ID: <2023041033-paragraph-uselessly-114f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x ed1f4ccfe947a3e1018a3bd7325134574c7ff9b3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041033-paragraph-uselessly-114f@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

ed1f4ccfe947 ("clk: imx: imx8mp: add shared clk gate for usb suspend clk")
cf7f3f4fa9e5 ("clk: imx8mp: fix usb_root_clk parent")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ed1f4ccfe947a3e1018a3bd7325134574c7ff9b3 Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Fri, 30 Sep 2022 22:54:22 +0800
Subject: [PATCH] clk: imx: imx8mp: add shared clk gate for usb suspend clk

32K usb suspend clock gate is shared with usb_root_clk, this
shared clock gate was initially defined only for usb suspend
clock, usb suspend clk is kept on while system is active or
system sleep with usb wakeup enabled, so usb root clock is
fine with this situation; with the commit cf7f3f4fa9e5
("clk: imx8mp: fix usb_root_clk parent"), this clock gate is
changed to be for usb root clock, but usb root clock will
be off while usb is suspended, so usb suspend clock will be
gated too, this cause some usb functionalities will not work,
so define this clock to be a shared clock gate to conform with
the real HW status.

Fixes: 9c140d9926761 ("clk: imx: Add support for i.MX8MP clock driver")
Cc: stable@vger.kernel.org # v5.19+
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/1664549663-20364-2-git-send-email-jun.li@nxp.com

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 652ae58c2735..5d68d975b4eb 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -17,6 +17,7 @@
 
 static u32 share_count_nand;
 static u32 share_count_media;
+static u32 share_count_usb;
 
 static const char * const pll_ref_sels[] = { "osc_24m", "dummy", "dummy", "dummy", };
 static const char * const audio_pll1_bypass_sels[] = {"audio_pll1", "audio_pll1_ref_sel", };
@@ -673,7 +674,8 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_UART2_ROOT] = imx_clk_hw_gate4("uart2_root_clk", "uart2", ccm_base + 0x44a0, 0);
 	hws[IMX8MP_CLK_UART3_ROOT] = imx_clk_hw_gate4("uart3_root_clk", "uart3", ccm_base + 0x44b0, 0);
 	hws[IMX8MP_CLK_UART4_ROOT] = imx_clk_hw_gate4("uart4_root_clk", "uart4", ccm_base + 0x44c0, 0);
-	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate4("usb_root_clk", "hsio_axi", ccm_base + 0x44d0, 0);
+	hws[IMX8MP_CLK_USB_ROOT] = imx_clk_hw_gate2_shared2("usb_root_clk", "hsio_axi", ccm_base + 0x44d0, 0, &share_count_usb);
+	hws[IMX8MP_CLK_USB_SUSP] = imx_clk_hw_gate2_shared2("usb_suspend_clk", "osc_32k", ccm_base + 0x44d0, 0, &share_count_usb);
 	hws[IMX8MP_CLK_USB_PHY_ROOT] = imx_clk_hw_gate4("usb_phy_root_clk", "usb_phy_ref", ccm_base + 0x44f0, 0);
 	hws[IMX8MP_CLK_USDHC1_ROOT] = imx_clk_hw_gate4("usdhc1_root_clk", "usdhc1", ccm_base + 0x4510, 0);
 	hws[IMX8MP_CLK_USDHC2_ROOT] = imx_clk_hw_gate4("usdhc2_root_clk", "usdhc2", ccm_base + 0x4520, 0);

