Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BDC51A7CA
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiEDRHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355911AbiEDREr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA6649C90;
        Wed,  4 May 2022 09:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0674B8279F;
        Wed,  4 May 2022 16:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2A9C385AA;
        Wed,  4 May 2022 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683210;
        bh=sCjBYryfbrDNUGqpThNG1E4jFTg2IH/IIsr3Om6bE/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTPHvJRjO7SUs8vBOX7miqGV0qlkPwlvu4ToyIlu+vZmmqPxPKmaZtsGfF/ytLzhY
         HfQ4y12GX1bCdoabTE5zfvFjygd1g5vlPIBEy7uEMZwTe7UN09qLWhYYWT48VLpwH3
         NEpCTVKndA4YUtiX1kwd1dlRYlJOxZWD6Sb7Wz8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/177] ARM: dts: dra7: Fix suspend warning for vpe powerdomain
Date:   Wed,  4 May 2022 18:44:15 +0200
Message-Id: <20220504153058.558589545@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 8d2453d9a307c2eafd21242dd73f35f05fb7ce74 ]

We currently are getting the following warning after a system suspend:

Powerdomain (vpe_pwrdm) didn't enter target state 0

Looks like this is because the STANDBYMODE bit for SMART_IDLE should
not be used. The TRM "Table 12-348. VPE_SYSCONFIG" says that the value
for SMART_IDLE is "0x2: Same behavior as bit-field value of 0x1". But
if the SMART_IDLE value is used, PM_VPE_PWRSTST LASTPOWERSTATEENTERED
bits always show value of 3.

Let's fix the issue by dropping SMART_IDLE for vpe. And let's also add
the missing the powerdomain for vpe.

Fixes: 1a2095160594 ("ARM: dts: dra7: Add ti-sysc node for VPE")
Cc: Benoit Parrot <bparrot@ti.com>
Reported-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-l4.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index 0a11bacffc1f..5733e3a4ea8e 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -4188,11 +4188,11 @@ target-module@1d0010 {			/* 0x489d0000, ap 27 30.0 */
 			reg = <0x1d0010 0x4>;
 			reg-names = "sysc";
 			ti,sysc-midle = <SYSC_IDLE_FORCE>,
-					<SYSC_IDLE_NO>,
-					<SYSC_IDLE_SMART>;
+					<SYSC_IDLE_NO>;
 			ti,sysc-sidle = <SYSC_IDLE_FORCE>,
 					<SYSC_IDLE_NO>,
 					<SYSC_IDLE_SMART>;
+			power-domains = <&prm_vpe>;
 			clocks = <&vpe_clkctrl DRA7_VPE_VPE_CLKCTRL 0>;
 			clock-names = "fck";
 			#address-cells = <1>;
-- 
2.35.1



