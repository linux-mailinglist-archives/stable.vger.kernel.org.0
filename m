Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83765A05CC
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiHYBfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiHYBfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:35:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4797C80E89;
        Wed, 24 Aug 2022 18:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E886192F;
        Thu, 25 Aug 2022 01:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2281EC433D7;
        Thu, 25 Aug 2022 01:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391313;
        bh=zApxLZkGQgIiEAl0cKBA5wYfrmSWkqkobdRgh6WknAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENkruvkYKuYRcNAvn2BDAIooTPZNil1Y13HAbmqXtnw9Bo+3fVZMOABEXjxeLRECq
         Mdh2XbT8C3wvU2/6f5cWpWDYHirRQkFkK9slEHuQC7o6FxpwSKjw+KAy1Gol2L0YYg
         9IcBMcpx0O9t1ornS3AxfIkqHVsm5KrM00OMZXlK/0eMuPN+gVzuBhs7Nj8L6FKIpG
         hs6uVyAI1lSHTRPUe2fVn9WHrsftylz1o7iq+Rn9hVpO0SZWw5UMZh1g/WVDRJjClp
         /RlYbTNhd0EuIklDJhGfoavHbTL2BPMpBrKFyDIHo3GMDCJryfTl83R6Iu3wlyf5e5
         N9yW+o9Owf8EA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>, Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Hawking.Zhang@amd.com, lijo.lazar@amd.com,
        mario.limonciello@amd.com, tim.huang@amd.com, tao.zhou1@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 12/38] drm/amd/pm: skip pptable override for smu_v13_0_7
Date:   Wed, 24 Aug 2022 21:33:35 -0400
Message-Id: <20220825013401.22096-12-sashal@kernel.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 4e64b529c5b04e7944b41de554ee686ecab00744 ]

skip pptable override for smu_v13_0_7 secure boards only.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 5aa08c031f72..1d8a9e5b3cc0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -203,6 +203,9 @@ int smu_v13_0_init_pptable_microcode(struct smu_context *smu)
 	if (!adev->scpm_enabled)
 		return 0;
 
+	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 7))
+		return 0;
+
 	/* override pptable_id from driver parameter */
 	if (amdgpu_smu_pptable_id >= 0) {
 		pptable_id = amdgpu_smu_pptable_id;
@@ -210,13 +213,6 @@ int smu_v13_0_init_pptable_microcode(struct smu_context *smu)
 	} else {
 		pptable_id = smu->smu_table.boot_values.pp_table_id;
 
-		if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 7) &&
-			pptable_id == 3667)
-			pptable_id = 36671;
-
-		if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 7) &&
-			pptable_id == 3688)
-			pptable_id = 36881;
 		/*
 		 * Temporary solution for SMU V13.0.0 with SCPM enabled:
 		 *   - use 36831 signed pptable when pp_table_id is 3683
-- 
2.35.1

