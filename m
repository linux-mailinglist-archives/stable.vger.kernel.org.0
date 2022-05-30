Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AFF537C24
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbiE3NbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbiE3NaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805F58CB26;
        Mon, 30 May 2022 06:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22E8A60EA5;
        Mon, 30 May 2022 13:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A931C3411A;
        Mon, 30 May 2022 13:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917238;
        bh=4Ka0zqH5BPXKlynHTbbm9h1V2CMI319SCy/R6j+8HWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgcAgxtTBWnpSoDE7hm0GapGsQK6NbsnaYK6bN11VSZ51bm3iE+upRjbnoXiW53uR
         DXl5IHxznec3sDO+wmC354UbVZGQsceaJaqsIJAnTtXpSV9UXjiR0izTuKUOQvY+S4
         +Drp5ZufUmeelPWVjEPTlUZk7slR7C1L76LirOnTkyghmVtvfKIQmbsfspBr8vux04
         vlBrKAYIVOtXweRrR9rO+4A+1CBNKT55oHiZ4vMVn4H/NNH0sRGZwFg2qPfsrpibmz
         3Gq7zo0hJJzqLxoGj/5IPqTTTg+bh6vcRvj7nIAJr3+9SUFirtEFIJQXWU59AWEFUl
         l3sAeKF9UdeSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>, kernel test robot <lkp@intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        lijo.lazar@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 067/159] drm/amd/pm: fix the compile warning
Date:   Mon, 30 May 2022 09:22:52 -0400
Message-Id: <20220530132425.1929512-67-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
index 8b23cc9f098a..8fd0782a2b20 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
@@ -1623,19 +1623,7 @@ static int kv_update_samu_dpm(struct amdgpu_device *adev, bool gate)
 
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

