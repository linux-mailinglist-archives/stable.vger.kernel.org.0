Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AA253835A
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239921AbiE3Ocz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242542AbiE3ObR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F82212C95A;
        Mon, 30 May 2022 06:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F15A160FA9;
        Mon, 30 May 2022 13:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A2BC3411A;
        Mon, 30 May 2022 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918764;
        bh=7FQ9dFAbfLF1xAX2WYU0zqhOLcJvn+BST6o5QtsQMfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9F7a+XhdWDzboEabe+tLstnrzPeyXJG/SugNYUzI9K363vBBjdzCLP088cFyRJt/
         sbNevqPiOO4saxrZ9KDSC9xjJ+t8eq6K/KaX+VElEv9bipDO84qr3L66sKTu82t8D5
         rWxCiQ0wRrqqPzB9NNhG9fNyJkX4OumyBcw6HY/3ackiwanCe5u69wQ1oVgZmFg307
         Efo7hgmXaZ9dyPjKYAd4HhJS1AY17ytX5SF2OnB9J81bSd4Xm3Ap6Y0ubG0qsH7OiH
         JLXFlCuUsBzIETX/PIbAt/JyMPP4MDhGZGou0mrxGjuRiDifdH7PLmWInw4JnXRC9B
         qBdkNT6GQWEUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>, kernel test robot <lkp@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 12/24] drm/amd/pm: fix the compile warning
Date:   Mon, 30 May 2022 09:51:59 -0400
Message-Id: <20220530135211.1937674-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530135211.1937674-1-sashal@kernel.org>
References: <20220530135211.1937674-1-sashal@kernel.org>
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
index f61c489e5f6d..81f1591a9be9 100644
--- a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
+++ b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
@@ -1617,19 +1617,7 @@ static int kv_update_samu_dpm(struct amdgpu_device *adev, bool gate)
 
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

