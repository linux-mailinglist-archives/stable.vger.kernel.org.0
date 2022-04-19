Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67144507834
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356865AbiDSSYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357111AbiDSSWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:22:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA80419B3;
        Tue, 19 Apr 2022 11:15:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20F44B81865;
        Tue, 19 Apr 2022 18:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1F2C385A9;
        Tue, 19 Apr 2022 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392114;
        bh=904Yeuvzqm23g7s+sAX4Ms24/YBBVjFmcCiyB/hFFGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivUYSTT4tVl6ADWH+h4QJVyTzDu1RZhd7ou/6GF32DJ82BPekfh7xHwQj0KlRQJ98
         yhzPx/T6fXfS0bbk9zWY6sm3PfVSNl2aJEEx0HEfRNhX2oqoUO65By+vtaxXDANbSD
         GhG1oM2NEDx6UP/dQOVxQZsKrLwD/O74z7rx4rXOcyj5GNWOp9c1t9KPWO+khbRDfR
         +RV8VKWCQwAE2+JISnu9cetRTXJxTSPxspv9gAC7V7tqKjgig/YIcD7d85qyvgCX+v
         yf/fTYj9I73q99aCgp693H0OIXwhgmvHzGLBJME8Tg/E1CeFIJly624pMlyhwA7FE3
         HC7stT60J4fiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        maxime@cerno.tech, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 10/14] drm/msm/mdp5: check the return of kzalloc()
Date:   Tue, 19 Apr 2022 14:14:39 -0400
Message-Id: <20220419181444.485959-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181444.485959-1-sashal@kernel.org>
References: <20220419181444.485959-1-sashal@kernel.org>
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
index 83423092de2f..da0799333970 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -179,7 +179,10 @@ static void mdp5_plane_reset(struct drm_plane *plane)
 		drm_framebuffer_put(plane->state->fb);
 
 	kfree(to_mdp5_plane_state(plane->state));
+	plane->state = NULL;
 	mdp5_state = kzalloc(sizeof(*mdp5_state), GFP_KERNEL);
+	if (!mdp5_state)
+		return;
 
 	/* assign default blend parameters */
 	mdp5_state->alpha = 255;
-- 
2.35.1

