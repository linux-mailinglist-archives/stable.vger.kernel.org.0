Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F97366AAD1
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjANJ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjANJ6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:58:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3967A80
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7640C603E0
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83347C433D2;
        Sat, 14 Jan 2023 09:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673690302;
        bh=CC40cVjz1SYnp9UvYhnFjA6wT2iYMq0i2ZiUkt/mU+w=;
        h=Subject:To:Cc:From:Date:From;
        b=tBqvKBAHcYeoYnrpUSbUBXKQc/TU1ULnZxQYwsDv8POId675a8eGMazhhQAD4j/PX
         H8Jgop7f/6H9SPqB1+kt0PQkME6VkaGZo2fOPwSLJEE2w4Snpt2MH4inJ2LoavBdn9
         HaHy64QbSWHNTxAcDNpnsW1/FXjxWXqIVIGH9c1U=
Subject: FAILED: patch "[PATCH] drm/virtio: Fix GEM handle creation UAF" failed to apply to 4.14-stable tree
To:     robdclark@chromium.org, dmitry.osipenko@collabora.com,
        olvaffe@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:58:07 +0100
Message-ID: <167369028724989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

52531258318e ("drm/virtio: Fix GEM handle creation UAF")
897b4d1acaf5 ("drm/virtio: implement blob resources: resource create blob ioctl")
16845c5d5409 ("drm/virtio: implement blob resources: implement vram object")
6076a9711dc5 ("drm/virtio: implement blob resources: probe for host visible region")
6815cfe602d0 ("drm/virtio: implement blob resources: probe for the feature.")
30172efbfb84 ("drm/virtio: blob prep: refactor getting pages and attaching backing")
deb2464e4c6d ("drm/virtio: report uuid in debugfs")
c84adb304c10 ("drm/virtio: Support virtgpu exported resources")
0a19b068acc4 ("Merge tag 'drm-misc-next-2020-06-19' of git://anongit.freedesktop.org/drm/drm-misc into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 52531258318ed59a2dc5a43df2eaf0eb1d65438e Mon Sep 17 00:00:00 2001
From: Rob Clark <robdclark@chromium.org>
Date: Fri, 16 Dec 2022 15:33:55 -0800
Subject: [PATCH] drm/virtio: Fix GEM handle creation UAF

Userspace can guess the handle value and try to race GEM object creation
with handle close, resulting in a use-after-free if we dereference the
object after dropping the handle's reference.  For that reason, dropping
the handle's reference must be done *after* we are done dereferencing
the object.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Fixes: 62fb7a5e1096 ("virtio-gpu: add 3d/virgl support")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221216233355.542197-2-robdclark@gmail.com

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 5d05093014ac..9f4a90493aea 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -358,10 +358,18 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 		drm_gem_object_release(obj);
 		return ret;
 	}
-	drm_gem_object_put(obj);
 
 	rc->res_handle = qobj->hw_res_handle; /* similiar to a VM address */
 	rc->bo_handle = handle;
+
+	/*
+	 * The handle owns the reference now.  But we must drop our
+	 * remaining reference *after* we no longer need to dereference
+	 * the obj.  Otherwise userspace could guess the handle and
+	 * race closing it from another thread.
+	 */
+	drm_gem_object_put(obj);
+
 	return 0;
 }
 
@@ -723,11 +731,18 @@ static int virtio_gpu_resource_create_blob_ioctl(struct drm_device *dev,
 		drm_gem_object_release(obj);
 		return ret;
 	}
-	drm_gem_object_put(obj);
 
 	rc_blob->res_handle = bo->hw_res_handle;
 	rc_blob->bo_handle = handle;
 
+	/*
+	 * The handle owns the reference now.  But we must drop our
+	 * remaining reference *after* we no longer need to dereference
+	 * the obj.  Otherwise userspace could guess the handle and
+	 * race closing it from another thread.
+	 */
+	drm_gem_object_put(obj);
+
 	return 0;
 }
 

