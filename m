Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5736583A4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiL1Qtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiL1QtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:49:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364971C13F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:44:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBE72B81889
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182C2C433D2;
        Wed, 28 Dec 2022 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245871;
        bh=l/uTSJpkb7iF9/bwE+UEqemQYnCtWxrWUH9JUkWJkGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wud6W2vj5cuaj2hRP6qaEUY9CPIaUVuWaluAJ9U+wgKJJHjmpgFFax/K3RveYd8x7
         rjgdh8ZidCWOBix9sjzhnHVXfxHy6/afkdUncT8+i0E3qf1KEnN1kcyIFCstCvtwP/
         IF/wPGBfwHM3cHx3Pt8pgUvwCR8fu7Mt151oAVJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adriana Kobylak <anoo@us.ibm.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0939/1146] ARM: dts: aspeed: rainier,everest: Move reserved memory regions
Date:   Wed, 28 Dec 2022 15:41:18 +0100
Message-Id: <20221228144355.811960718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adriana Kobylak <anoo@us.ibm.com>

[ Upstream commit e184d42a6e085f95f5c4f1a4fbabebab2984cb68 ]

Move the reserved regions to account for a decrease in DRAM when ECC is
enabled. ECC takes 1/9th of memory.

Running on HW with ECC off, u-boot prints:
DRAM:  already initialized, 1008 MiB (capacity:1024 MiB, VGA:16 MiB, ECC:off)

And with ECC on, u-boot prints:
DRAM:  already initialized, 896 MiB (capacity:1024 MiB, VGA:16 MiB, ECC:on, ECC size:896 MiB)

This implies that MCR54 is configured for ECC to be bounded at the
bottom of a 16MiB VGA memory region:

1024MiB - 16MiB (VGA) = 1008MiB
1008MiB / 9 (for ECC) = 112MiB
1008MiB - 112MiB = 896MiB (available DRAM)

The flash_memory region currently starts at offset 896MiB:
0xb8000000 (flash_memory offset) - 0x80000000 (base memory address) = 0x38000000 = 896MiB

This is the end of the available DRAM with ECC enabled and therefore it
needs to be moved.

Since the flash_memory is 64MiB in size and needs to be 64MiB aligned,
it can just be moved up by 64MiB and would sit right at the end of the
available DRAM buffer.

The ramoops region currently follows the flash_memory, but it can be
moved to sit above flash_memory which would minimize the address-space
fragmentation.

Signed-off-by: Adriana Kobylak <anoo@us.ibm.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220916195535.1020185-1-anoo@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts | 17 ++++++++---------
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts | 16 +++++++++-------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
index a6a2bc3b855c..fcc890e3ad73 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -162,16 +162,9 @@ reserved-memory {
 		#size-cells = <1>;
 		ranges;
 
-		/* LPC FW cycle bridge region requires natural alignment */
-		flash_memory: region@b8000000 {
-			no-map;
-			reg = <0xb8000000 0x04000000>; /* 64M */
-		};
-
-		/* 48MB region from the end of flash to start of vga memory */
-		ramoops@bc000000 {
+		ramoops@b3e00000 {
 			compatible = "ramoops";
-			reg = <0xbc000000 0x200000>; /* 16 * (4 * 0x8000) */
+			reg = <0xb3e00000 0x200000>; /* 16 * (4 * 0x8000) */
 			record-size = <0x8000>;
 			console-size = <0x8000>;
 			ftrace-size = <0x8000>;
@@ -179,6 +172,12 @@ ramoops@bc000000 {
 			max-reason = <3>; /* KMSG_DUMP_EMERG */
 		};
 
+		/* LPC FW cycle bridge region requires natural alignment */
+		flash_memory: region@b4000000 {
+			no-map;
+			reg = <0xb4000000 0x04000000>; /* 64M */
+		};
+
 		/* VGA region is dictated by hardware strapping */
 		vga_memory: region@bf000000 {
 			no-map;
diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
index bf59a9962379..4879da4cdbd2 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
@@ -95,14 +95,9 @@ reserved-memory {
 		#size-cells = <1>;
 		ranges;
 
-		flash_memory: region@b8000000 {
-			no-map;
-			reg = <0xb8000000 0x04000000>; /* 64M */
-		};
-
-		ramoops@bc000000 {
+		ramoops@b3e00000 {
 			compatible = "ramoops";
-			reg = <0xbc000000 0x200000>; /* 16 * (4 * 0x8000) */
+			reg = <0xb3e00000 0x200000>; /* 16 * (4 * 0x8000) */
 			record-size = <0x8000>;
 			console-size = <0x8000>;
 			ftrace-size = <0x8000>;
@@ -110,6 +105,13 @@ ramoops@bc000000 {
 			max-reason = <3>; /* KMSG_DUMP_EMERG */
 		};
 
+		/* LPC FW cycle bridge region requires natural alignment */
+		flash_memory: region@b4000000 {
+			no-map;
+			reg = <0xb4000000 0x04000000>; /* 64M */
+		};
+
+		/* VGA region is dictated by hardware strapping */
 		vga_memory: region@bf000000 {
 			no-map;
 			compatible = "shared-dma-pool";
-- 
2.35.1



