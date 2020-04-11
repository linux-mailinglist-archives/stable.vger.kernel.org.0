Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795721A5844
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgDKXLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbgDKXLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F01A620CC7;
        Sat, 11 Apr 2020 23:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646676;
        bh=wS3jFTMM2C4qr3WLroCLDV8LJ8TkwN/96ofrMrcEvqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PShKxyJuqDRFJ9sSUQ1buuW7vNtLlL9XO8ENozNo7g7wruWwR2D6V9foICHzmclLm
         bxjyHE00x7pR84Lzk7P77Tf4Txij98TEv5mOi1eb6//1El9arLvZ+/+i/XODo/1RSA
         +eTLi8MviqPIhtOHlgVXpgvXoJARzCws4IBTEWQk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 074/108] drm/msm: devcoredump should dump MSM_SUBMIT_BO_DUMP buffers
Date:   Sat, 11 Apr 2020 19:09:09 -0400
Message-Id: <20200411230943.24951-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit e515af8d4a6f18f96c360724568a7497868101a8 ]

Also log buffers with the DUMP flag set, to ensure we capture all useful
cmdstream in crashdump state with modern mesa.

Otherwise we miss out on the contents of "state object" cmdstream
buffers.

v2: add missing 'inline'

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.h | 10 ++++++++++
 drivers/gpu/drm/msm/msm_gpu.c | 28 +++++++++++++++++++++++-----
 drivers/gpu/drm/msm/msm_rd.c  |  8 +-------
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.h b/drivers/gpu/drm/msm/msm_gem.h
index 9e0953c2b7cea..dcee0e223ed86 100644
--- a/drivers/gpu/drm/msm/msm_gem.h
+++ b/drivers/gpu/drm/msm/msm_gem.h
@@ -160,4 +160,14 @@ struct msm_gem_submit {
 	} bos[0];
 };
 
+/* helper to determine of a buffer in submit should be dumped, used for both
+ * devcoredump and debugfs cmdstream dumping:
+ */
+static inline bool
+should_dump(struct msm_gem_submit *submit, int idx)
+{
+	extern bool rd_full;
+	return rd_full || (submit->bos[idx].flags & MSM_SUBMIT_BO_DUMP);
+}
+
 #endif /* __MSM_GEM_H__ */
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index edd45f434ccd6..aea93e5035758 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -355,16 +355,34 @@ static void msm_gpu_crashstate_capture(struct msm_gpu *gpu,
 	state->cmd = kstrdup(cmd, GFP_KERNEL);
 
 	if (submit) {
-		int i;
-
-		state->bos = kcalloc(submit->nr_cmds,
+		int i, nr = 0;
+
+		/* count # of buffers to dump: */
+		for (i = 0; i < submit->nr_bos; i++)
+			if (should_dump(submit, i))
+				nr++;
+		/* always dump cmd bo's, but don't double count them: */
+		for (i = 0; i < submit->nr_cmds; i++)
+			if (!should_dump(submit, submit->cmd[i].idx))
+				nr++;
+
+		state->bos = kcalloc(nr,
 			sizeof(struct msm_gpu_state_bo), GFP_KERNEL);
 
+		for (i = 0; i < submit->nr_bos; i++) {
+			if (should_dump(submit, i)) {
+				msm_gpu_crashstate_get_bo(state, submit->bos[i].obj,
+					submit->bos[i].iova, submit->bos[i].flags);
+			}
+		}
+
 		for (i = 0; state->bos && i < submit->nr_cmds; i++) {
 			int idx = submit->cmd[i].idx;
 
-			msm_gpu_crashstate_get_bo(state, submit->bos[idx].obj,
-				submit->bos[idx].iova, submit->bos[idx].flags);
+			if (!should_dump(submit, submit->cmd[i].idx)) {
+				msm_gpu_crashstate_get_bo(state, submit->bos[idx].obj,
+					submit->bos[idx].iova, submit->bos[idx].flags);
+			}
 		}
 	}
 
diff --git a/drivers/gpu/drm/msm/msm_rd.c b/drivers/gpu/drm/msm/msm_rd.c
index c7832a951039f..4acebaefaed74 100644
--- a/drivers/gpu/drm/msm/msm_rd.c
+++ b/drivers/gpu/drm/msm/msm_rd.c
@@ -43,7 +43,7 @@
 #include "msm_gpu.h"
 #include "msm_gem.h"
 
-static bool rd_full = false;
+bool rd_full = false;
 MODULE_PARM_DESC(rd_full, "If true, $debugfs/.../rd will snapshot all buffer contents");
 module_param_named(rd_full, rd_full, bool, 0600);
 
@@ -333,12 +333,6 @@ static void snapshot_buf(struct msm_rd_state *rd,
 	msm_gem_put_vaddr(&obj->base);
 }
 
-static bool
-should_dump(struct msm_gem_submit *submit, int idx)
-{
-	return rd_full || (submit->bos[idx].flags & MSM_SUBMIT_BO_DUMP);
-}
-
 /* called under struct_mutex */
 void msm_rd_dump_submit(struct msm_rd_state *rd, struct msm_gem_submit *submit,
 		const char *fmt, ...)
-- 
2.20.1

