Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8451657CD1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiL1PgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbiL1PgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:36:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E160140DA
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0E3CB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6D7C433D2;
        Wed, 28 Dec 2022 15:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241777;
        bh=ezCmNJaRnXxW8eiBtplTqFHw8mrhOotUHAKRMgMxQuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMOA84IDz7sZ6ggSSNKDa7ALaR0XO7AJh+cyV+OFhqp7y5fnCR7EjDvJr0i7movms
         BSHtksL1I1BO7LGvV3qg9+OAR5EWbULn2LTKoMW13BJjng/hgcFB7fLZBw/14KKMWI
         CueArpV85OPalHV4GNpqXBnPjJ+9lxCnCriMfTvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0326/1073] regulator: qcom-rpmh: Fix PMR735a S3 regulator spec
Date:   Wed, 28 Dec 2022 15:31:54 +0100
Message-Id: <20221228144336.861712370@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit dd801b2265c81bf0c8b0b4b8f7c1e7bfed078403 ]

PMR735a has a wider range than previously defined. Fix it.

Fixes: c4e5aa3dbee5 ("regulator: qcom-rpmh: Add PM7325/PMR735A regulator support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221110210706.80301-1-konrad.dybcio@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 561de6b2e6e3..5839e4732336 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -1188,7 +1188,7 @@ static const struct rpmh_vreg_init_data pm7325_vreg_data[] = {
 static const struct rpmh_vreg_init_data pmr735a_vreg_data[] = {
 	RPMH_VREG("smps1",  "smp%s1",  &pmic5_ftsmps520, "vdd-s1"),
 	RPMH_VREG("smps2",  "smp%s2",  &pmic5_ftsmps520, "vdd-s2"),
-	RPMH_VREG("smps3",  "smp%s3",  &pmic5_hfsmps510, "vdd-s3"),
+	RPMH_VREG("smps3",  "smp%s3",  &pmic5_hfsmps515, "vdd-s3"),
 	RPMH_VREG("ldo1",   "ldo%s1",  &pmic5_nldo,      "vdd-l1-l2"),
 	RPMH_VREG("ldo2",   "ldo%s2",  &pmic5_nldo,      "vdd-l1-l2"),
 	RPMH_VREG("ldo3",   "ldo%s3",  &pmic5_nldo,      "vdd-l3"),
-- 
2.35.1



