Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB656AE82A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjCGRNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjCGRM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657F4EC68
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:07:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7538BB819AE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E8DC433D2;
        Tue,  7 Mar 2023 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208870;
        bh=QGb+Q50drtK3st0XGeJQ9VCA1+iXxAkzHhmOr/mysso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2B0u7T6Ntg6+8pF/ArAI7yhpbRLX8JqEzVKkylzUKovsQbOpaZ/SNquXB+JIxiJY
         vtVB1s9yKv+n6mfM9cTOFecCVadSuBVpIBuQgD3aM6JWGOIBS8Sd2972y3V8y2hYPd
         Eje7Yt2X55MlJ1BHEzevs8/+R9SdDNUCrNHrftGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0037/1001] arm64: dts: qcom: sc7280: correct SPMI bus address cells
Date:   Tue,  7 Mar 2023 17:46:49 +0100
Message-Id: <20230307170023.746027689@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 8da3786a91e56fe0c4aeb2c2209744474af6e517 ]

The SPMI bus uses two address cells and zero size cells (second reg
entry - SPMI_USID - is not the size):

  spmi@c440000: #address-cells:0:0: 2 was expected

Fixes: 14abf8dfe364 ("arm64: dts: qcom: sc7280: Add SPMI PMIC arbiter device for SC7280")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221213101921.47924-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 0adf13399e649..3bedd45e14afd 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -4246,8 +4246,8 @@ spmi_bus: spmi@c440000 {
 			interrupts-extended = <&pdc 1 IRQ_TYPE_LEVEL_HIGH>;
 			qcom,ee = <0>;
 			qcom,channel = <0>;
-			#address-cells = <1>;
-			#size-cells = <1>;
+			#address-cells = <2>;
+			#size-cells = <0>;
 			interrupt-controller;
 			#interrupt-cells = <4>;
 		};
-- 
2.39.2



