Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16116085C2
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiJVHiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiJVHhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:37:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CE925CE05;
        Sat, 22 Oct 2022 00:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50115CE2C98;
        Sat, 22 Oct 2022 07:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3614CC433C1;
        Sat, 22 Oct 2022 07:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424149;
        bh=TJwrFLLzUDARRz227XFqeD/qM+dImWjLpczpwfOOLTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkNO2loy7xZSEZmtcFTyTKxH6jF5g3f9+lx/zNO2lV7TbFmlVfUVYBmnbRE3JdmQb
         MrTdsTCHfJQViDSDXeMGTNrDBEDYugISsNwjACEDhvAEDrMVLP4sdCfmHb4Uo4YLa0
         dlVgoGgvBcJlBw4tIwa+2IJo8cG6DrWMKFmIwnVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.19 043/717] arm64: dts: qcom: sdm845-mtp: correct ADC settle time
Date:   Sat, 22 Oct 2022 09:18:42 +0200
Message-Id: <20221022072422.734871840@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 209a04885ab5f76722a1671d0fbf0a5b4bccacec upstream.

The PMIC's VADC property for settle time is qcom,hw-settle-time, not
qcom,hw-settle-time-us.  The latter is used in PMIC's TM ADC.

  qcom/sdm845-mtp.dtb: pmic@0: adc@3100:adc-chan@4c: 'qcom,hw-settle-time-us' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: d5e12f3823ae ("arm64: dts: qcom: sdm845: mtp: Add vadc channels and thermal zones")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220828084341.112146-13-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
@@ -536,42 +536,42 @@
 		reg = <ADC5_XO_THERM_100K_PU>;
 		label = "xo_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@4d {
 		reg = <ADC5_AMUX_THM1_100K_PU>;
 		label = "msm_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@4f {
 		reg = <ADC5_AMUX_THM3_100K_PU>;
 		label = "pa_therm1";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@51 {
 		reg = <ADC5_AMUX_THM5_100K_PU>;
 		label = "quiet_therm";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@83 {
 		reg = <ADC5_VPH_PWR>;
 		label = "vph_pwr";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 
 	adc-chan@85 {
 		reg = <ADC5_VCOIN>;
 		label = "vcoin";
 		qcom,ratiometric;
-		qcom,hw-settle-time-us = <200>;
+		qcom,hw-settle-time = <200>;
 	};
 };
 


