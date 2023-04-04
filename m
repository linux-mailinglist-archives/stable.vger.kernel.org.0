Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA376D6D4B
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbjDDTku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 15:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbjDDTku (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 15:40:50 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5697B44AA
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 12:40:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id ew6so135011260edb.7
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 12:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680637248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L+bv+X+HUb7L5CiJGIhzyoiVMLKFlHsSpQjg6oJVXtI=;
        b=cYDXCCCUhljhT5VPYCL0i1wlKB9kZDxS20bKdGXohA3mKYc0j/VM8xuKBq++xsT/FO
         KOTG0d6xoIWtn15OGqzvEhNlUffM5bmo/uiCyflzgvlVsV2i35VpJGYGVSuDGn4c3Mdp
         NOWcerctpXLigN5ou2obCjphHR01ABKqLdzN4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680637248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+bv+X+HUb7L5CiJGIhzyoiVMLKFlHsSpQjg6oJVXtI=;
        b=OwqJluFNk95FUFDYk14Ul5o5kCVr7t6TaC4Bn+HQjFFAZqQwFGN6vDVQgWK2HYkCwd
         v33rqNYJXpYfBoE4MdhNr8kz1qMlHIS/Cf1Z2c90LY5V0SRP1RwWHsc2/dYkwvne7HPw
         q8NNaznrRKogCseZF3pArfDTU/K90lwAPxYkGxmnJxsc6dGnT7DKk/ZPgDe+4wfPPgRk
         3SlRWqgSSDRUQ9vpOtYiSFH2Q/BW7aKFoVr5Dodi5NsmlZRZgi4Ax7iRidpbAi9ps1u8
         kHJgxIPZTdOUYCYHcfVkJsHs+21dWYFuVYbxj0okqU0e8Xs9Bq/vezXVppv3LrxXwTCJ
         cUTQ==
X-Gm-Message-State: AAQBX9fna2EWqX0+122k9S54KUzDrUtyHnUPNR02rFgHkRbHURbEsn4Y
        nAP5N3YgpNwWQfO8vtM9kP8oMQ==
X-Google-Smtp-Source: AKy350ZtXHF1TPelo6oE7RtQoe5ej7WiN9rL6H4LQHP7Ad2sqMbJJjjz7lkfoAFWB9Zxq2T2ONeuMw==
X-Received: by 2002:a05:6402:2811:b0:502:465:28e1 with SMTP id h17-20020a056402281100b00502046528e1mr4147038ede.0.1680637247791;
        Tue, 04 Apr 2023 12:40:47 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id xb7-20020a170907070700b00948c2f245a9sm2472802ejb.110.2023.04.04.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 12:40:47 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 1/3] drm/fb-helper: set x/yres_virtual in drm_fb_helper_check_var
Date:   Tue,  4 Apr 2023 21:40:36 +0200
Message-Id: <20230404194038.472803-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers are supposed to fix this up if needed if they don't outright
reject it. Uncovered by 6c11df58fd1a ("fbmem: Check virtual screen
sizes in fb_set_var()").

Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
Cc: stable@vger.kernel.org # v5.4+
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/drm_fb_helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 59409820f424..eb4ece3e0027 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1595,6 +1595,9 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 		return -EINVAL;
 	}
 
+	var->xres_virtual = fb->width;
+	var->yres_virtual = fb->height;
+
 	/*
 	 * Workaround for SDL 1.2, which is known to be setting all pixel format
 	 * fields values to zero in some cases. We treat this situation as a
-- 
2.40.0

