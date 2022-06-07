Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87A6541C1E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349146AbiFGV4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383303AbiFGVxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F395F5A;
        Tue,  7 Jun 2022 12:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59D10B82182;
        Tue,  7 Jun 2022 19:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7BDC385A5;
        Tue,  7 Jun 2022 19:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629075;
        bh=F5vc2z5PopVkJ8A8MZC70EPgQB/h1zcxegZ4uIkJRU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmTdBiNpeqPYixelxqRPqaUQTFP0fKf+8Nb8tJxfhY6DvjHj7vKEj2hrnDc8vvH2u
         O23J6JweUkYRCWcqJOe84c4CZXSkQqxqRzLaUxbZuSs+LZtxZ99Ckjv8bAGsukuwfV
         +1sJyaEa2Xz4d0/x3G2dxipQ5KzYTXViQaOxLMr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 561/879] ARM: dts: stm32: Fix PHY post-reset delay on Avenger96
Date:   Tue,  7 Jun 2022 19:01:19 +0200
Message-Id: <20220607165019.146590485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit ef2d90708883f4025a801feb0ba8411a7a4387e1 ]

Per KSZ9031RNX PHY datasheet FIGURE 7-5: POWER-UP/POWER-DOWN/RESET TIMING
Note 2: After the de-assertion of reset, wait a minimum of 100 μs before
starting programming on the MIIM (MDC/MDIO) interface.

Add 1ms post-reset delay to guarantee this figure.

Fixes: 010ca9fe500bf ("ARM: dts: stm32: Add missing ethernet PHY reset on AV96")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index 61e17f44ce81..76c54b006d87 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -141,6 +141,7 @@
 		compatible = "snps,dwmac-mdio";
 		reset-gpios = <&gpioz 2 GPIO_ACTIVE_LOW>;
 		reset-delay-us = <1000>;
+		reset-post-delay-us = <1000>;
 
 		phy0: ethernet-phy@7 {
 			reg = <7>;
-- 
2.35.1



