Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086352ABAF5
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731778AbgKINQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbgKINQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CB0020663;
        Mon,  9 Nov 2020 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927770;
        bh=d7RyIDV5UDr1WPkzzN3SckBDcN7i7ANB/MALInJ60as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2HFPQpjnrxj8c6FOYVF/E4ILTbpte/2Pjjl0P6y5HjsR1jD2ISa/NRkH/e8+k6mY
         zUKSggpwky3y78KAmR5DH0DPYTnBD/lu87cECWtabIfKvDr6a4QNUeEHlFprzYiTSj
         sSSpbElNLJ5hmRh6NpG62wDjeD60JaD9iap/zZ7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 016/133] drm/i915: Mark ininitial fb obj as WT on eLLC machines to avoid rcu lockup during fbdev init
Date:   Mon,  9 Nov 2020 13:54:38 +0100
Message-Id: <20201109125031.494706008@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 1664ffee760a5d98952318fdd9b198fae396d660 upstream.

Currently we leave the cache_level of the initial fb obj
set to NONE. This means on eLLC machines the first pin_to_display()
will try to switch it to WT which requires a vma unbind+bind.
If that happens during the fbdev initialization rcu does not
seem operational which causes the unbind to get stuck. To
most appearances this looks like a dead machine on boot.

Avoid the unbind by already marking the object cache_level
as WT when creating it. We still do an excplicit ggtt pin
which will rewrite the PTEs anyway, so they will match whatever
cache level we set.

Cc: <stable@vger.kernel.org> # v5.7+
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2381
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201007120329.17076-1-ville.syrjala@linux.intel.com
Link: https://patchwork.freedesktop.org/patch/msgid/20201015122138.30161-1-chris@chris-wilson.co.uk
(cherry picked from commit d46b60a2e8d246f1f0faa38e52f4f5a73858c338)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/display/intel_display.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -3432,6 +3432,14 @@ initial_plane_vma(struct drm_i915_privat
 	if (IS_ERR(obj))
 		return NULL;
 
+	/*
+	 * Mark it WT ahead of time to avoid changing the
+	 * cache_level during fbdev initialization. The
+	 * unbind there would get stuck waiting for rcu.
+	 */
+	i915_gem_object_set_cache_coherency(obj, HAS_WT(i915) ?
+					    I915_CACHE_WT : I915_CACHE_NONE);
+
 	switch (plane_config->tiling) {
 	case I915_TILING_NONE:
 		break;


