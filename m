Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D753DA0BF1
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 23:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfH1VBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 17:01:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:63004 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfH1VBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 17:01:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 14:01:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="183258871"
Received: from rdvivi-losangeles.jf.intel.com ([10.7.196.65])
  by orsmga003.jf.intel.com with ESMTP; 28 Aug 2019 14:01:51 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gfx@lists.freedesktop.org, dmitry.v.rogozhkin@intel.com,
        lionel.g.landwerlin@intel.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH] drm/i915: fix broadwell EU computation
Date:   Wed, 28 Aug 2019 14:02:09 -0700
Message-Id: <20190828210209.10541-1-rodrigo.vivi@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>

commit 6a67a20366f894c172734f28c5646bdbe48a46e3 upstream.

subslice_mask is an array indexed by slice, not subslice.

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: 8cc7669355136f ("drm/i915: store all subslice masks")
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=108712
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181112123931.2815-1-lionel.g.landwerlin@intel.com
(cherry picked from commit 63ac3328f0d1d37f286e397b14d9596ed09d7ca5)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # 4.17
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/i915/intel_device_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_device_info.c b/drivers/gpu/drm/i915/intel_device_info.c
index 0ef0c6448d53..01fa98299bae 100644
--- a/drivers/gpu/drm/i915/intel_device_info.c
+++ b/drivers/gpu/drm/i915/intel_device_info.c
@@ -474,7 +474,7 @@ static void broadwell_sseu_info_init(struct drm_i915_private *dev_priv)
 			u8 eu_disabled_mask;
 			u32 n_disabled;
 
-			if (!(sseu->subslice_mask[ss] & BIT(ss)))
+			if (!(sseu->subslice_mask[s] & BIT(ss)))
 				/* skip disabled subslice */
 				continue;
 
-- 
2.20.1

