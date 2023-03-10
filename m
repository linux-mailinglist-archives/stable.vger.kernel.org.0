Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0216B478C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjCJOvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbjCJOvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:51:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD528E6C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D736618B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CB0C433A1;
        Fri, 10 Mar 2023 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459696;
        bh=OUAL9pusy9iFSPS/KMrr3d0f2zqCmiBvzMSHY6xKqpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwdDCPcpGOY0bQS7TYW9aoj+KDp0Hk2IxV0MDAPcZPu7gHucrZ2oMmuyrTDhj2m6h
         vTXD0AM3UELzw6avHMFCKaKWMpV0qJ5fJPdz7H4waGFE4XbS3W38q305wQQ/b4ezZb
         uK4LMeV0Pg7I/FhLYnJ1sRCZAUru2y9WW9Q6XC7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/529] thermal/drivers/qcom/tsens_v1: Enable sensor 3 on MSM8976
Date:   Fri, 10 Mar 2023 14:33:45 +0100
Message-Id: <20230310133808.779214543@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 007d81a4519f04fa5ced5e9e28bf70cd753c398d ]

The sensor *is* in fact used and does report temperature.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Acked-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210225213119.116550-1-konrad.dybcio@somainline.org
Stable-dep-of: a7d3006be5ca ("thermal/drivers/tsens: Sort out msm8976 vs msm8956 data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens-v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/qcom/tsens-v1.c b/drivers/thermal/qcom/tsens-v1.c
index bff50f3b9d0b6..13624263f1dfe 100644
--- a/drivers/thermal/qcom/tsens-v1.c
+++ b/drivers/thermal/qcom/tsens-v1.c
@@ -375,11 +375,11 @@ static const struct tsens_ops ops_8976 = {
 	.get_temp	= get_temp_tsens_valid,
 };
 
-/* Valid for both MSM8956 and MSM8976. Sensor ID 3 is unused. */
+/* Valid for both MSM8956 and MSM8976. */
 struct tsens_plat_data data_8976 = {
 	.num_sensors	= 11,
 	.ops		= &ops_8976,
-	.hw_ids		= (unsigned int[]){0, 1, 2, 4, 5, 6, 7, 8, 9, 10},
+	.hw_ids		= (unsigned int[]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
 	.feat		= &tsens_v1_feat,
 	.fields		= tsens_v1_regfields,
 };
-- 
2.39.2



