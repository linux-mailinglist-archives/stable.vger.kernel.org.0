Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282DE541C0B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382741AbiFGV4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384331AbiFGVy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134B424AEE1;
        Tue,  7 Jun 2022 12:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB8CB618E1;
        Tue,  7 Jun 2022 19:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCF1C385A5;
        Tue,  7 Jun 2022 19:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629169;
        bh=/atc0+gFpH0rsZcqQNrfsag5GHjaKYkPOJ5HwXSCjX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FE0/aY98Er5LvEKg4AMeU7+0xD2I5oGEyMOiwxuduvaqUm2ljrhOvvTVi8Ucohm+n
         dGsYXVODkbiqqLG6IoH8B41oNzKcBKVcp0lWiqIUp8NXN3pwPp5YHpBhoVdIGctMjK
         5DciXl/5zYpx2MnBF/q2TuI99O1HUElFD8aDlX00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 587/879] arm64: dts: ti: k3-am64-mcu: remove incorrect UART base clock rates
Date:   Tue,  7 Jun 2022 19:01:45 +0200
Message-Id: <20220607165019.890475391@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 2bb5c9ff172c..02d4285acbb8 100644
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



