Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08778D9EDA
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbfJPWC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438540AbfJPV7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:33 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B2121D7D;
        Wed, 16 Oct 2019 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263172;
        bh=r+8aUgc/mfaf5/2iPvz/+sfyyYAYN95Yw/xN8JOWDWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8LWlH25HwUGhEa2B0i9sdqlOqi3xzDntY/YCZcOz90aWiaJTuKVpQ9SHdmhf9QWw
         PlB4VNrpAM4lNOTWcFPABICN5TTXLSv7n1d9xi1O/+weHaJd5C/dfFkSRZxdeW94R9
         MirpzmB8ODkWXFmiS+Qnx+ZCTtfDJQRdWI7qp4HQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 099/112] drm/i915: Mark contents as dirty on a write fault
Date:   Wed, 16 Oct 2019 14:51:31 -0700
Message-Id: <20191016214906.326608454@linuxfoundation.org>
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

commit b925708f28c2b7a3a362d709bd7f77bc75c1daac upstream.

Since dropping the set-to-gtt-domain in commit a679f58d0510 ("drm/i915:
Flush pages on acquisition"), we no longer mark the contents as dirty on
a write fault. This has the issue of us then not marking the pages as
dirty on releasing the buffer, which means the contents are not written
out to the swap device (should we ever pick that buffer as a victim).
Notably, this is visible in the dumb buffer interface used for cursors.
Having updated the cursor contents via mmap, and swapped away, if the
shrinker should evict the old cursor, upon next reuse, the cursor would
be invisible.

E.g. echo 80 > /proc/sys/kernel/sysrq ; echo f > /proc/sysrq-trigger

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111541
Fixes: a679f58d0510 ("drm/i915: Flush pages on acquisition")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Matthew Auld <matthew.william.auld@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190920121821.7223-1-chris@chris-wilson.co.uk
(cherry picked from commit 5028851cdfdf78dc22eacbc44a0ab0b3f599ee4a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -317,7 +317,11 @@ vm_fault_t i915_gem_fault(struct vm_faul
 				   msecs_to_jiffies_timeout(CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND));
 	GEM_BUG_ON(!obj->userfault_count);
 
-	i915_vma_set_ggtt_write(vma);
+	if (write) {
+		GEM_BUG_ON(!i915_gem_object_has_pinned_pages(obj));
+		i915_vma_set_ggtt_write(vma);
+		obj->mm.dirty = true;
+	}
 
 err_fence:
 	i915_vma_unpin_fence(vma);


