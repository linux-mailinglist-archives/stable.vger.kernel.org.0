Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA4232701
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 23:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgG2Vhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 17:37:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27401 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727823AbgG2VhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 17:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596058638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZUmMq7LOcytSQJLwWlWA10KHAFK/rR0ayzLy5+ncKQ=;
        b=cbJ9YaMxS2g2PlKgcaVRcrocm4ponH6sndDOCYbyL1Bjo7LQtMmffVTubHwc3cbnPICUB3
        vO7fovT6gyxAPhTRXjGj2Vszs48UTuC4J7aKolAQAZMt7gUYn3qXfvfa3iMUcwt+C5Xhxe
        p4T0HNiGyCuA1B+BgZWwwfinJ5+afpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-dxjl5SBXNtW7rFJNN47Wxw-1; Wed, 29 Jul 2020 17:37:16 -0400
X-MC-Unique: dxjl5SBXNtW7rFJNN47Wxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD96D1893DC0;
        Wed, 29 Jul 2020 21:37:14 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-119-146.rdu2.redhat.com [10.10.119.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA4F861176;
        Wed, 29 Jul 2020 21:37:13 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Karol Herbst <kherbst@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/9] drm/nouveau/kms/fbcon: Fix pm_runtime calls in nouveau_fbcon_output_poll_changed()
Date:   Wed, 29 Jul 2020 17:36:58 -0400
Message-Id: <20200729213703.119137-5-lyude@redhat.com>
In-Reply-To: <20200729213703.119137-1-lyude@redhat.com>
References: <20200729213703.119137-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Noticed two problems here:
* We're not dropping our runtime PM refs after getting an error
* We're not backing off when pm_runtime_get() indicates that there's
  already a resume in progress (-EINPROGRESS) (after which any delayed
  fbcon events will get handled anyway)

So, let's fix those.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 7fec8f5379fb ("drm/nouveau/drm/nouveau: Fix deadlock with fb_helper with async RPM requests")
Cc: stable@vger.kernel.org
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.19+
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 4d9f3b5ae72d2..b936bf1c14dec 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -503,10 +503,7 @@ nouveau_fbcon_output_poll_changed(struct drm_device *dev)
 	ret = pm_runtime_get(dev->dev);
 	if (ret == 1 || ret == -EACCES) {
 		drm_fb_helper_hotplug_event(&fbcon->helper);
-
-		pm_runtime_mark_last_busy(dev->dev);
-		pm_runtime_put_autosuspend(dev->dev);
-	} else if (ret == 0) {
+	} else if (ret == 0 || ret == -EINPROGRESS) {
 		/* If the GPU was already in the process of suspending before
 		 * this event happened, then we can't block here as we'll
 		 * deadlock the runtime pmops since they wait for us to
@@ -516,11 +513,15 @@ nouveau_fbcon_output_poll_changed(struct drm_device *dev)
 		NV_DEBUG(drm, "fbcon HPD event deferred until runtime resume\n");
 		fbcon->hotplug_waiting = true;
 		pm_runtime_put_noidle(drm->dev->dev);
+		goto out;
 	} else {
 		DRM_WARN("fbcon HPD event lost due to RPM failure: %d\n",
 			 ret);
 	}
 
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
+out:
 	mutex_unlock(&fbcon->hotplug_lock);
 }
 
-- 
2.26.2

