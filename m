Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558CB4EC114
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245677AbiC3Lzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344639AbiC3LxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CF5269356;
        Wed, 30 Mar 2022 04:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3461961616;
        Wed, 30 Mar 2022 11:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBBCC36AE2;
        Wed, 30 Mar 2022 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640959;
        bh=93YLaa0zQ7hqgghUl04JHh02d/eZiQqyJBOIBGaKxuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2WfVG1ctqfGWgEO5xVlJXG6I4lmDc42ujXfsD5HMwDvRUXT9R3ZLK9wxyzrSYxaJ
         0ER05E+95mH+IW852ORaTrFB4AW1LrSt31Lp/UK8Kc5VRs6H/incTrgrgyAElsON0a
         /RcdZ8kBoCMo63FV+gUdhYjXiqKAm/OIiCUVtlhZUWQwf8T1BlInt7s6hhaC/c35o6
         3SmsuEQVwX7evpP4RG872gC97GvrgcIE50odxxvDVbwDGnMEnTaShiBVR1N5sNnqUs
         xH9ylkNPlvtZTT/mPUjhzOKdZR68HvVpCgplEbGrD1JAXawYoAlQx9wOXwMkC6o8DA
         uZhgFqM1ZLzzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Schleich <rs@noreya.tech>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        mark.rutland@arm.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 30/59] ARM: dts: bcm2711: Add the missing L1/L2 cache information
Date:   Wed, 30 Mar 2022 07:48:02 -0400
Message-Id: <20220330114831.1670235-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Schleich <rs@noreya.tech>

[ Upstream commit 618682b350990f8f1bee718949c4b3858711eb58 ]

This patch fixes the kernel warning
"cacheinfo: Unable to detect cache hierarchy for CPU 0"
for the bcm2711 on newer kernel versions.

Signed-off-by: Richard Schleich <rs@noreya.tech>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
[florian: Align and remove comments matching property values]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2711.dtsi | 50 ++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
index 21294f775a20..89af57482bc8 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -459,12 +459,26 @@
 		#size-cells = <0>;
 		enable-method = "brcm,bcm2836-smp"; // for ARM 32-bit
 
+		/* Source for d/i-cache-line-size and d/i-cache-sets
+		 * https://developer.arm.com/documentation/100095/0003
+		 * /Level-1-Memory-System/About-the-L1-memory-system?lang=en
+		 * Source for d/i-cache-size
+		 * https://www.raspberrypi.com/documentation/computers
+		 * /processors.html#bcm2711
+		 */
 		cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a72";
 			reg = <0>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000d8>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			i-cache-size = <0xc000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 48KiB(size)/64(line-size)=768ways/3-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu1: cpu@1 {
@@ -473,6 +487,13 @@
 			reg = <1>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000e0>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			i-cache-size = <0xc000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 48KiB(size)/64(line-size)=768ways/3-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu2: cpu@2 {
@@ -481,6 +502,13 @@
 			reg = <2>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000e8>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			i-cache-size = <0xc000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 48KiB(size)/64(line-size)=768ways/3-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu3: cpu@3 {
@@ -489,6 +517,28 @@
 			reg = <3>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000f0>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			i-cache-size = <0xc000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 48KiB(size)/64(line-size)=768ways/3-way set
+			next-level-cache = <&l2>;
+		};
+
+		/* Source for d/i-cache-line-size and d/i-cache-sets
+		 *  https://developer.arm.com/documentation/100095/0003
+		 *  /Level-2-Memory-System/About-the-L2-memory-system?lang=en
+		 *  Source for d/i-cache-size
+		 *  https://www.raspberrypi.com/documentation/computers
+		 *  /processors.html#bcm2711
+		 */
+		l2: l2-cache0 {
+			compatible = "cache";
+			cache-size = <0x100000>;
+			cache-line-size = <64>;
+			cache-sets = <1024>; // 1MiB(size)/64(line-size)=16384ways/16-way set
+			cache-level = <2>;
 		};
 	};
 
-- 
2.34.1

