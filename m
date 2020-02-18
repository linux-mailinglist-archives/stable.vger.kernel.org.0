Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A155163204
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgBRUE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728753AbgBRUDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C61221D56;
        Tue, 18 Feb 2020 20:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056210;
        bh=lUIPdkq7OTx62a3ygJyQLftVTpwgspHMoLu7DyEpkQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgA0LqaDN8xShlC0RI1UK7Mfj2WO94r+5j+3pmEmzQJWNTPxOQnR3oyB/fLiF6YZG
         Z5xgUT7sajxloxNl6rtTqO4TrY2br/lHA0g9sonlekCPma9Uz3yoP3Q0+7Qd7meAS5
         HE1dQXTPdvb1XMqWSQR0HMJQ4HhOjq9sk7AfCwE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>,
        syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com,
        Emil Velikov <emil.velikov@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Anholt <eric@anholt.net>, Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.5 40/80] drm/vgem: Close use-after-free race in vgem_gem_create
Date:   Tue, 18 Feb 2020 20:55:01 +0100
Message-Id: <20200218190436.210849575@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4b848f20eda5974020f043ca14bacf7a7e634fc8 upstream.

There's two references floating around here (for the object reference,
not the handle_count reference, that's a different thing):

- The temporary reference held by vgem_gem_create, acquired by
  creating the object and released by calling
  drm_gem_object_put_unlocked.

- The reference held by the object handle, created by
  drm_gem_handle_create. This one generally outlives the function,
  except if a 2nd thread races with a GEM_CLOSE ioctl call.

So usually everything is correct, except in that race case, where the
access to gem_object->size could be looking at freed data already.
Which again isn't a real problem (userspace shot its feet off already
with the race, we could return garbage), but maybe someone can exploit
this as an information leak.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eric Anholt <eric@anholt.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Clark <robdclark@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200202132133.1891846-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vgem/vgem_drv.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -196,9 +196,10 @@ static struct drm_gem_object *vgem_gem_c
 		return ERR_CAST(obj);
 
 	ret = drm_gem_handle_create(file, &obj->base, handle);
-	drm_gem_object_put_unlocked(&obj->base);
-	if (ret)
+	if (ret) {
+		drm_gem_object_put_unlocked(&obj->base);
 		return ERR_PTR(ret);
+	}
 
 	return &obj->base;
 }
@@ -221,7 +222,9 @@ static int vgem_gem_dumb_create(struct d
 	args->size = gem_object->size;
 	args->pitch = pitch;
 
-	DRM_DEBUG("Created object of size %lld\n", size);
+	drm_gem_object_put_unlocked(gem_object);
+
+	DRM_DEBUG("Created object of size %llu\n", args->size);
 
 	return 0;
 }


