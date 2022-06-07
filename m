Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7105754064D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiFGRed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347479AbiFGRas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D010111BAF;
        Tue,  7 Jun 2022 10:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC5EFCE1D50;
        Tue,  7 Jun 2022 17:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D8BC385A5;
        Tue,  7 Jun 2022 17:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622819;
        bh=UN8skyeNYbUUm8Aon/abXlMm+91dIps70oypjb/glME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQ/QKEik4ENK4oJt3ibywv1PqjPduit8ocNPiKxqbISYLP/MgrdVMBO+XdJZ9Xf0E
         SBTzL7T/KczBuaCnKV8LFSrN87Y3ba6HrKSSE8U92VaKLS5msMOSrhB4sH0oUnK7St
         SOLjsuNlA+AxGB8vylIEsv9ahbuShveYqBOMCxlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/452] drm/msm/mdp5: Return error code in mdp5_mixer_release when deadlock is detected
Date:   Tue,  7 Jun 2022 19:00:50 +0200
Message-Id: <20220607164914.315593452@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit ca75f6f7c6f89365e40f10f641b15981b1f07c31 ]

There is a possibility for mdp5_get_global_state to return
-EDEADLK when acquiring the modeset lock, but currently global_state in
mdp5_mixer_release doesn't check for if an error is returned.

To avoid a NULL dereference error, let's have mdp5_mixer_release
check if an error is returned and propagate that error.

Reported-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Fixes: 7907a0d77cb4 ("drm/msm/mdp5: Use the new private_obj state")
Reviewed-by: Rob Clark <robdclark@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/485181/
Link: https://lore.kernel.org/r/20220505214051.155-2-quic_jesszhan@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c  | 10 ++++++++--
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c | 15 +++++++++++----
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h |  4 ++--
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index a8fa084dfa49..06f19ef5dbf3 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -608,9 +608,15 @@ int mdp5_crtc_setup_pipeline(struct drm_crtc *crtc,
 		if (ret)
 			return ret;
 
-		mdp5_mixer_release(new_crtc_state->state, old_mixer);
+		ret = mdp5_mixer_release(new_crtc_state->state, old_mixer);
+		if (ret)
+			return ret;
+
 		if (old_r_mixer) {
-			mdp5_mixer_release(new_crtc_state->state, old_r_mixer);
+			ret = mdp5_mixer_release(new_crtc_state->state, old_r_mixer);
+			if (ret)
+				return ret;
+
 			if (!need_right_mixer)
 				pipeline->r_mixer = NULL;
 		}
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c
index 954db683ae44..2536def2a000 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c
@@ -116,21 +116,28 @@ int mdp5_mixer_assign(struct drm_atomic_state *s, struct drm_crtc *crtc,
 	return 0;
 }
 
-void mdp5_mixer_release(struct drm_atomic_state *s, struct mdp5_hw_mixer *mixer)
+int mdp5_mixer_release(struct drm_atomic_state *s, struct mdp5_hw_mixer *mixer)
 {
 	struct mdp5_global_state *global_state = mdp5_get_global_state(s);
-	struct mdp5_hw_mixer_state *new_state = &global_state->hwmixer;
+	struct mdp5_hw_mixer_state *new_state;
 
 	if (!mixer)
-		return;
+		return 0;
+
+	if (IS_ERR(global_state))
+		return PTR_ERR(global_state);
+
+	new_state = &global_state->hwmixer;
 
 	if (WARN_ON(!new_state->hwmixer_to_crtc[mixer->idx]))
-		return;
+		return -EINVAL;
 
 	DBG("%s: release from crtc %s", mixer->name,
 	    new_state->hwmixer_to_crtc[mixer->idx]->name);
 
 	new_state->hwmixer_to_crtc[mixer->idx] = NULL;
+
+	return 0;
 }
 
 void mdp5_mixer_destroy(struct mdp5_hw_mixer *mixer)
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h b/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h
index 43c9ba43ce18..545ee223b9d7 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h
@@ -30,7 +30,7 @@ void mdp5_mixer_destroy(struct mdp5_hw_mixer *lm);
 int mdp5_mixer_assign(struct drm_atomic_state *s, struct drm_crtc *crtc,
 		      uint32_t caps, struct mdp5_hw_mixer **mixer,
 		      struct mdp5_hw_mixer **r_mixer);
-void mdp5_mixer_release(struct drm_atomic_state *s,
-			struct mdp5_hw_mixer *mixer);
+int mdp5_mixer_release(struct drm_atomic_state *s,
+		       struct mdp5_hw_mixer *mixer);
 
 #endif /* __MDP5_LM_H__ */
-- 
2.35.1



