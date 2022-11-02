Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC9F615830
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiKBCqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKBCqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C3321277
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12386617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB8EC433C1;
        Wed,  2 Nov 2022 02:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357211;
        bh=ZizDvIm2wffrlZTPNOCQC/EEW2RfeXwyg55eAheMWP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PawaxnBbT/NUDvEwK/+X+7Hko89E4Qur2Ezp5UGE/47fzVAKmse7jvx1Lq9wksMtY
         v9OESbO8bWUPbUuPWbHMc0NzxXmQDjc+CZiGQb6W0aFrWktdJitYMfOef1T9hSw+RE
         2RNEcQWuDl/yUWwyp1qGzw87jgaALow9DPoAFlc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Chia-I Wu <olvaffe@gmail.com>,
        Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 132/240] drm/msm/a6xx: Fix kvzalloc vs state_kcalloc usage
Date:   Wed,  2 Nov 2022 03:31:47 +0100
Message-Id: <20221102022114.366232656@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 83d18e9d9c0150d98dc24e3642ea93f5e245322c ]

adreno_show_object() is a trap!  It will re-allocate the pointer it is
passed on first call, when the data is ascii85 encoded, using kvmalloc/
kvfree().  Which means the data *passed* to it must be kvmalloc'd, ie.
we cannot use the state_kcalloc() helper.

This partially reverts commit ec8f1813bf8d ("drm/msm/a6xx: Replace
kcalloc() with kvzalloc()"), but adds the missing kvfree() to fix the
memory leak that was present previously.  And adds a warning comment.

Fixes: ec8f1813bf8d ("drm/msm/a6xx: Replace kcalloc() with kvzalloc()")
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/20
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/507014/
Link: https://lore.kernel.org/r/20221013225520.371226-2-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 11 ++++++++++-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c     |  7 ++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 3c112a6cc8a2..730355f9e2d4 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -819,7 +819,7 @@ static struct msm_gpu_state_bo *a6xx_snapshot_gmu_bo(
 
 	snapshot->iova = bo->iova;
 	snapshot->size = bo->size;
-	snapshot->data = state_kcalloc(a6xx_state, 1, snapshot->size);
+	snapshot->data = kvzalloc(snapshot->size, GFP_KERNEL);
 	if (!snapshot->data)
 		return NULL;
 
@@ -1034,6 +1034,15 @@ static void a6xx_gpu_state_destroy(struct kref *kref)
 	struct a6xx_gpu_state *a6xx_state = container_of(state,
 			struct a6xx_gpu_state, base);
 
+	if (a6xx_state->gmu_log)
+		kvfree(a6xx_state->gmu_log->data);
+
+	if (a6xx_state->gmu_hfi)
+		kvfree(a6xx_state->gmu_hfi->data);
+
+	if (a6xx_state->gmu_debug)
+		kvfree(a6xx_state->gmu_debug->data);
+
 	list_for_each_entry_safe(obj, tmp, &a6xx_state->objs, node)
 		kvfree(obj);
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 382fb7f9e497..5a0e8491cd3a 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -729,7 +729,12 @@ static char *adreno_gpu_ascii85_encode(u32 *src, size_t len)
 	return buf;
 }
 
-/* len is expected to be in bytes */
+/* len is expected to be in bytes
+ *
+ * WARNING: *ptr should be allocated with kvmalloc or friends.  It can be free'd
+ * with kvfree() and replaced with a newly kvmalloc'd buffer on the first call
+ * when the unencoded raw data is encoded
+ */
 void adreno_show_object(struct drm_printer *p, void **ptr, int len,
 		bool *encoded)
 {
-- 
2.35.1



