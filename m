Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7533738384D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244775AbhEQPvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245544AbhEQPsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:48:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1FD761D46;
        Mon, 17 May 2021 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262719;
        bh=DV6v08hIjtCuV/OAyyT9TFRA88JlEAEO4/Ts0IIT250=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBSROMs8uA7/nBFuzgYydRF/GbNdIPQ/Wltk5OAMi0UuNhQn1cenwbBsMgFXDdy3g
         t3G2TnwG/8E88iW2nPplwbeIyWMlW1EG7Mi5U40dmeGIyF9euvwm15F6OVZcE4C4V9
         RXWa8YkThffWuBhFyhTbng2ksTg5YbB4xQ2wqFu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 278/289] drm/i915: Read C0DRB3/C1DRB3 as 16 bits again
Date:   Mon, 17 May 2021 16:03:23 +0200
Message-Id: <20210517140314.496369638@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
@@ -652,8 +652,8 @@ static void detect_bit_6_swizzle(struct
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


