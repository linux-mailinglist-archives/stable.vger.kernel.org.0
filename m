Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E3865799F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiL1PDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiL1PDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE9A11C18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCFB1B816E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5ECC433EF;
        Wed, 28 Dec 2022 15:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239780;
        bh=wBd1nO3vG7R1jRWlw0UQbcKty0B+7WPECCQPSZK76ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pS6ZzvraeRFByihGs7Y4v3nHMvmdIlBNRdDP1XqQ2dDfTA+2fFsw1+WSv+ScASWw/
         ZYSbR34U4DVeyD4JksqTCxlN1b32ZYj6aguEZIyy82k5DYFTQbRkUq45RfqVHrMjzx
         hD3XwQ3BbeukW7wxIzvDya0qy9E8tTpqfDyL+UsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0042/1146] arm64: dts: renesas: r9a09g011: Fix unit address format error
Date:   Wed, 28 Dec 2022 15:26:21 +0100
Message-Id: <20221228144331.306857123@linuxfoundation.org>
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
index fb1a97202c38..0e72a66f8e3a 100644
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



