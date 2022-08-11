Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD8D59007E
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiHKPlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiHKPkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:40:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D538A6E2;
        Thu, 11 Aug 2022 08:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B990B6164A;
        Thu, 11 Aug 2022 15:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F19DC433B5;
        Thu, 11 Aug 2022 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232174;
        bh=3WO1X/r96fVsa2TO+JzUldSo6EvsERimnvGpjqkZ4pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuO4RWeN8Z6N8ieq5f8QWfzCrdoZHUb5nbW9p50BWnSyPO1dMhee1Uddvh4XA8kua
         r/rdUD+Ih4AP4ut46ecTE3uOh5gbAHHbRda/+HKZ5IsSX7U5A8mmjKrcIyA7PrM0IE
         PKLO4mWyC03tXvy5EARJ8DWb3lp4cB7F405XUV5jHKad9ZjAguorilqU86YwlMHZFu
         LWNUqDwMnz4nUqhpXMWb7/xGEYrOzGsigIFsCWLh1OCNfwbOkjMxLGh7gzDl/Vf5fW
         k8dRcCTH7HNEMSwmu1BOu1e/SNul8/DVFX21NpUtPSvo/EOSLLKSpFrJCFXndeO9fP
         gmH46MqmZubEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xinhui pan <xinhui.pan@amd.com>, Philip Yang <Philip.Yang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Felix.Kuehling@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 064/105] drm/amdgpu: Fix one list corruption when create queue fails
Date:   Thu, 11 Aug 2022 11:27:48 -0400
Message-Id: <20220811152851.1520029-64-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit cc3cb791f19ad0c4f951f38c98aa513b042ab329 ]

Queue would be freed when create_queue_cpsch fails
So lets do queue cleanup otherwise various list and memory issues
happen.

Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index e017b4240472..06417c7abca4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1666,14 +1666,13 @@ static int create_queue_cpsch(struct device_queue_manager *dqm, struct queue *q,
 	if (q->properties.is_active) {
 		increment_queue_count(dqm, qpd, q);
 
-		if (!dqm->dev->shared_resources.enable_mes) {
+		if (!dqm->dev->shared_resources.enable_mes)
 			retval = execute_queues_cpsch(dqm,
-					     KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
-		} else {
+					KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
+		else
 			retval = add_queue_mes(dqm, q, qpd);
-			if (retval)
-				goto cleanup_queue;
-		}
+		if (retval)
+			goto cleanup_queue;
 	}
 
 	/*
-- 
2.35.1

