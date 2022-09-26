Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7625EA455
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbiIZLpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbiIZLpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:45:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8FD7393F;
        Mon, 26 Sep 2022 03:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E8A4B80185;
        Mon, 26 Sep 2022 10:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66B6C43140;
        Mon, 26 Sep 2022 10:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189116;
        bh=XyojQ7fSLGv6sgp1IJlFNRcg0hwCTpYkavxuwJX689M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxj+eVGe4Wy71YjtWrJbA2i/CMK0DBJUrcJLBK3yWt8YtjsgmUOyUp7Ojbb9fX01H
         Mi43XJFraZk+X8KNtJAD+LoFcyfpe/f1cyuV9i+Uz/lDJpSOKXHjisa/MQjj+rXgFA
         iEuZ/jCTV7aQi5MVRi2AbwT9gLaRNzU4ksPZ9Dy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 079/207] arm64: dts: imx8mn: remove GPU power domain reset
Date:   Mon, 26 Sep 2022 12:11:08 +0200
Message-Id: <20220926100810.114790618@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SUBJ_WIPE_DEBT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 347155d1fa85972ac19d1bf58ae3f3ce95e51a5d ]

The PGC (power gating controller) already handles the reset for the
GPUMIX power domain. By specifying it within the device tree the reset
it issued a 2nd time. This confuses the hardware during power up and
sporadically hangs the SoC. Fix this by removing the reset property and
let the hardware handle the reset.

Fixes: 9a0f3b157e22e ("arm64: dts: imx8mn: Enable GPU")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index e41e1d56f980..7bd4eecd592e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -672,7 +672,6 @@ pgc_gpumix: power-domain@2 {
 							 <&clk IMX8MN_CLK_GPU_SHADER>,
 							 <&clk IMX8MN_CLK_GPU_BUS_ROOT>,
 							 <&clk IMX8MN_CLK_GPU_AHB>;
-						resets = <&src IMX8MQ_RESET_GPU_RESET>;
 					};
 
 					pgc_dispmix: power-domain@3 {
-- 
2.35.1



