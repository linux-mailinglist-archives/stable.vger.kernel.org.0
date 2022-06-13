Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7889B548A8A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357190AbiFMLxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356657AbiFMLux (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DA8D10E;
        Mon, 13 Jun 2022 03:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23FEC60EFE;
        Mon, 13 Jun 2022 10:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37910C34114;
        Mon, 13 Jun 2022 10:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117700;
        bh=lwGUoTqvlgocRTw2hxr/X5mUBTGEKQRqVn9MQ8udl2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZVbbpj1VeNaE3bqq+/AwrNxwplCR0WO0wqneXbwPpaTVBUOjXoC1QDB6nhMf6BlL
         QJVO95jJrNF78H44nmyd411LriZNGmJCotfgSX60DIOq2MiC5haSdeUv2TGTYBKlE5
         khjaQPP7IqqOFUbJ8OI7F0t8fCGLyFmGLgrgsMdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/287] drm/msm/mdp5: Return error code in mdp5_pipe_release when deadlock is detected
Date:   Mon, 13 Jun 2022 12:08:32 +0200
Message-Id: <20220613094926.546323454@linuxfoundation.org>
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

[ Upstream commit d59be579fa932c46b908f37509f319cbd4ca9a68 ]

mdp5_get_global_state runs the risk of hitting a -EDEADLK when acquiring
the modeset lock, but currently mdp5_pipe_release doesn't check for if
an error is returned. Because of this, there is a possibility of
mdp5_pipe_release hitting a NULL dereference error.

To avoid this, let's have mdp5_pipe_release check if
mdp5_get_global_state returns an error and propogate that error.

Changes since v1:
- Separated declaration and initialization of *new_state to avoid
  compiler warning
- Fixed some spelling mistakes in commit message

Changes since v2:
- Return 0 in case where hwpipe is NULL as this is considered normal
  behavior
- Added 2nd patch in series to fix a similar NULL dereference issue in
  mdp5_mixer_release

Reported-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Fixes: 7907a0d77cb4 ("drm/msm/mdp5: Use the new private_obj state")
Reviewed-by: Rob Clark <robdclark@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/485179/
Link: https://lore.kernel.org/r/20220505214051.155-1-quic_jesszhan@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c  | 15 +++++++++++----
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h  |  2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c | 20 ++++++++++++++++----
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c
index 1ef26bc63163..88de12225582 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c
@@ -130,18 +130,23 @@ int mdp5_pipe_assign(struct drm_atomic_state *s, struct drm_plane *plane,
 	return 0;
 }
 
-void mdp5_pipe_release(struct drm_atomic_state *s, struct mdp5_hw_pipe *hwpipe)
+int mdp5_pipe_release(struct drm_atomic_state *s, struct mdp5_hw_pipe *hwpipe)
 {
 	struct msm_drm_private *priv = s->dev->dev_private;
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(priv->kms));
 	struct mdp5_global_state *state = mdp5_get_global_state(s);
-	struct mdp5_hw_pipe_state *new_state = &state->hwpipe;
+	struct mdp5_hw_pipe_state *new_state;
 
 	if (!hwpipe)
-		return;
+		return 0;
+
+	if (IS_ERR(state))
+		return PTR_ERR(state);
+
+	new_state = &state->hwpipe;
 
 	if (WARN_ON(!new_state->hwpipe_to_plane[hwpipe->idx]))
-		return;
+		return -EINVAL;
 
 	DBG("%s: release from plane %s", hwpipe->name,
 		new_state->hwpipe_to_plane[hwpipe->idx]->name);
@@ -152,6 +157,8 @@ void mdp5_pipe_release(struct drm_atomic_state *s, struct mdp5_hw_pipe *hwpipe)
 	}
 
 	new_state->hwpipe_to_plane[hwpipe->idx] = NULL;
+
+	return 0;
 }
 
 void mdp5_pipe_destroy(struct mdp5_hw_pipe *hwpipe)
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h b/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h
index bb2b0ac7aa2b..072db6a99b85 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h
@@ -48,7 +48,7 @@ int mdp5_pipe_assign(struct drm_atomic_state *s, struct drm_plane *plane,
 		     uint32_t caps, uint32_t blkcfg,
 		     struct mdp5_hw_pipe **hwpipe,
 		     struct mdp5_hw_pipe **r_hwpipe);
-void mdp5_pipe_release(struct drm_atomic_state *s, struct mdp5_hw_pipe *hwpipe);
+int mdp5_pipe_release(struct drm_atomic_state *s, struct mdp5_hw_pipe *hwpipe);
 
 struct mdp5_hw_pipe *mdp5_pipe_init(enum mdp5_pipe pipe,
 		uint32_t reg_offset, uint32_t caps);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
index 3d8eaa25bea0..501d7989b9a5 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -402,12 +402,24 @@ static int mdp5_plane_atomic_check_with_state(struct drm_crtc_state *crtc_state,
 				mdp5_state->r_hwpipe = NULL;
 
 
-			mdp5_pipe_release(state->state, old_hwpipe);
-			mdp5_pipe_release(state->state, old_right_hwpipe);
+			ret = mdp5_pipe_release(state->state, old_hwpipe);
+			if (ret)
+				return ret;
+
+			ret = mdp5_pipe_release(state->state, old_right_hwpipe);
+			if (ret)
+				return ret;
+
 		}
 	} else {
-		mdp5_pipe_release(state->state, mdp5_state->hwpipe);
-		mdp5_pipe_release(state->state, mdp5_state->r_hwpipe);
+		ret = mdp5_pipe_release(state->state, mdp5_state->hwpipe);
+		if (ret)
+			return ret;
+
+		ret = mdp5_pipe_release(state->state, mdp5_state->r_hwpipe);
+		if (ret)
+			return ret;
+
 		mdp5_state->hwpipe = mdp5_state->r_hwpipe = NULL;
 	}
 
-- 
2.35.1



