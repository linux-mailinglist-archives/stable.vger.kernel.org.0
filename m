Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1D51157B
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiD0LIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiD0LHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:07:55 -0400
Received: from smtp110.ord1d.emailsrvr.com (smtp110.ord1d.emailsrvr.com [184.106.54.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A6E80BE3
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 04:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1651056874;
        bh=TWYQidF18CD3BHzOD5gTEys7gjZpmZbfQHDWi01K3ao=;
        h=From:To:Subject:Date:From;
        b=IpmFVq0oy0B6ns0kBEx3tQdWLuM4d0H6gsSCDvGqECmH+Zzy4TBTJxNFRIcH2On0L
         I5fPLHQ3Yuf3LWMVHElrwRNZs0w1Sc7uZGMzj+Blj5f+Nwcum6ux5cHYKW5fciDn/v
         fpTYlDG5Jt9FBo+9qIzP66ukMFo9v8mMnyQLGbzE=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp6.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 4FA86E00E0;
        Wed, 27 Apr 2022 06:54:33 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     stable@vger.kernel.org
Cc:     linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.15 2/2] ARM: dts: socfpga: change qspi to "intel,socfpga-qspi"
Date:   Wed, 27 Apr 2022 11:54:07 +0100
Message-Id: <20220427105407.40167-3-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427105407.40167-1-abbotti@mev.co.uk>
References: <20220427105407.40167-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 3bf3f977-eed8-458c-82a7-dc4c605c474d-3-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 36de991e93908f7ad5c2a0eac9c4ecf8b723fa4a upstream.

Because of commit 9cb2ff111712 ("spi: cadence-quadspi: Disable Auto-HW polling"),
which does a write to the CQSPI_REG_WR_COMPLETION_CTRL register
regardless of any condition. Well, the Cadence QuadSPI controller on
Intel's SoCFPGA platforms does not implement the
CQSPI_REG_WR_COMPLETION_CTRL register, thus a write to this register
results in a crash!

So starting with v5.16, I introduced the patch
98d948eb833 ("spi: cadence-quadspi: fix write completion support"),
which adds the dts compatible "intel,socfpga-qspi" that is specific for
versions that doesn't have the CQSPI_REG_WR_COMPLETION_CTRL register implemented.

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
[IA: submitted for linux-5.15.y]
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v3: revert back to "intel,socfpga-qspi"
v2: use both "cdns,qspi-nor" and "cdns,qspi-nor-0010"
---
 arch/arm/boot/dts/socfpga.dtsi                    | 2 +-
 arch/arm/boot/dts/socfpga_arria10.dtsi            | 2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi | 2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
index 0b021eef0b53..7c1d6423d7f8 100644
--- a/arch/arm/boot/dts/socfpga.dtsi
+++ b/arch/arm/boot/dts/socfpga.dtsi
@@ -782,7 +782,7 @@ ocram: sram@ffff0000 {
 		};
 
 		qspi: spi@ff705000 {
-			compatible = "cdns,qspi-nor";
+			compatible = "intel,socfpga-qspi", "cdns,qspi-nor";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0xff705000 0x1000>,
diff --git a/arch/arm/boot/dts/socfpga_arria10.dtsi b/arch/arm/boot/dts/socfpga_arria10.dtsi
index a574ea91d9d3..3ba431dfa8c9 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -756,7 +756,7 @@ usb0-ecc@ff8c8800 {
 		};
 
 		qspi: spi@ff809000 {
-			compatible = "cdns,qspi-nor";
+			compatible = "intel,socfpga-qspi", "cdns,qspi-nor";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0xff809000 0x100>,
diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
index d301ac0d406b..3ec301bd08a9 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
@@ -594,7 +594,7 @@ emac0-tx-ecc@ff8c0400 {
 		};
 
 		qspi: spi@ff8d2000 {
-			compatible = "cdns,qspi-nor";
+			compatible =  "intel,socfpga-qspi", "cdns,qspi-nor";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0xff8d2000 0x100>,
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
index de1e98c99ec5..f4270cf18996 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -628,7 +628,7 @@ sdmmca-ecc@ff8c8c00 {
 		};
 
 		qspi: spi@ff8d2000 {
-			compatible = "cdns,qspi-nor";
+			compatible = "intel,socfpga-qspi", "cdns,qspi-nor";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0xff8d2000 0x100>,
-- 
2.35.1

