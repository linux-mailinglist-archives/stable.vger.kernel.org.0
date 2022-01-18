Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382144916D0
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbiARCgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343982AbiARCeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:34:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCAAC06138F;
        Mon, 17 Jan 2022 18:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12048B811FF;
        Tue, 18 Jan 2022 02:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF8DC36AEB;
        Tue, 18 Jan 2022 02:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473154;
        bh=0tDVZXKr9K09AvgqRFA/1j1lSWqb13QUoRj3scev9K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfWTC0pmTADMl5OkoFwb5pUHn94rDhh5f4/Oi/EulQ+GQHBl8H2OP02hQnLAeqlY7
         eJLh7r3olEsMyoc6f9TfVgrjRvKNkpkddoWBcIP6f2P7EnqEi4xzBKd6XqYnJTXZLx
         ZkVYh9vLpQ0STXE+eva9X5jDpZaaRMBXV2PsrmD1V9BhgBBNFA6BAXVDCcCtDyXOVf
         jBDrbG1DTw9LV4mVgqo4pdEEa7b9XLPhfIOpIS9GN1TsnEMCpEBAdVySXddAwBnMnf
         7jPJTysZ5TsMcua+F2j5k0PrqV07ZnLQGDQ1IvlDcBiN4oVSSJ4sHBKBOMNzHqdiVZ
         HTtWZZ98cjWag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>,
        Diego Viola <diego.viola@gmail.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, lyude@redhat.com,
        airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 013/188] drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR
Date:   Mon, 17 Jan 2022 21:28:57 -0500
Message-Id: <20220118023152.1948105-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 24382875fb4f3..455e95a89259f 100644
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

