Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58B1383333
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbhEQO4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240504AbhEQOwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:52:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3361619AF;
        Mon, 17 May 2021 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261441;
        bh=Yfd5w6FeNX3JHwOoNN9ps/qfTtOFNmsKlV/pbgU3fHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tz18yQxX7Y1vkfadGDe5KAUtKOiAOkH0o+rUdoQOjorSql0A113qoPEKRN6OBS1Fm
         WqOyi/2lVxfFVua7RXhUqNYcQchdQjFgOajnk+SSoCyz14zn7QTHIJswO/fz/cVNw3
         eBMvxxlKlIWmpJylIXpFCvokpOgolzwkouNIVdMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.12 346/363] drm/i915/overlay: Fix active retire callback alignment
Date:   Mon, 17 May 2021 16:03:32 +0200
Message-Id: <20210517140314.294750757@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit a915fe5e9601c632417ef5261af70788d7d23a8a upstream.

__i915_active_call annotation is required on the retire callback to ensure
correct function alignment.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: a21ce8ad12d2 ("drm/i915/overlay: Switch to using i915_active tracking")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210429083530.849546-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit d8e44e4dd221ee283ea60a6fb87bca08807aa0ab)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_overlay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -383,7 +383,7 @@ static void intel_overlay_off_tail(struc
 		i830_overlay_clock_gating(dev_priv, true);
 }
 
-static void
+__i915_active_call static void
 intel_overlay_last_flip_retire(struct i915_active *active)
 {
 	struct intel_overlay *overlay =


