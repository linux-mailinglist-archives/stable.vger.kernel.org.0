Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C390501427
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbiDNNls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344503AbiDNNcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:32:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CA4222BD;
        Thu, 14 Apr 2022 06:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5F4E6190F;
        Thu, 14 Apr 2022 13:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D72C385A5;
        Thu, 14 Apr 2022 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942996;
        bh=16QRb3m5ZYhtSBWzdBO2IiJyLiJuNysbaCprcuAXlZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCTCS0bdMPPkXNTXT9PzFyGoRtObDMIabhNkSsiXsqH/PNu15rj4k1FXJ7Zhazn3R
         +LFNB9pxZKF3S+aVmzIrDNY0hCjzAxbPTzGqsJ3FgequRTbV/f4Axe5EaEmex3/r2T
         tHptIfHhUoi+rZhQ5dyx1IsMXa1BHIJUnAaVTGm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 337/338] drm/amdgpu: Check if fd really is an amdgpu fd.
Date:   Thu, 14 Apr 2022 15:14:00 +0200
Message-Id: <20220414110848.484703272@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 021830d24ba55a578f602979274965344c8e6284 upstream.

Otherwise we interpret the file private data as drm & amdgpu data
while it might not be, possibly allowing one to get memory corruption.

Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h       |    2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c   |   16 ++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c |   10 +++++++---
 3 files changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -955,6 +955,8 @@ struct amdgpu_gfx {
 	DECLARE_BITMAP			(pipe_reserve_bitmap, AMDGPU_MAX_COMPUTE_QUEUES);
 };
 
+int amdgpu_file_to_fpriv(struct file *filp, struct amdgpu_fpriv **fpriv);
+
 int amdgpu_ib_get(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		  unsigned size, struct amdgpu_ib *ib);
 void amdgpu_ib_free(struct amdgpu_device *adev, struct amdgpu_ib *ib,
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1132,6 +1132,22 @@ static const struct file_operations amdg
 #endif
 };
 
+int amdgpu_file_to_fpriv(struct file *filp, struct amdgpu_fpriv **fpriv)
+{
+        struct drm_file *file;
+
+	if (!filp)
+		return -EINVAL;
+
+	if (filp->f_op != &amdgpu_driver_kms_fops) {
+		return -EINVAL;
+	}
+
+	file = filp->private_data;
+	*fpriv = file->driver_priv;
+	return 0;
+}
+
 static bool
 amdgpu_get_crtc_scanout_position(struct drm_device *dev, unsigned int pipe,
 				 bool in_vblank_irq, int *vpos, int *hpos,
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
@@ -54,16 +54,20 @@ static int amdgpu_sched_process_priority
 						  enum drm_sched_priority priority)
 {
 	struct file *filp = fget(fd);
-	struct drm_file *file;
 	struct amdgpu_fpriv *fpriv;
 	struct amdgpu_ctx *ctx;
 	uint32_t id;
+	int r;
 
 	if (!filp)
 		return -EINVAL;
 
-	file = filp->private_data;
-	fpriv = file->driver_priv;
+	r = amdgpu_file_to_fpriv(filp, &fpriv);
+	if (r) {
+		fput(filp);
+		return r;
+	}
+
 	idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
 		amdgpu_ctx_priority_override(ctx, priority);
 


