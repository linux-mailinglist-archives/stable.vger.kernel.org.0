Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D885F94D2
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiJJAMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiJJAMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:12:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06404D49;
        Sun,  9 Oct 2022 16:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 931CCB80DE0;
        Sun,  9 Oct 2022 23:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD265C433D6;
        Sun,  9 Oct 2022 23:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359380;
        bh=QXcBMzebHoL91pIygKKq4BACg8oie/iIyZvGUNaBrXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YX57SV7EScocMOR82M3M07aki2MA5jTTTx6PnIm7y4odsPsPq07I7E+R4guQae/SG
         XxaIUhTj2LmH+waqQ0FZw7f8RHg01E2LwVyZrUs4FqFzvulpP95uXOcEjizwVKiIFa
         Svva5JXgSsBZbd8bJ/PJVa0RY1okpX3ANJFBvzln7t1Dl+QdpAkyh1DrG0SGgp8X+9
         ZzXb/8UnAM0+IbOD+mtyGmMH0+MosJb7Q6fEjLQCx5jfTDmk1Zd4N00YbdjxwfMHZS
         I5EdEfhbHdyBm9Nm58jk8oGy5U88dNvjTseM/sWpytiFP7Dc6J6yy2fZ5B1fl9IBO7
         HwSL/KabLWitw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liviu Dudau <liviu.dudau@arm.com>,
        Carsten Haitzler <carsten.haitzler@arm.com>,
        Sasha Levin <sashal@kernel.org>, james.qian.wang@arm.com,
        mihail.atanassov@arm.com, brian.starkey@arm.com, airlied@gmail.com,
        daniel@ffwll.ch, sumit.semwal@linaro.org, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 6.0 04/44] drm/komeda: Fix handling of atomic commits in the atomic_commit_tail hook
Date:   Sun,  9 Oct 2022 19:48:52 -0400
Message-Id: <20221009234932.1230196-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liviu Dudau <liviu.dudau@arm.com>

[ Upstream commit eaa225b6b52233d45457fd33730e1528c604d92d ]

Komeda driver relies on the generic DRM atomic helper functions to handle
commits. It only implements an atomic_commit_tail hook for the
mode_config_helper_funcs and even that one is pretty close to the generic
implementation with the exception of additional dma_fence signalling.

What the generic helper framework doesn't do is waiting for the actual
hardware to signal that the commit parameters have been written into the
appropriate registers. As we signal CRTC events only on the irq handlers,
we need to flush the configuration and wait for the hardware to respond.

Add the Komeda specific implementation for atomic_commit_hw_done() that
flushes and waits for flip done before calling drm_atomic_helper_commit_hw_done().

The fix was prompted by a patch from Carsten Haitzler where he was trying to
solve the same issue but in a different way that I think can lead to wrong
event signaling to userspace.

Reported-by: Carsten Haitzler <carsten.haitzler@arm.com>
Tested-by: Carsten Haitzler <carsten.haitzler@arm.com>
Reviewed-by: Carsten Haitzler <carsten.haitzler@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220722122139.288486-1-liviu.dudau@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/arm/display/komeda/komeda_crtc.c  |  4 ++--
 .../gpu/drm/arm/display/komeda/komeda_kms.c   | 21 ++++++++++++++++++-
 .../gpu/drm/arm/display/komeda/komeda_kms.h   |  2 ++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
index 59172acb9738..292f533d8cf0 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_crtc.c
@@ -235,7 +235,7 @@ void komeda_crtc_handle_event(struct komeda_crtc   *kcrtc,
 			crtc->state->event = NULL;
 			drm_crtc_send_vblank_event(crtc, event);
 		} else {
-			DRM_WARN("CRTC[%d]: FLIP happen but no pending commit.\n",
+			DRM_WARN("CRTC[%d]: FLIP happened but no pending commit.\n",
 				 drm_crtc_index(&kcrtc->base));
 		}
 		spin_unlock_irqrestore(&crtc->dev->event_lock, flags);
@@ -286,7 +286,7 @@ komeda_crtc_atomic_enable(struct drm_crtc *crtc,
 	komeda_crtc_do_flush(crtc, old);
 }
 
-static void
+void
 komeda_crtc_flush_and_wait_for_flip_done(struct komeda_crtc *kcrtc,
 					 struct completion *input_flip_done)
 {
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_kms.c b/drivers/gpu/drm/arm/display/komeda/komeda_kms.c
index 93b7f09b96ca..327051bba5b6 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_kms.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_kms.c
@@ -69,6 +69,25 @@ static const struct drm_driver komeda_kms_driver = {
 	.minor = 1,
 };
 
+static void komeda_kms_atomic_commit_hw_done(struct drm_atomic_state *state)
+{
+	struct drm_device *dev = state->dev;
+	struct komeda_kms_dev *kms = to_kdev(dev);
+	int i;
+
+	for (i = 0; i < kms->n_crtcs; i++) {
+		struct komeda_crtc *kcrtc = &kms->crtcs[i];
+
+		if (kcrtc->base.state->active) {
+			struct completion *flip_done = NULL;
+			if (kcrtc->base.state->event)
+				flip_done = kcrtc->base.state->event->base.completion;
+			komeda_crtc_flush_and_wait_for_flip_done(kcrtc, flip_done);
+		}
+	}
+	drm_atomic_helper_commit_hw_done(state);
+}
+
 static void komeda_kms_commit_tail(struct drm_atomic_state *old_state)
 {
 	struct drm_device *dev = old_state->dev;
@@ -81,7 +100,7 @@ static void komeda_kms_commit_tail(struct drm_atomic_state *old_state)
 
 	drm_atomic_helper_commit_modeset_enables(dev, old_state);
 
-	drm_atomic_helper_commit_hw_done(old_state);
+	komeda_kms_atomic_commit_hw_done(old_state);
 
 	drm_atomic_helper_wait_for_flip_done(dev, old_state);
 
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_kms.h b/drivers/gpu/drm/arm/display/komeda/komeda_kms.h
index 7889e380ab23..7339339ef6b8 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_kms.h
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_kms.h
@@ -183,6 +183,8 @@ void komeda_kms_cleanup_private_objs(struct komeda_kms_dev *kms);
 
 void komeda_crtc_handle_event(struct komeda_crtc   *kcrtc,
 			      struct komeda_events *evts);
+void komeda_crtc_flush_and_wait_for_flip_done(struct komeda_crtc *kcrtc,
+					      struct completion *input_flip_done);
 
 struct komeda_kms_dev *komeda_kms_attach(struct komeda_dev *mdev);
 void komeda_kms_detach(struct komeda_kms_dev *kms);
-- 
2.35.1

