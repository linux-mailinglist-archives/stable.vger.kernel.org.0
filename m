Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E2347AF40
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbhLTPKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbhLTPIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:08:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D721EC0A885B;
        Mon, 20 Dec 2021 06:54:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB70B80EF0;
        Mon, 20 Dec 2021 14:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42A0C36AE8;
        Mon, 20 Dec 2021 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012039;
        bh=STWsFiiFqwpzbv1ZsyuUQl56z9SBv+FNIeXEY8UGfN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxHqJR1gYSL0g1sAh/iQUkISg1r7Ff+JdsHbEgU67KIIBW7zcDw2pDTKJnaLFImTa
         5a/hufmlNhiucqaijJ14hCXHIE+TNd+f+S5w+WHWRa/blZCLpVZNNxZTLumO5JO0Ru
         RQ1uoukNoWs/8U5OR9GvJXo+8NWcsstBKqUgbl3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Stezenbach <js@sig21.net>,
        Javier Martinez Canillas <javierm@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/177] Revert "drm/fb-helper: improve DRM fbdev emulation device names"
Date:   Mon, 20 Dec 2021 15:33:28 +0100
Message-Id: <20211220143042.053057775@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 842470c4e211f284a224842849b1fa81b130c154 ]

This reverts commit b3484d2b03e4c940a9598aa841a52d69729c582a.

That change attempted to improve the DRM drivers fbdev emulation device
names to avoid having confusing names like "simpledrmdrmfb" in /proc/fb.

But unfortunately, there are user-space programs such as pm-utils that
match against the fbdev names and so broke after the mentioned commit.

Since the names in /proc/fb are used by tools that consider it an uAPI,
let's restore the old names even when this lead to silly names like the
one mentioned above.

Fixes: b3484d2b03e4 ("drm/fb-helper: improve DRM fbdev emulation device names")
Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211020165740.3011927-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 8e7a124d6c5a3..22bf690910b25 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1743,7 +1743,13 @@ void drm_fb_helper_fill_info(struct fb_info *info,
 			       sizes->fb_width, sizes->fb_height);
 
 	info->par = fb_helper;
-	snprintf(info->fix.id, sizeof(info->fix.id), "%s",
+	/*
+	 * The DRM drivers fbdev emulation device name can be confusing if the
+	 * driver name also has a "drm" suffix on it. Leading to names such as
+	 * "simpledrmdrmfb" in /proc/fb. Unfortunately, it's an uAPI and can't
+	 * be changed due user-space tools (e.g: pm-utils) matching against it.
+	 */
+	snprintf(info->fix.id, sizeof(info->fix.id), "%sdrmfb",
 		 fb_helper->dev->driver->name);
 
 }
-- 
2.33.0



