Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CB5680F7A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbjA3NyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbjA3NyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:54:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EFE39BB5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:54:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD1DEB81145
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F259C433EF;
        Mon, 30 Jan 2023 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086839;
        bh=sntyZKMHugb8r2YSo7t5212vLB9+x5wmxLcPCAgH/z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGpqaBc47yNJDYRP2Fx76RRPnzPpEFyaARDmBADxSM1xVnNAPPGM+DAZNx20zCDmj
         2NzVTkFfv37i4EE8MjuFe5G/CSziFXsFlT1sKdml8M/bmC2GSLjJvAMR9tk/oAVbvG
         cEL36tvO3+6h7GaspwD7OodWKtHunQvvqE0IshoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haibo Chen <haibo.chen@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/313] arm64: dts: imx93-11x11-evk: correct clock and strobe pad setting
Date:   Mon, 30 Jan 2023 14:47:30 +0100
Message-Id: <20230130134337.374837495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 62f0147fd4d86620853bee027800f988d3013656 ]

For clock and strobe pad of usdhc, need to config as pull down.
Current pad config set these pad as both pull up and pull down,
this is wrong, so fix it here.
Find this issue when enable HS400ES mode on one Micron eMMC chip,
CMD8 always meet CRC error in HS400ES/HS400 mode.

Fixes: e37907bd8294 ("arm64: dts: freescale: add i.MX93 11x11 EVK basic support")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
index 69786c326db0..27f9a9f33134 100644
--- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
@@ -74,7 +74,7 @@ MX93_PAD_UART1_TXD__LPUART1_TX			0x31e
 
 	pinctrl_usdhc1: usdhc1grp {
 		fsl,pins = <
-			MX93_PAD_SD1_CLK__USDHC1_CLK		0x17fe
+			MX93_PAD_SD1_CLK__USDHC1_CLK		0x15fe
 			MX93_PAD_SD1_CMD__USDHC1_CMD		0x13fe
 			MX93_PAD_SD1_DATA0__USDHC1_DATA0	0x13fe
 			MX93_PAD_SD1_DATA1__USDHC1_DATA1	0x13fe
@@ -84,7 +84,7 @@ MX93_PAD_SD1_DATA4__USDHC1_DATA4	0x13fe
 			MX93_PAD_SD1_DATA5__USDHC1_DATA5	0x13fe
 			MX93_PAD_SD1_DATA6__USDHC1_DATA6	0x13fe
 			MX93_PAD_SD1_DATA7__USDHC1_DATA7	0x13fe
-			MX93_PAD_SD1_STROBE__USDHC1_STROBE	0x17fe
+			MX93_PAD_SD1_STROBE__USDHC1_STROBE	0x15fe
 		>;
 	};
 
@@ -102,7 +102,7 @@ MX93_PAD_SD2_CD_B__GPIO3_IO00		0x31e
 
 	pinctrl_usdhc2: usdhc2grp {
 		fsl,pins = <
-			MX93_PAD_SD2_CLK__USDHC2_CLK		0x17fe
+			MX93_PAD_SD2_CLK__USDHC2_CLK		0x15fe
 			MX93_PAD_SD2_CMD__USDHC2_CMD		0x13fe
 			MX93_PAD_SD2_DATA0__USDHC2_DATA0	0x13fe
 			MX93_PAD_SD2_DATA1__USDHC2_DATA1	0x13fe
-- 
2.39.0



