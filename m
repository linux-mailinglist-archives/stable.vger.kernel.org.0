Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019EE65792B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiL1O6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiL1O6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711831274F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B71261541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB21C433F1;
        Wed, 28 Dec 2022 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239490;
        bh=sWRMUQOmGXPMDEGjyJdkqFYDwJYOlv81EffLH/nUy4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKzw7wsgarSVMnW4/uUgpFu84VCLV/29V/zKEcg4GkpO9Gl97KTcGSsJV+AJk7l1y
         /Gv+9kKM6w3mEgJB+yDoX66hwtF9p8ShtKezA5w9ZUlJuTBI8fi7sQBXwKWhsmP8wu
         lubgHH5VyE12WSuvruio2HA97ufRcRHvjUpaaEoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/731] clk: imx: replace osc_hdmi with dummy
Date:   Wed, 28 Dec 2022 15:35:41 +0100
Message-Id: <20221228144303.344466587@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit e7fa365ff66f16772dc06b480cd78f858d10856b ]

There is no occurrence of the hdmi oscillator in the reference manual
(document IMX8MNRM Rev 2, 07/2022). Further, if we consider the indexes
76-81 and 134 of the "Clock Root" table of chapter 5 of the RM, there is
no entry for the source select bits 101b, which is the setting referenced
by "osc_hdmi".
Fix by renaming "osc_hdmi" with "dummy", a clock which has already been
used for missing source select bits.

Tested on the BSH SystemMaster (SMM) S2 board.

Fixes: 96d6392b54dbb ("clk: imx: Add support for i.MX8MN clock driver")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Acked-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20221117113637.1978703-3-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mn.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index 4f5f368ef25b..dfba853335fd 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -108,27 +108,27 @@ static const char * const imx8mn_disp_pixel_sels[] = {"osc_24m", "video_pll1_out
 						      "sys_pll3_out", "clk_ext4", };
 
 static const char * const imx8mn_sai2_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
-						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
+						"video_pll1_out", "sys_pll1_133m", "dummy",
 						"clk_ext3", "clk_ext4", };
 
 static const char * const imx8mn_sai3_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
-						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
+						"video_pll1_out", "sys_pll1_133m", "dummy",
 						"clk_ext3", "clk_ext4", };
 
 static const char * const imx8mn_sai5_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
-						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
+						"video_pll1_out", "sys_pll1_133m", "dummy",
 						"clk_ext2", "clk_ext3", };
 
 static const char * const imx8mn_sai6_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
-						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
+						"video_pll1_out", "sys_pll1_133m", "dummy",
 						"clk_ext3", "clk_ext4", };
 
 static const char * const imx8mn_sai7_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
-						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
+						"video_pll1_out", "sys_pll1_133m", "dummy",
 						"clk_ext3", "clk_ext4", };
 
 static const char * const imx8mn_spdif1_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
-						  "video_pll1_out", "sys_pll1_133m", "osc_hdmi",
+						  "video_pll1_out", "sys_pll1_133m", "dummy",
 						  "clk_ext2", "clk_ext3", };
 
 static const char * const imx8mn_enet_ref_sels[] = {"osc_24m", "sys_pll2_125m", "sys_pll2_50m",
-- 
2.35.1



