Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C223C1AC6A1
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394507AbgDPOmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392655AbgDPOAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:00:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0092192A;
        Thu, 16 Apr 2020 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045645;
        bh=BudN9PO6+TsvlmZ4xfpD3WYK9Ew7qwscvnSX+TMKCI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSo+UAFUoID7pEyl7r++eNNrwFFddF0NzaVaaPaOiaA9ToZj8FMij+k2BWVf9FtjK
         yHKF9xBFSox+7gvc/G6KrFIM4oQ7jISNqkguSAcDovH4CFsoL2GxKce3us41MKZt/Q
         lVuZkD/Cc2wWhK95bKB1ckk3CXWnAFuHgPFVAT9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>,
        Lyude Paul <lyude@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.6 218/254] drm/i915/gt: Treat idling as a RPS downclock event
Date:   Thu, 16 Apr 2020 15:25:07 +0200
Message-Id: <20200416131353.247729120@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 98479ada421a8fd2123b98efd398a6f1379307ab upstream.

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
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_rps.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -763,6 +763,19 @@ void intel_rps_park(struct intel_rps *rp
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


