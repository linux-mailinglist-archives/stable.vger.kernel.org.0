Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D65B1EE3
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388829AbfIMNNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389400AbfIMNNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:52 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55BE9214AE;
        Fri, 13 Sep 2019 13:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380431;
        bh=gefNbHmOak9H16F1TzmWs7MZQQw1Ok0+B6RFIQ4rio4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oMwNjxkCGM2/Q92rNwEgdbzLZyjuZvyIE3ixwAoJE559vV+vK2yacEuGV7NmEz3I3
         rlvv/3EKqHklovzdZym7/hkJSLm1ln4TRzef0fvLhxbdYsXN2IsFuq2ibjhj0eJgei
         KYdeqOc+hovYBkqHAc669Gu+pNON0RakiAgmichQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/190] drm/i915: Restore sane defaults for KMS on GEM error load
Date:   Fri, 13 Sep 2019 14:05:17 +0100
Message-Id: <20190913130604.720362445@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ed43df720c007d60bee6d81da07bcdc7e4a55ae ]

If we fail during GEM initialisation, we scrub the HW state by
performing a device level GPU resuet. However, we want to leave the
system in a usable state (with functioning KMS but no GEM) so after
scrubbing the HW state, we need to restore some sane defaults and
re-enable the low-level common parts of the GPU (such as the GMCH).

v2: Restore GTT entries.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20180726085033.4044-2-chris@chris-wilson.co.uk
Reviewed-by: Michał Winiarski <michal.winiarski@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_gem.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 03cda197fb6b8..5019dfd8bcf16 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -5595,6 +5595,8 @@ err_uc_misc:
 		i915_gem_cleanup_userptr(dev_priv);
 
 	if (ret == -EIO) {
+		mutex_lock(&dev_priv->drm.struct_mutex);
+
 		/*
 		 * Allow engine initialisation to fail by marking the GPU as
 		 * wedged. But we only want to do this where the GPU is angry,
@@ -5605,7 +5607,14 @@ err_uc_misc:
 					"Failed to initialize GPU, declaring it wedged!\n");
 			i915_gem_set_wedged(dev_priv);
 		}
-		ret = 0;
+
+		/* Minimal basic recovery for KMS */
+		ret = i915_ggtt_enable_hw(dev_priv);
+		i915_gem_restore_gtt_mappings(dev_priv);
+		i915_gem_restore_fences(dev_priv);
+		intel_init_clock_gating(dev_priv);
+
+		mutex_unlock(&dev_priv->drm.struct_mutex);
 	}
 
 	i915_gem_drain_freed_objects(dev_priv);
-- 
2.20.1



