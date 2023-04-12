Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3204B6DFDC9
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 20:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjDLSmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 14:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDLSmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 14:42:09 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E795E51
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 11:42:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-2f45377dcc7so130406f8f.1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 11:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1681324927; x=1683916927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ec8CKxGhnACrZ8hcY1NoeaXk7CEhzDVHpK3LN1wYN4=;
        b=Q/9GEYHNM5MAD8Y6u9GMe3XXxcVC0j+yOEv9n/SS/29KypsEuUpvV8qhWcPTwlWSWW
         eiy78yHOzE9ufibU30p1S/udcrMCg2JWxNvHq+AZpw6zJAdaWvC6OVWdEVcVu+7Hkt+S
         khkNDBFhgxzeYGtJvuQARqYatNkNu78QOz9mA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681324927; x=1683916927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ec8CKxGhnACrZ8hcY1NoeaXk7CEhzDVHpK3LN1wYN4=;
        b=TNfWGEIvL+dLXTqql8RnuPSERNcYOhSOvsstNDvI5KNTTEX6MR6bloJagtoCfs4NC/
         0SOsYRy1/5Ah+9bDEHq1d5jTK/fSzNoFM+7T0heO+QGo2/AktbmyrP521d3oYQoBDR0v
         n2bGba0s0ztyPRaH7jji/e00A80yZiHDrj2pjfImd7Jf8EiaZoerTU9SbGur2qVP5cDp
         ct9cVM+lkUHxwvw4AjTOvxlUdsc/M5IpVQNt2IyEmNJDvUN+klfCW0Wqg1Zi6uFumCs1
         +f3CvGAAdvg8EbRzjIS/yhs2wxuyGc3fAVjoILF7Wv3osHiqwoGSl4ulMo36ptf/y1Kk
         Co3w==
X-Gm-Message-State: AAQBX9ftzaKTxGrqFvOd1p70B44QmFrNhL6H+rBSmWyjpUEYjpFSRnwt
        BIMTCB82JTZthHjqc968PjO/nw==
X-Google-Smtp-Source: AKy350aRH19+zFexV3bYTMsdE6XeWtLgtLPwnCf2FX7WcSOxYv0gNzXFUJR1uMH6k5UPxNe336TTEg==
X-Received: by 2002:a5d:6581:0:b0:2c9:8b81:bd04 with SMTP id q1-20020a5d6581000000b002c98b81bd04mr2185513wru.0.1681324926980;
        Wed, 12 Apr 2023 11:42:06 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id k13-20020a5d66cd000000b002f28de9f73bsm6293044wrw.55.2023.04.12.11.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 11:42:06 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     security@kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Xingyuan Mo <hdthky0@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>, Helge Deller <deller@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] fbcon: set_con2fb_map needs to set con2fb_map!
Date:   Wed, 12 Apr 2023 20:41:52 +0200
Message-Id: <20230412184152.213506-2-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412184152.213506-1-daniel.vetter@ffwll.ch>
References: <20230412184152.213506-1-daniel.vetter@ffwll.ch>
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

I got really badly confused in d443d9386472 ("fbcon: move more common
code into fb_open()") because we set the con2fb_map before the failure
points, which didn't look good.

But in trying to fix that I moved the assignment into the wrong path -
we need to do it for _all_ vc we take over, not just the first one
(which additionally requires the call to con2fb_acquire_newinfo).

I've figured this out because of a KASAN bug report, where the
fbcon_registered_fb and fbcon_display arrays went out of sync in
fbcon_mode_deleted() because the con2fb_map pointed at the old
fb_info, but the modes and everything was updated for the new one.

Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Fixes: d443d9386472 ("fbcon: move more common code into fb_open()")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Xingyuan Mo <hdthky0@gmail.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.19+
---
 drivers/video/fbdev/core/fbcon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 52f6ce8e794a..eb565a10e5cd 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -846,10 +846,11 @@ static int set_con2fb_map(int unit, int newidx, int user)
 		if (err)
 			return err;
 
-		con2fb_map[unit] = newidx;
 		fbcon_add_cursor_work(info);
 	}
 
+	con2fb_map[unit] = newidx;
+
 	/*
 	 * If old fb is not mapped to any of the consoles,
 	 * fbcon should release it.
-- 
2.40.0

