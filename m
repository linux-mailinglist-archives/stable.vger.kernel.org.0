Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10BB491A4F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352168AbiARC7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241851AbiARCrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:47:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F19356142C;
        Tue, 18 Jan 2022 02:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B5C36AFB;
        Tue, 18 Jan 2022 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474030;
        bh=42cKnB73ycwsYbytnMtn+m7ZqxOi3VaJu09BCcgAuRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFBNKD/K1FJAjZ5eE88sRZXnMprL9lKPo+Diz0Qk8WFIbGXPlf8qlsJa8RlGY3q0G
         xYoW+GESzcKIcF5hEY5bAtklqOBi/rHTl5N6w7rgmdISNNXLVyYMzdqeKQfPrwGDtj
         prqCl5D7Dn2ZTWPfJ21MU3uVJYZJ8wBW2AU2N2aveuZLw5U4vh4WB+p0gXUYBWBd/U
         9XIBuzcmTC/S53iOrrJjJaOkz8FAJWCfszVbr6dYb9I3orlR4OTQdI9MVPqw8ftOXV
         qMuwIuJdZX4SUcn1tYRhwoj0g47++ET47EMpS/BYZy2H0cu2LalCmHmAx4oEjaArJY
         CyWKesr+H60MQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>,
        Diego Viola <diego.viola@gmail.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, lyude@redhat.com,
        airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 04/59] drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR
Date:   Mon, 17 Jan 2022 21:46:05 -0500
Message-Id: <20220118024701.1952911-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index ce70a193caa7f..8cf3d1b4662de 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
@@ -70,20 +70,13 @@ nvkm_pmu_fini(struct nvkm_subdev *subdev, bool suspend)
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
@@ -94,25 +87,37 @@ nvkm_pmu_reset(struct nvkm_pmu *pmu)
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
 
 static int
-- 
2.34.1

