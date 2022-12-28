Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D7F6583B0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiL1QuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbiL1Qtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:49:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1604C1F2CD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:45:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA9F6157C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F66C433D2;
        Wed, 28 Dec 2022 16:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245901;
        bh=Tb7LrijgU4dstKVAnIW6zaqJrgtkhNneSzCOxpsYAHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RivxoTAPQ2Gh1ZZNOSNoDkr8P3RYjkOMx/+fsN7FLiwWA79CoXsnBNmrtINTdb3v9
         1X5P3ItiKD7KG3s/eGZsCCIsQWmi5oJR4LsG9Ox8MdKgokdGbZfPv3f746T0Mn4yqt
         PrGcAXAyXn4XdHpM8GfHGacsI64AAVqNkHLvZTdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0944/1146] arm64: dts: qcom: sm6350: Add apps_smmu with streamID to SDHCI 1/2 nodes
Date:   Wed, 28 Dec 2022 15:41:23 +0100
Message-Id: <20221228144355.957397060@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 7372b944a6ba5ac86628eaacc89ed4f103435cb9 ]

When enabling the APPS SMMU the mainline driver reconfigures the SMMU
from its bootloader configuration, losing the stream mapping for (among
which) the SDHCI hardware and breaking its ADMA feature.  This feature
can be disabled with:

    sdhci.debug_quirks=0x40

But it is of course desired to have this feature enabled and working
through the SMMU.

Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221030073232.22726-11-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 3a315280c34a..9d3da44758d9 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -485,6 +485,7 @@ sdhc_1: mmc@7c4000 {
 			interrupts = <GIC_SPI 641 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 644 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "hc_irq", "pwr_irq";
+			iommus = <&apps_smmu 0x60 0x0>;
 
 			clocks = <&gcc GCC_SDCC1_AHB_CLK>,
 				 <&gcc GCC_SDCC1_APPS_CLK>,
@@ -1063,6 +1064,7 @@ sdhc_2: mmc@8804000 {
 			interrupts = <GIC_SPI 204 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 222 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "hc_irq", "pwr_irq";
+			iommus = <&apps_smmu 0x560 0x0>;
 
 			clocks = <&gcc GCC_SDCC2_AHB_CLK>,
 				 <&gcc GCC_SDCC2_APPS_CLK>,
-- 
2.35.1



