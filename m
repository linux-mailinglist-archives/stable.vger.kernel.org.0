Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4612540CE0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352674AbiFGSlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353346AbiFGSkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:40:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B107C1862A3;
        Tue,  7 Jun 2022 10:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CDD9CE2428;
        Tue,  7 Jun 2022 17:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967C4C34115;
        Tue,  7 Jun 2022 17:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624709;
        bh=3KKKZtJ4sFeXRC/0k5HsH1u7OtlOH5IUU4Szu7BmfA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX5Vd64bnezOWYYRdpPDsv1l+aYxXuh2ivkdcWOauO7dWyFDvFuv5WczFfkOyCyA5
         DOV9DxLhzvGJuI/MtuyQoKzzPsj+ApshhTO57A+jZAZu/wQU8tlB4qvtAYlQ14ge8d
         uf7ZA/6i2q5eVjFHm8YcnNekPe+ys094BHw3bpmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/667] arm64: dts: ti: k3-am64-mcu: remove incorrect UART base clock rates
Date:   Tue,  7 Jun 2022 19:01:29 +0200
Message-Id: <20220607164947.447335342@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 439677d416b17dd39964d5f7d64b742a2e51da5b ]

We found that (at least some versions of) the sci-fw set the base clock
rate for UARTs in the MCU domain to 96 MHz instead of the expected 48 MHz,
leading to incorrect baud rates when used from Linux.

As the 8250_omap driver will query the actual clock rate from the clk
driver when clock-frequency is unset, removing the incorrect property is
sufficient to fix the baud rate.

Fixes: 8abae9389bdb ("arm64: dts: ti: Add support for AM642 SoC")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20220419075157.189347-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi
index 59cc58f7d0c8..93e684bbd66c 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi
@@ -10,7 +10,6 @@
 		compatible = "ti,am64-uart", "ti,am654-uart";
 		reg = <0x00 0x04a00000 0x00 0x100>;
 		interrupts = <GIC_SPI 185 IRQ_TYPE_LEVEL_HIGH>;
-		clock-frequency = <48000000>;
 		current-speed = <115200>;
 		power-domains = <&k3_pds 149 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 149 0>;
@@ -21,7 +20,6 @@
 		compatible = "ti,am64-uart", "ti,am654-uart";
 		reg = <0x00 0x04a10000 0x00 0x100>;
 		interrupts = <GIC_SPI 186 IRQ_TYPE_LEVEL_HIGH>;
-		clock-frequency = <48000000>;
 		current-speed = <115200>;
 		power-domains = <&k3_pds 160 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 160 0>;
-- 
2.35.1



