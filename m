Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B85904EF
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbiHKQfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238711AbiHKQdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:33:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86696BB02C;
        Thu, 11 Aug 2022 09:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B281FB821BA;
        Thu, 11 Aug 2022 16:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45026C433C1;
        Thu, 11 Aug 2022 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234257;
        bh=yl0xHkcESV7NTyfRvJaAPC4xYMup5ytE1fDcH4xEmw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZsf+Qk+S666bLuy3lmVFklbYDSuDLX2nbmrWGEW3xTu5+Uqcp/p/2whe4DT+od0c
         u71u8T0sCZyKTkTPWBo8SIiLvbD07/+q6xRDPBulthKhi4KEFnbCM/aR4K2DQvajdR
         OOo1UJ5Os7/UxWzbS44b2xVSfi8MfxuDoodHCI2TXfPbu2IkpQInjCyftnrHWLr9M5
         CyY0qZdjEPtALbGL0/jUZRtlEiYyvKhkD36wV4pQnIsRYWHwQclcEOIycTlYcMpDPN
         mH87JMTFDdieA0t0ww8W5wL2/33aPfPDwLAyVKRk3/te6NJq0sCXMwtg5GDPRRlk9n
         /lC9PPbGoe1eA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 03/14] drm/radeon: Initialize fences array entries in radeon_sa_bo_next_hole
Date:   Thu, 11 Aug 2022 12:10:32 -0400
Message-Id: <20220811161050.1543183-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161050.1543183-1-sashal@kernel.org>
References: <20220811161050.1543183-1-sashal@kernel.org>
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

From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

[ Upstream commit 0381ac3ca2e727d4dfb7264d9416a8ba6bb6c18b ]

Similar to the handling of amdgpu_sa_bo_next_hole in commit 6a15f3ff19a8
("drm/amdgpu: Initialize fences array entries in amdgpu_sa_bo_next_hole"),
we thought a patch might be needed here as well.

The entries were only initialized once in radeon_sa_bo_new. If a fence
wasn't signalled yet in the first radeon_sa_bo_next_hole call, but then
got signalled before a later radeon_sa_bo_next_hole call, it could
destroy the fence but leave its pointer in the array, resulting in
use-after-free in radeon_sa_bo_new.

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_sa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_sa.c b/drivers/gpu/drm/radeon/radeon_sa.c
index 197b157b73d0..0cb6eeb77b5f 100644
--- a/drivers/gpu/drm/radeon/radeon_sa.c
+++ b/drivers/gpu/drm/radeon/radeon_sa.c
@@ -267,6 +267,8 @@ static bool radeon_sa_bo_next_hole(struct radeon_sa_manager *sa_manager,
 	for (i = 0; i < RADEON_NUM_RINGS; ++i) {
 		struct radeon_sa_bo *sa_bo;
 
+		fences[i] = NULL;
+
 		if (list_empty(&sa_manager->flist[i])) {
 			continue;
 		}
@@ -332,10 +334,8 @@ int radeon_sa_bo_new(struct radeon_device *rdev,
 
 	spin_lock(&sa_manager->wq.lock);
 	do {
-		for (i = 0; i < RADEON_NUM_RINGS; ++i) {
-			fences[i] = NULL;
+		for (i = 0; i < RADEON_NUM_RINGS; ++i)
 			tries[i] = 0;
-		}
 
 		do {
 			radeon_sa_bo_try_free(sa_manager);
-- 
2.35.1

