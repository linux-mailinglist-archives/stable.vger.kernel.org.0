Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E562D6098
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391927AbgLJPzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391168AbgLJOim (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:38:42 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Baker <edward.baker@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 38/75] drm/i915/gt: Limit frequency drop to RPe on parking
Date:   Thu, 10 Dec 2020 15:27:03 +0100
Message-Id: <20201210142607.941137005@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit aff76ab795364569b1cac58c1d0bc7df956e3899 upstream.

We treat idling the GT (intel_rps_park) as a downclock event, and reduce
the frequency we intend to restart the GT with. Since the two workloads
are likely related (e.g. a compositor rendering every 16ms), we want to
carry the frequency and load information from across the idling.
However, we do also need to update the frequencies so that workloads
that run for less than 1ms are autotuned by RPS (otherwise we leave
compositors running at max clocks, draining excess power). Conversely,
if we try to run too slowly, the next workload has to run longer. Since
there is a hysteresis in the power graph, below a certain frequency
running a short workload for longer consumes more energy than running it
slightly higher for less time. The exact balance point is unknown
beforehand, but measurements with 30fps media playback indicate that RPe
is a better choice.

Reported-by: Edward Baker <edward.baker@intel.com>
Tested-by: Edward Baker <edward.baker@intel.com>
Fixes: 043cd2d14ede ("drm/i915/gt: Leave rps->cur_freq on unpark")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Edward Baker <edward.baker@intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201124183521.28623-1-chris@chris-wilson.co.uk
(cherry picked from commit f7ed83cc1925f0b8ce2515044d674354035c3af9)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_rps.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -882,6 +882,10 @@ void intel_rps_park(struct intel_rps *rp
 		adj = -2;
 	rps->last_adj = adj;
 	rps->cur_freq = max_t(int, rps->cur_freq + adj, rps->min_freq);
+	if (rps->cur_freq < rps->efficient_freq) {
+		rps->cur_freq = rps->efficient_freq;
+		rps->last_adj = 0;
+	}
 
 	GT_TRACE(rps_to_gt(rps), "park:%x\n", rps->cur_freq);
 }


