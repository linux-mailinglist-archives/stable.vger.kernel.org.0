Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B495382C7
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbiE3O20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241637AbiE3O0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:26:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B04AF1ED;
        Mon, 30 May 2022 06:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF4EFCE106D;
        Mon, 30 May 2022 13:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE358C385B8;
        Mon, 30 May 2022 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918614;
        bh=7hOF5LIIgA8H9rcX73Ms/bkqSJE6g5sOxsMKbPqpvmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvIWJHg0i+0RoLzcQYu/uXbkz/Q587It8ttCFeM2/IEF3B1SzXZjtJ78h6/0Dhz+/
         XFI6DC1IWwAzT2YVRhyB7yjdzSj/cr9svA5Ihfw0Ad2xsdWTF8ElmjWMdCe8cbO4x3
         HOL7fy0lO+1QED8tq+ep+0IrJK2O2gdg2LnV2UY7NpUr6MEVOiMWTKpgsN1w/fbvGk
         XowLqcT0+KgLmC7hIBgTuu0cCnqQCB8cQApa1JR+Anv8sIk+V7xveIm9duqDco6wUv
         P+7DXaHss8tCohOVP6JVGYtsCeKOppBhW3x3KzsRIupgVlY3cNOMhl4s6s/NXhmJ26
         sjL40KdyGvapg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>, kernel test robot <lkp@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 19/38] drm/amd/pm: fix the compile warning
Date:   Mon, 30 May 2022 09:49:05 -0400
Message-Id: <20220530134924.1936816-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134924.1936816-1-sashal@kernel.org>
References: <20220530134924.1936816-1-sashal@kernel.org>
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

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 555238d92ac32dbad2d77ad2bafc48d17391990c ]

Fix the compile warning below:
drivers/gpu/drm/amd/amdgpu/../pm/legacy-dpm/kv_dpm.c:1641
kv_get_acp_boot_level() warn: always true condition '(table->entries[i]->clk >= 0) => (0-u32max >= 0)'

Reported-by: kernel test robot <lkp@intel.com>
CC: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/kv_dpm.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
index cb79a93c2eb7..91504eccc60c 100644
--- a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
+++ b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
@@ -1610,19 +1610,7 @@ static int kv_update_samu_dpm(struct amdgpu_device *adev, bool gate)
 
 static u8 kv_get_acp_boot_level(struct amdgpu_device *adev)
 {
-	u8 i;
-	struct amdgpu_clock_voltage_dependency_table *table =
-		&adev->pm.dpm.dyn_state.acp_clock_voltage_dependency_table;
-
-	for (i = 0; i < table->count; i++) {
-		if (table->entries[i].clk >= 0) /* XXX */
-			break;
-	}
-
-	if (i >= table->count)
-		i = table->count - 1;
-
-	return i;
+	return 0;
 }
 
 static void kv_update_acp_boot_level(struct amdgpu_device *adev)
-- 
2.35.1

