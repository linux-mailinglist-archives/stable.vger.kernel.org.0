Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B8E45A1A0
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 12:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbhKWLkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 06:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236251AbhKWLkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 06:40:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99D8560E73;
        Tue, 23 Nov 2021 11:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637667433;
        bh=OvRWccbRtmQJFk1uEhKSQ2ry9Wq0bOCstx3yYR6KEg8=;
        h=Subject:To:Cc:From:Date:From;
        b=bLJxzpAitdmX9ReNYW8bUaY49rcB5tuTYo8RLco7u4Iko3XuG0zShivHARgZC+iLj
         rFqweHBG0qRmPZcYCYohVbN3vamlAPz17q2C7FGUwskup3hk2HA+41qmQWkt1NB4F5
         a7QOzahyfBXW0xcyujfogK8irPNyIfbr9WWHVfiw=
Subject: FAILED: patch "[PATCH] drm/i915: Convert unconditional clflush to" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, airlied@redhat.com,
        maarten.lankhorst@linux.intel.com, thomas.hellstrom@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 12:37:10 +0100
Message-ID: <163766743015627@kroah.com>
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

From af7b6d234eefa30c461cc16912bafb32b9e6141c Mon Sep 17 00:00:00 2001
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

