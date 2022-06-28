Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98E55D7EA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbiF1CYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244020AbiF1CXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:23:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71F724BE3;
        Mon, 27 Jun 2022 19:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FA37B818E4;
        Tue, 28 Jun 2022 02:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A380C34115;
        Tue, 28 Jun 2022 02:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382967;
        bh=1AZ9E++Vb3N93HgDXsC4h5TUHskZvX7imfTPJbNKftM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNk3ilbskrUnRXD59VzL4Ta4WVZEKO6CLWsK2Ekg/srYEocEVbGfq2NyWj/wwzHUo
         BXUGgP6iaGPwWvXrKzyI2/9bUVJki07pZI2tghT0ATIWVXeXv5f3l2lhJA2ESEEzHP
         aGPyIGL6noPmbyJQGhObgphS1GVZ216ojw5WdNqxc5fE9j/ALsmGFTZaqbVjdyYoGk
         JAqh2hU7orYcfbMfSit3W5uGh2EQ8ngO70mFV1HFU8HtsYzXf1Fo+/rDZkvKXQbZU6
         Ry8R2hHjlsPPxll+WqAYl/kiQMtZbLT5V2EMBXCiOg1WxoCOrYtfOGOx/QJKD2s3ZJ
         fD2MTpK4v9moA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, lgirdwood@gmail.com,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/34] regulator: qcom_smd: correct MP5496 ranges
Date:   Mon, 27 Jun 2022 22:22:10 -0400
Message-Id: <20220628022241.595835-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 122e951eb8045338089b086c8bd9b0b9afb04a92 ]

Currently set MP5496 Buck and LDO ranges dont match its datasheet[1].
According to the datasheet:
Buck range is 0.6-2.1875V with a 12.5mV step
LDO range is 0.8-3.975V with a 25mV step.

So, correct the ranges according to the datasheet[1].

[1] https://www.monolithicpower.com/en/documentview/productdocument/index/version/2/document_type/Datasheet/lang/en/sku/MP5496GR/document_id/6906/

Signed-off-by: Robert Marko <robimarko@gmail.com>
Link: https://lore.kernel.org/r/20220604193300.125758-2-robimarko@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_smd-regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/qcom_smd-regulator.c b/drivers/regulator/qcom_smd-regulator.c
index 05d227f9d2f2..94c40d6e8930 100644
--- a/drivers/regulator/qcom_smd-regulator.c
+++ b/drivers/regulator/qcom_smd-regulator.c
@@ -679,19 +679,19 @@ static const struct regulator_desc pms405_pldo600 = {
 
 static const struct regulator_desc mp5496_smpa2 = {
 	.linear_ranges = (struct linear_range[]) {
-		REGULATOR_LINEAR_RANGE(725000, 0, 27, 12500),
+		REGULATOR_LINEAR_RANGE(600000, 0, 127, 12500),
 	},
 	.n_linear_ranges = 1,
-	.n_voltages = 28,
+	.n_voltages = 128,
 	.ops = &rpm_mp5496_ops,
 };
 
 static const struct regulator_desc mp5496_ldoa2 = {
 	.linear_ranges = (struct linear_range[]) {
-		REGULATOR_LINEAR_RANGE(1800000, 0, 60, 25000),
+		REGULATOR_LINEAR_RANGE(800000, 0, 127, 25000),
 	},
 	.n_linear_ranges = 1,
-	.n_voltages = 61,
+	.n_voltages = 128,
 	.ops = &rpm_mp5496_ops,
 };
 
-- 
2.35.1

