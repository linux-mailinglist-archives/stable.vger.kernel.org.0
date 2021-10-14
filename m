Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF93E42D5BB
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 11:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhJNJMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 05:12:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:24837 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhJNJMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 05:12:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="208439349"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="208439349"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 02:10:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="527509467"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga008.fm.intel.com with SMTP; 14 Oct 2021 02:10:00 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 14 Oct 2021 12:09:59 +0300
From:   Ville Syrjala <ville.syrjala@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 3/4] drm/i915: Catch yet another unconditioal clflush
Date:   Thu, 14 Oct 2021 12:09:40 +0300
Message-Id: <20211014090941.12159-4-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014090941.12159-1-ville.syrjala@linux.intel.com>
References: <20211014090941.12159-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Replace the unconditional clflush() with drm_clflush_virt_range()
which does the wbinvd() fallback when clflush is not available.

This time no justification is given for the clflush in the
offending commit.

Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 2c8ab3339e39 ("drm/i915: Pin timeline map after first timeline pin, v4.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 drivers/gpu/drm/i915/gt/intel_timeline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index 23d7328892ed..438bbc7b8147 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -64,7 +64,7 @@ intel_timeline_pin_map(struct intel_timeline *timeline)
 
 	timeline->hwsp_map = vaddr;
 	timeline->hwsp_seqno = memset(vaddr + ofs, 0, TIMELINE_SEQNO_BYTES);
-	clflush(vaddr + ofs);
+	drm_clflush_virt_range(vaddr + ofs, TIMELINE_SEQNO_BYTES);
 
 	return 0;
 }
-- 
2.32.0

