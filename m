Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052446AE889
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCGRQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCGRQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F70795BD9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B72C6150C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158A2C433EF;
        Tue,  7 Mar 2023 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209129;
        bh=/K5ExP55nsjH99K+ihHdd2SjuSkiFQDpejkD0YprdGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXsBiWuL9nXXIT4V3NNJEtgcZpIK8KkaTKiBg2o8A2ol8uyXMRduvIbaJaEN6eKs1
         DCU4nNzNU81mXXiWcQGKqGpDRARcnUztRJ0zF12biV8/mt/R/8mTqY0nhhz3gTWkKx
         dLJZ5Vf11q3OvV0iRZAGeMBLnqm2yRE2zrMA+ScQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Vorel <pvorel@suse.cz>,
        Jamie Douglass <jamiemdouglass@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0118/1001] arm64: dts: qcom: msm8992-lg-bullhead: Enable regulators
Date:   Tue,  7 Mar 2023 17:48:10 +0100
Message-Id: <20230307170027.228751930@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <pvorel@suse.cz>

[ Upstream commit 2866527093ddbc6356bb31f560f0b4b4decf3e2e ]

Enable pm8994_s1, pm8994_l{26,29,30,32} regulators.
Use values from downstream kernel on bullhead rev 1.01.

NOTE: downstream kernel on angler rev 1.01 differences:
* pm8994_l29: regulator-min-microvolt = <2700000>
* pm8994_l{20,28,31}: use regulator-boot-on

Verification:
[    1.832460] s1: Bringing 0uV into 1025000-1025000uV
...
[    2.057667] l26: Bringing 0uV into 987500-987500uV
...
[    2.075722] l29: Bringing 0uV into 2800000-2800000uV
[    2.076604] l30: Bringing 0uV into 1800000-1800000uV
[    2.082431] l31: Bringing 0uV into 1262500-1262500uV
[    2.095767] l32: Bringing 0uV into 1800000-1800000uV

Fixes: f3b2c99e73be ("arm64: dts: Enable onboard SDHCI on msm8992")
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Jamie Douglass <jamiemdouglass@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230203100952.13857-1-pvorel@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/msm8992-lg-bullhead.dtsi    | 32 ++++++-------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index cdd796040703c..cd77dcb558722 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -94,8 +94,8 @@ pm8994_regulators: regulators-0 {
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
 		pm8994_s1: s1 {
-			regulator-min-microvolt = <800000>;
-			regulator-max-microvolt = <800000>;
+			regulator-min-microvolt = <1025000>;
+			regulator-max-microvolt = <1025000>;
 		};
 
 		pm8994_s2: s2 {
@@ -251,11 +251,8 @@ pm8994_l25: l25 {
 		};
 
 		pm8994_l26: l26 {
-			/*
-			 * TODO: value from downstream
-			 * regulator-min-microvolt = <987500>;
-			 * fails to apply
-			 */
+			regulator-min-microvolt = <987500>;
+			regulator-max-microvolt = <987500>;
 		};
 
 		pm8994_l27: l27 {
@@ -269,19 +266,13 @@ pm8994_l28: l28 {
 		};
 
 		pm8994_l29: l29 {
-			/*
-			 * TODO: Unsupported voltage range.
-			 * regulator-min-microvolt = <2800000>;
-			 * regulator-max-microvolt = <2800000>;
-			 */
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
 		};
 
 		pm8994_l30: l30 {
-			/*
-			 * TODO: get this verified
-			 * regulator-min-microvolt = <1800000>;
-			 * regulator-max-microvolt = <1800000>;
-			 */
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
 
 		pm8994_l31: l31 {
@@ -290,11 +281,8 @@ pm8994_l31: l31 {
 		};
 
 		pm8994_l32: l32 {
-			/*
-			 * TODO: get this verified
-			 * regulator-min-microvolt = <1800000>;
-			 * regulator-max-microvolt = <1800000>;
-			 */
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
 	};
 
-- 
2.39.2



