Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4692966C5FE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjAPQNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjAPQM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:12:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E087126599
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E9C9B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9C7C433EF;
        Mon, 16 Jan 2023 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885262;
        bh=modqFFpLh/1B9gTcp0eniKm85BE4PYJqQz65XEMxrcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJBTRcTLDvPyTAqFAomAaazk2d3ddqZltWX/PdpL0gPXJkKG40Bj6XWIZkWeWZP+i
         8ptMJ/JBMUsdi2NDts68qDZhwDOpJB+fCBM50OYxw7rmvCoabgnCLH7vnN0N2ZK/DX
         pfjyzHiSSm0bnvfrbK93oJWNWCRKkm5u0G1kIknI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Abel Vesa <abel.vesa@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/64] clk: imx8mp: Add DISP2 pixel clock
Date:   Mon, 16 Jan 2023 16:51:27 +0100
Message-Id: <20230116154744.314339139@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 39772efd98adecbd5b8c6096d465d2fcbafbde6a ]

Add pixel clock for second LCDIFv3 interface. Both LCDIFv3 interfaces use
the same set of parent clock, so deduplicate imx8mp_media_disp1_pix_sels
into common imx8mp_media_disp_pix_sels and use it for both.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Abel Vesa <abel.vesa@nxp.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220313123949.207284-1-marex@denx.de
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Stable-dep-of: 5c1f7f109094 ("dt-bindings: clocks: imx8mp: Add ID for usb suspend clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c             | 5 +++--
 include/dt-bindings/clock/imx8mp-clock.h | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 36e8d619e334..2af39c8240fa 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -362,7 +362,7 @@ static const char * const imx8mp_media_mipi_phy1_ref_sels[] = {"osc_24m", "sys_p
 							       "clk_ext2", "audio_pll2_out",
 							       "video_pll1_out", };
 
-static const char * const imx8mp_media_disp1_pix_sels[] = {"osc_24m", "video_pll1_out", "audio_pll2_out",
+static const char * const imx8mp_media_disp_pix_sels[] = {"osc_24m", "video_pll1_out", "audio_pll2_out",
 							   "audio_pll1_out", "sys_pll1_800m",
 							   "sys_pll2_1000m", "sys_pll3_out", "clk_ext4", };
 
@@ -566,6 +566,7 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_AHB] = imx8m_clk_hw_composite_bus_critical("ahb_root", imx8mp_ahb_sels, ccm_base + 0x9000);
 	hws[IMX8MP_CLK_AUDIO_AHB] = imx8m_clk_hw_composite_bus("audio_ahb", imx8mp_audio_ahb_sels, ccm_base + 0x9100);
 	hws[IMX8MP_CLK_MIPI_DSI_ESC_RX] = imx8m_clk_hw_composite_bus("mipi_dsi_esc_rx", imx8mp_mipi_dsi_esc_rx_sels, ccm_base + 0x9200);
+	hws[IMX8MP_CLK_MEDIA_DISP2_PIX] = imx8m_clk_hw_composite("media_disp2_pix", imx8mp_media_disp_pix_sels, ccm_base + 0x9300);
 
 	hws[IMX8MP_CLK_IPG_ROOT] = imx_clk_hw_divider2("ipg_root", "ahb_root", ccm_base + 0x9080, 0, 1);
 	hws[IMX8MP_CLK_IPG_AUDIO_ROOT] = imx_clk_hw_divider2("ipg_audio_root", "audio_ahb", ccm_base + 0x9180, 0, 1);
@@ -630,7 +631,7 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_USDHC3] = imx8m_clk_hw_composite("usdhc3", imx8mp_usdhc3_sels, ccm_base + 0xbc80);
 	hws[IMX8MP_CLK_MEDIA_CAM1_PIX] = imx8m_clk_hw_composite("media_cam1_pix", imx8mp_media_cam1_pix_sels, ccm_base + 0xbd00);
 	hws[IMX8MP_CLK_MEDIA_MIPI_PHY1_REF] = imx8m_clk_hw_composite("media_mipi_phy1_ref", imx8mp_media_mipi_phy1_ref_sels, ccm_base + 0xbd80);
-	hws[IMX8MP_CLK_MEDIA_DISP1_PIX] = imx8m_clk_hw_composite("media_disp1_pix", imx8mp_media_disp1_pix_sels, ccm_base + 0xbe00);
+	hws[IMX8MP_CLK_MEDIA_DISP1_PIX] = imx8m_clk_hw_composite("media_disp1_pix", imx8mp_media_disp_pix_sels, ccm_base + 0xbe00);
 	hws[IMX8MP_CLK_MEDIA_CAM2_PIX] = imx8m_clk_hw_composite("media_cam2_pix", imx8mp_media_cam2_pix_sels, ccm_base + 0xbe80);
 	hws[IMX8MP_CLK_MEDIA_LDB] = imx8m_clk_hw_composite("media_ldb", imx8mp_media_ldb_sels, ccm_base + 0xbf00);
 	hws[IMX8MP_CLK_MEMREPAIR] = imx8m_clk_hw_composite_critical("mem_repair", imx8mp_memrepair_sels, ccm_base + 0xbf80);
diff --git a/include/dt-bindings/clock/imx8mp-clock.h b/include/dt-bindings/clock/imx8mp-clock.h
index e8d68fbb6e3f..4a621fddfcd3 100644
--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -322,7 +322,9 @@
 #define IMX8MP_CLK_HSIO_AXI			311
 #define IMX8MP_CLK_MEDIA_ISP			312
 
-#define IMX8MP_CLK_END				313
+#define IMX8MP_CLK_MEDIA_DISP2_PIX		313
+
+#define IMX8MP_CLK_END				314
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1
-- 
2.35.1



