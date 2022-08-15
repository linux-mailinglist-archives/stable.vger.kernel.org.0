Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B5259419B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346909AbiHOUqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344556AbiHOUpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:45:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A43B69FA;
        Mon, 15 Aug 2022 12:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66583601BF;
        Mon, 15 Aug 2022 19:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D504C433D6;
        Mon, 15 Aug 2022 19:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590509;
        bh=RyfyMD2avYPrcXzgnjWluHibnunGgUa10wADbejMdW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDB6zkXY8xoFsHZ12BT3WO2/nGU53PVAvHNENiwkIQrmFEyMjrAhuTa7xUZj2xvR2
         nwQydnPJrqF9BIxNkZ3NbyRlJzXMyRrHNABhRtW5AjRSzV30nu1YYTvlPH8kVjoxYF
         8+wqhO5pG8kJGZelSvoVwm1RpIVeThqPTqZ574Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0282/1095] arm64: dts: qcom: msm8998: Make regulator voltages multiple of step-size
Date:   Mon, 15 Aug 2022 19:54:41 +0200
Message-Id: <20220815180441.446306699@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 2aa54fa87cca1fa43870a9caf4fcce00eb087fa5 ]

These voltages are not a multiple of the given step-size 8000 (with base
voltage 1664000) in pm8998_pldo, resulting in PLDO regulators l18 and
l22 failing to validate and in turn not probing the rpm-pm8998-regulator
driver:

    l18: unsupportable voltage constraints 2856000-2848000uV
    qcom_rpm_smd_regulator rpm-glink:rpm-requests:pm8998-regulators: l18: devm_regulator_register() failed, ret=-22

Round the voltages down for the sake of erring on the safe side, leaving
a comment in place to document this discrepancy wrt downstream sources.

Fixes: 390883af89d2 ("arm64: dts: qcom: msm8998: Introduce support for Sony Yoshino platform")
Reported-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220507153627.1478268-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom/msm8998-sony-xperia-yoshino-poplar.dts    | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino-poplar.dts b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino-poplar.dts
index 4a1f98a21031..c21333aa73c2 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino-poplar.dts
+++ b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino-poplar.dts
@@ -26,11 +26,13 @@ &lab {
 };
 
 &vreg_l18a_2p85 {
-	regulator-min-microvolt = <2850000>;
-	regulator-max-microvolt = <2850000>;
+	/* Note: Round-down from 2850000 to be a multiple of PLDO step-size 8000 */
+	regulator-min-microvolt = <2848000>;
+	regulator-max-microvolt = <2848000>;
 };
 
 &vreg_l22a_2p85 {
-	regulator-min-microvolt = <2700000>;
-	regulator-max-microvolt = <2700000>;
+	/* Note: Round-down from 2700000 to be a multiple of PLDO step-size 8000 */
+	regulator-min-microvolt = <2696000>;
+	regulator-max-microvolt = <2696000>;
 };
-- 
2.35.1



