Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3106CC25F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjC1Ooo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjC1Ool (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:44:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9083CD318
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E561CE1DA0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE31C433EF;
        Tue, 28 Mar 2023 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014671;
        bh=io/iffRCJyxQfqu+eZ5yV/8+NO4GioKeLTr2HDJ4LxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM+Pp/jD2qB8Gts//dm8phpZHiR4oAxKgnAKZlb8cIEAydTdhmt7rURKF7abtHG0e
         hpo89tPlH4dnq1IPQj1TOhQOXMtNBw29TQ9DQDJRWx8ZTmo/h+4RHN859aahWa/K5p
         9tZyvqikbt04xkQzSjbZrkRmLU/ydibzACIkfUsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steev Klimaszewski <steev@kali.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 011/240] arm64: dts: qcom: sc8280xp: Add label property to vadc channel nodes
Date:   Tue, 28 Mar 2023 16:39:34 +0200
Message-Id: <20230328142620.131077460@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 8013295662f55696e5953ef14c31ba03721adf8f ]

For uniquely identifying the vadc channels, label property has to be used.
The initial commit adding vadc support assumed that the driver will use the
unit address along with the node name to identify the channels. But this
assumption is now broken by,
commit 701c875aded8 ("iio: adc: qcom-spmi-adc5: Fix the channel name") that
stripped unit address from channel names. This results in probe failure of
the vadc driver:

[    8.380370] iio iio:device0: tried to double register : in_temp_pmic-die-temp_input
[    8.380383] qcom-spmi-adc5 c440000.spmi:pmic@0:adc@3100: Failed to register sysfs interfaces
[    8.380386] qcom-spmi-adc5: probe of c440000.spmi:pmic@0:adc@3100 failed with error -16

Hence, let's get rid of the assumption about drivers and rely on label
property to uniquely identify the channels.

The labels are derived from the schematics for each PMIC. For internal adc
channels such as die and xo, the PMIC names are used as a prefix.

Fixes: 7c0151347401 ("arm64: dts: qcom: sc8280xp-x13s: Add PM8280_{1/2} ADC_TM5 channels")
Fixes: 9d41cd17394a ("arm64: dts: qcom: sc8280xp-x13s: Add PMR735A VADC channel")
Fixes: 3375151a7185 ("arm64: dts: qcom: sc8280xp-x13s: Add PM8280_{1/2} VADC channels")
Fixes: 9a6b3042c533 ("arm64: dts: qcom: sc8280xp-x13s: Add PMK8280 VADC channels")
Reported-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230211052415.14581-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 568c6be1ceaae..a0eb1b3424778 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -425,75 +425,88 @@ &pmk8280_vadc {
 	pmic-die-temp@3 {
 		reg = <PMK8350_ADC7_DIE_TEMP>;
 		qcom,pre-scaling = <1 1>;
+		label = "pmk8350_die_temp";
 	};
 
 	xo-therm@44 {
 		reg = <PMK8350_ADC7_AMUX_THM1_100K_PU>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "pmk8350_xo_therm";
 	};
 
 	pmic-die-temp@103 {
 		reg = <PM8350_ADC7_DIE_TEMP(1)>;
 		qcom,pre-scaling = <1 1>;
+		label = "pmc8280_1_die_temp";
 	};
 
 	sys-therm@144 {
 		reg = <PM8350_ADC7_AMUX_THM1_100K_PU(1)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm1";
 	};
 
 	sys-therm@145 {
 		reg = <PM8350_ADC7_AMUX_THM2_100K_PU(1)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm2";
 	};
 
 	sys-therm@146 {
 		reg = <PM8350_ADC7_AMUX_THM3_100K_PU(1)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm3";
 	};
 
 	sys-therm@147 {
 		reg = <PM8350_ADC7_AMUX_THM4_100K_PU(1)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm4";
 	};
 
 	pmic-die-temp@303 {
 		reg = <PM8350_ADC7_DIE_TEMP(3)>;
 		qcom,pre-scaling = <1 1>;
+		label = "pmc8280_2_die_temp";
 	};
 
 	sys-therm@344 {
 		reg = <PM8350_ADC7_AMUX_THM1_100K_PU(3)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm5";
 	};
 
 	sys-therm@345 {
 		reg = <PM8350_ADC7_AMUX_THM2_100K_PU(3)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm6";
 	};
 
 	sys-therm@346 {
 		reg = <PM8350_ADC7_AMUX_THM3_100K_PU(3)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm7";
 	};
 
 	sys-therm@347 {
 		reg = <PM8350_ADC7_AMUX_THM4_100K_PU(3)>;
 		qcom,hw-settle-time = <200>;
 		qcom,ratiometric;
+		label = "sys_therm8";
 	};
 
 	pmic-die-temp@403 {
 		reg = <PMR735A_ADC7_DIE_TEMP>;
 		qcom,pre-scaling = <1 1>;
+		label = "pmr735a_die_temp";
 	};
 };
 
-- 
2.39.2



