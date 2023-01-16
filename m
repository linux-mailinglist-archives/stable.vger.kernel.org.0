Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4996866C9A0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbjAPQwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbjAPQwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:52:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799794C6E8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CA4E61085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A68C433F0;
        Mon, 16 Jan 2023 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887048;
        bh=Cr3RkvpqM8xdSvd2CeNYGesZsm0JkZPODMzCZtruBWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZRTfQvlPmAzI04QzERuKX4W5MFNoy6jCu0zcp96PIdDqZ3uxphFE610UTp1x3ljK
         1t5oMZRiR9klpTSvnUyg1UbqVdXcz6GbFkSnhFkQOdR9Wom8m7BQ7k9GVYaFd80/29
         PPP3mVxVuWAU9XBYLIuWTSX4H1nRtOqw73mN57C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Chia-I Wu <olvaffe@gmail.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 646/658] drm/virtio: Fix GEM handle creation UAF
Date:   Mon, 16 Jan 2023 16:52:14 +0100
Message-Id: <20230116154939.040980498@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 52531258318ed59a2dc5a43df2eaf0eb1d65438e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 0a88ef11b9d3..5ae132e37277 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -327,10 +327,18 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 		drm_gem_object_release(obj);
 		return ret;
 	}
-	drm_gem_object_put_unlocked(obj);
 
 	rc->res_handle = qobj->hw_res_handle; /* similiar to a VM address */
 	rc->bo_handle = handle;
+
+	/*
+	 * The handle owns the reference now.  But we must drop our
+	 * remaining reference *after* we no longer need to dereference
+	 * the obj.  Otherwise userspace could guess the handle and
+	 * race closing it from another thread.
+	 */
+	drm_gem_object_put_unlocked(obj);
+
 	return 0;
 }
 
-- 
2.35.1



