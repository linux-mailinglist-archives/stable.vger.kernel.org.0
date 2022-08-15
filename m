Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13945944A4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345230AbiHOWTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350491AbiHOWRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:17:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCAA4D262;
        Mon, 15 Aug 2022 12:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95A5C611DD;
        Mon, 15 Aug 2022 19:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E4FC433D6;
        Mon, 15 Aug 2022 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592458;
        bh=yqibmGB8lQdsS1eWP4a+ONsj3+OHTEMl5n8rAQ0Jouo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvkyQPJIW8+UxDc4D3suHZ+nRU6NYBc0vocM4SBGkgvT5Z51PmwF4MzfuI9fPu255
         7RzBczu8zCWuNWI9vj+fqxanL4XjEqOCG5sQz56ABqVLXwoCQTIXbA+xy/gl77yn6M
         CMwNDZMRlMghzSDy+h8vlPBe2ibnzWk/5TjUXt6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20Gon=C3=A7alves?= <nunojpg@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 5.19 0086/1157] drm/fb-helper: Fix out-of-bounds access
Date:   Mon, 15 Aug 2022 19:50:42 +0200
Message-Id: <20220815180442.996471118@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ae25885bdf59fde40726863c57fd20e4a0642183 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -680,7 +680,11 @@ static void drm_fb_helper_damage(struct
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
@@ -715,22 +719,29 @@ static void drm_fb_helper_memory_range_t
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


