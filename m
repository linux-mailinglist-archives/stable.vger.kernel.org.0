Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E23541575
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357732AbiFGUgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377715AbiFGUeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762601E7165;
        Tue,  7 Jun 2022 11:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF30EB8237C;
        Tue,  7 Jun 2022 18:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA6DC385A2;
        Tue,  7 Jun 2022 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626942;
        bh=zbZoZDXyPQtH/CA9+JLIhXQbldowgqpgV7bnTEcHvuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjToTmEjigegRIkNsr4AvH1l66oagIG+h4XL0M95H7Vj6cpxwK2Xe6eMlM5E2LDuh
         0IjSxA1+Zwuz0kYpSLgZq83KNUW9K4R2zXOJKKf+qRHjI6ceY01xZ0gNjK30sU3LYp
         yXYz0v7IxH80JwdRhpaHS6HWw2ckzMFPcENrI1Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 519/772] arm64: dts: marvell: espressobin-ultra: fix SPI-NOR config
Date:   Tue,  7 Jun 2022 19:01:51 +0200
Message-Id: <20220607165004.271776655@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 5202f4c3816b42e989f9cad49a73c7e88fba89f4 ]

SPI config for the SPI-NOR is incorrect and completely breaking
reading/writing to the onboard SPI-NOR.

SPI-NOR is connected in the single(x1) IO mode and not in the quad
(x4) mode.
Also, there is no need to override the max frequency from the DTSI
as the mx25u3235f that is used supports 104Mhz.

Fixes: 3404fe15a60f ("arm64: dts: marvell: add DT for ESPRESSObin-Ultra")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-espressobin-ultra.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-ultra.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-ultra.dts
index c5eb3604dd5b..610ff6f385c7 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-ultra.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin-ultra.dts
@@ -71,10 +71,6 @@
 
 &spi0 {
 	flash@0 {
-		spi-max-frequency = <108000000>;
-		spi-rx-bus-width = <4>;
-		spi-tx-bus-width = <4>;
-
 		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
-- 
2.35.1



