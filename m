Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E6814FD46
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 14:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgBBNVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 08:21:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36686 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgBBNVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 08:21:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so14544076wru.3
        for <stable@vger.kernel.org>; Sun, 02 Feb 2020 05:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cHVArCA0NkObFToWw2KI8ZjIcDBFbLQ6CdfkkiPE81Q=;
        b=TEmmVDj0++o7kGG6MrcVufIc0rC2Ax9HAq77FmojxCjZjUSr5dqABRzdgmF8NGVnHu
         js8FDD/Qp4TZdq1MNW36F0UpJQl6GLudC3zw+UVQ1VuV17JsX3oWa1ozfFlo8pOyQGFg
         8KHsNNsXC6AxkKPkwLq0kkIuN1xrz3F5pttoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cHVArCA0NkObFToWw2KI8ZjIcDBFbLQ6CdfkkiPE81Q=;
        b=NtgFB1U4CSDNX9W3Au51D28sopeBa1kRqOhbsHpuqeQbyGZJxrWi0vpFouqk89WObs
         hyKe36+cIElcUCs0WZx8pL6zUUmZ2DQ1sVIyLD8auiK48Jiv1Xrqs/BGFhycM+BcLNdV
         vFiY2p9gS8BKFK6lyf9zF53gaWIpdU+4ThELY6S9lGvD2CM2rqu3o9m3EINkUOIRFJFR
         BiOfKagwCkUZ5FqRlbcnEnY6plxw9gIKE5d39PBN+46dIF59UecqElgzXE4Q6u8WzCNX
         EIIuxXDUNVGu9jIhefFepqb0AeJ1WhSX6Mp/Hiy6DKqGl2X6aCHt7CXA9IrwkhpmkzH7
         E80A==
X-Gm-Message-State: APjAAAXuXwQ0vAONCpU/FxYihCNmMlQ9A/bWJeae1Ga4HWTmJeys4EKZ
        uv2AIJiB9Op8J0EWn4GjeSFwag==
X-Google-Smtp-Source: APXvYqzLITzGUKwVkpTTZzU1yF022BgipZxUFF6BYrWBoVFzhnOw14rw22j/lRkTRORr3x8FXrIIag==
X-Received: by 2002:a5d:4052:: with SMTP id w18mr4250553wrp.112.1580649698793;
        Sun, 02 Feb 2020 05:21:38 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id b18sm20994530wru.50.2020.02.02.05.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 05:21:38 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>, stable@vger.kernel.org,
        Emil Velikov <emil.velikov@collabora.com>,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Anholt <eric@anholt.net>, Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm/vgem: Close use-after-free race in vgem_gem_create
Date:   Sun,  2 Feb 2020 14:21:33 +0100
Message-Id: <20200202132133.1891846-1-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Reported-by: syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eric Anholt <eric@anholt.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Clark <robdclark@chromium.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/vgem/vgem_drv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index 5bd60ded3d81..909eba43664a 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -196,9 +196,10 @@ static struct drm_gem_object *vgem_gem_create(struct drm_device *dev,
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
@@ -221,7 +222,9 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 	args->size = gem_object->size;
 	args->pitch = pitch;
 
-	DRM_DEBUG("Created object of size %lld\n", size);
+	drm_gem_object_put_unlocked(gem_object);
+
+	DRM_DEBUG("Created object of size %llu\n", args->size);
 
 	return 0;
 }
-- 
2.24.1

