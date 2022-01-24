Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816AE49955A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392615AbiAXUvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390872AbiAXUqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF102C061259;
        Mon, 24 Jan 2022 11:56:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC6760B89;
        Mon, 24 Jan 2022 19:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB8CC340E5;
        Mon, 24 Jan 2022 19:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054182;
        bh=N+xAuBNrumYAwKdpAGtW0TSvVD1arLgbiAIJ/iqPfH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Wgc1tA4QNEdQ8/T3xWQNaqSBbTnoU4lWyWnxMlzzKRl/U0evUKk9+6XO2qZ7qfLG
         /TF301QQ+QmgT3mVsDLyW0FHmNQ4wCOp0HSwAWQINjfMMjoa0kqjGoLfd6IB/99sZP
         fRZVnZ58qo04AV4O95JQ0jaPUNvIEy0jLV0CXi/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diego Viola <diego.viola@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/563] drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR
Date:   Mon, 24 Jan 2022 19:41:10 +0100
Message-Id: <20220124184034.988303891@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



