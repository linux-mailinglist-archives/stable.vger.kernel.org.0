Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B5661584B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiKBCtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiKBCtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:49:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D8D6562
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 897DC61729
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1BC433D6;
        Wed,  2 Nov 2022 02:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357342;
        bh=pKBUNdafFO6AO0Nw0ju2H23r0amSYiTIrkXn9hgiSMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxFfkpQGuZ28luMrPlz7OFuGZorhbvaUyV0mCrsHD98RE6vl9AK7nWnq1zuo0vKz9
         Cu4a8tNIqHlI1XQ+edPVecwvPaKHHeOp+zSIzRM4lDyRkFLHEb4hcTN8nYH1vwtuyx
         qknG/vUUDd63hiKrPCA9DTEUS86neJ0kjwEwNr9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Akhil P Oommen <quic_akhilpo@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 125/240] drm/msm/a6xx: Replace kcalloc() with kvzalloc()
Date:   Wed,  2 Nov 2022 03:31:40 +0100
Message-Id: <20221102022114.209708418@linuxfoundation.org>
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

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit ec8f1813bf8d0737898f99a8c1c69df0cde0d7dd ]

In order to reduce chance of allocation failure while capturing a6xx
gpu state, use kvzalloc() instead of kcalloc() in state_kcalloc().

Indirectly, this patch helps to fix leaking memory allocated for
gmu_debug object.

Fixes: b859f9b009b (drm/msm/gpu: Snapshot GMU debug buffer)
Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/505074/
Link: https://lore.kernel.org/r/20220928124830.1.I8ea24a8d586b4978823b848adde000f92f74d5c2@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 55f443328d8e..3c112a6cc8a2 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -91,7 +91,7 @@ struct a6xx_state_memobj {
 static void *state_kcalloc(struct a6xx_gpu_state *a6xx_state, int nr, size_t objsize)
 {
 	struct a6xx_state_memobj *obj =
-		kzalloc((nr * objsize) + sizeof(*obj), GFP_KERNEL);
+		kvzalloc((nr * objsize) + sizeof(*obj), GFP_KERNEL);
 
 	if (!obj)
 		return NULL;
@@ -819,7 +819,7 @@ static struct msm_gpu_state_bo *a6xx_snapshot_gmu_bo(
 
 	snapshot->iova = bo->iova;
 	snapshot->size = bo->size;
-	snapshot->data = kvzalloc(snapshot->size, GFP_KERNEL);
+	snapshot->data = state_kcalloc(a6xx_state, 1, snapshot->size);
 	if (!snapshot->data)
 		return NULL;
 
@@ -1034,14 +1034,8 @@ static void a6xx_gpu_state_destroy(struct kref *kref)
 	struct a6xx_gpu_state *a6xx_state = container_of(state,
 			struct a6xx_gpu_state, base);
 
-	if (a6xx_state->gmu_log)
-		kvfree(a6xx_state->gmu_log->data);
-
-	if (a6xx_state->gmu_hfi)
-		kvfree(a6xx_state->gmu_hfi->data);
-
 	list_for_each_entry_safe(obj, tmp, &a6xx_state->objs, node)
-		kfree(obj);
+		kvfree(obj);
 
 	adreno_gpu_state_destroy(state);
 	kfree(a6xx_state);
-- 
2.35.1



