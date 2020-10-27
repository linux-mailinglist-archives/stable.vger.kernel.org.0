Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F129B550
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794237AbgJ0PKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794233AbgJ0PKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 889CD206F4;
        Tue, 27 Oct 2020 15:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811442;
        bh=datDmBA4U7YZmVzQlAmkqlro81PjwMPIAx8NNhAHkx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2IzVAbZ6xCbLda2D6RQxgCpRDY4pz83BD4oGCSu4zJLlW3BXVKqp7qkPqccgIkdI
         143j52hzHjViNe25MFVifSKzGQ2ztQJplutkMQVmWFGHEfzEA4era0WZyOuZghtc/z
         IVeCG3yMQSgrah/zS47biaVZOLDDt1p5qnkblTF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 495/633] arm64: dts: qcom: msm8916: Remove one more thermal trip point unit name
Date:   Tue, 27 Oct 2020 14:53:58 +0100
Message-Id: <20201027135545.961091707@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit e6859ae8603c5946b8f3ecbd9b4f02b72955b9d0 ]

Commit fe2aff0c574d2 ("arm64: dts: qcom: msm8916: remove unit name for thermal trip points")
removed the unit names for most of the thermal trip points defined
in msm8916.dtsi, but missed to update the one for cpu0_1-thermal.

So why wasn't this spotted by "make dtbs_check"? Apparently, the name
of the thermal zone is already invalid: thermal-zones.yaml specifies
a regex of ^[a-zA-Z][a-zA-Z0-9\\-]{1,12}-thermal$, so it is not allowed
to contain underscores. Therefore the thermal zone was never verified
using the DTB schema.

After replacing the underscore in the thermal zone name, the warning
shows up:

    apq8016-sbc.dt.yaml: thermal-zones: cpu0-1-thermal:trips: 'trip-point@0'
    does not match any of the regexes: '^[a-zA-Z][a-zA-Z0-9\\-_]{0,63}$', 'pinctrl-[0-9]+'

Fix up the thermal zone names and remove the unit name for the trip point.

Cc: Amit Kucheria <amit.kucheria@linaro.org>
Fixes: fe2aff0c574d2 ("arm64: dts: qcom: msm8916: remove unit name for thermal trip points")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200915071221.72895-3-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 32bd140ac9fd4..729d36ff2e247 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -228,14 +228,14 @@ pmu {
 	};
 
 	thermal-zones {
-		cpu0_1-thermal {
+		cpu0-1-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 
 			thermal-sensors = <&tsens 5>;
 
 			trips {
-				cpu0_1_alert0: trip-point@0 {
+				cpu0_1_alert0: trip-point0 {
 					temperature = <75000>;
 					hysteresis = <2000>;
 					type = "passive";
@@ -258,7 +258,7 @@ map0 {
 			};
 		};
 
-		cpu2_3-thermal {
+		cpu2-3-thermal {
 			polling-delay-passive = <250>;
 			polling-delay = <1000>;
 
-- 
2.25.1



