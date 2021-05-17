Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBF38332F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239739AbhEQOzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240245AbhEQOwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF9FD61285;
        Mon, 17 May 2021 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261432;
        bh=AJygNUVoXLm9cwR2YFmquQx+fAOqWhYWxBsp02vkKvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIitNiqycN7LNWGvNE9sLFHvC+a6dfj0WGJrzFmTcd8WF3b8MHg/vm/k11jfUoSEc
         Ifjiey7sNilIFVNy0N4Jna09Q2efQ2J0SjUDFRitfQ934zN110aS+Rx6IpLmv590wl
         OEo2z4utnXX+py7vkHygUPGon0lPpP8FnFQuZ+dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.12 345/363] drm/i915: Read C0DRB3/C1DRB3 as 16 bits again
Date:   Mon, 17 May 2021 16:03:31 +0200
Message-Id: <20210517140314.265585190@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 04d019961fd15de92874575536310243a0d4c5c5 upstream.

We've defined C0DRB3/C1DRB3 as 16 bit registers, so access them
as such.

Fixes: 1c8242c3a4b2 ("drm/i915: Use unchecked writes for setting up the fences")
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210421153401.13847-3-ville.syrjala@linux.intel.com
(cherry picked from commit f765a5b48c667bdada5e49d5e0f23f8c0687b21b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
+++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
@@ -670,8 +670,8 @@ static void detect_bit_6_swizzle(struct
 		 * banks of memory are paired and unswizzled on the
 		 * uneven portion, so leave that as unknown.
 		 */
-		if (intel_uncore_read(uncore, C0DRB3) ==
-		    intel_uncore_read(uncore, C1DRB3)) {
+		if (intel_uncore_read16(uncore, C0DRB3) ==
+		    intel_uncore_read16(uncore, C1DRB3)) {
 			swizzle_x = I915_BIT_6_SWIZZLE_9_10;
 			swizzle_y = I915_BIT_6_SWIZZLE_9;
 		}


