Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFAA590129
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiHKPv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbiHKPvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081D5979EF;
        Thu, 11 Aug 2022 08:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98B4C616C2;
        Thu, 11 Aug 2022 15:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661CBC433D7;
        Thu, 11 Aug 2022 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232563;
        bh=xQmukVhejqSSvaIVDFsfMkvhcUx1mL0PI7bqN3mEXus=;
        h=From:To:Cc:Subject:Date:From;
        b=d4CXwt1cqNnn59qi82DeBc3VC6j8uMAsfvf/RUV7u+XJFVp2hwcQnaFYQBmdMwGuT
         ens8eCyDYDXi8U8k87Vada0Xw3uTiSdnzYkRl92HPw0ioYnFpsJ54zgG4LXGVuxb6h
         l6ICuYjJju0rLx554ZelyWN/htQLON4TlmMxs4IDH3PzoiEvqgUoBxKRIfE1Posy3E
         s41U0vjlXMf64y9jlAqO3DsCsLBcjQ+nL4hGtLAXCxxpCSCccShBN42anIUXK0zsqo
         nu6ybCyKpZ6z4M9qXVmqKj/6BQXHltGqB1Ta+2jJpaGybdU431cD4zUwipW+ImqYST
         InHqQ2dm0O0Zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, daniel@ffwll.ch,
        deller@gmx.de, tzimmermann@suse.de, sam@ravnborg.org,
        alexander.deucher@amd.com, deng.changcheng@zte.com.cn,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 01/93] fbdev: Restart conflicting fb removal loop when unregistering devices
Date:   Thu, 11 Aug 2022 11:40:55 -0400
Message-Id: <20220811154237.1531313-1-sashal@kernel.org>
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
index 643383d74edc..82880f59ba67 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1566,6 +1566,7 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 {
 	int i;
 
+restart_removal:
 	/* check all firmware fbs and kick off if the base addr overlaps */
 	for_each_registered_fb(i) {
 		struct apertures_struct *gen_aper;
@@ -1600,12 +1601,23 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
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
@@ -1946,13 +1958,9 @@ EXPORT_SYMBOL(register_framebuffer);
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
index 9a77ab615c36..ae399d3ea4f9 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -503,7 +503,6 @@ struct fb_info {
 	} *apertures;
 
 	bool skip_vt_switch; /* no VT switch on suspend/resume required */
-	bool forced_out; /* set when being removed by another driver */
 };
 
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
-- 
2.35.1

