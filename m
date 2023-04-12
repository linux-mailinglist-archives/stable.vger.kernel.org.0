Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA066DFDC8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 20:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjDLSmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 14:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjDLSmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 14:42:09 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B642D68
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 11:42:07 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2f27a10f72bso220497f8f.0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 11:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1681324926; x=1683916926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zFG3aFpLF1SyuUuo1r0qEtH92YGNKfq0/bZWTEVilhs=;
        b=Lf59wXWsHdZ6WE8YJkjGZAUJ3oZCZMPaSnqW3n+T5FNdVDx7CMFCfNtXIW9oO+knQQ
         Xyh873IbyGInqrBJEs7eqs8Ujpf8gw5B2gOn/C1ZC0ISfVT/LWSAPKsklxNOdrNjABjH
         R8LXGqocX6UWq7IMW7Xh93qAc/C4M057w26NI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681324926; x=1683916926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zFG3aFpLF1SyuUuo1r0qEtH92YGNKfq0/bZWTEVilhs=;
        b=XdVrH8hr59TGQmOoNj1gv0MJWjV5VOW79acbnfc5V1ScC/XSw+t+Ui/HWEOA5c0edr
         iP1tRdE1Wd47If90sdgwkKzmCyr2/xgsdJZ6h6GO72p2zbR9pqVAKngLobwczYOtKvYd
         cuRs3ROWI2ibGgOrpWJoUqzfUI9h2ciY/Lhos53botf1HwHvF6sxx9w2V8XclreEnv3t
         DE9B5v+c+PecO4RQepZdVou8Rn9UviI+safSb8k5vNN+SIfRAIVBsZhe3/y58meV2ltQ
         YVvFeNxKktTTSjcndaBHwpxRy1o78hFofgSYGO8V2qbjMNJX1905nbl6Dfsk2wCaANND
         Mdcw==
X-Gm-Message-State: AAQBX9cyB5jWW07oWL2w0G/agr25axDxe4z+2x7mlZKePbJrL3wu0XkG
        7Fa+wMnEBSa0M2cyMuxcZkfdxQ==
X-Google-Smtp-Source: AKy350aDoKMtCqmzt+KBI0fyRu7JPwCwoMcOEi0rgJj5vdwsIB56Vr300jAzLNhQSO3Dq22fPLvsQA==
X-Received: by 2002:adf:ea0c:0:b0:2f5:7487:7b3d with SMTP id q12-20020adfea0c000000b002f574877b3dmr212196wrm.1.1681324926234;
        Wed, 12 Apr 2023 11:42:06 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id k13-20020a5d66cd000000b002f28de9f73bsm6293044wrw.55.2023.04.12.11.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 11:42:05 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     security@kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Xingyuan Mo <hdthky0@gmail.com>, Helge Deller <deller@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] fbcon: Fix error paths in set_con2fb_map
Date:   Wed, 12 Apr 2023 20:41:51 +0200
Message-Id: <20230412184152.213506-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a regressoin introduced in b07db3958485 ("fbcon: Ditch error
handling for con2fb_release_oldinfo"). I failed to realize that the
if (!err) checks and therefore flattening the control flow due to
con2fb_release_oldinfo() (which was impossible) wasn't correct,
because con2fb_acquire_newinfo() could fail.

Fix this with an early return statement.

Note that there's still a difference compared to the orginal state of
the code, the below lines are now also skipped on error:

	if (!search_fb_in_map(info_idx))
		info_idx = newidx;

These are only needed when we've actually thrown out an old fb_info
from the console mappings, which only happens later on.

Also move the fbcon_add_cursor_work() call into the same if block,
it's all protected by console_lock so doesn't matter when we set up
the blinking cursor delayed work anyway. This further simplifies the
control flow and allows us to ditch the found local variable.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Fixes: b07db3958485 ("fbcon: Ditch error handling for con2fb_release_oldinfo")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.19+
---
 drivers/video/fbdev/core/fbcon.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 0a2c47df01f4..52f6ce8e794a 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -823,7 +823,7 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	int oldidx = con2fb_map[unit];
 	struct fb_info *info = fbcon_registered_fb[newidx];
 	struct fb_info *oldinfo = NULL;
-	int found, err = 0, show_logo;
+	int err = 0, show_logo;
 
 	WARN_CONSOLE_UNLOCKED();
 
@@ -841,26 +841,25 @@ static int set_con2fb_map(int unit, int newidx, int user)
 	if (oldidx != -1)
 		oldinfo = fbcon_registered_fb[oldidx];
 
-	found = search_fb_in_map(newidx);
-
-	if (!err && !found) {
+	if (!search_fb_in_map(newidx)) {
 		err = con2fb_acquire_newinfo(vc, info, unit);
-		if (!err)
-			con2fb_map[unit] = newidx;
+		if (err)
+			return err;
+
+		con2fb_map[unit] = newidx;
+		fbcon_add_cursor_work(info);
 	}
 
 	/*
 	 * If old fb is not mapped to any of the consoles,
 	 * fbcon should release it.
 	 */
-	if (!err && oldinfo && !search_fb_in_map(oldidx))
+	if (oldinfo && !search_fb_in_map(oldidx))
 		con2fb_release_oldinfo(vc, oldinfo, info);
 
 	show_logo = (fg_console == 0 && !user &&
 			 logo_shown != FBCON_LOGO_DONTSHOW);
 
-	if (!found)
-		fbcon_add_cursor_work(info);
 	con2fb_map_boot[unit] = newidx;
 	con2fb_init_display(vc, info, unit, show_logo);
 
-- 
2.40.0

