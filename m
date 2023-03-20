Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C526C0E8B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjCTKTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjCTKTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:19:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547621041B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:19:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06282B80DE0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64399C433EF;
        Mon, 20 Mar 2023 10:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679307579;
        bh=R15ZucWFf46/nc0vGLuqWFZ/+JLPKNjuKz3YFDei6e0=;
        h=Subject:To:Cc:From:Date:From;
        b=WjQzbc48M8834p0hV3EiMAjj7nsZj1zs/u4aSs+tcAZgyQVHL7EjIhaHD3PR6I52w
         Ru2OwewoDDqXFG13LBHqat8rjtP0ABR+l96g0ukI0ffXY45YTwjn1g2ShioESXEhoa
         vJ+pZb2CcZM/DBGazuAyj1RJlgHlA2XNjUVONy4E=
Subject: FAILED: patch "[PATCH] drm/amd/display: Write to correct dirty_rect" failed to apply to 6.1-stable tree
To:     ben@bcheng.me, alexander.deucher@amd.com, hamza.mahfooz@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:19:36 +0100
Message-ID: <1679307576136187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 751281c55579f0cb0e56c9797d4663f689909681
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1679307576136187@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

751281c55579 ("drm/amd/display: Write to correct dirty_rect")
30ebe41582d1 ("drm/amd/display: add FB_DAMAGE_CLIPS support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 751281c55579f0cb0e56c9797d4663f689909681 Mon Sep 17 00:00:00 2001
From: Benjamin Cheng <ben@bcheng.me>
Date: Sun, 12 Mar 2023 20:47:39 -0400
Subject: [PATCH] drm/amd/display: Write to correct dirty_rect

When FB_DAMAGE_CLIPS are provided in a non-MPO scenario, the loop does
not use the counter i. This causes the fill_dc_dity_rect() to always
fill dirty_rects[0], causing graphical artifacts when a damage clip
aware DRM client sends more than 1 damage clip.

Instead, use the flip_addrs->dirty_rect_count which is incremented by
fill_dc_dirty_rect() on a successful fill.

Fixes: 30ebe41582d1 ("drm/amd/display: add FB_DAMAGE_CLIPS support")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2453
Signed-off-by: Benjamin Cheng <ben@bcheng.me>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 009ef917dad4..32abbafd43fa 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5105,9 +5105,9 @@ static void fill_dc_dirty_rects(struct drm_plane *plane,
 
 		for (; flip_addrs->dirty_rect_count < num_clips; clips++)
 			fill_dc_dirty_rect(new_plane_state->plane,
-					   &dirty_rects[i], clips->x1,
-					   clips->y1, clips->x2 - clips->x1,
-					   clips->y2 - clips->y1,
+					   &dirty_rects[flip_addrs->dirty_rect_count],
+					   clips->x1, clips->y1,
+					   clips->x2 - clips->x1, clips->y2 - clips->y1,
 					   &flip_addrs->dirty_rect_count,
 					   false);
 		return;

