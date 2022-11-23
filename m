Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D13C6356A8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbiKWJbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237801AbiKWJbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89235BD7E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E368B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25CDC433C1;
        Wed, 23 Nov 2022 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195806;
        bh=Xhot2VfNAB4AkgKvs9OLpBqEMJ/DuE/cQX3zOo1+Ab4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCKwTniqYXK2zwFPR6pOFysAgqSs2kLkxhQV7QRyWewC0KX43EHsnvbfCKF/RaHFx
         uMd516Igog+mId7IupeoR05eMDpVoKJiUizHHCTSMkNuynYhOMnCgrnYqL5uSAsYYy
         LQ3st2v3eLMBHEIGVOjtmvVJGryLiWNzOHHaxido=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Douglas Anderson <dianders@chromium.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/181] arm64: dts: qcom: sa8155p-adp: Specify which LDO modes are allowed
Date:   Wed, 23 Nov 2022 09:50:01 +0100
Message-Id: <20221123084604.005025185@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit bd9f3dcf42d943b53190f99bcdbcfe98a56ac4cd ]

This board uses RPMH, specifies "regulator-allow-set-load" for LDOs,
but doesn't specify any modes with "regulator-allowed-modes".

Prior to commit efb0cb50c427 ("regulator: qcom-rpmh: Implement
get_optimum_mode(), not set_load()") the above meant that we were able
to set either LPM or HPM mode. After that commit (and fixes [1]) we'll
be stuck at the initial mode. Discussion of this has resulted in the
decision that the old dts files were wrong and should be fixed to
fully restore old functionality.

Let's re-enable the old functionality by fixing the dts.

NOTE: while here, let's also remove the nonsensical
"regulator-allow-set-load" on the fixed regulator "vreg_s4a_1p8".

[1] https://lore.kernel.org/r/20220824142229.RFT.v2.2.I6f77860e5cd98bf5c67208fa9edda4a08847c304@changeid

Fixes: 5b85e8f2225c ("arm64: dts: qcom: sa8155p-adp: Add base dts file")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220829094903.v2.1.Id59c32b560c4662d8b3697de2bd494d08d654806@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
index 5ae2ddc65f7e..56a789a5789e 100644
--- a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
@@ -43,7 +43,6 @@ vreg_s4a_1p8: smps4 {
 
 		regulator-always-on;
 		regulator-boot-on;
-		regulator-allow-set-load;
 
 		vin-supply = <&vreg_3p3>;
 	};
@@ -114,6 +113,9 @@ vreg_l5a_0p88: ldo5 {
 			regulator-max-microvolt = <880000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7a_1p8: ldo7 {
@@ -129,6 +131,9 @@ vreg_l10a_2p96: ldo10 {
 			regulator-max-microvolt = <2960000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l11a_0p8: ldo11 {
@@ -235,6 +240,9 @@ vreg_l5c_1p2: ldo5 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7c_1p8: ldo7 {
@@ -250,6 +258,9 @@ vreg_l8c_1p2: ldo8 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l10c_3p3: ldo10 {
-- 
2.35.1



