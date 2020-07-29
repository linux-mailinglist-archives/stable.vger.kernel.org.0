Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4135A232700
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 23:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgG2Vhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 17:37:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726365AbgG2VhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 17:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596058637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ny64fSMMc7Rq10ZRUtyqKunya/reGTsGGORluTaaBMg=;
        b=NTIQCMFhKLcMHy0yfn3X60uU9hhU66Ca7TzCFPhYMpyphNSCstVJl708Inm9p3GQGQ4BEr
        PkHhpCJdf63UKd0vFRbjBGJc5fPNEGHKCsMcS7YlVcEkxvL0rWR5VxlqNSX9s8yqGhYTT2
        LEj69SMG2qSn6Dx26pkJIfwiIX7hKlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-g7qGyxW0PC2vBuHIW8CSZQ-1; Wed, 29 Jul 2020 17:37:14 -0400
X-MC-Unique: g7qGyxW0PC2vBuHIW8CSZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7766F91275;
        Wed, 29 Jul 2020 21:37:13 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-119-146.rdu2.redhat.com [10.10.119.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EC9A60C84;
        Wed, 29 Jul 2020 21:37:12 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/9] drm/nouveau/kms/fbcon: Correct pm_runtime calls in nouveau_fbcon_release()
Date:   Wed, 29 Jul 2020 17:36:57 -0400
Message-Id: <20200729213703.119137-4-lyude@redhat.com>
In-Reply-To: <20200729213703.119137-1-lyude@redhat.com>
References: <20200729213703.119137-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We want to update the last busy timer for our device and use
pm_runtime_put_autosuspend() here instead so that our GPU can
autosuspend when we're done.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: f231976c2e89 ("drm/nouveau/fbcon: take runpm reference when userspace has an open fd")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: stable@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.3+
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index fad8030ec1f81..4d9f3b5ae72d2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -200,8 +200,11 @@ static int
 nouveau_fbcon_release(struct fb_info *info, int user)
 {
 	struct nouveau_fbdev *fbcon = info->par;
-	struct nouveau_drm *drm = nouveau_drm(fbcon->helper.dev);
-	pm_runtime_put(drm->dev->dev);
+	struct drm_device *dev = fbcon->helper.dev;
+
+	pm_runtime_mark_last_busy(dev->dev);
+	pm_runtime_put_autosuspend(dev->dev);
+
 	return 0;
 }
 
-- 
2.26.2

