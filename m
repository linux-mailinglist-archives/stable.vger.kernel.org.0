Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17F54F3BF1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382203AbiDEMDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357971AbiDEK1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1D3C74B2;
        Tue,  5 Apr 2022 03:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36CC8617AC;
        Tue,  5 Apr 2022 10:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475E3C385A1;
        Tue,  5 Apr 2022 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153509;
        bh=ZRS2hcKHXOZ9Z/uxbsKNo77SLe2c5OqQQnovn31c8O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LK43r9KRkGwIZ/Ei+iEO+Zi/x9VAkPj4oJfNMZYHKt1kzUBy86GxfHJwS5P5BaORd
         POgu/6HY0nontQwe/8dbO0xMSgpCU6qpkLw/mLR2RK7SiKh8x27Bt6TJsl1L6Vvuc6
         YbuvBHWBKl8Ick7zjV36aak7rU5TW4lgZfCuN6Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/599] arm64: dts: qcom: sdm845: fix microphone bias properties and values
Date:   Tue,  5 Apr 2022 09:28:22 +0200
Message-Id: <20220405070305.030760308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 625c24460dbbc3b6c9a148c0a30f0830893fc909 ]

replace millivolt with correct microvolt and adjust value to
the minimal value allowed by documentation.

Found with `make qcom/sdm845-oneplus-fajita.dtb`.

Fixes:
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias1-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias2-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias3-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias4-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias1-millivolt', 'qcom,micbias2-millivolt', 'qcom,micbias3-millivolt', 'qcom,micbias4-millivolt' do not match any of the regexes: '^.*@[0-9a-f]+$', 'pinctrl-[0-9]+'

Fixes: 27ca1de07dc3 ("arm64: dts: qcom: sdm845: add slimbus nodes")

Signed-off-by: David Heidelberg <david@ixit.cz>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211213195105.114596-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index ea6e3a11e641..9beb3c34fcdb 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -3406,10 +3406,10 @@
 					#clock-cells = <0>;
 					clock-frequency = <9600000>;
 					clock-output-names = "mclk";
-					qcom,micbias1-millivolt = <1800>;
-					qcom,micbias2-millivolt = <1800>;
-					qcom,micbias3-millivolt = <1800>;
-					qcom,micbias4-millivolt = <1800>;
+					qcom,micbias1-microvolt = <1800000>;
+					qcom,micbias2-microvolt = <1800000>;
+					qcom,micbias3-microvolt = <1800000>;
+					qcom,micbias4-microvolt = <1800000>;
 
 					#address-cells = <1>;
 					#size-cells = <1>;
-- 
2.34.1



