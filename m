Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E859366369C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 02:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjAJBTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 20:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjAJBTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 20:19:14 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4B362EE
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 17:19:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so14747865pjj.2
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 17:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JRJYNk03xPF7I0f3RiiUNSrwj7K0SCkYwCDphRZWj3c=;
        b=LYUy8d956TFa4i0X/jINb9cLqY6o2DO8RoacHNTbbqpl8LHI2/Qg246QCSQgHVA+nH
         HJSdqiBTvghIgiNFKN+RnWDfVLcTTn1WiBk2hYjjliNu1Hb2C6+1JXHTA8Yqa0uUud+P
         UdwMdphpyLdOm8qn7t1kn+/887P41sckwQAH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JRJYNk03xPF7I0f3RiiUNSrwj7K0SCkYwCDphRZWj3c=;
        b=miKZNHs21wVIxevUX4NUyQgzp0qnDhuRc0MMi3yv4tiO/sl7DOus4re4Q09m9gtLMr
         FJx/unkPLXYgMKketm5yU66hCwfEy6HtPeVczm8p+QZBumXmg4YhCbcRpbpefUY1dKdb
         6c8zMIQix/Z8/BjxRUP4FHoMpGQTKeboGL71R0ylXsv1V7N42RqmZ0VRGkB2TBF5ae3M
         YSLa+MD6fUCKYZsvmqxao97lipnTDgcj+Eh+7ayXtzRAcsl+6xDdGX/mIUUcIqVX4zDN
         8iKk4d7OBcW0MknZqk6Mh1MHUYlLfYSLnIJxoooDKCbeAgqEzCavNp0GeR8Quc4OT11F
         SPrw==
X-Gm-Message-State: AFqh2krAibyPZWAnt2n4/lGO+dWNnq3nsOTM96jeLXy7ACGL7h2bCyAH
        TKSW+8FisGPkEXNE4tLp8dK+Qg==
X-Google-Smtp-Source: AMrXdXt7E/WtGBXtZLOsFB0eXRM7CAxST+jXno99j/6BC6C7198kPAZn7z/EVahK9YCxBH+9/0JnBQ==
X-Received: by 2002:a17:902:e951:b0:193:2ed4:561a with SMTP id b17-20020a170902e95100b001932ed4561amr5989384pll.38.1673313552926;
        Mon, 09 Jan 2023 17:19:12 -0800 (PST)
Received: from localhost ([2620:15c:9d:2:99d8:feca:9efd:a216])
        by smtp.gmail.com with UTF8SMTPSA id u1-20020a170902714100b001933355456esm17519plm.215.2023.01.09.17.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 17:19:12 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>
Cc:     linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Sandy Huang <hjc@rock-chips.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@mailbox.org>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/2] drm/atomic: Allow vblank-enabled + self-refresh "disable"
Date:   Mon,  9 Jan 2023 17:18:16 -0800
Message-Id: <20230109171809.v3.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The self-refresh helper framework overloads "disable" to sometimes mean
"go into self-refresh mode," and this mode activates automatically
(e.g., after some period of unchanging display output). In such cases,
the display pipe is still considered "on", and user-space is not aware
that we went into self-refresh mode. Thus, users may expect that
vblank-related features (such as DRM_IOCTL_WAIT_VBLANK) still work
properly.

However, we trigger the WARN_ONCE() here if a CRTC driver tries to leave
vblank enabled.

Add a different expectation: that CRTCs *should* leave vblank enabled
when going into self-refresh.

This patch is preparation for another patch -- "drm/rockchip: vop: Leave
vblank enabled in self-refresh" -- which resolves conflicts between the
above self-refresh behavior and the API tests in IGT's kms_vblank test
module.

== Some alternatives discussed: ==

It's likely that on many display controllers, vblank interrupts will
turn off when the CRTC is disabled, and so in some cases, self-refresh
may not support vblank. To support such cases, we might consider
additions to the generic helpers such that we fire vblank events based
on a timer.

However, there is currently only one driver using the common
self-refresh helpers (i.e., rockchip), and at least as of commit
bed030a49f3e ("drm/rockchip: Don't fully disable vop on self refresh"),
the CRTC hardware is powered enough to continue to generate vblank
interrupts.

So we chose the simpler option of leaving vblank interrupts enabled. We
can reevaluate this decision and perhaps augment the helpers if/when we
gain a second driver that has different requirements.

v3:
 * include discussion summary

v2:
 * add 'ret != 0' warning case for self-refresh
 * describe failing test case and relation to drm/rockchip patch better

Cc: <stable@vger.kernel.org> # dependency for "drm/rockchip: vop: Leave
                             # vblank enabled in self-refresh"
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index d579fd8f7cb8..a22485e3e924 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1209,7 +1209,16 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
 			continue;
 
 		ret = drm_crtc_vblank_get(crtc);
-		WARN_ONCE(ret != -EINVAL, "driver forgot to call drm_crtc_vblank_off()\n");
+		/*
+		 * Self-refresh is not a true "disable"; ensure vblank remains
+		 * enabled.
+		 */
+		if (new_crtc_state->self_refresh_active)
+			WARN_ONCE(ret != 0,
+				  "driver disabled vblank in self-refresh\n");
+		else
+			WARN_ONCE(ret != -EINVAL,
+				  "driver forgot to call drm_crtc_vblank_off()\n");
 		if (ret == 0)
 			drm_crtc_vblank_put(crtc);
 	}
-- 
2.39.0.314.g84b9a713c41-goog

