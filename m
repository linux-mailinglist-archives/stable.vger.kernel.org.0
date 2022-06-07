Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8371541A6E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378551AbiFGVdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381041AbiFGVbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAF822CBCA;
        Tue,  7 Jun 2022 12:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9A8D617CC;
        Tue,  7 Jun 2022 19:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF07C385A2;
        Tue,  7 Jun 2022 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628637;
        bh=TQ3Y3rgG9grSoqcDMuYepeiWXwXwF02pRKQIscNhIF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zODXs2KpLCbt9UfK4A+R8cHAWgVDFMafSseHPfOC3kyZLUBKFhI1muoZgvGJR3v2U
         3IPtj/yYsizw8tebm2lQm5S95yvtuo8duqxWxycDMViaTr4bde3ORgXHdXFFOWr2BC
         /z3XywpZDydLN6e2iUT4sR2eRvweGltCWvXsP8ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 400/879] drm/msm/mdp5: Return error code in mdp5_mixer_release when deadlock is detected
Date:   Tue,  7 Jun 2022 18:58:38 +0200
Message-Id: <20220607165014.473515299@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index b966cd69f99d..fe2922c8d21b 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -612,9 +612,15 @@ static int mdp5_crtc_setup_pipeline(struct drm_crtc *crtc,
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



