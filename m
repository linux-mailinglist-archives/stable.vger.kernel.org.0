Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC504F3924
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377650AbiDELaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352042AbiDEKDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:03:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249E4AA00E;
        Tue,  5 Apr 2022 02:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E73A6616D0;
        Tue,  5 Apr 2022 09:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E61C385A2;
        Tue,  5 Apr 2022 09:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152367;
        bh=93YLaa0zQ7hqgghUl04JHh02d/eZiQqyJBOIBGaKxuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWsyFwwb4BpjQHopkeE1AQNuhuUCwjo1tmgQaB6Qkhw2V7Ei/3dZpSreaVXVjyBIu
         HsVIraZyxV22Djd9wfNV3D2Nv9xNU/CF3XBwbRnfk7UHV5n7kRfysZu77yt24fpfD5
         JuWAautYPdMjFnMIW7wn9oQyAKbjDoDMYYQHFl6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Schleich <rs@noreya.tech>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 752/913] ARM: dts: bcm2711: Add the missing L1/L2 cache information
Date:   Tue,  5 Apr 2022 09:30:14 +0200
Message-Id: <20220405070402.374643926@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



