Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369041BCA6F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgD1SkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730841AbgD1SjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:39:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 850C320575;
        Tue, 28 Apr 2020 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099163;
        bh=YRPz9qHcObap93jH97qo4aIT3nzat78I2eNfcwvsejg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQH23i8uo2UzANs2OBsmQWMiWZ58p1br48vcqMoeahw98MHAzaaS/HWuA/Vl02okx
         TX2j4wVSVtrYcGdyRCufR+k75OvrVUQniM1zeQbIIaPXz9ULH6Qbh6/QWM5MPgKXA6
         e/rcsaNbRQhW3kpfltM00HKBQzRdAKXtXzeX7Wds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francisco Jerez <currojerez@riseup.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.6 164/167] drm/i915/gt: Update PMINTRMSK holding fw
Date:   Tue, 28 Apr 2020 20:25:40 +0200
Message-Id: <20200428182246.345179491@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit e1eb075c5051987fbbadbc0fb8211679df657721 upstream.

If we use a non-forcewaked write to PMINTRMSK, it does not take effect
until much later, if at all, causing a loss of RPS interrupts and no GPU
reclocking, leaving the GPU running at the wrong frequency for long
periods of time.

Reported-by: Francisco Jerez <currojerez@riseup.net>
Suggested-by: Francisco Jerez <currojerez@riseup.net>
Fixes: 35cc7f32c298 ("drm/i915/gt: Use non-forcewake writes for RPS")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Francisco Jerez <currojerez@riseup.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Andi Shyti <andi.shyti@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@intel.com>
Reviewed-by: Francisco Jerez <currojerez@riseup.net>
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20200415170318.16771-2-chris@chris-wilson.co.uk
(cherry picked from commit a080bd994c4023042a2b605c65fa10a25933f636)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_rps.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -83,7 +83,8 @@ static void rps_enable_interrupts(struct
 	gen6_gt_pm_enable_irq(gt, rps->pm_events);
 	spin_unlock_irq(&gt->irq_lock);
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_mask(rps, rps->cur_freq));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_mask(rps, rps->last_freq));
 }
 
 static void gen6_rps_reset_interrupts(struct intel_rps *rps)
@@ -117,7 +118,8 @@ static void rps_disable_interrupts(struc
 
 	rps->pm_events = 0;
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
 
 	spin_lock_irq(&gt->irq_lock);
 	gen6_gt_pm_disable_irq(gt, GEN6_PM_RPS_EVENTS);


