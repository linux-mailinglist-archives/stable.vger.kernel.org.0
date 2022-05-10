Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC899521753
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbiEJNXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243563AbiEJNWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AD852530;
        Tue, 10 May 2022 06:16:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61129615DD;
        Tue, 10 May 2022 13:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46067C385C2;
        Tue, 10 May 2022 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188578;
        bh=NI3jWGh0Qcgl5TwhM/Wovh4SvdT7Ryx5lfnD/o7tqM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDqhUEr/oQnDm5DaF5bGz7DGmNKODtQrM3uZUcZslQLL/rwEchuRykshZ9cKNkNQM
         osRn17TUjJsHPtu8eifKN/saxCHRAOuLqoarP2s88Fui5GoPLHPwaU8akzihes20un
         1++speVEOW6xLjtlTISmZPqHSfiT9nUUag/G5440=
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
        Daniel Vetter <daniel.vetter@intel.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 53/78] drm/vgem: Close use-after-free race in vgem_gem_create
Date:   Tue, 10 May 2022 15:07:39 +0200
Message-Id: <20220510130734.108704531@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[OP: backport to 4.19: adjusted DRM_DEBUG() -> DRM_DEBUG_DRIVER()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vgem/vgem_drv.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -190,9 +190,10 @@ static struct drm_gem_object *vgem_gem_c
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
@@ -215,7 +216,9 @@ static int vgem_gem_dumb_create(struct d
 	args->size = gem_object->size;
 	args->pitch = pitch;
 
-	DRM_DEBUG_DRIVER("Created object of size %lld\n", size);
+	drm_gem_object_put_unlocked(gem_object);
+
+	DRM_DEBUG_DRIVER("Created object of size %llu\n", args->size);
 
 	return 0;
 }


