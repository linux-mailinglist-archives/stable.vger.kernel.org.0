Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1810A310
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 18:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfKZRJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 12:09:20 -0500
Received: from mga04.intel.com ([192.55.52.120]:25235 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfKZRJU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Nov 2019 12:09:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2019 09:09:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,246,1571727600"; 
   d="scan'208";a="198887065"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga007.jf.intel.com with SMTP; 26 Nov 2019 09:09:16 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 26 Nov 2019 19:09:15 +0200
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: [PATCH 01/13] drm/i915/fbc: Disable fbc by default on all glk+
Date:   Tue, 26 Nov 2019 19:08:59 +0200
Message-Id: <20191126170911.23253-2-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191126170911.23253-1-ville.syrjala@linux.intel.com>
References: <20191126170911.23253-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

We're missing a workaround in the fbc code for all glk+ platforms
which can cause corruption around the top of the screen. So
enabling fbc by default is a bad idea. I'm not keen to backport
the w/a so let's start by disabling fbc by default on all glk+.
We'll lift the restriction once the w/a is in place.

Cc: stable@vger.kernel.org
Cc: Daniel Drake <drake@endlessm.com>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/display/intel_fbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index 92c7eb243559..3cc1f4b4b5a3 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -1284,7 +1284,7 @@ static int intel_sanitize_fbc_option(struct drm_i915_private *dev_priv)
 		return 0;
 
 	/* https://bugs.freedesktop.org/show_bug.cgi?id=108085 */
-	if (IS_GEMINILAKE(dev_priv))
+	if (INTEL_GEN(dev_priv) >= 10 || IS_GEMINILAKE(dev_priv))
 		return 0;
 
 	if (IS_BROADWELL(dev_priv) || INTEL_GEN(dev_priv) >= 9)
-- 
2.23.0

