Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEC662403
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbfGHP3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbfGHP3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8553A20645;
        Mon,  8 Jul 2019 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599755;
        bh=ND7lbqp39s4GIPSTjVhiU1UnmlxoVFRq31gK7a+756c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFxZB17CU5QpOtN8G7HVbNOGW/zYNZULnz1paQ6PNH8w0qwIO+S+u8QKPlns09Ydk
         5Sq/Aw0RkvsQXoAGfeubUCGCjL4LCOmjPQkhMaPdMiZ5d0tdeW+fegtEb41iudEMkF
         nQvyDFhkSDFRCHaynmZLt6dK5ReED63ROgc0fVlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 67/90] drm/fb-helper: generic: Dont take module ref for fbcon
Date:   Mon,  8 Jul 2019 17:13:34 +0200
Message-Id: <20190708150525.748813850@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6ab20a05f4c7ed45632e24d5397d6284e192567d ]

It's now safe to let fbcon unbind automatically on fbdev unregister.
The crash problem was fixed in commit 2122b40580dd
("fbdev: fbcon: Fix unregister crash when more than one framebuffer")

Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20190210131039.52664-13-noralf@tronnes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index a0663f44e218..8b546fde139d 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2957,7 +2957,8 @@ static int drm_fbdev_fb_open(struct fb_info *info, int user)
 {
 	struct drm_fb_helper *fb_helper = info->par;
 
-	if (!try_module_get(fb_helper->dev->driver->fops->owner))
+	/* No need to take a ref for fbcon because it unbinds on unregister */
+	if (user && !try_module_get(fb_helper->dev->driver->fops->owner))
 		return -ENODEV;
 
 	return 0;
@@ -2967,7 +2968,8 @@ static int drm_fbdev_fb_release(struct fb_info *info, int user)
 {
 	struct drm_fb_helper *fb_helper = info->par;
 
-	module_put(fb_helper->dev->driver->fops->owner);
+	if (user)
+		module_put(fb_helper->dev->driver->fops->owner);
 
 	return 0;
 }
-- 
2.20.1



