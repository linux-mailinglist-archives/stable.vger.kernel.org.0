Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E814C73A8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiB1Rh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238308AbiB1RhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:37:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCEF89CF8;
        Mon, 28 Feb 2022 09:32:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E547A61358;
        Mon, 28 Feb 2022 17:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04297C340E7;
        Mon, 28 Feb 2022 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069525;
        bh=OdVa2ugLA2SYLg1Q1Zk4v0F51Z57H51iaDsKFNlaeLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZXFMlQH+HaXBCOyuCa+3zewQVBQzEoJPUuplD7R9BSicI2sc2aqy0kob8e2SQiYA
         sj77w/65Ws78Im1gK2Y3K8z5QPYaqS384Ld3j4RDOTAVbpmiQuyqtNuKQXrofzw4+O
         hUMqHlrgUDBkr0rTxvWQOdvRcG6caF/M/2k7zvqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.4 51/53] Revert "drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR"
Date:   Mon, 28 Feb 2022 18:24:49 +0100
Message-Id: <20220228172252.022032029@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Herbst <kherbst@redhat.com>

This reverts commit c9ec3d85c0eef7c71cdc68db758e0f0e378132c0.

This commit causes a regression if 4cdd2450bf739bada353e82d27b00db9af8c3001
is not applied as well. This was fixed for 5.16, 5.15 and 5.10.

On older stable branches backporting this commit is complicated as relevant
code changed quite a bit. Furthermore most of the affected hardware barely
works on those and users would want to use the newer kernels anyway.

Cc: stable@vger.kernel.org # 5.4 4.19 and 4.14
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Link: https://gitlab.freedesktop.org/drm/nouveau/-/issues/149
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c |   37 ++++++++++---------------
 1 file changed, 16 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c
@@ -88,13 +88,20 @@ nvkm_pmu_fini(struct nvkm_subdev *subdev
 	return 0;
 }
 
-static void
+static int
 nvkm_pmu_reset(struct nvkm_pmu *pmu)
 {
 	struct nvkm_device *device = pmu->subdev.device;
 
 	if (!pmu->func->enabled(pmu))
-		return;
+		return 0;
+
+	/* Inhibit interrupts, and wait for idle. */
+	nvkm_wr32(device, 0x10a014, 0x0000ffff);
+	nvkm_msec(device, 2000,
+		if (!nvkm_rd32(device, 0x10a04c))
+			break;
+	);
 
 	/* Reset. */
 	if (pmu->func->reset)
@@ -105,37 +112,25 @@ nvkm_pmu_reset(struct nvkm_pmu *pmu)
 		if (!(nvkm_rd32(device, 0x10a10c) & 0x00000006))
 			break;
 	);
+
+	return 0;
 }
 
 static int
 nvkm_pmu_preinit(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	nvkm_pmu_reset(pmu);
-	return 0;
+	return nvkm_pmu_reset(pmu);
 }
 
 static int
 nvkm_pmu_init(struct nvkm_subdev *subdev)
 {
 	struct nvkm_pmu *pmu = nvkm_pmu(subdev);
-	struct nvkm_device *device = pmu->subdev.device;
-
-	if (!pmu->func->init)
-		return 0;
-
-	if (pmu->func->enabled(pmu)) {
-		/* Inhibit interrupts, and wait for idle. */
-		nvkm_wr32(device, 0x10a014, 0x0000ffff);
-		nvkm_msec(device, 2000,
-			if (!nvkm_rd32(device, 0x10a04c))
-				break;
-		);
-
-		nvkm_pmu_reset(pmu);
-	}
-
-	return pmu->func->init(pmu);
+	int ret = nvkm_pmu_reset(pmu);
+	if (ret == 0 && pmu->func->init)
+		ret = pmu->func->init(pmu);
+	return ret;
 }
 
 static int


