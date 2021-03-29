Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9AD34DA26
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhC2WVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhC2WVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 510B66196E;
        Mon, 29 Mar 2021 22:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056498;
        bh=lUbK4NYL9hmuKEr4+Eb7qVrc0rtzm8u8PW+SIy5Hlv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=byF+wNoAqVaugKOkDAAMIJmzEkhe6VLaoILFLNop8s+v7vR50te6zMx/bIaWsXkzB
         Jk/cILcUC0WNA7KuqkSv1vMYFSYGYEEu6kKaZ8JbJjL1kg3gYf0lZ3vKZ5KFjoY13N
         qjKT0IYONQEY23vv9kjA/B7G15/4M2d0G6esxz4iLmtLz0Avofut4wMEfowZCqwTfW
         DBSXbeDzR05rDYToiiDhoKQspKLZ7/w35t8z/i/55V8MIQXwsUg9NvjkydWThMRtxX
         LLKz/a5KUTRL7xciTekxtyeR+DmqRVy5jJHGYH+Y6if8N7tN6kA+VEFfEbDH2ZhSaB
         GIa2S9NhXxUCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jordan Crouse <jcrouse@codeaurora.org>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 03/38] drm/msm: a6xx: Make sure the SQE microcode is safe
Date:   Mon, 29 Mar 2021 18:20:58 -0400
Message-Id: <20210329222133.2382393-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

[ Upstream commit 8490f02a3ca45fd1bbcadc243b4db9b69d0e3450 ]

Most a6xx targets have security issues that were fixed with new versions
of the microcode(s). Make sure that we are booting with a safe version of
the microcode for the target and print a message and error if not.

v2: Add more informative error messages and fix typos

Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 77 ++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 0366419d8bfe..e7a8442b59af 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -521,28 +521,73 @@ static int a6xx_cp_init(struct msm_gpu *gpu)
 	return a6xx_idle(gpu, ring) ? 0 : -EINVAL;
 }
 
-static void a6xx_ucode_check_version(struct a6xx_gpu *a6xx_gpu,
+/*
+ * Check that the microcode version is new enough to include several key
+ * security fixes. Return true if the ucode is safe.
+ */
+static bool a6xx_ucode_check_version(struct a6xx_gpu *a6xx_gpu,
 		struct drm_gem_object *obj)
 {
+	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
+	struct msm_gpu *gpu = &adreno_gpu->base;
 	u32 *buf = msm_gem_get_vaddr(obj);
+	bool ret = false;
 
 	if (IS_ERR(buf))
-		return;
+		return false;
 
 	/*
-	 * If the lowest nibble is 0xa that is an indication that this microcode
-	 * has been patched. The actual version is in dword [3] but we only care
-	 * about the patchlevel which is the lowest nibble of dword [3]
-	 *
-	 * Otherwise check that the firmware is greater than or equal to 1.90
-	 * which was the first version that had this fix built in
+	 * Targets up to a640 (a618, a630 and a640) need to check for a
+	 * microcode version that is patched to support the whereami opcode or
+	 * one that is new enough to include it by default.
 	 */
-	if (((buf[0] & 0xf) == 0xa) && (buf[2] & 0xf) >= 1)
-		a6xx_gpu->has_whereami = true;
-	else if ((buf[0] & 0xfff) > 0x190)
-		a6xx_gpu->has_whereami = true;
+	if (adreno_is_a618(adreno_gpu) || adreno_is_a630(adreno_gpu) ||
+		adreno_is_a640(adreno_gpu)) {
+		/*
+		 * If the lowest nibble is 0xa that is an indication that this
+		 * microcode has been patched. The actual version is in dword
+		 * [3] but we only care about the patchlevel which is the lowest
+		 * nibble of dword [3]
+		 *
+		 * Otherwise check that the firmware is greater than or equal
+		 * to 1.90 which was the first version that had this fix built
+		 * in
+		 */
+		if ((((buf[0] & 0xf) == 0xa) && (buf[2] & 0xf) >= 1) ||
+			(buf[0] & 0xfff) >= 0x190) {
+			a6xx_gpu->has_whereami = true;
+			ret = true;
+			goto out;
+		}
 
+		DRM_DEV_ERROR(&gpu->pdev->dev,
+			"a630 SQE ucode is too old. Have version %x need at least %x\n",
+			buf[0] & 0xfff, 0x190);
+	}  else {
+		/*
+		 * a650 tier targets don't need whereami but still need to be
+		 * equal to or newer than 1.95 for other security fixes
+		 */
+		if (adreno_is_a650(adreno_gpu)) {
+			if ((buf[0] & 0xfff) >= 0x195) {
+				ret = true;
+				goto out;
+			}
+
+			DRM_DEV_ERROR(&gpu->pdev->dev,
+				"a650 SQE ucode is too old. Have version %x need at least %x\n",
+				buf[0] & 0xfff, 0x195);
+		}
+
+		/*
+		 * When a660 is added those targets should return true here
+		 * since those have all the critical security fixes built in
+		 * from the start
+		 */
+	}
+out:
 	msm_gem_put_vaddr(obj);
+	return ret;
 }
 
 static int a6xx_ucode_init(struct msm_gpu *gpu)
@@ -565,7 +610,13 @@ static int a6xx_ucode_init(struct msm_gpu *gpu)
 		}
 
 		msm_gem_object_set_name(a6xx_gpu->sqe_bo, "sqefw");
-		a6xx_ucode_check_version(a6xx_gpu, a6xx_gpu->sqe_bo);
+		if (!a6xx_ucode_check_version(a6xx_gpu, a6xx_gpu->sqe_bo)) {
+			msm_gem_unpin_iova(a6xx_gpu->sqe_bo, gpu->aspace);
+			drm_gem_object_put(a6xx_gpu->sqe_bo);
+
+			a6xx_gpu->sqe_bo = NULL;
+			return -EPERM;
+		}
 	}
 
 	gpu_write64(gpu, REG_A6XX_CP_SQE_INSTR_BASE_LO,
-- 
2.30.1

