Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C756148E8
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiKALbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKALaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:30:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF580647F;
        Tue,  1 Nov 2022 04:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 867ADB81CCA;
        Tue,  1 Nov 2022 11:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7C1C433D7;
        Tue,  1 Nov 2022 11:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302162;
        bh=Vmo3ZHg1pN7KwuHV1CJhSuXf8BQVVmcDqJbW4/gHbJg=;
        h=From:To:Cc:Subject:Date:From;
        b=j+T/niV3QDtRdccCSwCxbIMAL3hyiS9Du2qjYKzOQ6SrGhNw0C9CKg7NkVrl0QjVf
         Kv8YANndLMWoIEAl/vp3rfDqyoNt3gVxGOwH1OfRNBn/sqHqYbSERabsxISB0QyaG/
         9y5AtPyQ593PQOht9Ggw6XC0hFBE6N980MFr25DZXTFLg7LjknUr9kxtnbSko2m8PF
         rqkwlyxNuYnQLuxKzZmNeW7MYfLLQmYQhRMx/QpiHpq4CeZx7/LacG8RKun0chnF8/
         dvLnpQ15ujW++RpexFuPKe/N/xwyjMCxvcE6EE9ar8ftfoT+LCkQvNQe+Uo0ZjLghm
         auS2qnp0UsQzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 01/19] media: rkisp1: Don't pass the quantization to rkisp1_csm_config()
Date:   Tue,  1 Nov 2022 07:29:01 -0400
Message-Id: <20221101112919.799868-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 711d91497e203b058cf0a08c0f7d41c04efbde76 ]

The rkisp1_csm_config() function takes a pointer to the rkisp1_params
structure which contains the quantization value. There's no need to pass
it separately to the function. Drop it from the function parameters.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-params.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
index 8fa5b0abf1f9..8461e88c1288 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
@@ -751,7 +751,7 @@ static void rkisp1_ie_enable(struct rkisp1_params *params, bool en)
 	}
 }
 
-static void rkisp1_csm_config(struct rkisp1_params *params, bool full_range)
+static void rkisp1_csm_config(struct rkisp1_params *params)
 {
 	static const u16 full_range_coeff[] = {
 		0x0026, 0x004b, 0x000f,
@@ -765,7 +765,7 @@ static void rkisp1_csm_config(struct rkisp1_params *params, bool full_range)
 	};
 	unsigned int i;
 
-	if (full_range) {
+	if (params->quantization == V4L2_QUANTIZATION_FULL_RANGE) {
 		for (i = 0; i < ARRAY_SIZE(full_range_coeff); i++)
 			rkisp1_write(params->rkisp1, full_range_coeff[i],
 				     RKISP1_CIF_ISP_CC_COEFF_0 + i * 4);
@@ -1235,11 +1235,7 @@ static void rkisp1_params_config_parameter(struct rkisp1_params *params)
 	rkisp1_param_set_bits(params, RKISP1_CIF_ISP_HIST_PROP,
 			      rkisp1_hst_params_default_config.mode);
 
-	/* set the  range */
-	if (params->quantization == V4L2_QUANTIZATION_FULL_RANGE)
-		rkisp1_csm_config(params, true);
-	else
-		rkisp1_csm_config(params, false);
+	rkisp1_csm_config(params);
 
 	spin_lock_irq(&params->config_lock);
 
-- 
2.35.1

