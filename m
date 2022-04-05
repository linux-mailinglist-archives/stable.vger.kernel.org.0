Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4244F2EAA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbiDEIgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbiDEITd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F2275C38;
        Tue,  5 Apr 2022 01:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D887DB81B90;
        Tue,  5 Apr 2022 08:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CC5C385A0;
        Tue,  5 Apr 2022 08:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146193;
        bh=+EkYPM/9VSMLeOdGLvUk8BbpTJ3vtgGT8IT5amiLLb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtySrJGr6y5zD7e104cetnnJTzLWuJ7lx1rVolHLJvALwVi5oW69iAjEk0edvHXk/
         BVpc8srD8f2AWoC0T6TWdl2VWb+r5M67E9YjbIVO2KJZ6sn1uYHtrF9eNYRH91pSU4
         UDjJxM+2450f/6dt2TP9tOQYllKGijIRtv/MjVTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0637/1126] drm/msm/a6xx: Fix missing ARRAY_SIZE() check
Date:   Tue,  5 Apr 2022 09:23:04 +0200
Message-Id: <20220405070426.333993833@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 17cfad6424db..616be7265da4 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -655,19 +655,23 @@ static void a6xx_set_cp_protect(struct msm_gpu *gpu)
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



