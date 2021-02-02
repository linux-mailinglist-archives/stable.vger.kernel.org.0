Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC08830CCA8
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbhBBUDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232371AbhBBNnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:43:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76E3B64F70;
        Tue,  2 Feb 2021 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273222;
        bh=l6D115tAnUcADOdU7I7PmsLHAnuCKBGlaNAlrBXia8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlFnz2g5W/8NasdurP/Mo4mwJlFyOxBQ8kU1G7UaB2zVVP8SQMIwFTd2iB4n8nXTc
         y6Zpt4h9QjUHhN/CCGPO8ian0fS5XXZe0tRhJFM/fpC0AQm1SrTumk6hZnvjFTvZr4
         23He5BvKqeBIqglPhQlb34m6rZr15zCpkRKOFZz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 025/142] drm/i915/gt: Always try to reserve GGTT address 0x0
Date:   Tue,  2 Feb 2021 14:36:28 +0100
Message-Id: <20210202132958.749710625@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 489140b5ba2e7cc4b853c29e0591895ddb462a82 upstream.

Since writing to address 0 is a very common mistake, let's try to avoid
putting anything sensitive there.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210125125033.23656-1-chris@chris-wilson.co.uk
Cc: stable@vger.kernel.org
(cherry picked from commit 56b429cc584c6ed8b895d8d8540959655db1ff73)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_ggtt.c |   47 ++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_ggtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt.c
@@ -526,16 +526,39 @@ static int init_ggtt(struct i915_ggtt *g
 
 	mutex_init(&ggtt->error_mutex);
 	if (ggtt->mappable_end) {
-		/* Reserve a mappable slot for our lockless error capture */
-		ret = drm_mm_insert_node_in_range(&ggtt->vm.mm,
-						  &ggtt->error_capture,
-						  PAGE_SIZE, 0,
-						  I915_COLOR_UNEVICTABLE,
-						  0, ggtt->mappable_end,
-						  DRM_MM_INSERT_LOW);
-		if (ret)
-			return ret;
+		/*
+		 * Reserve a mappable slot for our lockless error capture.
+		 *
+		 * We strongly prefer taking address 0x0 in order to protect
+		 * other critical buffers against accidental overwrites,
+		 * as writing to address 0 is a very common mistake.
+		 *
+		 * Since 0 may already be in use by the system (e.g. the BIOS
+		 * framebuffer), we let the reservation fail quietly and hope
+		 * 0 remains reserved always.
+		 *
+		 * If we fail to reserve 0, and then fail to find any space
+		 * for an error-capture, remain silent. We can afford not
+		 * to reserve an error_capture node as we have fallback
+		 * paths, and we trust that 0 will remain reserved. However,
+		 * the only likely reason for failure to insert is a driver
+		 * bug, which we expect to cause other failures...
+		 */
+		ggtt->error_capture.size = I915_GTT_PAGE_SIZE;
+		ggtt->error_capture.color = I915_COLOR_UNEVICTABLE;
+		if (drm_mm_reserve_node(&ggtt->vm.mm, &ggtt->error_capture))
+			drm_mm_insert_node_in_range(&ggtt->vm.mm,
+						    &ggtt->error_capture,
+						    ggtt->error_capture.size, 0,
+						    ggtt->error_capture.color,
+						    0, ggtt->mappable_end,
+						    DRM_MM_INSERT_LOW);
 	}
+	if (drm_mm_node_allocated(&ggtt->error_capture))
+		drm_dbg(&ggtt->vm.i915->drm,
+			"Reserved GGTT:[%llx, %llx] for use by error capture\n",
+			ggtt->error_capture.start,
+			ggtt->error_capture.start + ggtt->error_capture.size);
 
 	/*
 	 * The upper portion of the GuC address space has a sizeable hole
@@ -548,9 +571,9 @@ static int init_ggtt(struct i915_ggtt *g
 
 	/* Clear any non-preallocated blocks */
 	drm_mm_for_each_hole(entry, &ggtt->vm.mm, hole_start, hole_end) {
-		drm_dbg_kms(&ggtt->vm.i915->drm,
-			    "clearing unused GTT space: [%lx, %lx]\n",
-			    hole_start, hole_end);
+		drm_dbg(&ggtt->vm.i915->drm,
+			"clearing unused GTT space: [%lx, %lx]\n",
+			hole_start, hole_end);
 		ggtt->vm.clear_range(&ggtt->vm, hole_start,
 				     hole_end - hole_start);
 	}


