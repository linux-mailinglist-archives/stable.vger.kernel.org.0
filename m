Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8396088CE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiJVIXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbiJVIVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:21:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FC72DCB1E;
        Sat, 22 Oct 2022 00:58:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 131FF60B93;
        Sat, 22 Oct 2022 07:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B48CC433D6;
        Sat, 22 Oct 2022 07:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425536;
        bh=EToABdKvy4XhxuhBiW5VUN7zQrDrFjx5hkuwfUdi6NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kBGb4nTkxl4d/UgXuCpISumNps+WFsGrCHW2MhMPZwwHu/gwgeSqsGAZ3MfND6+i
         bbqnIId8ORYe8azs7c6fm3mrcVq/+mYWv1fey78dRmWdCpEugcdIsRgVYq9akuF1vP
         fWxvn9ddn2wzXoJGlCAVXUNef+mLYYuELH1WLp1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Knecht <vincent.knecht@mailoo.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 534/717] thermal/drivers/qcom/tsens-v0_1: Fix MSM8939 fourth sensor hw_id
Date:   Sat, 22 Oct 2022 09:26:53 +0200
Message-Id: <20221022072521.941039343@linuxfoundation.org>
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

From: Vincent Knecht <vincent.knecht@mailoo.org>

[ Upstream commit b0c883e900702f408d62cf92b0ef01303ed69be9 ]

Reading temperature from this sensor fails with 'Invalid argument'.

Looking at old vendor dts [1], its hw_id should be 3 instead of 4.
Change this hw_id accordingly.

[1] https://github.com/msm8916-mainline/android_kernel_qcom_msm8916/blob/master/arch/arm/boot/dts/qcom/msm8939-common.dtsi#L511

Fixes: 332bc8ebab2c ("thermal: qcom: tsens-v0_1: Add support for MSM8939")
Signed-off-by: Vincent Knecht <vincent.knecht@mailoo.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20220811105014.7194-1-vincent.knecht@mailoo.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v0_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index f136cb350238..327f37202c69 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -604,7 +604,7 @@ static const struct tsens_ops ops_8939 = {
 struct tsens_plat_data data_8939 = {
 	.num_sensors	= 10,
 	.ops		= &ops_8939,
-	.hw_ids		= (unsigned int []){ 0, 1, 2, 4, 5, 6, 7, 8, 9, 10 },
+	.hw_ids		= (unsigned int []){ 0, 1, 2, 3, 5, 6, 7, 8, 9, 10 },
 
 	.feat		= &tsens_v0_1_feat,
 	.fields	= tsens_v0_1_regfields,
-- 
2.35.1



