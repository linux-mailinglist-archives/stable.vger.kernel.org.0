Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01FE50565F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbiDRNen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244871AbiDRNa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E471EEE9;
        Mon, 18 Apr 2022 05:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06814B80E4B;
        Mon, 18 Apr 2022 12:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DED4C385A7;
        Mon, 18 Apr 2022 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286604;
        bh=o6yvl3mQE+1+NChV+lOG93OdAgrAvTWNdi3fmZLSDEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRIuGlUBBVyea71v6tLuq2WUHL2sN/HxkcQIT+757k6ZBo01YI1MyqC9EuRNNzaMY
         gjKvTKlRW5Tj4HXK8uKLHpWfEPGNFzBelgidnxLt6jDVePOz7YZWuGuVIavH/ali6Y
         24p4kmUZAiyvKgqHEcUOTkJIP1E8TIlDVpf3omBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Schleich <rs@noreya.tech>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 170/284] ARM: dts: bcm2837: Add the missing L1/L2 cache information
Date:   Mon, 18 Apr 2022 14:12:31 +0200
Message-Id: <20220418121216.578046097@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
index d5d058a568c3..20407a5aafc8 100644
--- a/arch/arm/boot/dts/bcm2837.dtsi
+++ b/arch/arm/boot/dts/bcm2837.dtsi
@@ -32,12 +32,26 @@
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
@@ -46,6 +60,13 @@
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
@@ -54,6 +75,13 @@
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
@@ -62,6 +90,27 @@
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



