Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07756D60DD
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbjDDMh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 08:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbjDDMhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 08:37:20 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE35D46A8
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 05:36:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eh3so129918608edb.11
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 05:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1680611788; x=1683203788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ytb1Vj4ccJ8fQhhuaM6FADRjPSh2hGFkD2p+/X8w2sQ=;
        b=F/3ENKHkSYxaFUpT33R//n7OuGJ+0CXCwZgjCXPQx5kryiqI28kGX6v3VImyd6HHkL
         EHqo0zkYpfaIoFlxPzlPB4N/gno7PN39P4foM/iXnnRDyRssj8u57TkAjfbw/Rw64GZH
         +KryYEJVU9DGuyIK+53HfknTT1sDDSjgtT5Eg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680611788; x=1683203788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ytb1Vj4ccJ8fQhhuaM6FADRjPSh2hGFkD2p+/X8w2sQ=;
        b=KjmloeRoWlEqOEtXlAJ07JX5uelV2OLDZQPB8uIhmt0ILyun5aOhnZ7AoeXr2gccif
         UZRrOfNMsqRqhBt8MPMDT3O8VUlU2ros+ptTt4xeTAS3Zk+TRRqFHnRQuPu0+5LBIqGZ
         0tYBkttw3Zg4tvKFGsSqdd4j9eyENXXAjkIPiX5Ao2zQPxRDSYINzKVMxqTerha3cf/7
         Fz6QPtI0tdRAoqWPdXJ1DkRqGyPyu2OIJZ/x6koYuV8vW67MFs8NgJBeN20ivwFshTg8
         GUNmivn59UEA1tylGQ+AY+iligRaYLCShAtqRgN4SrVe6J9bID22nyiJiCblobO3HVVj
         xi4w==
X-Gm-Message-State: AAQBX9f+ryiLv51RrsiUJdZE6h282D43D1IjwoansY6kqV2tAhuyR21w
        9T6LBAInX4zuD2X061CnRxXPtg==
X-Google-Smtp-Source: AKy350YazvVsTB8X9wr7pFrnVUPrxE/2xq65YwKSqqMdrVcrAQL3zV3EzyW7APLGff+i6K+q2N2/IA==
X-Received: by 2002:a17:906:51cd:b0:949:148d:82c1 with SMTP id v13-20020a17090651cd00b00949148d82c1mr1762449ejk.0.1680611787958;
        Tue, 04 Apr 2023 05:36:27 -0700 (PDT)
Received: from phenom.ffwll.local (212-51-149-33.fiber7.init7.net. [212.51.149.33])
        by smtp.gmail.com with ESMTPSA id j3-20020a170906050300b00947a40ded80sm5761642eja.104.2023.04.04.05.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:36:27 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com,
        Helge Deller <deller@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] fbdev: Don't spam dmesg on bad userspace ioctl input
Date:   Tue,  4 Apr 2023 14:36:24 +0200
Message-Id: <20230404123624.360384-1-daniel.vetter@ffwll.ch>
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

There's a few reasons the kernel should not spam dmesg on bad
userspace ioctl input:
- at warning level it results in CI false positives
- it allows userspace to drown dmesg output, potentially hiding real
  issues.

None of the other generic EINVAL checks report in the
FBIOPUT_VSCREENINFO ioctl do this, so it's also inconsistent.

I guess the intent of the patch which introduced this warning was that
the drivers ->fb_check_var routine should fail in that case. Reality
is that there's too many fbdev drivers and not enough people
maintaining them by far, and so over the past few years we've simply
handled all these validation gaps by tighning the checks in the core,
because that's realistically really all that will ever happen.

Reported-by: syzbot+20dcf81733d43ddff661@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=c5faf983bfa4a607de530cd3bb008888bf06cefc
Fixes: 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
Cc: Helge Deller <deller@gmx.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org # v5.4+
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/video/fbdev/core/fbmem.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 875541ff185b..9757f4bcdf57 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1021,10 +1021,6 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 	/* verify that virtual resolution >= physical resolution */
 	if (var->xres_virtual < var->xres ||
 	    var->yres_virtual < var->yres) {
-		pr_warn("WARNING: fbcon: Driver '%s' missed to adjust virtual screen size (%ux%u vs. %ux%u)\n",
-			info->fix.id,
-			var->xres_virtual, var->yres_virtual,
-			var->xres, var->yres);
 		return -EINVAL;
 	}
 
-- 
2.40.0

