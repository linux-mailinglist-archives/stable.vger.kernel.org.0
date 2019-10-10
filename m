Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65FDD2344
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388183AbfJJIks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387545AbfJJIkr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A5A2218AC;
        Thu, 10 Oct 2019 08:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696846;
        bh=Ie0By+KUnOkwmDWpsFLRzWys8/g/MupAZOH9aBYUGdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWHS2UrZ6biemLVcSOwyoF/VqKcFkhMETxBG67bxQLkrolstDaPPPSE2AWiEzvBi4
         +5fBbI0belrBJNkoX6WWmdtxk7gmFOTl8QfLmAA8EjwB/dIUTjrplyL+xy7l43rV/E
         SZGuBjo3ZsEbCLf+E5X0zxvn+ku+MriSIHpMe+Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 072/148] drm/i915: to make vgpu ppgtt notificaiton as atomic operation
Date:   Thu, 10 Oct 2019 10:35:33 +0200
Message-Id: <20191010083615.760135349@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolin Zhang <xiaolin.zhang@intel.com>

commit 9e77f5001b9833a6bdd3940df245053c2212a32b upstream.

vgpu ppgtt notification was split into 2 steps, the first step is to
update PVINFO's pdp register and then write PVINFO's g2v_notify register
with action code to tirgger ppgtt notification to GVT side.

currently these steps were not atomic operations due to no any protection,
so it is easy to enter race condition state during the MTBF, stress and
IGT test to cause GPU hang.

the solution is to add a lock to make vgpu ppgtt notication as atomic
operation.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/1566543451-13955-1-git-send-email-xiaolin.zhang@intel.com
(cherry picked from commit 52988009843160c5b366b4082ed6df48041c655c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.h     |    1 +
 drivers/gpu/drm/i915/i915_gem_gtt.c |   12 +++++++-----
 drivers/gpu/drm/i915/i915_vgpu.c    |    1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1073,6 +1073,7 @@ struct i915_frontbuffer_tracking {
 };
 
 struct i915_virtual_gpu {
+	struct mutex lock; /* serialises sending of g2v_notify command pkts */
 	bool active;
 	u32 caps;
 };
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1248,14 +1248,15 @@ free_scratch_page:
 	return ret;
 }
 
-static int gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
+static void gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
 {
-	struct i915_address_space *vm = &ppgtt->vm;
-	struct drm_i915_private *dev_priv = vm->i915;
+	struct drm_i915_private *dev_priv = ppgtt->vm.i915;
 	enum vgt_g2v_type msg;
 	int i;
 
-	if (i915_vm_is_4lvl(vm)) {
+	mutex_lock(&dev_priv->vgpu.lock);
+
+	if (i915_vm_is_4lvl(&ppgtt->vm)) {
 		const u64 daddr = px_dma(ppgtt->pd);
 
 		I915_WRITE(vgtif_reg(pdp[0].lo), lower_32_bits(daddr));
@@ -1275,9 +1276,10 @@ static int gen8_ppgtt_notify_vgt(struct
 				VGT_G2V_PPGTT_L3_PAGE_TABLE_DESTROY);
 	}
 
+	/* g2v_notify atomically (via hv trap) consumes the message packet. */
 	I915_WRITE(vgtif_reg(g2v_notify), msg);
 
-	return 0;
+	mutex_unlock(&dev_priv->vgpu.lock);
 }
 
 static void gen8_free_scratch(struct i915_address_space *vm)
--- a/drivers/gpu/drm/i915/i915_vgpu.c
+++ b/drivers/gpu/drm/i915/i915_vgpu.c
@@ -79,6 +79,7 @@ void i915_check_vgpu(struct drm_i915_pri
 	dev_priv->vgpu.caps = __raw_uncore_read32(uncore, vgtif_reg(vgt_caps));
 
 	dev_priv->vgpu.active = true;
+	mutex_init(&dev_priv->vgpu.lock);
 	DRM_INFO("Virtual GPU for Intel GVT-g detected.\n");
 }
 


