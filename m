Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E349553829D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239632AbiE3OYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbiE3OXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0D0A7E2E;
        Mon, 30 May 2022 06:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0117060FEE;
        Mon, 30 May 2022 13:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8E0C385B8;
        Mon, 30 May 2022 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918593;
        bh=aLylDdqT0NTqM4D2n1JKqFVOODdcHs+kgtWOg5yMgK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tva/PpC+kOrXkJzgFbpo1HvW37ZFUyZgRZdD6kmnrPs8E2ccmPCaSIqakK1fjKir9
         hUmAmgFDBGXOX6+RGG3upGUZ70oawOunIG7VwJ4sjU3qE1NR4OZiQeykQfLRXmyx3t
         K2Xir4MjUqKEgEU4NzoWPcBHGWS3Zi8bualXqVL//HwPZVMIKmjaV4/KHXVZR/7eWY
         QlNo/OTbC5xjbPXm+S0PSWDbXpHg0RUNM76uYt9xYvQkHFtyIDcm0Gzv3yZV/Bh3Fb
         YyQ9I4eh4CXH0QgzcFHnLV78LU9kE1R3tCu5ieZzHVCi270GcFk80CZT/IVV3CueaK
         UuLtjv70iOr3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 10/38] drm/amd/pm: fix double free in si_parse_power_table()
Date:   Mon, 30 May 2022 09:48:56 -0400
Message-Id: <20220530134924.1936816-10-sashal@kernel.org>
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

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

[ Upstream commit f3fa2becf2fc25b6ac7cf8d8b1a2e4a86b3b72bd ]

In function si_parse_power_table(), array adev->pm.dpm.ps and its member
is allocated. If the allocation of each member fails, the array itself
is freed and returned with an error code. However, the array is later
freed again in si_dpm_fini() function which is called when the function
returns an error.

This leads to potential double free of the array adev->pm.dpm.ps, as
well as leak of its array members, since the members are not freed in
the allocation function and the array is not nulled when freed.
In addition adev->pm.dpm.num_ps, which keeps track of the allocated
array member, is not updated until the member allocation is
successfully finished, this could also lead to either use after free,
or uninitialized variable access in si_dpm_fini().

Fix this by postponing the free of the array until si_dpm_fini() and
increment adev->pm.dpm.num_ps everytime the array member is allocated.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/si_dpm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/si_dpm.c b/drivers/gpu/drm/amd/amdgpu/si_dpm.c
index 1de96995e690..9f811051ceb0 100644
--- a/drivers/gpu/drm/amd/amdgpu/si_dpm.c
+++ b/drivers/gpu/drm/amd/amdgpu/si_dpm.c
@@ -7247,17 +7247,15 @@ static int si_parse_power_table(struct amdgpu_device *adev)
 	if (!adev->pm.dpm.ps)
 		return -ENOMEM;
 	power_state_offset = (u8 *)state_array->states;
-	for (i = 0; i < state_array->ucNumEntries; i++) {
+	for (adev->pm.dpm.num_ps = 0, i = 0; i < state_array->ucNumEntries; i++) {
 		u8 *idx;
 		power_state = (union pplib_power_state *)power_state_offset;
 		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		ps = kzalloc(sizeof(struct  si_ps), GFP_KERNEL);
-		if (ps == NULL) {
-			kfree(adev->pm.dpm.ps);
+		if (ps == NULL)
 			return -ENOMEM;
-		}
 		adev->pm.dpm.ps[i].ps_priv = ps;
 		si_parse_pplib_non_clock_info(adev, &adev->pm.dpm.ps[i],
 					      non_clock_info,
@@ -7279,8 +7277,8 @@ static int si_parse_power_table(struct amdgpu_device *adev)
 			k++;
 		}
 		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
+		adev->pm.dpm.num_ps++;
 	}
-	adev->pm.dpm.num_ps = state_array->ucNumEntries;
 
 	/* fill in the vce power states */
 	for (i = 0; i < adev->pm.dpm.num_of_vce_states; i++) {
-- 
2.35.1

