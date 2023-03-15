Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D926BB19F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjCOM3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjCOM2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006E097486
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FEF261D26
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAE2C433EF;
        Wed, 15 Mar 2023 12:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883263;
        bh=UuW9ymnzqb3fZYpjQGKkr9yKOSaBjx5RBz6nZwu0kfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUANffsZJnoyy3Xd35yPKRjgdIwRLNItGu+8CQnB4DqtORAcaiuJYGS6mS3yLOZaQ
         JKo4Nnt2QZJDDjL2cBRXmw7WaErUJXr4NeftE3GnynIq/g6IZA+5LgYBeEZFuPMsk0
         uuTuh5GjRkjmHnqDFDmIhsQL564qTv3Luqg2dyCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/145] drm/msm/a5xx: fix highest bank bit for a530
Date:   Wed, 15 Mar 2023 13:11:53 +0100
Message-Id: <20230315115740.620552910@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 141f66ebbfa17cc7e2075f06c50107da978c965b ]

A530 has highest bank bit equal to 15 (like A540). Fix values written to
REG_A5XX_RB_MODE_CNTL and REG_A5XX_TPL1_MODE_CNTL registers.

Fixes: 1d832ab30ce6 ("drm/msm/a5xx: Add support for Adreno 508, 509, 512 GPUs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/522639/
Link: https://lore.kernel.org/r/20230214020956.164473-3-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index c1bc5e2aaefe5..b8c49ba65254c 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -801,7 +801,7 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	gpu_write(gpu, REG_A5XX_RBBM_AHB_CNTL2, 0x0000003F);
 
 	/* Set the highest bank bit */
-	if (adreno_is_a540(adreno_gpu))
+	if (adreno_is_a540(adreno_gpu) || adreno_is_a530(adreno_gpu))
 		regbit = 2;
 	else
 		regbit = 1;
-- 
2.39.2



