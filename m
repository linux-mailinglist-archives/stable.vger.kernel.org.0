Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A32FD9EC8
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfJPWCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438649AbfJPV7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:51 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E71D222C2;
        Wed, 16 Oct 2019 21:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263190;
        bh=pcGHmEd7rKiz0AWG27Jsh94bX116U0ITyp0UnfLY9nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFjIW8mL4jfoxbnHMvuDZwD7b+k5sU+vktn6LzGkhBvTxPdFeFgDqUO5Y8GX5K8cK
         JfeerTouzRf7jJnea4LRnYJsTEN07+xKCJNN4sGFYRFmqPyvA0DUqyCJ7ddzqjnAgf
         jZFrlH3oW5kOsjsMXvz0u3g2Tq2aoGGXznNSRuqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Martin Peres <martin.peres@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 068/112] drm/i915: Perform GGTT restore much earlier during resume
Date:   Wed, 16 Oct 2019 14:51:00 -0700
Message-Id: <20191016214902.978070580@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 6c76a93c453643e11a1063906c7c39168dd8d163 upstream.

As soon as we re-enable the various functions within the HW, they may go
off and read data via a GGTT offset. Hence, if we have not yet restored
the GGTT PTE before then, they may read and even *write* random locations
in memory.

Detected by DMAR faults during resume.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Martin Peres <martin.peres@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190909110011.8958-4-chris@chris-wilson.co.uk
(cherry picked from commit cec5ca08e36fd18d2939b98055346b3b06f56c6c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_pm.c    |    3 ---
 drivers/gpu/drm/i915/i915_drv.c           |    5 +++++
 drivers/gpu/drm/i915/selftests/i915_gem.c |    6 ++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pm.c
@@ -250,9 +250,6 @@ void i915_gem_resume(struct drm_i915_pri
 	mutex_lock(&i915->drm.struct_mutex);
 	intel_uncore_forcewake_get(&i915->uncore, FORCEWAKE_ALL);
 
-	i915_gem_restore_gtt_mappings(i915);
-	i915_gem_restore_fences(i915);
-
 	if (i915_gem_init_hw(i915))
 		goto err_wedged;
 
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -2238,6 +2238,11 @@ static int i915_drm_resume(struct drm_de
 	if (ret)
 		DRM_ERROR("failed to re-enable GGTT\n");
 
+	mutex_lock(&dev_priv->drm.struct_mutex);
+	i915_gem_restore_gtt_mappings(dev_priv);
+	i915_gem_restore_fences(dev_priv);
+	mutex_unlock(&dev_priv->drm.struct_mutex);
+
 	intel_csr_ucode_resume(dev_priv);
 
 	i915_restore_state(dev_priv);
--- a/drivers/gpu/drm/i915/selftests/i915_gem.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem.c
@@ -117,6 +117,12 @@ static void pm_resume(struct drm_i915_pr
 	with_intel_runtime_pm(&i915->runtime_pm, wakeref) {
 		intel_gt_sanitize(i915, false);
 		i915_gem_sanitize(i915);
+
+		mutex_lock(&i915->drm.struct_mutex);
+		i915_gem_restore_gtt_mappings(i915);
+		i915_gem_restore_fences(i915);
+		mutex_unlock(&i915->drm.struct_mutex);
+
 		i915_gem_resume(i915);
 	}
 }


