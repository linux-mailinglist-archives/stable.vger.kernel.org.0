Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88834408BC
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 14:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhJ3Mag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 08:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230320AbhJ3Mag (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 08:30:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E1F060F45;
        Sat, 30 Oct 2021 12:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635596886;
        bh=N9lcQXCUamGmY26FCHbnw4WqRVrEWFgb21/aERbHjLY=;
        h=Subject:To:Cc:From:Date:From;
        b=hKbSFV4sTzTeTMd0u3U1mTlVkOd1XC1MQWFrFENX98OnZ3hGNHfKBeqdNvYCU1Dnx
         PCiAnYHkInlKgWWn+Y7VwF68uEzBqzc9V+zUk9dC6Uxlhc47TVcaQty76BFKp+7faf
         iJDXfx3C9YoCkOtCJR0Rx0DjLFncj14nE9gobHZk=
Subject: FAILED: patch "[PATCH] drm/i915: Convert unconditional clflush to" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, airlied@redhat.com,
        jani.nikula@intel.com, maarten.lankhorst@linux.intel.com,
        thomas.hellstrom@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 14:27:59 +0200
Message-ID: <1635596879246162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fcf918ffd3b35e288097036c04af7446b2c6f2f1 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Thu, 14 Oct 2021 12:09:39 +0300
Subject: [PATCH] drm/i915: Convert unconditional clflush to
 drm_clflush_virt_range()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This one is apparently a "clflush for good measure", so bit more
justification (if you can call it that) than some of the others.
Convert to drm_clflush_virt_range() again so that machines without
clflush will survive the ordeal.

Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com> #v1
Fixes: 12ca695d2c1e ("drm/i915: Do not share hwsp across contexts any more, v8.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211014090941.12159-3-ville.syrjala@linux.intel.com
Reviewed-by: Dave Airlie <airlied@redhat.com>
(cherry picked from commit af7b6d234eefa30c461cc16912bafb32b9e6141c)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 1257f4f11e66..23d7328892ed 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -225,7 +225,7 @@ void intel_timeline_reset_seqno(const struct intel_timeline *tl)
 
 	memset(hwsp_seqno + 1, 0, TIMELINE_SEQNO_BYTES - sizeof(*hwsp_seqno));
 	WRITE_ONCE(*hwsp_seqno, tl->seqno);
-	clflush(hwsp_seqno);
+	drm_clflush_virt_range(hwsp_seqno, TIMELINE_SEQNO_BYTES);
 }
 
 void intel_timeline_enter(struct intel_timeline *tl)

