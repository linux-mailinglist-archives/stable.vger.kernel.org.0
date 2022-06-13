Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBE7548DF8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356172AbiFMLxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356658AbiFMLuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:50:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59197DFF1;
        Mon, 13 Jun 2022 03:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75D96B80D3F;
        Mon, 13 Jun 2022 10:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB30C3411C;
        Mon, 13 Jun 2022 10:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117703;
        bh=oQPAN4chqWIIPG6atT+E2ldnFSAde1cFsl4zzRUvJZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FyRG0dPV2Sr4C9Rj6w8zOTRpMHjjqNBhVeyI0vBXUst8y9OAQpmFS/r1Y/0Evbp4s
         cVLbrJPlJHezmIKHBa5u2lxlEQw6ciMkbmHLKk79TH247nQJf97eb2rj/PdQbjaFC4
         21gCjOzlaAxu9Eh73YhkCTqBpIC/z1dBnz4wJFtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/287] drm/msm/mdp5: Return error code in mdp5_mixer_release when deadlock is detected
Date:   Mon, 13 Jun 2022 12:08:33 +0200
Message-Id: <20220613094926.576495995@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index aa28a43ff842..76639a108ff5 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -537,9 +537,15 @@ int mdp5_crtc_setup_pipeline(struct drm_crtc *crtc,
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
index 113e6b569562..9c8275300b55 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c
@@ -127,21 +127,28 @@ int mdp5_mixer_assign(struct drm_atomic_state *s, struct drm_crtc *crtc,
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
index 9be94f567fbd..6bcb0b544665 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h
@@ -41,7 +41,7 @@ void mdp5_mixer_destroy(struct mdp5_hw_mixer *lm);
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



