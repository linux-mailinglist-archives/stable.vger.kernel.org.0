Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC779507785
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356285AbiDSSP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356342AbiDSSPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:15:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892FB3E5F7;
        Tue, 19 Apr 2022 11:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04141B818EE;
        Tue, 19 Apr 2022 18:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21C3C385A7;
        Tue, 19 Apr 2022 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391925;
        bh=rgM8kfe5zD9EZNfO/4CiOhR5Q/c5QFs9MDQG24jIl1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwuc9UrkGrFxXkJB484smNCOL8GDkGschpD08ebHizugR+mRP4RKDkKHIZW0CHCeA
         a9p6lMB7ek80P3SftwAUXBO9ldMTWD23CUGNc+pHg5dLTC01bBU6Vjod7Zt5meK6ah
         W5wHYFnAHTpkhJ3DAega92rRVTFiWqZF4VtDJTlr8s886zJeVwsWsMcaZyVkpDXvac
         pSNZqkiF7AR0dGsWcy+eZ4+rEAp9DNKHI9sQRp8YTi7A/vh16QAqMqBt2DTHoJ0RwU
         uxRAeUaC9VkpxvIausRShVz5uyfqcpsreegI0jYsJhWRoyj8xvhvtBI7kIPpDlye9F
         7bJj4NYhxsLZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        maxime@cerno.tech, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 18/34] drm/msm/mdp5: check the return of kzalloc()
Date:   Tue, 19 Apr 2022 14:10:45 -0400
Message-Id: <20220419181104.484667-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
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

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 047ae665577776b7feb11bd4f81f46627cff95e7 ]

kzalloc() is a memory allocation function which can return NULL when
some internal memory errors happen. So it is better to check it to
prevent potential wrong memory access.

Besides, since mdp5_plane_reset() is void type, so we should better
set `plane-state` to NULL after releasing it.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/481055/
Link: https://lore.kernel.org/r/tencent_8E2A1C78140EE1784AB2FF4B2088CC0AB908@qq.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
index c6b69afcbac8..50e854207c70 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -90,7 +90,10 @@ static void mdp5_plane_reset(struct drm_plane *plane)
 		__drm_atomic_helper_plane_destroy_state(plane->state);
 
 	kfree(to_mdp5_plane_state(plane->state));
+	plane->state = NULL;
 	mdp5_state = kzalloc(sizeof(*mdp5_state), GFP_KERNEL);
+	if (!mdp5_state)
+		return;
 
 	if (plane->type == DRM_PLANE_TYPE_PRIMARY)
 		mdp5_state->base.zpos = STAGE_BASE;
-- 
2.35.1

