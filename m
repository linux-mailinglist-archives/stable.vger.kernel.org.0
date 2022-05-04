Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600A751A73C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354898AbiEDRDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354908AbiEDQ7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A48A488B5;
        Wed,  4 May 2022 09:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13CBA617BD;
        Wed,  4 May 2022 16:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF75C385A4;
        Wed,  4 May 2022 16:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683065;
        bh=c9tifztPdtIZMnIZoFYTn8EbVTxFGghKHU5Yrzs7rmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6NHRzL56JMaPy5TfeYyG052QmOGmTLdmnHjLVoQ43idl4QTUtNPxDe+7cgWYcMcJ
         lublwXIyfKjqQnKhnsxcDLsUt7C20B+ruPz55yLj5Xj0l8UiFH5226uo6/3au1fwf0
         FKxaLWJzew+zG+Jw9G4jvZo7MJYgsehzm0XKbexs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/129] ARM: dts: at91: Map MCLK for wm8731 on at91sam9g20ek
Date:   Wed,  4 May 2022 18:44:02 +0200
Message-Id: <20220504153025.043787892@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 0e486fe341fabd8e583f3d601a874cd394979c45 ]

The MCLK of the WM8731 on the AT91SAM9G20-EK board is connected to the
PCK0 output of the SoC and is expected to be set to 12MHz. Previously
this was mapped using pre-common clock API calls in the audio machine
driver but the conversion to the common clock framework broke that so
describe things in the DT instead.

Fixes: ff78a189b0ae55f ("ARM: at91: remove old at91-specific clock driver")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220404102806.581374-2-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 87bb39060e8b..ca03685f0f08 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -219,6 +219,12 @@ i2c-gpio-0 {
 		wm8731: wm8731@1b {
 			compatible = "wm8731";
 			reg = <0x1b>;
+
+			/* PCK0 at 12MHz */
+			clocks = <&pmc PMC_TYPE_SYSTEM 8>;
+			clock-names = "mclk";
+			assigned-clocks = <&pmc PMC_TYPE_SYSTEM 8>;
+			assigned-clock-rates = <12000000>;
 		};
 	};
 
-- 
2.35.1



