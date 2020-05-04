Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CD51C388C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 13:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEDLqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 07:46:08 -0400
Received: from relay.sw.ru ([185.231.240.75]:48250 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbgEDLqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 07:46:08 -0400
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1jVZXx-0002Ve-Rd; Mon, 04 May 2020 14:46:06 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 4.4] drm/qxl: qxl_release leak in qxl_draw_dirty_fb()
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <59a0935c-6492-edc2-a7df-c116c9ecae2b@virtuozzo.com>
Date:   Mon, 4 May 2020 14:46:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>From 85e9b88af1e6164f19ec71381efd5e2bcfc17620 Mon Sep 17 00:00:00 2001
From: Vasily Averin <vvs@virtuozzo.com>
Date: Mon, 27 Apr 2020 08:32:46 +0300
Subject: [PATCH] drm/qxl: qxl_release leak in qxl_draw_dirty_fb()

ret should be changed to release allocated struct qxl_release

Cc: stable@vger.kernel.org
Fixes: 8002db6336dd ("qxl: convert qxl driver to proper use for reservations")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: http://patchwork.freedesktop.org/patch/msgid/22cfd55f-07c8-95d0-a2f7-191b7153c3d4@virtuozzo.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

backported to v4.4-stable

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 drivers/gpu/drm/qxl/qxl_draw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_draw.c b/drivers/gpu/drm/qxl/qxl_draw.c
index 6e6c76080d6a..c8ccb3765597 100644
--- a/drivers/gpu/drm/qxl/qxl_draw.c
+++ b/drivers/gpu/drm/qxl/qxl_draw.c
@@ -352,9 +352,10 @@ void qxl_draw_dirty_fb(struct qxl_device *qdev,
 		goto out_release_backoff;
 
 	rects = drawable_set_clipping(qdev, drawable, num_clips, clips_bo);
-	if (!rects)
+	if (!rects) {
+		ret = -EINVAL;
 		goto out_release_backoff;
-
+	}
 	drawable = (struct qxl_drawable *)qxl_release_map(qdev, release);
 
 	drawable->clip.type = SPICE_CLIP_TYPE_RECTS;
-- 
2.17.1

