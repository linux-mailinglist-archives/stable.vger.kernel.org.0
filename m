Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E426579D90
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241563AbiGSMwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241827AbiGSMvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAD5528A8;
        Tue, 19 Jul 2022 05:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3FDD6177D;
        Tue, 19 Jul 2022 12:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B58C341C6;
        Tue, 19 Jul 2022 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233222;
        bh=cey1oaBxcEhch8J5lfJN4U0SmBTjN4OUZg8Q9ANH8E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZBhXkTVkkOq4eW6ka6HUuGjmU69QxdUTAH5yH/zmz8UPCtwt76SIL5/z9ZL2c/kV
         2APih/5Jq9kHyTMy5138p1pugk8MimA+bY+cS6wXsKjdyLr9eby8fpiFjcO+X7rpA9
         U0tPemeokOXSjrkqJpiOlJOHUlK4GcEN2fuqstbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 048/231] drm/amdgpu: keep fbdev buffers pinned during suspend
Date:   Tue, 19 Jul 2022 13:52:13 +0200
Message-Id: <20220719114718.322469240@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f9a89117fbdc63c0d4ab63a8f3596a72c245bcfe ]

Was dropped when we converted to the generic helpers.

Fixes: 087451f372bf ("drm/amdgpu: use generic fb helpers instead of setting up AMD own's.")
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 25 +++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index fae5c1debfad..ffb3702745a5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1547,6 +1547,21 @@ bool amdgpu_crtc_get_scanout_position(struct drm_crtc *crtc,
 						  stime, etime, mode);
 }
 
+static bool
+amdgpu_display_robj_is_fb(struct amdgpu_device *adev, struct amdgpu_bo *robj)
+{
+	struct drm_device *dev = adev_to_drm(adev);
+	struct drm_fb_helper *fb_helper = dev->fb_helper;
+
+	if (!fb_helper || !fb_helper->buffer)
+		return false;
+
+	if (gem_to_amdgpu_bo(fb_helper->buffer->gem) != robj)
+		return false;
+
+	return true;
+}
+
 int amdgpu_display_suspend_helper(struct amdgpu_device *adev)
 {
 	struct drm_device *dev = adev_to_drm(adev);
@@ -1582,10 +1597,12 @@ int amdgpu_display_suspend_helper(struct amdgpu_device *adev)
 			continue;
 		}
 		robj = gem_to_amdgpu_bo(fb->obj[0]);
-		r = amdgpu_bo_reserve(robj, true);
-		if (r == 0) {
-			amdgpu_bo_unpin(robj);
-			amdgpu_bo_unreserve(robj);
+		if (!amdgpu_display_robj_is_fb(adev, robj)) {
+			r = amdgpu_bo_reserve(robj, true);
+			if (r == 0) {
+				amdgpu_bo_unpin(robj);
+				amdgpu_bo_unreserve(robj);
+			}
 		}
 	}
 	return 0;
-- 
2.35.1



