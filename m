Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0969349181F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344610AbiARCo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347038AbiARCkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:40:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDE6061127;
        Tue, 18 Jan 2022 02:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA76C36AE3;
        Tue, 18 Jan 2022 02:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473631;
        bh=N+xAuBNrumYAwKdpAGtW0TSvVD1arLgbiAIJ/iqPfH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap6SszjwUFCxNiG2/oHXaOLCnm9Crze4tcFsaJqqczDgLp2jqkhlzjsguy33kZtqf
         D/+i8WhZCcHQ5RsdI3FdSo+y6awCnMucEgVtkfUlOhZEwUUE9d0dIJODhXiT1lI6gU
         BE6bBEphq+vb7DHEWTLZo/LzsRiRtnyNltNZ5U0+m8/tgJKuPylVlfPOM5QfvRtzTp
         ++jWgoPYb/9qWCbgnNKe3y/uwoKTElgaqyHDeJB6LfPddZdAZP6dnnXmXGESKXW3Y+
         GwJAtaIEdOy1eFoDWzFfzgT5ZDavefcS4hhFtnwH5bQ37fTckE61hok0TK0O6UABFi
         KbwjaCN3ladig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>,
        Diego Viola <diego.viola@gmail.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, lyude@redhat.com,
        airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 008/116] drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR
Date:   Mon, 17 Jan 2022 21:38:19 -0500
Message-Id: <20220118024007.1950576-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 1d2271d2fb85e54bfc9630a6c30ac0feb9ffb983 ]

There have been reports of the WFI timing out on some boards, and a
patch was proposed to just remove it.  This stuff is rather fragile,
and I believe the WFI might be needed with our FW prior to GM200.

However, we probably should not be touching PMU during init on GPUs
where we depend on NVIDIA FW, outside of limited circumstances, so
this should be a somewhat safer change that achieves the desired
result.

Reported-by: Diego Viola <diego.viola@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://gitlab.freedesktop.org/drm/nouveau/-/merge_requests/10
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/nvkm/subdev/pmu/base.c    | 37 +++++++++++--------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
index a0fe607c9c07f..3bfc55c571b5e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
@@ -94,20 +94,13 @@ nvkm_pmu_fini(struct nvkm_subdev *subdev, bool suspend)
 	return 0;
 }
 
-static int
+static void
 nvkm_pmu_reset(struct nvkm_pmu *pmu)
 {
 	struct nvkm_device *device = pmu->subdev.device;
 
 	if (!pmu->func->enabled(pmu))
-		return 0;
-
-	/* Inhibit interrupts, and wait for idle. */
-	nvkm_wr32(device, 0x10a014, 0x0000ffff);
-	nvkm_msec(device, 2000,
-		if (!nvkm_rd32(device, 0x10a04c))
-			break;
-	);
+		return;
 
 	/* Reset. */
 	if (pmu->func->reset)
@@ -118,25 +111,37 @@ nvkm_pmu_reset(struct nvkm_pmu *pmu)
 		if (!(nvkm_rd32(device, 0x10a10c) & 0x00000006))
 			break;
 	);
-
-	return 0;
 }
 
 static int
 nvkm_pmu_preinit(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	return nvkm_pmu_reset(pmu);
+	nvkm_pmu_reset(pmu);
+	return 0;
 }
 
 static int
 nvkm_pmu_init(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	int ret = nvkm_pmu_reset(pmu);
-	if (ret == 0 && pmu->func->init)
-		ret = pmu->func->init(pmu);
-	return ret;
+	struct nvkm_device *device = pmu->subdev.device;
+
+	if (!pmu->func->init)
+		return 0;
+
+	if (pmu->func->enabled(pmu)) {
+		/* Inhibit interrupts, and wait for idle. */
+		nvkm_wr32(device, 0x10a014, 0x0000ffff);
+		nvkm_msec(device, 2000,
+			if (!nvkm_rd32(device, 0x10a04c))
+				break;
+		);
+
+		nvkm_pmu_reset(pmu);
+	}
+
+	return pmu->func->init(pmu);
 }
 
 static void *
-- 
2.34.1

