Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71DC4F37AA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359428AbiDELTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349173AbiDEJtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0137679;
        Tue,  5 Apr 2022 02:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0A07CE1C6F;
        Tue,  5 Apr 2022 09:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76E1C385A1;
        Tue,  5 Apr 2022 09:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151725;
        bh=TtJ6sFR2YeP4tCJrB/dl20FNpSQJNjqdHrikirjH4Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dd8MFm9Fa3UdRjNvDojTbkBMJBIwvpFS3K8jzqWVF2Zcg1Hclhde/Ff7Sigt3+kfZ
         mqz+r3ZkIU3u5yMGolSsthC5cdtC/xHSYiH5qOpbFXacy9r6xqMZ8KI43sRJ5bGmBl
         QIT8nReeqqfweBWuNV3xmpeNx03vPsJIEYmDu+To=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 519/913] drm/msm/a6xx: Fix missing ARRAY_SIZE() check
Date:   Tue,  5 Apr 2022 09:26:21 +0200
Message-Id: <20220405070355.411181404@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit cca96584b35765bf9eb5f38ca55a144ea2ba0de4 ]

Fixes: f6d62d091cfd ("drm/msm/a6xx: add support for Adreno 660 GPU")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220305173405.914989-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index b681c45520bb..f54bfdb1ebff 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -658,19 +658,23 @@ static void a6xx_set_cp_protect(struct msm_gpu *gpu)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	const u32 *regs = a6xx_protect;
-	unsigned i, count = ARRAY_SIZE(a6xx_protect), count_max = 32;
-
-	BUILD_BUG_ON(ARRAY_SIZE(a6xx_protect) > 32);
-	BUILD_BUG_ON(ARRAY_SIZE(a650_protect) > 48);
+	unsigned i, count, count_max;
 
 	if (adreno_is_a650(adreno_gpu)) {
 		regs = a650_protect;
 		count = ARRAY_SIZE(a650_protect);
 		count_max = 48;
+		BUILD_BUG_ON(ARRAY_SIZE(a650_protect) > 48);
 	} else if (adreno_is_a660_family(adreno_gpu)) {
 		regs = a660_protect;
 		count = ARRAY_SIZE(a660_protect);
 		count_max = 48;
+		BUILD_BUG_ON(ARRAY_SIZE(a660_protect) > 48);
+	} else {
+		regs = a6xx_protect;
+		count = ARRAY_SIZE(a6xx_protect);
+		count_max = 32;
+		BUILD_BUG_ON(ARRAY_SIZE(a6xx_protect) > 32);
 	}
 
 	/*
-- 
2.34.1



