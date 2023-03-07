Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB416AEDB6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCGSGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCGSGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:06:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A520A5D7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:59:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6A1DB819C7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C28C433D2;
        Tue,  7 Mar 2023 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211962;
        bh=DUQnO9dy8/C2qiOBrthkT5FEKaTadROumZB7wPAQw50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTVsbQ4g5uyhimNUzTaq7uhHefKXU4bOiDvEKY90yagHomgTYrZ8KYqSpSKIvrpq1
         Fd0FLnAoFl40d0Me2FOwu2aYrNqPRJC9us68SEThCHBlMoVjXY2cOhPw/obc2vZQSy
         k42QdU4uTiOwLCWOkvXkSF34ZR+UT2QFZq9DtNDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Davis <afd@ti.com>,
        Nishanth Menon <nm@ti.com>, Bryan Brattlof <bb@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/885] arm64: dts: ti: k3-am62: Enable SPI nodes at the board level
Date:   Tue,  7 Mar 2023 17:49:26 +0100
Message-Id: <20230307170003.059725131@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Davis <afd@ti.com>

[ Upstream commit 361e8b7144405b78bd37cc3e9b2d23fc2e2ed6d5 ]

SPI nodes defined in the top-level AM62x SoC dtsi files are incomplete
and will not be functional unless they are extended with pinmux
information.

As the pinmux is only known at the board integration level, these
nodes should only be enabled when provided with this information.

Disable the SPI nodes in the dtsi files and only enable the ones that
are actually pinned out on a given board.

Signed-off-by: Andrew Davis <afd@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20221018211533.21335-4-afd@ti.com
Stable-dep-of: 6be5d8e5d180 ("arm64: dts: ti: k3-am62-main: Fix clocks for McSPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 3 +++
 arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi  | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
index 03660476364f3..27b4034d0db2e 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -307,6 +307,7 @@ main_spi0: spi@20100000 {
 		#size-cells = <0>;
 		power-domains = <&k3_pds 141 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 172 0>;
+		status = "disabled";
 	};
 
 	main_spi1: spi@20110000 {
@@ -317,6 +318,7 @@ main_spi1: spi@20110000 {
 		#size-cells = <0>;
 		power-domains = <&k3_pds 142 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 173 0>;
+		status = "disabled";
 	};
 
 	main_spi2: spi@20120000 {
@@ -327,6 +329,7 @@ main_spi2: spi@20120000 {
 		#size-cells = <0>;
 		power-domains = <&k3_pds 143 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 174 0>;
+		status = "disabled";
 	};
 
 	main_gpio_intr: interrupt-controller@a00000 {
diff --git a/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
index f56c803560f26..df2d8f36a31bd 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
@@ -42,6 +42,7 @@ mcu_spi0: spi@4b00000 {
 		#size-cells = <0>;
 		power-domains = <&k3_pds 147 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 147 0>;
+		status = "disabled";
 	};
 
 	mcu_spi1: spi@4b10000 {
@@ -52,6 +53,7 @@ mcu_spi1: spi@4b10000 {
 		#size-cells = <0>;
 		power-domains = <&k3_pds 148 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 148 0>;
+		status = "disabled";
 	};
 
 	mcu_gpio_intr: interrupt-controller@4210000 {
-- 
2.39.2



