Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252F4294D44
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 15:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437420AbgJUNOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 09:14:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:6931 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437412AbgJUNOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Oct 2020 09:14:47 -0400
IronPort-SDR: g2FogmL06VZzj1YLNxR6IofDbyJ6n/1HAopj/YLrxjXT1cSTm6HwJIlOBixDiIWS9SsUEZIf6f
 P4nNY0kr4w1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="167454380"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="167454380"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 06:14:46 -0700
IronPort-SDR: BHJ7erK/zo8E+rVN8E8rEFoOTgjfX1Z1AYb4BbHXX8A2/YVpRpKCLZUnoS0V5UYcLpcNhozz85
 uE4N4Gq8wHxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="321009626"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga006.jf.intel.com with SMTP; 21 Oct 2020 06:14:44 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 21 Oct 2020 16:14:43 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 1/5] drm/i915: Restore ILK-M RPS support
Date:   Wed, 21 Oct 2020 16:14:39 +0300
Message-Id: <20201021131443.25616-1-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Restore RPS for ILK-M. We lost it when an extra HAS_RPS()
check appeared in intel_rps_enable().

Unfortunaltey this just makes the performance worse on my
ILK because intel_ips insists on limiting the GPU freq to
the minimum. If we don't do the RPS init then intel_ips will
not limit the frequency for whatever reason. Either it can't
get at some required information and thus makes wrong decisions,
or we mess up some weights/etc. and cause it to make the wrong
decisions when RPS init has been done, or the entire thing is
just wrong. Would require a bunch of reverse engineering to
figure out what's going on.

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Fixes: 9c878557b1eb ("drm/i915/gt: Use the RPM config register to determine clk frequencies")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index 27964ac0638a..1fe390727d80 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -389,6 +389,7 @@ static const struct intel_device_info ilk_m_info = {
 	GEN5_FEATURES,
 	PLATFORM(INTEL_IRONLAKE),
 	.is_mobile = 1,
+	.has_rps = true,
 	.display.has_fbc = 1,
 };
 
-- 
2.26.2

