Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFF6657937
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiL1O7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiL1O6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1929312744
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0095B8171A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A69BC433D2;
        Wed, 28 Dec 2022 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239519;
        bh=+Y2k4XNb1phLqqeVeTe/06TPXKKCp5VXlH2m2UFDNVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0gjXlFOhAII+XO1dsXHn090G/ZRkFN8T7EH0M4fV7VOg/ZG8NqhNz7jRHgM8MYhn
         a13L8NDYqiD2FY4Sqhl9uGGcc+EaQKmP5y1aXetw/NLxQG5C9Gs6OEa23qfcnMkmkP
         EhN00EUy2jNbwqVFX7XlNi5QBGCrbHww+HiWwd/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0045/1073] arm64: dts: renesas: r9a09g011: Fix unit address format error
Date:   Wed, 28 Dec 2022 15:27:13 +0100
Message-Id: <20221228144329.346677509@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 278f5015a3deaa2ea0db6070bbc2a8edf2455643 ]

Although the HW User Manual for RZ/V2M states in the "Address Map"
section that the interrupt controller is assigned addresses starting
from 0x82000000, the memory locations from 0x82000000 0x0x8200FFFF
are marked as reserved in the "Interrupt Controller (GIC)" section
and are currently not used by the device tree, leading to the below
warning:

arch/arm64/boot/dts/renesas/r9a09g011.dtsi:51.38-63.5: Warning
(simple_bus_reg): /soc/interrupt-controller@82000000: simple-bus unit
address format error, expected "82010000"

Fix the unit address accordingly.

Fixes: fb1929b98f2e ("arm64: dts: renesas: Add initial DTSI for RZ/V2M SoC")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Link: https://lore.kernel.org/r/20221103230648.53748-2-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g011.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g011.dtsi b/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
index d4cc5459fbb7..4ce0f3944649 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
@@ -48,7 +48,7 @@ soc: soc {
 		#size-cells = <2>;
 		ranges;
 
-		gic: interrupt-controller@82000000 {
+		gic: interrupt-controller@82010000 {
 			compatible = "arm,gic-400";
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
-- 
2.35.1



