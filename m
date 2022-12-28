Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A75D658404
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiL1QyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbiL1QxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:53:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B521C126
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:48:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6A0160D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3274C433F0;
        Wed, 28 Dec 2022 16:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246118;
        bh=RfH9LmeSmRyUFA/u+LvjDwVJ2qp3eFFU8aKEIPlYbZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIxFUfH2y9HOHxCR1Hguvlaurl4CrVho7XjXuU6GWAY0UKSDO9zQfj1YsP4F0hN5t
         FGtSbfKLwlucdn1glE2YgAhcswMaiVZLYxFSIwFUK8+srCpt0yBtvYA0BhYMBu5jNF
         PrfPSwRlAj53L+e8NjbUOU7rV843gaeYptuSVTjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1015/1073] drm/amd/pm: avoid large variable on kernel stack
Date:   Wed, 28 Dec 2022 15:43:23 +0100
Message-Id: <20221228144355.744437544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d118b18fb1da02b41df2da78cb2794b3638d89cd ]

The activity_monitor_external[] array is too big to fit on the
kernel stack, resulting in this warning with clang:

drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_7_ppt.c:1438:12: error: stack frame size (1040) exceeds limit (1024) in 'smu_v13_0_7_get_power_profile_mode' [-Werror,-Wframe-larger-than]

Use dynamic allocation instead. It should also be possible to
have single element here instead of the array, but this seems
easier.

v2: fix up argument to sizeof() (Alex)

Fixes: 334682ae8151 ("drm/amd/pm: enable workload type change on smu_v13_0_7")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index d74debc584f8..39deb06a86ba 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1436,7 +1436,7 @@ static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
 
 static int smu_v13_0_7_get_power_profile_mode(struct smu_context *smu, char *buf)
 {
-	DpmActivityMonitorCoeffIntExternal_t activity_monitor_external[PP_SMC_POWER_PROFILE_COUNT];
+	DpmActivityMonitorCoeffIntExternal_t *activity_monitor_external;
 	uint32_t i, j, size = 0;
 	int16_t workload_type = 0;
 	int result = 0;
@@ -1444,6 +1444,12 @@ static int smu_v13_0_7_get_power_profile_mode(struct smu_context *smu, char *buf
 	if (!buf)
 		return -EINVAL;
 
+	activity_monitor_external = kcalloc(PP_SMC_POWER_PROFILE_COUNT,
+					    sizeof(*activity_monitor_external),
+					    GFP_KERNEL);
+	if (!activity_monitor_external)
+		return -ENOMEM;
+
 	size += sysfs_emit_at(buf, size, "                              ");
 	for (i = 0; i <= PP_SMC_POWER_PROFILE_WINDOW3D; i++)
 		size += sysfs_emit_at(buf, size, "%-14s%s", amdgpu_pp_profile_name[i],
@@ -1456,15 +1462,17 @@ static int smu_v13_0_7_get_power_profile_mode(struct smu_context *smu, char *buf
 		workload_type = smu_cmn_to_asic_specific_index(smu,
 							       CMN2ASIC_MAPPING_WORKLOAD,
 							       i);
-		if (workload_type < 0)
-			return -EINVAL;
+		if (workload_type < 0) {
+			result = -EINVAL;
+			goto out;
+		}
 
 		result = smu_cmn_update_table(smu,
 					  SMU_TABLE_ACTIVITY_MONITOR_COEFF, workload_type,
 					  (void *)(&activity_monitor_external[i]), false);
 		if (result) {
 			dev_err(smu->adev->dev, "[%s] Failed to get activity monitor!", __func__);
-			return result;
+			goto out;
 		}
 	}
 
@@ -1492,7 +1500,10 @@ do {													\
 	PRINT_DPM_MONITOR(Fclk_BoosterFreq);
 #undef PRINT_DPM_MONITOR
 
-	return size;
+	result = size;
+out:
+	kfree(activity_monitor_external);
+	return result;
 }
 
 static int smu_v13_0_7_set_power_profile_mode(struct smu_context *smu, long *input, uint32_t size)
-- 
2.35.1



