Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FDB2AB9C6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732630AbgKINMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732670AbgKINMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609AE20663;
        Mon,  9 Nov 2020 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927554;
        bh=9LVOaEv1xpEcM9vQKHt3zgpBF4iz0IYaLh3kK7/X2og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCiYZvi6Fh8cZRZe8F2FGpuG6vkrioYiEF/276KXBbk4rP4D0gCRzs0GXhknIadxV
         1qygUMAYyFEadAYYpT5FB4xzFO+u4ibBBqg3D47jQWW0WjHywxr5LXTYY7wuqRE/eb
         kbjzqm9plUgdZNCU0972fxBKX+IAf5UgrHXW1Xm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 03/85] drm/i915: Drop runtime-pm assert from vgpu io accessors
Date:   Mon,  9 Nov 2020 13:55:00 +0100
Message-Id: <20201109125022.782239088@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 5c6c13cd1102caf92d006a3cf4591c0229019daf upstream.

The "mmio" writes into vgpu registers are simple memory traps from the
guest into the host. We do not need to assert in the guest that the
device is awake for the io as we do not write to the device itself.

However, over time we have refactored all the mmio accessors with the
result that the vgpu reuses the gen2 accessors and so inherits the
assert for runtime-pm of the native device. The assert though has
actually been there since commit 3be0bf5acca6 ("drm/i915: Create vGPU
specific MMIO operations to reduce traps").

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20200811092532.13753-1-chris@chris-wilson.co.uk
(cherry picked from commit 0e65ce24a33c1d37da4bf43c34e080334ec6cb60)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_uncore.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -1124,6 +1124,18 @@ unclaimed_reg_debug(struct intel_uncore
 		spin_unlock(&uncore->debug->lock);
 }
 
+#define __vgpu_read(x) \
+static u##x \
+vgpu_read##x(struct intel_uncore *uncore, i915_reg_t reg, bool trace) { \
+	u##x val = __raw_uncore_read##x(uncore, reg); \
+	trace_i915_reg_rw(false, reg, val, sizeof(val), trace); \
+	return val; \
+}
+__vgpu_read(8)
+__vgpu_read(16)
+__vgpu_read(32)
+__vgpu_read(64)
+
 #define GEN2_READ_HEADER(x) \
 	u##x val = 0; \
 	assert_rpm_wakelock_held(uncore->rpm);
@@ -1327,6 +1339,16 @@ __gen_reg_write_funcs(gen8);
 #undef GEN6_WRITE_FOOTER
 #undef GEN6_WRITE_HEADER
 
+#define __vgpu_write(x) \
+static void \
+vgpu_write##x(struct intel_uncore *uncore, i915_reg_t reg, u##x val, bool trace) { \
+	trace_i915_reg_rw(true, reg, val, sizeof(val), trace); \
+	__raw_uncore_write##x(uncore, reg, val); \
+}
+__vgpu_write(8)
+__vgpu_write(16)
+__vgpu_write(32)
+
 #define ASSIGN_RAW_WRITE_MMIO_VFUNCS(uncore, x) \
 do { \
 	(uncore)->funcs.mmio_writeb = x##_write8; \
@@ -1647,7 +1669,10 @@ static void uncore_raw_init(struct intel
 {
 	GEM_BUG_ON(intel_uncore_has_forcewake(uncore));
 
-	if (IS_GEN(uncore->i915, 5)) {
+	if (intel_vgpu_active(uncore->i915)) {
+		ASSIGN_RAW_WRITE_MMIO_VFUNCS(uncore, vgpu);
+		ASSIGN_RAW_READ_MMIO_VFUNCS(uncore, vgpu);
+	} else if (IS_GEN(uncore->i915, 5)) {
 		ASSIGN_RAW_WRITE_MMIO_VFUNCS(uncore, gen5);
 		ASSIGN_RAW_READ_MMIO_VFUNCS(uncore, gen5);
 	} else {


