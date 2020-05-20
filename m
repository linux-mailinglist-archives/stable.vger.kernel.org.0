Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283AC1DAD99
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 10:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgETIgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 04:36:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:62025 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETIgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 04:36:14 -0400
IronPort-SDR: douOI4QBfi/t1GMuvBbnl7XnGBZMqe4u4Z6Qnn6yFs2wMQrJcmyA9n+ZDLXkajvsAW4SUaQyoa
 /7lXOz7fc3+g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 01:36:14 -0700
IronPort-SDR: TPnZat1l35MrYjITVt9CND8m+5ang3uMFRjhLvKC1cxbSYCBGza+Uh0HKvShjGsmZtcvBXNxTr
 CqG5XWoFsZwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="299864462"
Received: from vtt.iind.intel.com ([10.145.162.194])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2020 01:36:10 -0700
From:   Prasad Nallani <prasad.nallani@intel.com>
To:     gfx-internal-devel@eclists.intel.com
Cc:     jon.ewins@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 04/54] drm/i915/gt: Treat idling as a RPS downclock event
Date:   Wed, 20 May 2020 14:03:22 +0530
Message-Id: <20200520083412.25470-5-prasad.nallani@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520083412.25470-1-prasad.nallani@intel.com>
References: <20200520083412.25470-1-prasad.nallani@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

If we park/unpark faster than we can respond to RPS events, we never
will process a downclock event after expiring a waitboost, and thus we
will forever restart the GPU at max clocks even if the workload switches
and doesn't justify full power.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/1500
Fixes: 3e7abf814193 ("drm/i915: Extract GT render power state management")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200322163225.28791-1-chris@chris-wilson.co.uk
Cc: <stable@vger.kernel.org> # v5.5+
(cherry picked from commit 21abf0bf168dffff1192e0f072af1dc74ae1ff0e)
---
 drivers/gpu/drm/i915/gt/intel_rps.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index 6beaa2b4e8f7..32ccb4efb0d9 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -768,6 +768,19 @@ void intel_rps_park(struct intel_rps *rps)
 	intel_uncore_forcewake_get(rps_to_uncore(rps), FORCEWAKE_MEDIA);
 	rps_set(rps, rps->idle_freq, false);
 	intel_uncore_forcewake_put(rps_to_uncore(rps), FORCEWAKE_MEDIA);
+
+	/*
+	 * Since we will try and restart from the previously requested
+	 * frequency on unparking, treat this idle point as a downclock
+	 * interrupt and reduce the frequency for resume. If we park/unpark
+	 * more frequently than the rps worker can run, we will not respond
+	 * to any EI and never see a change in frequency.
+	 *
+	 * (Note we accommodate Cherryview's limitation of only using an
+	 * even bin by applying it to all.)
+	 */
+	rps->cur_freq =
+		max_t(int, round_down(rps->cur_freq - 1, 2), rps->min_freq);
 }
 
 void intel_rps_boost(struct i915_request *rq)
