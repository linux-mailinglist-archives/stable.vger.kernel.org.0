Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAEB591A57
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbiHMMub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239184AbiHMMua (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:50:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A422F0
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E89AAB8015B
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33699C433D6;
        Sat, 13 Aug 2022 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395025;
        bh=NsOtHjdO3WRdOZ9gehdwgqR//lxwz7pEXCznQYRTz7w=;
        h=Subject:To:Cc:From:Date:From;
        b=ShmaM3QRWHRKDOdgNuhJS32fpCUNYAH1raq27MRkf6cbdlWmJoYX3bE8SdR+hQnw/
         pl/augCzasSS1UBiMq07i+XZc7JvcvtPWD1Lhz3Ix1zN4gLxF5E+zZIgPysl2ZlXYN
         8sNtHE/zjPUVat+y9d/ZGheY9langIHj1d4k4EBo=
Subject: FAILED: patch "[PATCH] drm/fb-helper: Fix out-of-bounds access" failed to apply to 5.18-stable tree
To:     tzimmermann@suse.de, javierm@redhat.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        nunojpg@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 14:50:23 +0200
Message-ID: <16603950232212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ae25885bdf59fde40726863c57fd20e4a0642183 Mon Sep 17 00:00:00 2001
From: Thomas Zimmermann <tzimmermann@suse.de>
Date: Tue, 21 Jun 2022 12:46:17 +0200
Subject: [PATCH] drm/fb-helper: Fix out-of-bounds access
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Clip memory range to screen-buffer size to avoid out-of-bounds access
in fbdev deferred I/O's damage handling.

Fbdev's deferred I/O can only track pages. From the range of pages, the
damage handler computes the clipping rectangle for the display update.
If the fbdev screen buffer ends near the beginning of a page, that page
could contain more scanlines. The damage handler would then track these
non-existing scanlines as dirty and provoke an out-of-bounds access
during the screen update. Hence, clip the maximum memory range to the
size of the screen buffer.

While at it, rename the variables min/max to min_off/max_off in
drm_fb_helper_deferred_io(). This avoids confusion with the macros of
the same name.

Reported-by: Nuno Gonçalves <nunojpg@gmail.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Nuno Gonçalves <nunojpg@gmail.com>
Fixes: 67b723f5b742 ("drm/fb-helper: Calculate damaged area in separate helper")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: <stable@vger.kernel.org> # v5.18+
Link: https://patchwork.freedesktop.org/patch/msgid/20220621104617.8817-1-tzimmermann@suse.de

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 5e9c373e6b88..2d4cee6a10ff 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -681,7 +681,11 @@ static void drm_fb_helper_damage(struct fb_info *info, u32 x, u32 y,
 	schedule_work(&helper->damage_work);
 }
 
-/* Convert memory region into area of scanlines and pixels per scanline */
+/*
+ * Convert memory region into area of scanlines and pixels per
+ * scanline. The parameters off and len must not reach beyond
+ * the end of the framebuffer.
+ */
 static void drm_fb_helper_memory_range_to_clip(struct fb_info *info, off_t off, size_t len,
 					       struct drm_rect *clip)
 {
@@ -716,22 +720,29 @@ static void drm_fb_helper_memory_range_to_clip(struct fb_info *info, off_t off,
  */
 void drm_fb_helper_deferred_io(struct fb_info *info, struct list_head *pagereflist)
 {
-	unsigned long start, end, min, max;
+	unsigned long start, end, min_off, max_off;
 	struct fb_deferred_io_pageref *pageref;
 	struct drm_rect damage_area;
 
-	min = ULONG_MAX;
-	max = 0;
+	min_off = ULONG_MAX;
+	max_off = 0;
 	list_for_each_entry(pageref, pagereflist, list) {
 		start = pageref->offset;
 		end = start + PAGE_SIZE;
-		min = min(min, start);
-		max = max(max, end);
+		min_off = min(min_off, start);
+		max_off = max(max_off, end);
 	}
-	if (min >= max)
+	if (min_off >= max_off)
 		return;
 
-	drm_fb_helper_memory_range_to_clip(info, min, max - min, &damage_area);
+	/*
+	 * As we can only track pages, we might reach beyond the end
+	 * of the screen and account for non-existing scanlines. Hence,
+	 * keep the covered memory area within the screen buffer.
+	 */
+	max_off = min(max_off, info->screen_size);
+
+	drm_fb_helper_memory_range_to_clip(info, min_off, max_off - min_off, &damage_area);
 	drm_fb_helper_damage(info, damage_area.x1, damage_area.y1,
 			     drm_rect_width(&damage_area),
 			     drm_rect_height(&damage_area));

