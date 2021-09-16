Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3725840E7FE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244147AbhIPRne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354334AbhIPRjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29C261A81;
        Thu, 16 Sep 2021 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811046;
        bh=BJ5jpffpZV24DZA1GQvEEw0dm+XQ1zpkg6i3g/vhDS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEgQSvRNvVvUZusD5QGz97xiT13OVuFG3u7b08OfY4kZU7/sITkNRLpOjDeWyKqnk
         IoIuCcIX8/+F2BzGcow2jpQs4Wt3LZfvjBg4Kqqkf69Z7FXF9+CDbs9MgW3A/S+2C7
         z1q4LsH81H4/WyYwqmcFAhuoUtXV7d1stCyBgjAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Keely <Sean.Keely@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 363/432] drm/amdkfd: Account for SH/SE count when setting up cu masks.
Date:   Thu, 16 Sep 2021 18:01:52 +0200
Message-Id: <20210916155823.112701549@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Keely <Sean.Keely@amd.com>

[ Upstream commit 1ec06c2dee679e9f089e78ed20cb74ee90155f61 ]

On systems with multiple SH per SE compute_static_thread_mgmt_se#
is split into independent masks, one for each SH, in the upper and
lower 16 bits.  We need to detect this and apply cu masking to each
SH.  The cu mask bits are assigned first to each SE, then to
alternate SHs, then finally to higher CU id.  This ensures that
the maximum number of SPIs are engaged as early as possible while
balancing CU assignment to each SH.

v2: Use max SH/SE rather than max SH in cu_per_sh.

v3: Fix comment blocks, ensure se_mask is initially zero filled,
    and correctly assign se.sh.cu positions to unset bits in cu_mask.

Signed-off-by: Sean Keely <Sean.Keely@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c | 84 +++++++++++++++-----
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h |  1 +
 2 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
index 88813dad731f..c021519af810 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
@@ -98,36 +98,78 @@ void mqd_symmetrically_map_cu_mask(struct mqd_manager *mm,
 		uint32_t *se_mask)
 {
 	struct kfd_cu_info cu_info;
-	uint32_t cu_per_se[KFD_MAX_NUM_SE] = {0};
-	int i, se, sh, cu = 0;
-
+	uint32_t cu_per_sh[KFD_MAX_NUM_SE][KFD_MAX_NUM_SH_PER_SE] = {0};
+	int i, se, sh, cu;
 	amdgpu_amdkfd_get_cu_info(mm->dev->kgd, &cu_info);
 
 	if (cu_mask_count > cu_info.cu_active_number)
 		cu_mask_count = cu_info.cu_active_number;
 
+	/* Exceeding these bounds corrupts the stack and indicates a coding error.
+	 * Returning with no CU's enabled will hang the queue, which should be
+	 * attention grabbing.
+	 */
+	if (cu_info.num_shader_engines > KFD_MAX_NUM_SE) {
+		pr_err("Exceeded KFD_MAX_NUM_SE, chip reports %d\n", cu_info.num_shader_engines);
+		return;
+	}
+	if (cu_info.num_shader_arrays_per_engine > KFD_MAX_NUM_SH_PER_SE) {
+		pr_err("Exceeded KFD_MAX_NUM_SH, chip reports %d\n",
+			cu_info.num_shader_arrays_per_engine * cu_info.num_shader_engines);
+		return;
+	}
+	/* Count active CUs per SH.
+	 *
+	 * Some CUs in an SH may be disabled.	HW expects disabled CUs to be
+	 * represented in the high bits of each SH's enable mask (the upper and lower
+	 * 16 bits of se_mask) and will take care of the actual distribution of
+	 * disabled CUs within each SH automatically.
+	 * Each half of se_mask must be filled only on bits 0-cu_per_sh[se][sh]-1.
+	 *
+	 * See note on Arcturus cu_bitmap layout in gfx_v9_0_get_cu_info.
+	 */
 	for (se = 0; se < cu_info.num_shader_engines; se++)
 		for (sh = 0; sh < cu_info.num_shader_arrays_per_engine; sh++)
-			cu_per_se[se] += hweight32(cu_info.cu_bitmap[se % 4][sh + (se / 4)]);
-
-	/* Symmetrically map cu_mask to all SEs:
-	 * cu_mask[0] bit0 -> se_mask[0] bit0;
-	 * cu_mask[0] bit1 -> se_mask[1] bit0;
-	 * ... (if # SE is 4)
-	 * cu_mask[0] bit4 -> se_mask[0] bit1;
+			cu_per_sh[se][sh] = hweight32(cu_info.cu_bitmap[se % 4][sh + (se / 4)]);
+
+	/* Symmetrically map cu_mask to all SEs & SHs:
+	 * se_mask programs up to 2 SH in the upper and lower 16 bits.
+	 *
+	 * Examples
+	 * Assuming 1 SH/SE, 4 SEs:
+	 * cu_mask[0] bit0 -> se_mask[0] bit0
+	 * cu_mask[0] bit1 -> se_mask[1] bit0
+	 * ...
+	 * cu_mask[0] bit4 -> se_mask[0] bit1
+	 * ...
+	 *
+	 * Assuming 2 SH/SE, 4 SEs
+	 * cu_mask[0] bit0 -> se_mask[0] bit0 (SE0,SH0,CU0)
+	 * cu_mask[0] bit1 -> se_mask[1] bit0 (SE1,SH0,CU0)
+	 * ...
+	 * cu_mask[0] bit4 -> se_mask[0] bit16 (SE0,SH1,CU0)
+	 * cu_mask[0] bit5 -> se_mask[1] bit16 (SE1,SH1,CU0)
+	 * ...
+	 * cu_mask[0] bit8 -> se_mask[0] bit1 (SE0,SH0,CU1)
 	 * ...
+	 *
+	 * First ensure all CUs are disabled, then enable user specified CUs.
 	 */
-	se = 0;
-	for (i = 0; i < cu_mask_count; i++) {
-		if (cu_mask[i / 32] & (1 << (i % 32)))
-			se_mask[se] |= 1 << cu;
-
-		do {
-			se++;
-			if (se == cu_info.num_shader_engines) {
-				se = 0;
-				cu++;
+	for (i = 0; i < cu_info.num_shader_engines; i++)
+		se_mask[i] = 0;
+
+	i = 0;
+	for (cu = 0; cu < 16; cu++) {
+		for (sh = 0; sh < cu_info.num_shader_arrays_per_engine; sh++) {
+			for (se = 0; se < cu_info.num_shader_engines; se++) {
+				if (cu_per_sh[se][sh] > cu) {
+					if (cu_mask[i / 32] & (1 << (i % 32)))
+						se_mask[se] |= 1 << (cu + sh * 16);
+					i++;
+					if (i == cu_mask_count)
+						return;
+				}
 			}
-		} while (cu >= cu_per_se[se] && cu < 32);
+		}
 	}
 }
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
index b5e2ea7550d4..6e6918ccedfd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
@@ -27,6 +27,7 @@
 #include "kfd_priv.h"
 
 #define KFD_MAX_NUM_SE 8
+#define KFD_MAX_NUM_SH_PER_SE 2
 
 /**
  * struct mqd_manager
-- 
2.30.2



