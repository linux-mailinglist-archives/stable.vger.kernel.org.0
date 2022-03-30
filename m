Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DE74EC271
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344374AbiC3L7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345922AbiC3LzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD71276F90;
        Wed, 30 Mar 2022 04:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C53761704;
        Wed, 30 Mar 2022 11:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D038C3410F;
        Wed, 30 Mar 2022 11:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641157;
        bh=pFdRCSOxzPhEsyQeL9XSfBzfcCUGhXyUbPzLbsmmzLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppiKL0lDyj/25O9xt1wMf97yu71wgAJBLgSOItpAktjmzKj8dHIYxcurgNKqLGA0I
         5Vtbnyd1gNnwvE+Zy8WeEk2/Is3V8cJnjdRLL6jFwzZK1exMKbKpQlPAt6FAuoO0BS
         MK5jzu6HCyZUPGVzT5cMo8enYg62Fflw44oOGTSc6GbGk1FTpCs4pP4aqs/BikxHmd
         4CAHhKFjEp1GbucAT4SETDAPlIl2XAwrKD2igpKAtkPEzYfYgRN9cBOE366XyPuE9C
         yO65ChO+DR3ATQDUepTOKTU8hGECkbv0XXb9aPzObtr7IOkw3o0HEfGdkpqNB7JVNR
         UZ+DEEt7BURUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Schleich <rs@noreya.tech>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        mark.rutland@arm.com, linux@armlinux.org.uk, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 07/25] ARM: dts: bcm2837: Add the missing L1/L2 cache information
Date:   Wed, 30 Mar 2022 07:52:07 -0400
Message-Id: <20220330115225.1672278-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115225.1672278-1-sashal@kernel.org>
References: <20220330115225.1672278-1-sashal@kernel.org>
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

[ Upstream commit bdf8762da268d2a34abf517c36528413906e9cd5 ]

This patch fixes the kernel warning
"cacheinfo: Unable to detect cache hierarchy for CPU 0"
for the bcm2837 on newer kernel versions.

Signed-off-by: Richard Schleich <rs@noreya.tech>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
[florian: Align and remove comments matching property values]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2837.dtsi | 49 ++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2837.dtsi b/arch/arm/boot/dts/bcm2837.dtsi
index beb6c502dadc..bcad098a7fcc 100644
--- a/arch/arm/boot/dts/bcm2837.dtsi
+++ b/arch/arm/boot/dts/bcm2837.dtsi
@@ -38,12 +38,26 @@
 		#size-cells = <0>;
 		enable-method = "brcm,bcm2836-smp"; // for ARM 32-bit
 
+		/* Source for d/i-cache-line-size and d/i-cache-sets
+		 * https://developer.arm.com/documentation/ddi0500/e/level-1-memory-system
+		 * /about-the-l1-memory-system?lang=en
+		 *
+		 * Source for d/i-cache-size
+		 * https://magpi.raspberrypi.com/articles/raspberry-pi-3-specs-benchmarks
+		 */
 		cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a53";
 			reg = <0>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000d8>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu1: cpu@1 {
@@ -52,6 +66,13 @@
 			reg = <1>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000e0>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu2: cpu@2 {
@@ -60,6 +81,13 @@
 			reg = <2>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000e8>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu3: cpu@3 {
@@ -68,6 +96,27 @@
 			reg = <3>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000f0>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
+		};
+
+		/* Source for cache-line-size + cache-sets
+		 * https://developer.arm.com/documentation/ddi0500
+		 * /e/level-2-memory-system/about-the-l2-memory-system?lang=en
+		 * Source for cache-size
+		 * https://datasheets.raspberrypi.com/cm/cm1-and-cm3-datasheet.pdf
+		 */
+		l2: l2-cache0 {
+			compatible = "cache";
+			cache-size = <0x80000>;
+			cache-line-size = <64>;
+			cache-sets = <512>; // 512KiB(size)/64(line-size)=8192ways/16-way set
+			cache-level = <2>;
 		};
 	};
 };
-- 
2.34.1

