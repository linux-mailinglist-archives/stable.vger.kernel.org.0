Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46961660B74
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 02:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbjAGBYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 20:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbjAGBX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 20:23:58 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A7F728A9
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 17:23:57 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d15so3515745pls.6
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 17:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fqc+kkMFie/fztyQhVGKblB/deI6poCZbFpfQY0gQ5M=;
        b=T58kzIf5KVpaNXEtW9T33Mo50vYqvco1twQmTAboyo/KCu3tpXXPxRX3is2nRboBkK
         IFmSrS0lC/MbF3+tyDud6LC3NdPNHNDld4SpKQ/1bF5KEgQ1Cd/Puai5wuLafJcGw5hQ
         Xu6lrgspDIHnr68pABxoI/C7OTjXX4iVHNjOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fqc+kkMFie/fztyQhVGKblB/deI6poCZbFpfQY0gQ5M=;
        b=s04oOn3/GfQGgOgExbmmZ7pDGAMljIeHpPrd9+HQ1OVAGRQjd+KiHp90zZmktl/1lh
         BPl4R/Rhx560cdQO/FynxnY9+w8Jz+HG1/DbNIHTObrM3gqLsChfUkXzdY3YIXfugQa0
         V2IVK0oIle+/1/wOZA9tCOdownbsWh0RvoIntmlXM3vtbBuK7E4Oax2MDYz7QEnww/2Q
         /n7OdKzhoY8t7HP+LXPGFQHnZnZ6Injz+ZD0nhmZ9jdc4weG8+MaG/5ZK4tP+eeg/9Y+
         iZi3ccFhPMROgyJnAjlUMXsKqjR6P46lE6BAI107W6krc3DY0Bf0SjpJ6OgLsSQ6dRbW
         3shg==
X-Gm-Message-State: AFqh2kqzhtHnC5wPuXpbkP4r0d0OMLevkMJmj+hTZvd/GGnoo8av0gua
        xbiRAsp6Bv+VwuFmHvbqtHG8fw==
X-Google-Smtp-Source: AMrXdXvm4NOW/ltnbwyEvzMNORkJ0sSf/IJ/q3eNi+aIWeAhDUuIo1PyIhxCieNcGFJa22JoQ5TygQ==
X-Received: by 2002:a17:902:ee13:b0:189:13df:9d86 with SMTP id z19-20020a170902ee1300b0018913df9d86mr65902309plb.14.1673054636979;
        Fri, 06 Jan 2023 17:23:56 -0800 (PST)
Received: from localhost ([2620:15c:9d:2:bc4e:2cc9:68b3:15dc])
        by smtp.gmail.com with UTF8SMTPSA id cp12-20020a170902e78c00b0019276616eb0sm1569183plb.83.2023.01.06.17.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 17:23:56 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>
Cc:     =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@mailbox.org>,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>
Subject: [PATCH v2 2/2] drm/rockchip: vop: Leave vblank enabled in self-refresh
Date:   Fri,  6 Jan 2023 17:23:23 -0800
Message-Id: <20230106172310.v2.2.Ic07cba4ab9a7bd3618a9e4258b8f92ea7d10ae5a@changeid>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
In-Reply-To: <20230106172310.v2.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
References: <20230106172310.v2.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If we disable vblank when entering self-refresh, vblank APIs (like
DRM_IOCTL_WAIT_VBLANK) no longer work. But user space is not aware when
we enter self-refresh, so this appears to be an API violation -- that
DRM_IOCTL_WAIT_VBLANK fails with EINVAL whenever the display is idle and
enters self-refresh.

The downstream driver used by many of these systems never used to
disable vblank for PSR, and in fact, even upstream, we didn't do that
until radically redesigning the state machine in commit 6c836d965bad
("drm/rockchip: Use the helpers for PSR").

Thus, it seems like a reasonable API fix to simply restore that
behavior, and leave vblank enabled.

Note that this appears to potentially unbalance the
drm_crtc_vblank_{off,on}() calls in some cases, but:
(a) drm_crtc_vblank_on() documents this as OK and
(b) if I do the naive balancing, I find state machine issues such that
    we're not in sync properly; so it's easier to take advantage of (a).

This issue was exposed by IGT's kms_vblank tests, and reported by
KernelCI.

Backporting notes:
Marking as 'Fixes' commit 6c836d965bad ("drm/rockchip: Use the helpers
for PSR"), but it probably depends on commit bed030a49f3e
("drm/rockchip: Don't fully disable vop on self refresh") as well.

We also need the previous patch ("drm/atomic: Allow vblank-enabled +
self-refresh "disable""), of course.

v2:
 * skip unnecessary lock/unlock

Fixes: 6c836d965bad ("drm/rockchip: Use the helpers for PSR")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/dri-devel/Y5itf0+yNIQa6fU4@sirena.org.uk/
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index fa1f4ee6d195..9fea03121247 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -717,13 +717,13 @@ static void vop_crtc_atomic_disable(struct drm_crtc *crtc,
 	if (crtc->state->self_refresh_active)
 		rockchip_drm_set_win_enabled(crtc, false);
 
+	if (crtc->state->self_refresh_active)
+		goto out;
+
 	mutex_lock(&vop->vop_lock);
 
 	drm_crtc_vblank_off(crtc);
 
-	if (crtc->state->self_refresh_active)
-		goto out;
-
 	/*
 	 * Vop standby will take effect at end of current frame,
 	 * if dsp hold valid irq happen, it means standby complete.
@@ -757,9 +757,9 @@ static void vop_crtc_atomic_disable(struct drm_crtc *crtc,
 	vop_core_clks_disable(vop);
 	pm_runtime_put(vop->dev);
 
-out:
 	mutex_unlock(&vop->vop_lock);
 
+out:
 	if (crtc->state->event && !crtc->state->active) {
 		spin_lock_irq(&crtc->dev->event_lock);
 		drm_crtc_send_vblank_event(crtc, crtc->state->event);
-- 
2.39.0.314.g84b9a713c41-goog

