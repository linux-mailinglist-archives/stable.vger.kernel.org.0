Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2455FB627
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiJKPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiJKO7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:59:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1433A0273;
        Tue, 11 Oct 2022 07:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24C55611EA;
        Tue, 11 Oct 2022 14:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C448EC433B5;
        Tue, 11 Oct 2022 14:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500049;
        bh=NVTvgu8e0e04JuGOEXD0ndBLhX9O5QdfCFAzWYx3Qe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2Uvmiey4PJ4HmkEJwhfZw9lmKFNImiBpHQUrfuMnwWivtgb+tMWOD2ZS/9YVDiu6
         peIFYsEMeDAZT9PVaBmFqbMrcx7A0EO3eZXPUVTF+VGo76abTKFu1BiNSgrejbwXIx
         deCmjdvEDXP/nbKN+fswNhzILFEYidzsDujNUot2bugZvj1GRMEuheQODnwOUYT3bI
         KjF+WnLCFMcPU1dtGJHbYcsTuAb+M2zNsEY/ddLVUXZ9sWO82u6GFeu48N2enKCbzQ
         cV2X4scA7olla7ek1l/6RqmWVFCLcw3dfz8K4AYmUvzh4TChpwVRJd99dHLbOK7Vrt
         itloqBd6HobIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 08/11] ARM: dts: imx6sx: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:53:55 -0400
Message-Id: <20221011145358.1624959-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145358.1624959-1-sashal@kernel.org>
References: <20221011145358.1624959-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 415432c008b2bce8138841356ba444631cabaa50 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index ae0728df542e..b9ab1118be30 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -167,12 +167,18 @@ soc {
 		ocram_s: sram@8f8000 {
 			compatible = "mmio-sram";
 			reg = <0x008f8000 0x4000>;
+			ranges = <0 0x008f8000 0x4000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SX_CLK_OCRAM_S>;
 		};
 
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SX_CLK_OCRAM>;
 		};
 
-- 
2.35.1

