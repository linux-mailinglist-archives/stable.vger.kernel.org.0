Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8F532881F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbhCARdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:33:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238428AbhCAR1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:27:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADDB165083;
        Mon,  1 Mar 2021 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617435;
        bh=nyqPznlIgn3UOaa5hCktShuwtjijwSgNN+JeTbVnz5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcg1EY2FuZbsM5bdI5WH1SFNi6zAMbRFGEQtZMqRdFVvwHcYme/QqCdgvpGHZR92G
         +FMP7cWDUZbWjr4HlWjjlQvkHaqRTfFUSxjmZjHbBWGOIZ8pcIlUEHQWxsfWDKvf60
         IJgyS4aD+432dGo4kC7wP8/nqYFtFnEbQhYzZ65k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/340] drm/fb-helper: Add missed unlocks in setcmap_legacy()
Date:   Mon,  1 Mar 2021 17:10:17 +0100
Message-Id: <20210301161051.920568163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 0a260e731d6c4c17547ac275a2cde888a9eb4a3d ]

setcmap_legacy() does not call drm_modeset_unlock_all() in some exits,
add the missed unlocks with goto to fix it.

Fixes: 964c60063bff ("drm/fb-helper: separate the fb_setcmap helper into atomic and legacy paths")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20201203144248.418281-1-hslester96@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 6b8502bcf0fd3..02ffde5fd7226 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -965,11 +965,15 @@ static int setcmap_legacy(struct fb_cmap *cmap, struct fb_info *info)
 	drm_modeset_lock_all(fb_helper->dev);
 	drm_client_for_each_modeset(modeset, &fb_helper->client) {
 		crtc = modeset->crtc;
-		if (!crtc->funcs->gamma_set || !crtc->gamma_size)
-			return -EINVAL;
+		if (!crtc->funcs->gamma_set || !crtc->gamma_size) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (cmap->start + cmap->len > crtc->gamma_size)
-			return -EINVAL;
+		if (cmap->start + cmap->len > crtc->gamma_size) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		r = crtc->gamma_store;
 		g = r + crtc->gamma_size;
@@ -982,8 +986,9 @@ static int setcmap_legacy(struct fb_cmap *cmap, struct fb_info *info)
 		ret = crtc->funcs->gamma_set(crtc, r, g, b,
 					     crtc->gamma_size, NULL);
 		if (ret)
-			return ret;
+			goto out;
 	}
+out:
 	drm_modeset_unlock_all(fb_helper->dev);
 
 	return ret;
-- 
2.27.0



