Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1152F5F9532
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiJJARD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiJJAQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:16:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05620EE1C;
        Sun,  9 Oct 2022 16:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DB7B80C74;
        Sun,  9 Oct 2022 23:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36541C4347C;
        Sun,  9 Oct 2022 23:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359541;
        bh=N4wF+6kGYuK5CrjAuFfYgXmfcNsLOqTRoXjZk208taQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gji+owdJICRWUnidW+w9LvU9kkWPjH7y2MNRdPR8T5CVjpVup4lUMnNxm2vfsjkBx
         oYdaNI2BhcNDHvznpMLutdnt6DplITVWG6wUaYODxRiO/Fa9wF+Hv08rgqrpOEKgdk
         ya33fyCsnl5DcLCwsslfI5pn6OQs24jNYFI/3hnwv2CCcD2/P3Q49UuX1eoraHfs3q
         3vPjikiXI9eDDGofS9gTumgoocQfPe5JqzGi8QneSf2CXUbPgFmHEzyi55fkaKcr1f
         3VPIe6gw7j/IifWTb9FtXhBk2TziI7H1K22RiBgzv4PdjciIR0W0AvAynOMKhd//kR
         eBm4ird5G9heQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Ellis Michael <ellis@ellismichael.com>,
        Graham Sider <Graham.Sider@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 44/44] drm/amdkfd: Fix UBSAN shift-out-of-bounds warning
Date:   Sun,  9 Oct 2022 19:49:32 -0400
Message-Id: <20221009234932.1230196-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit b292cafe2dd02d96a07147e4b160927e8399d5cc ]

This was fixed in initialize_cpsch before, but not in initialize_nocpsch.
Factor sdma bitmap initialization into a helper function to apply the
correct implementation in both cases without duplicating it.

v2: Added a range check

Reported-by: Ellis Michael <ellis@ellismichael.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Graham Sider <Graham.Sider@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 45 +++++++++----------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 007a3db69df1..ecb4c3abc629 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1242,6 +1242,24 @@ static void init_interrupts(struct device_queue_manager *dqm)
 			dqm->dev->kfd2kgd->init_interrupts(dqm->dev->adev, i);
 }
 
+static void init_sdma_bitmaps(struct device_queue_manager *dqm)
+{
+	unsigned int num_sdma_queues =
+		min_t(unsigned int, sizeof(dqm->sdma_bitmap)*8,
+		      get_num_sdma_queues(dqm));
+	unsigned int num_xgmi_sdma_queues =
+		min_t(unsigned int, sizeof(dqm->xgmi_sdma_bitmap)*8,
+		      get_num_xgmi_sdma_queues(dqm));
+
+	if (num_sdma_queues)
+		dqm->sdma_bitmap = GENMASK_ULL(num_sdma_queues-1, 0);
+	if (num_xgmi_sdma_queues)
+		dqm->xgmi_sdma_bitmap = GENMASK_ULL(num_xgmi_sdma_queues-1, 0);
+
+	dqm->sdma_bitmap &= ~get_reserved_sdma_queues_bitmap(dqm);
+	pr_info("sdma_bitmap: %llx\n", dqm->sdma_bitmap);
+}
+
 static int initialize_nocpsch(struct device_queue_manager *dqm)
 {
 	int pipe, queue;
@@ -1270,11 +1288,7 @@ static int initialize_nocpsch(struct device_queue_manager *dqm)
 
 	memset(dqm->vmid_pasid, 0, sizeof(dqm->vmid_pasid));
 
-	dqm->sdma_bitmap = ~0ULL >> (64 - get_num_sdma_queues(dqm));
-	dqm->sdma_bitmap &= ~(get_reserved_sdma_queues_bitmap(dqm));
-	pr_info("sdma_bitmap: %llx\n", dqm->sdma_bitmap);
-
-	dqm->xgmi_sdma_bitmap = ~0ULL >> (64 - get_num_xgmi_sdma_queues(dqm));
+	init_sdma_bitmaps(dqm);
 
 	return 0;
 }
@@ -1452,9 +1466,6 @@ static int set_sched_resources(struct device_queue_manager *dqm)
 
 static int initialize_cpsch(struct device_queue_manager *dqm)
 {
-	uint64_t num_sdma_queues;
-	uint64_t num_xgmi_sdma_queues;
-
 	pr_debug("num of pipes: %d\n", get_pipes_per_mec(dqm));
 
 	mutex_init(&dqm->lock_hidden);
@@ -1463,24 +1474,10 @@ static int initialize_cpsch(struct device_queue_manager *dqm)
 	dqm->active_cp_queue_count = 0;
 	dqm->gws_queue_count = 0;
 	dqm->active_runlist = false;
-
-	num_sdma_queues = get_num_sdma_queues(dqm);
-	if (num_sdma_queues >= BITS_PER_TYPE(dqm->sdma_bitmap))
-		dqm->sdma_bitmap = ULLONG_MAX;
-	else
-		dqm->sdma_bitmap = (BIT_ULL(num_sdma_queues) - 1);
-
-	dqm->sdma_bitmap &= ~(get_reserved_sdma_queues_bitmap(dqm));
-	pr_info("sdma_bitmap: %llx\n", dqm->sdma_bitmap);
-
-	num_xgmi_sdma_queues = get_num_xgmi_sdma_queues(dqm);
-	if (num_xgmi_sdma_queues >= BITS_PER_TYPE(dqm->xgmi_sdma_bitmap))
-		dqm->xgmi_sdma_bitmap = ULLONG_MAX;
-	else
-		dqm->xgmi_sdma_bitmap = (BIT_ULL(num_xgmi_sdma_queues) - 1);
-
 	INIT_WORK(&dqm->hw_exception_work, kfd_process_hw_exception);
 
+	init_sdma_bitmaps(dqm);
+
 	return 0;
 }
 
-- 
2.35.1

