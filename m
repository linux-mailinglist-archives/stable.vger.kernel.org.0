Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B27B60480C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiJSNsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbiJSNrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:47:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03153895D6;
        Wed, 19 Oct 2022 06:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACAC2B8241F;
        Wed, 19 Oct 2022 08:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218C6C433D6;
        Wed, 19 Oct 2022 08:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169847;
        bh=bYETwzBYvYBK+ZkJLVh9pj7tY31tMnUd7N/uOtigN4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3oVgBI3Ic0y9JZDTtu7fQG9zbjbOPyMSMdHckY0WMSsAnk4wVdIzgUJaowpkViX8
         upc3I56yd2Zjn8FPYPipZPHO929bhs4+i1B6/gjcxKNae4ipYuxlzU6JZhblu0HThP
         iKfyrtO4Qc568NepeBvvkWolXInwE7WQcvzST4t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 431/862] arm64: dts: qcom: sa8295p-adp: disallow regulator mode switches
Date:   Wed, 19 Oct 2022 10:28:38 +0200
Message-Id: <20221019083309.012193920@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 2a6164cef63cae77edbd9deef844b1774886fcb7 ]

Do not allow the RPMh regulators to switch to low-power mode with an
exception for the UFS regulators (l3c, l6c, l10c and l17c) as UFS
supports an idle mode.

This specifically avoids having regulators be but in low-power mode when
only some consumers specify loads while the actual total load really
warrants high-power mode.

Fixes: 519183af39b2 ("arm64: dts: qcom: add SA8540P and ADP")
Link: https://lore.kernel.org/all/YtkrDcjTGhpaU1e0@hovoldconsulting.com
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220803121942.30236-4-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8295p-adp.dts | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8295p-adp.dts b/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
index 9398f0349944..ca5f5ad32ce5 100644
--- a/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8295p-adp.dts
@@ -35,7 +35,6 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1208000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l5a: ldo5 {
@@ -43,7 +42,6 @@
 			regulator-min-microvolt = <912000>;
 			regulator-max-microvolt = <912000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l7a: ldo7 {
@@ -51,7 +49,6 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l13a: ldo13 {
@@ -59,7 +56,6 @@
 			regulator-min-microvolt = <3072000>;
 			regulator-max-microvolt = <3072000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 	};
 
@@ -72,7 +68,6 @@
 			regulator-min-microvolt = <912000>;
 			regulator-max-microvolt = <912000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l2c: ldo2 {
@@ -80,7 +75,6 @@
 			regulator-min-microvolt = <3072000>;
 			regulator-max-microvolt = <3072000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l3c: ldo3 {
@@ -96,7 +90,6 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1208000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l6c: ldo6 {
@@ -112,7 +105,6 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l10c: ldo10 {
@@ -141,7 +133,6 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l7g: ldo7 {
@@ -149,7 +140,6 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 
 		vreg_l8g: ldo8 {
@@ -157,7 +147,6 @@
 			regulator-min-microvolt = <880000>;
 			regulator-max-microvolt = <880000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-allow-set-load;
 		};
 	};
 };
-- 
2.35.1



