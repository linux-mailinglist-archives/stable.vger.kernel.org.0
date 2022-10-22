Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974726089E3
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiJVIns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbiJVImi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:42:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24902E8D8B;
        Sat, 22 Oct 2022 01:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A2FBB82E13;
        Sat, 22 Oct 2022 08:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B630AC433D6;
        Sat, 22 Oct 2022 08:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425919;
        bh=k1aIw9YxKECaGaO2jmbXqWliP/zH74AICWyaTZxJlzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeHrdDuwZaQBDX6YjEHvPj32brHotlhPh/knXgM7Z2jVGigQrNig2Y7gBr0E/dVhG
         b0fcbVB9klOKnGjlLhJSv0yh0IpNoVMzytWwNzjv2kitdlpqunODbjAs4rqUDNJEz1
         lI91QbfCXcXfudiAMzJFGYR+YP7XeXJOs32p3aQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ellis Michael <ellis@ellismichael.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Graham Sider <Graham.Sider@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 628/717] drm/amdkfd: Fix UBSAN shift-out-of-bounds warning
Date:   Sat, 22 Oct 2022 09:28:27 +0200
Message-Id: <20221022072526.233866903@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e1797657b04c..7d3fc5849466 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1232,6 +1232,24 @@ static void init_interrupts(struct device_queue_manager *dqm)
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
@@ -1260,11 +1278,7 @@ static int initialize_nocpsch(struct device_queue_manager *dqm)
 
 	memset(dqm->vmid_pasid, 0, sizeof(dqm->vmid_pasid));
 
-	dqm->sdma_bitmap = ~0ULL >> (64 - get_num_sdma_queues(dqm));
-	dqm->sdma_bitmap &= ~(get_reserved_sdma_queues_bitmap(dqm));
-	pr_info("sdma_bitmap: %llx\n", dqm->sdma_bitmap);
-
-	dqm->xgmi_sdma_bitmap = ~0ULL >> (64 - get_num_xgmi_sdma_queues(dqm));
+	init_sdma_bitmaps(dqm);
 
 	return 0;
 }
@@ -1442,9 +1456,6 @@ static int set_sched_resources(struct device_queue_manager *dqm)
 
 static int initialize_cpsch(struct device_queue_manager *dqm)
 {
-	uint64_t num_sdma_queues;
-	uint64_t num_xgmi_sdma_queues;
-
 	pr_debug("num of pipes: %d\n", get_pipes_per_mec(dqm));
 
 	mutex_init(&dqm->lock_hidden);
@@ -1453,24 +1464,10 @@ static int initialize_cpsch(struct device_queue_manager *dqm)
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



