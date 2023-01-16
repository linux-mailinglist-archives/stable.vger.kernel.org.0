Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3693C66C542
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjAPQEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjAPQDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:03:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD68244AF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:02:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F652B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E411BC433F0;
        Mon, 16 Jan 2023 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884945;
        bh=bbJrhWh8Sxuc4CnyUKPfswEdUiISU/BKCU8Skk9sGos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyPFYJDZHubJIV+L5e6BxTKgxhlJmzOVIwfA9Yzvm3bY8h7zNr5WeqJK3HJtQdggz
         q3KUOFJ1TA7iaO1MrQCooXCv190LzpJlDI4WUWDcf1g/+F3SeYMIiClGXblJ8KaYE0
         wFiFEbYP2+SRCF4Jsialo0hpEliOLyhMF6A6YF0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Chia-I Wu <olvaffe@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 5.15 16/86] drm/virtio: Fix GEM handle creation UAF
Date:   Mon, 16 Jan 2023 16:50:50 +0100
Message-Id: <20230116154747.749149412@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

commit 52531258318ed59a2dc5a43df2eaf0eb1d65438e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -292,10 +292,18 @@ static int virtio_gpu_resource_create_io
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
 
@@ -656,11 +664,18 @@ static int virtio_gpu_resource_create_bl
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
 


