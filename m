Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33E5593B40
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344429AbiHOUcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347702AbiHOUbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:31:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA6EA5C79;
        Mon, 15 Aug 2022 12:04:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 549CFB81104;
        Mon, 15 Aug 2022 19:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BA4C433D6;
        Mon, 15 Aug 2022 19:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590282;
        bh=tJAnO42wOvjfzA6oc3W60FsYJ9qlzwG5YhKzZ2eZRWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+4CLn8xKJiMuyGmrP+jK4dMPitMTOUZcxBrdh7NJHxLCRgBXusH8rdTzG7pIXtAS
         XBGK8g05jNJKIC6U4sYImTenO6Zd5x4gTVw8+wSd41Th3iI1yN8/04XELBre6MyUZq
         Q23ETHr5Xg/cRud9NMnRqXHHv5paXkb/b8f/OG/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0211/1095] arm64: dts: qcom: sdm845-akatsuki: Round down l22a regulator voltage
Date:   Mon, 15 Aug 2022 19:53:30 +0200
Message-Id: <20220815180438.392245088@linuxfoundation.org>
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

[ Upstream commit 4148a9eeb15152865d60b0913d96beb7ca166f9a ]

2700000 is not a multiple of pmic4_pldo's step size of 8000 (with base
voltage 1664000), resulting in pm8998-rpmh-regulators not probing.  Just
as we did with MSM8998's Sony Yoshino Poplar [1], round the voltages
down to err on the cautious side and leave a comment in place to
document this discrepancy wrt downstream sources.

[1]: https://lore.kernel.org/linux-arm-msm/20220507153627.1478268-1-marijn.suijten@somainline.org/

Fixes: 30a7f99befc6 ("arm64: dts: qcom: Add support for SONY Xperia XZ2 / XZ2C / XZ3 (Tama platform)")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220620211212.269956-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/qcom/sdm845-sony-xperia-tama-akatsuki.dts | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama-akatsuki.dts b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama-akatsuki.dts
index 8a0d94e7f598..2f5e12deaada 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama-akatsuki.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama-akatsuki.dts
@@ -19,8 +19,9 @@ &vreg_l14a_1p8 {
 };
 
 &vreg_l22a_2p8 {
-	regulator-min-microvolt = <2700000>;
-	regulator-max-microvolt = <2700000>;
+	/* Note: Round-down from 2700000 to be a multiple of PLDO step-size 8000 */
+	regulator-min-microvolt = <2696000>;
+	regulator-max-microvolt = <2696000>;
 };
 
 &vreg_l28a_2p8 {
-- 
2.35.1



