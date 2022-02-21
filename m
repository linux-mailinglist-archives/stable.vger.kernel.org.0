Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524F34BE465
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347715AbiBUJKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:10:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347713AbiBUJJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:09:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255A7D6D;
        Mon, 21 Feb 2022 01:01:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0821B80EB5;
        Mon, 21 Feb 2022 09:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD40C340F1;
        Mon, 21 Feb 2022 09:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434089;
        bh=Zt9qi23eS8zYLN+BEhLKUBkGlfrKDNwe6e4w79x+CEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQ5BjT3/HH4Vs9VQQ/08GHKYGz/d+346gq9cImUXrEIyq4LAe2XJfkM7K6uVhfFEz
         EV+E/rq3+guX4SrUaq653phpshHwHFoeoWdv6wGz2AL6uC5QHwf+LtmdeRkUzLbbCK
         cpHFvBO6BFM7ev/jVMMh0oQq0hCr7V1ib3BV+8NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.10 001/121] drm/nouveau/pmu/gm200-: use alternate falcon reset sequence
Date:   Mon, 21 Feb 2022 09:48:13 +0100
Message-Id: <20220221084921.195979565@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

commit 4cdd2450bf739bada353e82d27b00db9af8c3001 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://gitlab.freedesktop.org/drm/nouveau/-/merge_requests/10
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/falcon/base.c      |    8 ++++--
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c |   31 +++++++++++++++++++++++-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c |    2 -
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c |    2 -
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c |    2 -
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h  |    2 +
 6 files changed, 41 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/falcon/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/base.c
@@ -119,8 +119,12 @@ nvkm_falcon_disable(struct nvkm_falcon *
 int
 nvkm_falcon_reset(struct nvkm_falcon *falcon)
 {
-	nvkm_falcon_disable(falcon);
-	return nvkm_falcon_enable(falcon);
+	if (!falcon->func->reset) {
+		nvkm_falcon_disable(falcon);
+		return nvkm_falcon_enable(falcon);
+	}
+
+	return falcon->func->reset(falcon);
 }
 
 int
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c
@@ -23,9 +23,38 @@
  */
 #include "priv.h"
 
+static int
+gm200_pmu_flcn_reset(struct nvkm_falcon *falcon)
+{
+	struct nvkm_pmu *pmu = container_of(falcon, typeof(*pmu), falcon);
+
+	nvkm_falcon_wr32(falcon, 0x014, 0x0000ffff);
+	pmu->func->reset(pmu);
+	return nvkm_falcon_enable(falcon);
+}
+
+const struct nvkm_falcon_func
+gm200_pmu_flcn = {
+	.debug = 0xc08,
+	.fbif = 0xe00,
+	.load_imem = nvkm_falcon_v1_load_imem,
+	.load_dmem = nvkm_falcon_v1_load_dmem,
+	.read_dmem = nvkm_falcon_v1_read_dmem,
+	.bind_context = nvkm_falcon_v1_bind_context,
+	.wait_for_halt = nvkm_falcon_v1_wait_for_halt,
+	.clear_interrupt = nvkm_falcon_v1_clear_interrupt,
+	.set_start_addr = nvkm_falcon_v1_set_start_addr,
+	.start = nvkm_falcon_v1_start,
+	.enable = nvkm_falcon_v1_enable,
+	.disable = nvkm_falcon_v1_disable,
+	.reset = gm200_pmu_flcn_reset,
+	.cmdq = { 0x4a0, 0x4b0, 4 },
+	.msgq = { 0x4c8, 0x4cc, 0 },
+};
+
 static const struct nvkm_pmu_func
 gm200_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gf100_pmu_enabled,
 	.reset = gf100_pmu_reset,
 };
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
@@ -211,7 +211,7 @@ gm20b_pmu_recv(struct nvkm_pmu *pmu)
 
 static const struct nvkm_pmu_func
 gm20b_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gf100_pmu_enabled,
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
@@ -39,7 +39,7 @@ gp102_pmu_enabled(struct nvkm_pmu *pmu)
 
 static const struct nvkm_pmu_func
 gp102_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gp102_pmu_enabled,
 	.reset = gp102_pmu_reset,
 };
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
@@ -78,7 +78,7 @@ gp10b_pmu_acr = {
 
 static const struct nvkm_pmu_func
 gp10b_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gf100_pmu_enabled,
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
@@ -44,6 +44,8 @@ void gf100_pmu_reset(struct nvkm_pmu *);
 
 void gk110_pmu_pgob(struct nvkm_pmu *, bool);
 
+extern const struct nvkm_falcon_func gm200_pmu_flcn;
+
 void gm20b_pmu_acr_bld_patch(struct nvkm_acr *, u32, s64);
 void gm20b_pmu_acr_bld_write(struct nvkm_acr *, u32, struct nvkm_acr_lsfw *);
 int gm20b_pmu_acr_boot(struct nvkm_falcon *);


