Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2F15EA63C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiIZMes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237021AbiIZMeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:34:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D1E6DF4;
        Mon, 26 Sep 2022 04:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59201B802BD;
        Mon, 26 Sep 2022 10:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601E3C433D6;
        Mon, 26 Sep 2022 10:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189141;
        bh=SgKUTz/NY4rxLAMButqiqiL0++jYccXz5Yp4u3aD/hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjgVi1Xh365gPDwNaEEdlXEWVozBdTuEIhA5g2iUEx6KJwCZ8u8LdWJBsyikqzqk3
         iEM3IDTXkDjqdb1apnzpMcuMCd8uhtjtmdcGbh5YbDWcJ4GgR3K+6H+/Y+fDL3bFZW
         9iGuJ4ZZAPh3ETuqjW4XK7KDBS6cajejSN1uSDmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 086/207] arm64: dts: imx8mm-verdin: extend pmic voltages
Date:   Mon, 26 Sep 2022 12:11:15 +0200
Message-Id: <20220926100810.436967508@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philippe Schenker <philippe.schenker@toradex.com>

[ Upstream commit b5a76cb38df779076a3cff624ce6a368d9bcf330 ]

Currently, we limited the voltages from the PMIC very strictly. This
causes an issue with one Toradex SKU that uses a consumer-grade chip
that is capable of going up to 1.8GHz at 1.00V.

Extend the ranges to min/max values of the SoC operating ranges (table
10) in the datasheet. Detailed explanation as follows:

BUCK2:
  - As already described above, the SKU with the consumer-grade chip
    needs a voltage of at least 1.00V. 1.05V is chosen now as this is
    listed as the maximum. Both industrial and consumer-grade chips have
    an absolute maximum rating of 1.15V which makes it still safe to put
    1.05V
  - Lower the regulator-min value to the smallest value allowed from the
    Quad-A53, 1.2GHz version of the SoC

BUCK3:
  - This regulator is used for SoC input voltages VDD_GPU, VDD_VPU and
    VDD_DRAM.
  - Use the smallest value of these three inputs as the regulator-min
  - Use the largest value of these three inputs as the regulator-max

LDO2:
  - This LDO is used for VDD_SNVS_0P8 SoC input voltage. As this has a
    single nominal input voltage just put this in the middle of 0.8V.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index c2d4da25482f..44b473494d0f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -359,8 +359,8 @@ reg_vdd_arm: BUCK2 {
 				nxp,dvs-standby-voltage = <850000>;
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-max-microvolt = <950000>;
-				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1050000>;
+				regulator-min-microvolt = <805000>;
 				regulator-name = "On-module +VDD_ARM (BUCK2)";
 				regulator-ramp-delay = <3125>;
 			};
@@ -368,8 +368,8 @@ reg_vdd_arm: BUCK2 {
 			reg_vdd_dram: BUCK3 {
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-max-microvolt = <950000>;
-				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1000000>;
+				regulator-min-microvolt = <805000>;
 				regulator-name = "On-module +VDD_GPU_VPU_DDR (BUCK3)";
 			};
 
@@ -408,7 +408,7 @@ reg_nvcc_snvs: LDO1 {
 			reg_vdd_snvs: LDO2 {
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-max-microvolt = <900000>;
+				regulator-max-microvolt = <800000>;
 				regulator-min-microvolt = <800000>;
 				regulator-name = "On-module +V0.8_SNVS (LDO2)";
 			};
-- 
2.35.1



