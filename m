Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE8156FB79
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiGKJbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiGKJaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:30:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1B672EE2;
        Mon, 11 Jul 2022 02:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73F7EB80E84;
        Mon, 11 Jul 2022 09:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A962CC34115;
        Mon, 11 Jul 2022 09:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531008;
        bh=MvmgnXxSGFc0Vw1XACvyfAJ3wLGDYlztU1H00/h+Z1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xR0lYE7ZZ1cKPlfePi4vG62yc6RgkeCtck2QPcHatiDf5ZUFYTzqWp9x9UTCXGmL1
         daQkwSKSd0HZVlX6ucFgMUN3YSXzOuj/CnOwuqT7ZozCOz6wJ3HJAPg7s25d9+nhmI
         bZ12HceEnFFx9YnZQBm/Z5fMzWw8OtPLEyrlVVRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 062/112] arm64: dts: imx8mp-evk: correct I2C5 pad settings
Date:   Mon, 11 Jul 2022 11:07:02 +0200
Message-Id: <20220711090551.334196919@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 8c214b78e149dc7209e38a031292fe21d7017561 ]

According to RM bit layout, BIT3 and BIT0 are reserved.
 8  7   6   5   4   3  2 1  0
PE HYS PUE ODE FSEL X  DSE  X

Although function is not broken, we should not set reserved bit.

Fixes: 8134822db08d ("arm64: dts: imx8mp-evk: add support for I2C5")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index 454856bd4f56..938757b26add 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -481,8 +481,8 @@
 
 	pinctrl_i2c5: i2c5grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SPDIF_RX__I2C5_SDA         0x400001c3
-			MX8MP_IOMUXC_SPDIF_TX__I2C5_SCL         0x400001c3
+			MX8MP_IOMUXC_SPDIF_RX__I2C5_SDA         0x400001c2
+			MX8MP_IOMUXC_SPDIF_TX__I2C5_SCL         0x400001c2
 		>;
 	};
 
-- 
2.35.1



