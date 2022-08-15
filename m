Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA159412E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbiHOVJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbiHOVHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F5EB9FBE;
        Mon, 15 Aug 2022 12:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D3960F6A;
        Mon, 15 Aug 2022 19:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6A2C433D6;
        Mon, 15 Aug 2022 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590950;
        bh=qthlUxLyneTrQoXxQBbYo31Gy/R5BpXEYmeBs7zGNCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJNG8BkWjCKwAeqtRiUj0UNGYKTIC3xia4bYcdWj2Ln/C7b8DslNr2jDyvfcu8Oh3
         x93sCwwzd22iNxQIefioP5l8FD3CLs587XIN9vN4WdN67vvrpmiz/rZPgoypuxJ0En
         jhsyP7XxgFeHre3jCqEaxKuNOnaSedW3trmwAM0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0423/1095] drm/msm/mdp5: Fix global state lock backoff
Date:   Mon, 15 Aug 2022 19:57:02 +0200
Message-Id: <20220815180447.224365926@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 92ef86ab513593c6329d04146e61f9a670e72fc5 ]

We need to grab the lock after the early return for !hwpipe case.
Otherwise, we could have hit contention yet still returned 0.

Fixes an issue that the new CONFIG_DRM_DEBUG_MODESET_LOCK stuff flagged
in CI:

   WARNING: CPU: 0 PID: 282 at drivers/gpu/drm/drm_modeset_lock.c:296 drm_modeset_lock+0xf8/0x154
   Modules linked in:
   CPU: 0 PID: 282 Comm: kms_cursor_lega Tainted: G        W         5.19.0-rc2-15930-g875cc8bc536a #1
   Hardware name: Qualcomm Technologies, Inc. DB820c (DT)
   pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
   pc : drm_modeset_lock+0xf8/0x154
   lr : drm_atomic_get_private_obj_state+0x84/0x170
   sp : ffff80000cfab6a0
   x29: ffff80000cfab6a0 x28: 0000000000000000 x27: ffff000083bc4d00
   x26: 0000000000000038 x25: 0000000000000000 x24: ffff80000957ca58
   x23: 0000000000000000 x22: ffff000081ace080 x21: 0000000000000001
   x20: ffff000081acec18 x19: ffff80000cfabb80 x18: 0000000000000038
   x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffea0d0
   x14: 0000000000000000 x13: 284e4f5f4e524157 x12: 5f534b434f4c5f47
   x11: ffff80000a386aa8 x10: 0000000000000029 x9 : ffff80000cfab610
   x8 : 0000000000000029 x7 : 0000000000000014 x6 : 0000000000000000
   x5 : 0000000000000001 x4 : ffff8000081ad904 x3 : 0000000000000029
   x2 : ffff0000801db4c0 x1 : ffff80000cfabb80 x0 : ffff000081aceb58
   Call trace:
    drm_modeset_lock+0xf8/0x154
    drm_atomic_get_private_obj_state+0x84/0x170
    mdp5_get_global_state+0x54/0x6c
    mdp5_pipe_release+0x2c/0xd4
    mdp5_plane_atomic_check+0x2ec/0x414
    drm_atomic_helper_check_planes+0xd8/0x210
    drm_atomic_helper_check+0x54/0xb0
    ...
   ---[ end trace 0000000000000000 ]---
   drm_modeset_lock attempting to lock a contended lock without backoff:
      drm_modeset_lock+0x148/0x154
      mdp5_get_global_state+0x30/0x6c
      mdp5_pipe_release+0x2c/0xd4
      mdp5_plane_atomic_check+0x290/0x414
      drm_atomic_helper_check_planes+0xd8/0x210
      drm_atomic_helper_check+0x54/0xb0
      drm_atomic_check_only+0x4b0/0x8f4
      drm_atomic_commit+0x68/0xe0

Fixes: d59be579fa93 ("drm/msm/mdp5: Return error code in mdp5_pipe_release when deadlock is detected")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/492701/
Link: https://lore.kernel.org/r/20220707162040.1594855-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c
index a4f5cb90f3e8..e4b8a789835a 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c
@@ -123,12 +123,13 @@ int mdp5_pipe_release(struct drm_atomic_state *s, struct mdp5_hw_pipe *hwpipe)
 {
 	struct msm_drm_private *priv = s->dev->dev_private;
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(priv->kms));
-	struct mdp5_global_state *state = mdp5_get_global_state(s);
+	struct mdp5_global_state *state;
 	struct mdp5_hw_pipe_state *new_state;
 
 	if (!hwpipe)
 		return 0;
 
+	state = mdp5_get_global_state(s);
 	if (IS_ERR(state))
 		return PTR_ERR(state);
 
-- 
2.35.1



