Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3DFA61F8
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfICG4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:56:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43872 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfICG4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 02:56:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id u72so4400592pgb.10
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 23:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=63naJTzVpAIq0B9AEz7oC56daTv5sIo3itON2f7HCdg=;
        b=qlIc1kZNUSEis4xPtAe2vGproYxzVQ4Sqyq9xvpjUKmmWltJv/1g/l4c/k7azDOSF7
         TMiWaxjoVaBFuIyIWWMpBTRxRQl2QSgi1TXErgRIgFS0/quWdUWJ06sEgwHatwbuZtzc
         ZppTe4/4kpyRpaSlYbExx9j+3L1X8gCS7TPK5bylEI6r/Y+5T/VG01xhyA65NM4pMuIH
         i1QwXYW0nH87NZWZNoULz9kv2StEte877lqujLvYnEK0MXiFMYBUBoLYVskwqkTwQwn8
         h+65MVd3gQ6oTiTiEnZzBJfMHswIF6ccifNGBiqmqFgMjq5ICFomUz3SdBVD6xeHpf47
         9QNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=63naJTzVpAIq0B9AEz7oC56daTv5sIo3itON2f7HCdg=;
        b=e24dl3QBtwPFdQFLeRYe2Rel6OspJaKPix+E7BXoIuSNXc7rzMc9hVaMEypG7iDutL
         JUrsJrfIax3ayUvVivHi6P4mgZeTUS0eQoQXPo4T3/46tMTtmj/lk3dkDeHDOyrVc11z
         8Xzn9F1uZRpddyeG/c00fJlk5Kdc6gQwUg5581TnShPzpRKaJ+CyXXYCDtVHw2TTOi9d
         //ZWc2r8AdFj08/c65Nbtl5fQmdkFGMJdWIBX0D9fGXzV0KteMKkwhUrdWrr+RMWiE4D
         13H70FZhvuGd/DzzDIVCl1KTd+DTszV8GbwB68uRw+BF7tW91/rEsIGk1puI8he2YRF9
         ZR4Q==
X-Gm-Message-State: APjAAAXDIIQS2vD53qnhAaxUWwR49HiWnmqHDdbVNZIpaoMKak0tL6Oc
        ltPeohbALI5IqkKop8iNUWOSk7jyMXdPKQ==
X-Google-Smtp-Source: APXvYqxd/j+T8QJmSIsIzaygKzKALx+cde7roGbSkff1Tptv3dOOMPVjCFVwg3YlkwTTrw/JnG/gHw==
X-Received: by 2002:a17:90a:b108:: with SMTP id z8mr17183365pjq.108.1567493767618;
        Mon, 02 Sep 2019 23:56:07 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id e189sm19370762pgc.15.2019.09.02.23.56.03
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Sep 2019 23:56:07 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, chris@chris-wilson.co.uk, airlied@linux.ie
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        arnd@arndb.de, baolin.wang@linaro.org, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y 1/8] drm/i915/fbdev: Actually configure untiled displays
Date:   Tue,  3 Sep 2019 14:55:26 +0800
Message-Id: <5723d9006de706582fb46f9e1e3eb8ce168c2126.1567492316.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567492316.git.baolin.wang@linaro.org>
References: <cover.1567492316.git.baolin.wang@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

If we skipped all the connectors that were not part of a tile, we would
leave conn_seq=0 and conn_configured=0, convincing ourselves that we
had stagnated in our configuration attempts. Avoid this situation by
starting conn_seq=ALL_CONNECTORS, and repeating until we find no more
connectors to configure.

Fixes: 754a76591b12 ("drm/i915/fbdev: Stop repeating tile configuration on stagnation")
Reported-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190215123019.32283-1-chris@chris-wilson.co.uk
Cc: <stable@vger.kernel.org> # v3.19+
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/gpu/drm/i915/intel_fbdev.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
index da2d309..14eb8a0 100644
--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -326,8 +326,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 				    bool *enabled, int width, int height)
 {
 	struct drm_i915_private *dev_priv = to_i915(fb_helper->dev);
-	unsigned long conn_configured, conn_seq, mask;
 	unsigned int count = min(fb_helper->connector_count, BITS_PER_LONG);
+	unsigned long conn_configured, conn_seq;
 	int i, j;
 	bool *save_enabled;
 	bool fallback = true, ret = true;
@@ -345,10 +345,9 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 		drm_modeset_backoff(&ctx);
 
 	memcpy(save_enabled, enabled, count);
-	mask = GENMASK(count - 1, 0);
+	conn_seq = GENMASK(count - 1, 0);
 	conn_configured = 0;
 retry:
-	conn_seq = conn_configured;
 	for (i = 0; i < count; i++) {
 		struct drm_fb_helper_connector *fb_conn;
 		struct drm_connector *connector;
@@ -361,7 +360,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 		if (conn_configured & BIT(i))
 			continue;
 
-		if (conn_seq == 0 && !connector->has_tile)
+		/* First pass, only consider tiled connectors */
+		if (conn_seq == GENMASK(count - 1, 0) && !connector->has_tile)
 			continue;
 
 		if (connector->status == connector_status_connected)
@@ -465,8 +465,10 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 		conn_configured |= BIT(i);
 	}
 
-	if ((conn_configured & mask) != mask && conn_configured != conn_seq)
+	if (conn_configured != conn_seq) { /* repeat until no more are found */
+		conn_seq = conn_configured;
 		goto retry;
+	}
 
 	/*
 	 * If the BIOS didn't enable everything it could, fall back to have the
-- 
1.7.9.5

