Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6880E1B3E9D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgDVK3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730774AbgDVK0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:26:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50B7D2075A;
        Wed, 22 Apr 2020 10:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551214;
        bh=qH9qERq1aobruUDxNorQSbRv11rBGAyt79dGitcZhbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngg8HLl3NTIcWx4KMYcdcQC2EqElpWhS3cpzzbtowabIYc5XvoBJ7xZubmoTVkTW0
         +LPPAzHpZdQ1Pmc8Wtunz/qSPkUR/RyF/7qusaZ1oqanP5/5zeBXbQ5lcZuLz/9JyC
         ttwn4xqJinGdjZPYlNpxBEk7gc2/MlOpiU42b3fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 146/166] drm/nouveau/gr/gp107,gp108: implement workaround for HW hanging during init
Date:   Wed, 22 Apr 2020 11:57:53 +0200
Message-Id: <20200422095104.269210231@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 028a12f5aa829b4ba6ac011530b815eda4960e89 ]

Certain boards with GP107/GP108 chipsets hang (often, but randomly) for
unknown reasons during GR initialisation.

The first tell-tale symptom of this issue is:

nouveau 0000:01:00.0: bus: MMIO read of 00000000 FAULT at 409800 [ TIMEOUT ]

appearing in dmesg, likely followed by many other failures being logged.

Karol found this WAR for the issue a while back, but efforts to isolate
the root cause and proper fix have not yielded success so far.  I've
modified the original patch to include a few more details, limit it to
GP107/GP108 by default, and added a config option to override this choice.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/nvkm/engine/gr/gf100.c    | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
index dd8f85b8b3a7e..f2f5636efac45 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
@@ -1981,8 +1981,34 @@ gf100_gr_init_(struct nvkm_gr *base)
 {
 	struct gf100_gr *gr = gf100_gr(base);
 	struct nvkm_subdev *subdev = &base->engine.subdev;
+	struct nvkm_device *device = subdev->device;
+	bool reset = device->chipset == 0x137 || device->chipset == 0x138;
 	u32 ret;
 
+	/* On certain GP107/GP108 boards, we trigger a weird issue where
+	 * GR will stop responding to PRI accesses after we've asked the
+	 * SEC2 RTOS to boot the GR falcons.  This happens with far more
+	 * frequency when cold-booting a board (ie. returning from D3).
+	 *
+	 * The root cause for this is not known and has proven difficult
+	 * to isolate, with many avenues being dead-ends.
+	 *
+	 * A workaround was discovered by Karol, whereby putting GR into
+	 * reset for an extended period right before initialisation
+	 * prevents the problem from occuring.
+	 *
+	 * XXX: As RM does not require any such workaround, this is more
+	 *      of a hack than a true fix.
+	 */
+	reset = nvkm_boolopt(device->cfgopt, "NvGrResetWar", reset);
+	if (reset) {
+		nvkm_mask(device, 0x000200, 0x00001000, 0x00000000);
+		nvkm_rd32(device, 0x000200);
+		msleep(50);
+		nvkm_mask(device, 0x000200, 0x00001000, 0x00001000);
+		nvkm_rd32(device, 0x000200);
+	}
+
 	nvkm_pmu_pgob(gr->base.engine.subdev.device->pmu, false);
 
 	ret = nvkm_falcon_get(&gr->fecs.falcon, subdev);
-- 
2.20.1



