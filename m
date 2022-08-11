Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387F65902AD
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbiHKQMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237440AbiHKQMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:12:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FADC66A71;
        Thu, 11 Aug 2022 08:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F25A7B8214A;
        Thu, 11 Aug 2022 15:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B11C433D6;
        Thu, 11 Aug 2022 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233398;
        bh=c43hwv3IsCqgSm2DiFNJ6q9oPVHVaIVOuIIAd8QFku8=;
        h=From:To:Cc:Subject:Date:From;
        b=uDsblE/TGlh+dUzEp4LLWPsP5+hpWUWLbOY5xvfolhUoyZ399apO59Q30cinFD8KS
         dxOADy64owEBGJKDew4dQPrkPK4b2SP65w/4tQDRph/b8KAphojRzy5qqEae4PiMeL
         UJRViDxhm9S1jX/6bf9ksWByPuFn3bSYrFHkLhABLianRJCsZr+XJ5HBh/6xagq6xD
         YfQ6Mvdhw7qILqZST+Wvdgu8y86CQZFQyR2pqwmamcUCSaHDjEcF40BwIlwDWSCPrn
         pP5RBXUnAJ/TwIvQRbGzTSvZRJqy6TFWtS5aflSCZWVVjCdpvTiF50KnTdEWYu+BTU
         +k4fe6kKO2ZJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, daniel@ffwll.ch,
        deller@gmx.de, tzimmermann@suse.de, sam@ravnborg.org,
        alexander.deucher@amd.com, deng.changcheng@zte.com.cn,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 01/69] fbdev: Restart conflicting fb removal loop when unregistering devices
Date:   Thu, 11 Aug 2022 11:55:10 -0400
Message-Id: <20220811155632.1536867-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 3367aa7d74d240261de2543ddb35531ccad9d884 ]

Drivers that want to remove registered conflicting framebuffers prior to
register their own framebuffer, call to remove_conflicting_framebuffers().

This function takes the registration_lock mutex, to prevent a race when
drivers register framebuffer devices. But if a conflicting framebuffer
device is found, the underlaying platform device is unregistered and this
will lead to the platform driver .remove callback to be called. Which in
turn will call to unregister_framebuffer() that takes the same lock.

To prevent this, a struct fb_info.forced_out field was used as indication
to unregister_framebuffer() whether the mutex has to be grabbed or not.

But this could be unsafe, since the fbdev core is making assumptions about
what drivers may or may not do in their .remove callbacks. Allowing to run
these callbacks with the registration_lock held can cause deadlocks, since
the fbdev core has no control over what drivers do in their removal path.

A better solution is to drop the lock before platform_device_unregister(),
so unregister_framebuffer() can take it when called from the fbdev driver.
The lock is acquired again after the device has been unregistered and at
this point the removal loop can be restarted.

Since the conflicting framebuffer device has already been removed, the
loop would just finish when no more conflicting framebuffers are found.

Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220511113039.1252432-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c | 22 +++++++++++++++-------
 include/linux/fb.h               |  1 -
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 528c87ff14d8..619d82e20d4e 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1568,6 +1568,7 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 {
 	int i;
 
+restart_removal:
 	/* check all firmware fbs and kick off if the base addr overlaps */
 	for_each_registered_fb(i) {
 		struct apertures_struct *gen_aper;
@@ -1602,12 +1603,23 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 				 */
 				do_unregister_framebuffer(registered_fb[i]);
 			} else if (dev_is_platform(device)) {
-				registered_fb[i]->forced_out = true;
+				/*
+				 * Drop the lock because if the device is unregistered, its
+				 * driver will call to unregister_framebuffer(), that takes
+				 * this lock.
+				 */
+				mutex_unlock(&registration_lock);
 				platform_device_unregister(to_platform_device(device));
+				mutex_lock(&registration_lock);
 			} else {
 				pr_warn("fb%d: cannot remove device\n", i);
 				do_unregister_framebuffer(registered_fb[i]);
 			}
+			/*
+			 * Restart the removal loop now that the device has been
+			 * unregistered and its associated framebuffer gone.
+			 */
+			goto restart_removal;
 		}
 	}
 }
@@ -1945,13 +1957,9 @@ EXPORT_SYMBOL(register_framebuffer);
 void
 unregister_framebuffer(struct fb_info *fb_info)
 {
-	bool forced_out = fb_info->forced_out;
-
-	if (!forced_out)
-		mutex_lock(&registration_lock);
+	mutex_lock(&registration_lock);
 	do_unregister_framebuffer(fb_info);
-	if (!forced_out)
-		mutex_unlock(&registration_lock);
+	mutex_unlock(&registration_lock);
 }
 EXPORT_SYMBOL(unregister_framebuffer);
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 3d7306c9a706..02f362c661c8 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -502,7 +502,6 @@ struct fb_info {
 	} *apertures;
 
 	bool skip_vt_switch; /* no VT switch on suspend/resume required */
-	bool forced_out; /* set when being removed by another driver */
 };
 
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
-- 
2.35.1

