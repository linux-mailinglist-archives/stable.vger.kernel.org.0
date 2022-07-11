Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15F556FAB5
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiGKJVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiGKJUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA983550B8;
        Mon, 11 Jul 2022 02:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E684061148;
        Mon, 11 Jul 2022 09:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05387C341CB;
        Mon, 11 Jul 2022 09:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530762;
        bh=+vTkH3RZDBI92uQCYAYfCPRyOw85ue/9OySuXaIhlos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ju5sM/yH1rPtHOxn382t8rivyUlauYbUvhbwgEYm1d1kW0Fx7nhSjwFMd3InuplDq
         dNOxGUg4cliHdjIFQ7iSrNwHiPbjfUwsmD8Q/IbcHn1NQNy0r2dr0Vh0lwR014g3rA
         uFJ9h1Kf593R8ivPzh4y10rVlzOFGUsexP7pZKok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 31/55] arm64: dts: imx8mp-evk: correct I2C3 pad settings
Date:   Mon, 11 Jul 2022 11:07:19 +0200
Message-Id: <20220711090542.681601764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
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

[ Upstream commit 0836de513ebaae5f03014641eac996290d67493d ]

According to RM bit layout, BIT3 and BIT0 are reserved.
 8  7   6   5   4   3  2 1  0
PE HYS PUE ODE FSEL X  DSE  X

Although function is not broken, we should not set reserved bit.

Fixes: 5e4a67ff7f69 ("arm64: dts: imx8mp-evk: Add i2c3 support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index c0663a6c8376..c016f5b7d24a 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -154,8 +154,8 @@
 
 	pinctrl_i2c3: i2c3grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_I2C3_SCL__I2C3_SCL		0x400001c3
-			MX8MP_IOMUXC_I2C3_SDA__I2C3_SDA		0x400001c3
+			MX8MP_IOMUXC_I2C3_SCL__I2C3_SCL		0x400001c2
+			MX8MP_IOMUXC_I2C3_SDA__I2C3_SDA		0x400001c2
 		>;
 	};
 
-- 
2.35.1



