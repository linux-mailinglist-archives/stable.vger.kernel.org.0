Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759325A05D6
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiHYBgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiHYBfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:35:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB3795ADF;
        Wed, 24 Aug 2022 18:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E76ED61A2D;
        Thu, 25 Aug 2022 01:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85C5C433D6;
        Thu, 25 Aug 2022 01:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391324;
        bh=yCoyTheYT8qpcJ15sxdjnDuOVcCdfCqJTt4MqmhGzWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1L/8UzH+I+Wz+Pr6Zcke5Gn/D4qdfENRDkIM8zC1S4DtMEjI2lpsF0o8/CkR8y4A
         6TZA/fCg/MLq64Ve1hP6TF1cszmaoqG6NzOc2vRvhefqBBHrr08h3MrOzqNNEUrIRT
         CtCPeE/+spSnGK1tlGeWVEdVbmr70Nx+vISOFi6LFeHYjrptIL2WpAN2NTmnVRhArc
         bDztCwWSBKGbkiN6Vp0iqCf9cas9R79TFsozinW58E7HbZgHFMZG2+xzN3lVJfBLnp
         JJUT1KubWZqvHVpiYq+JwRUkz90QQc1yH84JODCYkLVhdINW1B/v6mPOCn9XazDC/A
         DpG1NcPCCE/HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Ni <nizhen@uniontech.com>, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        ray.huang@amd.com, tim.huang@amd.com, yifan1.zhang@amd.com,
        lang.yu@amd.com, Perry.Yuan@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 14/38] drm/amd/pm: Fix a potential gpu_metrics_table memory leak
Date:   Wed, 24 Aug 2022 21:33:37 -0400
Message-Id: <20220825013401.22096-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Zhen Ni <nizhen@uniontech.com>

[ Upstream commit 5afb76522a0af0513b6dc01f84128a73206b051b ]

Memory is allocated for gpu_metrics_table in
smu_v13_0_4_init_smc_tables(), but not freed in
smu_v13_0_4_fini_smc_tables(). This may cause memory leaks, fix it.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Zhen Ni <nizhen@uniontech.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
index 5a17b51aa0f9..7df360c25d51 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
@@ -190,6 +190,9 @@ static int smu_v13_0_4_fini_smc_tables(struct smu_context *smu)
 	kfree(smu_table->watermarks_table);
 	smu_table->watermarks_table = NULL;
 
+	kfree(smu_table->gpu_metrics_table);
+	smu_table->gpu_metrics_table = NULL;
+
 	return 0;
 }
 
-- 
2.35.1

