Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C94328DBD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbhCATQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:16:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241125AbhCATMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328DA650B4;
        Mon,  1 Mar 2021 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620574;
        bh=rNSZs4mihJpUWJ7OPGrVQqG4L1qeF4eDXCsXT4fKYAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hT7kWCoR0o3p/jJkLEYO7eK+lHVZzWCA7mXjT4/RINwaYpqqMIGNDccO9AvHEP84V
         g1yF3srkBn0wi1g8717T5cApt30bBRoGShFyfplm+X8V38ZmA84e+eoZXN5aQN8r3b
         Gwdy9nJk+aZYyQNSVWyq9b97gnQw5X+aKUdvI+Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 172/775] drm/fb-helper: Add missed unlocks in setcmap_legacy()
Date:   Mon,  1 Mar 2021 17:05:40 +0100
Message-Id: <20210301161210.142834027@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 4b81195106875..e82db0f4e7715 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -946,11 +946,15 @@ static int setcmap_legacy(struct fb_cmap *cmap, struct fb_info *info)
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
@@ -963,8 +967,9 @@ static int setcmap_legacy(struct fb_cmap *cmap, struct fb_info *info)
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



