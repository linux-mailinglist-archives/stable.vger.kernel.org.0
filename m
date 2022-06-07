Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707C7541A53
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379175AbiFGVck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380401AbiFGVax (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65E922A444;
        Tue,  7 Jun 2022 12:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 491A3617CC;
        Tue,  7 Jun 2022 19:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C25BC385A2;
        Tue,  7 Jun 2022 19:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628572;
        bh=mZZGN1vDCwTcevPbiRhr3RbO/mWB4btFM6x/einU7YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpmsyfAgqlCcrmkjiaL1/LdUeUDosFu5EWwx/NTjeGjgTWLB7WRWz407jMTkRXZ4/
         0T5Sv2lmFx/0G5o57rONNLIMAR6+MAevdkwFfa65CfU8iqMiu2hw4r+5zxa9UWH4SJ
         8sMhFm6fUZ4PvB6ATN5b6dHr4INBUjwPJfhNj6EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Weiss <luca@z3ntu.xyz>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 379/879] drm/msm: Fix null pointer dereferences without iommu
Date:   Tue,  7 Jun 2022 18:58:17 +0200
Message-Id: <20220607165013.870951553@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit 36a1d1bda77e1851bddfa9cf4e8ada94476dbaff ]

Check if 'aspace' is set before using it as it will stay null without
IOMMU, such as on msm8974.

Fixes: bc2112583a0b ("drm/msm/gpu: Track global faults per address-space")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20220421203455.313523-1-luca@z3ntu.xyz
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 5 ++++-
 drivers/gpu/drm/msm/msm_gpu.c           | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 9efc84929be0..1219f71629a5 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -272,7 +272,10 @@ int adreno_get_param(struct msm_gpu *gpu, struct msm_file_private *ctx,
 		*value = 0;
 		return 0;
 	case MSM_PARAM_FAULTS:
-		*value = gpu->global_faults + ctx->aspace->faults;
+		if (ctx->aspace)
+			*value = gpu->global_faults + ctx->aspace->faults;
+		else
+			*value = gpu->global_faults;
 		return 0;
 	case MSM_PARAM_SUSPENDS:
 		*value = gpu->suspend_count;
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index faf0c242874e..58eb3e1662cb 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -371,7 +371,8 @@ static void recover_worker(struct kthread_work *work)
 
 		/* Increment the fault counts */
 		submit->queue->faults++;
-		submit->aspace->faults++;
+		if (submit->aspace)
+			submit->aspace->faults++;
 
 		task = get_pid_task(submit->pid, PIDTYPE_PID);
 		if (task) {
-- 
2.35.1



