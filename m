Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D276DEE0F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjDLIjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjDLIjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1336EA5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C87A46300C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78A1C433D2;
        Wed, 12 Apr 2023 08:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288624;
        bh=wCvjPwQ/isy/0PMDVZFcUXo3lTVoQtGdjn7ZpjYmpoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0RxCdF1znYVd7jSF7R63vrry88wKhCrEK76Cetgm+OrOL07jIN0jQXAZYZyTUkeF
         QmqWGPXOJEtQOtY0bHTJ9kuu/Y/F1yEBguWb0cB5xP+9hwpDySSiEyXvLzePPtPz5v
         A8zwbQeMM8PEQzsDxHWTfGGXWUhB9ZRvoXKung6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/93] drm/amdgpu: fix amdgpu_job_free_resources v2
Date:   Wed, 12 Apr 2023 10:33:22 +0200
Message-Id: <20230412082823.954152927@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 1427a720273976a81d13d9d9fa60d53ce881cbd7 ]

It can be that neither fence were initialized when we run out of UVD
streams for example.

v2: fix typo breaking compile

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2324
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index de29518673dd3..90a83aaa9908c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -135,8 +135,14 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 	else
 		hw_fence = &job->hw_fence;
 
-	/* use sched fence if available */
-	f = job->base.s_fence ? &job->base.s_fence->finished : hw_fence;
+	/* Check if any fences where initialized */
+	if (job->base.s_fence && job->base.s_fence->finished.ops)
+		f = &job->base.s_fence->finished;
+	else if (job->hw_fence.ops)
+		f = &job->hw_fence;
+	else
+		f = NULL;
+
 	for (i = 0; i < job->num_ibs; ++i)
 		amdgpu_ib_free(ring->adev, &job->ibs[i], f);
 }
-- 
2.39.2



