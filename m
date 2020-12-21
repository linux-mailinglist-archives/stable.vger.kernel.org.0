Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB282DFA21
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 09:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgLUIsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 03:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgLUIsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 03:48:17 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2572C0611CC
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:36 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id i6so8258281otr.2
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 00:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pWQd77LKsJZmYiStZ2sL8C8J9higSAQyykL4PoIdt2c=;
        b=Dar2IahcqzextxOfAYQMrFzmpl4xk+BQdZmRz52wQSjKp6XtIRfKiXYCikH0g93/nj
         QM9yf+sUXr8v+7wP3F9JRSkwntvNtDlrnRY2T02XDn+K/KW5wjhxMcIIttgxwUysZfJX
         hmytercDGXCPqH79SdDDrWrLMLaIk0ciun8YXmw2VxLcDDzlS+lHNpreqgFqTI647hKF
         /kFinHKcplDvIWIDXOMaV5cY2ugZeJmzti9kG79oImz4BCP+GF2he2sCsOYcPR+MXR4v
         a73s+c2c+7fRawXu2o2Btgom3xGOlviscb2m8hgLyFzcgoZ9gpZbnDO1OPj/Fx26UYoW
         dIJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pWQd77LKsJZmYiStZ2sL8C8J9higSAQyykL4PoIdt2c=;
        b=aj4D+SvP4MCkHGjogzvctHNFKcgd7mV4qTTLMA83FTn+AIHE+ixqh8OfMCRiYP3VZ6
         5qcnnt/VsZErekpJJu8nzhB41O7XRPNEERY/nNkGBLd5DjF7WTv751np63vYkkSNnmch
         yG35YXwxzcesDJ4AFzajFfFR0bY1CKNrgwBbMGPmRhmITiHa02OgHIPh4XPpAHGL61sF
         eZc3+kF6KZdAFfh8/OUrLaylSxr+W3cbvVEej0FQUPsC003VQgM1Lg/ZpsGMiHFU1TXU
         PU6RkEV5WONVyxrm41Xa3rWAFyHWijyb6JLVRjCKdd5eMNKpbLxCqiix3qmA0uDRQjhh
         5Ttw==
X-Gm-Message-State: AOAM532a8S1eDc6mp5mVNTJUe9Av8WRVYnbN9wwwHhxAatJtKUonf8OR
        c0LzuHz/bQS8X58USvBbWzk=
X-Google-Smtp-Source: ABdhPJzPXBzHKTCeSEk5p0XaFvSmvPGsky4PNTt2gjfW0YKccP/zo+hhhAuwSl4hDRjHTZ0F8ttZBA==
X-Received: by 2002:a05:6830:1189:: with SMTP id u9mr11172294otq.70.1608540456343;
        Mon, 21 Dec 2020 00:47:36 -0800 (PST)
Received: from XChen-BuildServer.amd.com ([165.204.77.1])
        by smtp.gmail.com with ESMTPSA id i24sm3611270oot.42.2020.12.21.00.47.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 00:47:35 -0800 (PST)
From:   "Xiaogang.Chen" <chenxiaogang888@gmail.com>
X-Google-Original-From: "Xiaogang.Chen" <xiaogang.chen@amd.com>
To:     xiaogang.chen@amd.com
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Francisco Jerez <currojerez@riseup.net>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        "# v5 . 6+" <stable@vger.kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v1 06/14] drm/i915/gt: Update PMINTRMSK holding fw
Date:   Mon, 21 Dec 2020 02:47:11 -0600
Message-Id: <1608540439-28772-7-git-send-email-xiaogang.chen@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
References: <1608540439-28772-1-git-send-email-xiaogang.chen@amd.com>
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
 drivers/gpu/drm/i915/gt/intel_rps.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_rps.c b/drivers/gpu/drm/i915/gt/intel_rps.c
index b2d2459..8accea0 100644
--- a/drivers/gpu/drm/i915/gt/intel_rps.c
+++ b/drivers/gpu/drm/i915/gt/intel_rps.c
@@ -83,7 +83,8 @@ static void rps_enable_interrupts(struct intel_rps *rps)
 	gen6_gt_pm_enable_irq(gt, rps->pm_events);
 	spin_unlock_irq(&gt->irq_lock);
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_mask(rps, rps->cur_freq));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_mask(rps, rps->last_freq));
 }
 
 static void gen6_rps_reset_interrupts(struct intel_rps *rps)
@@ -117,7 +118,8 @@ static void rps_disable_interrupts(struct intel_rps *rps)
 
 	rps->pm_events = 0;
 
-	set(gt->uncore, GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
+	intel_uncore_write(gt->uncore,
+			   GEN6_PMINTRMSK, rps_pm_sanitize_mask(rps, ~0u));
 
 	spin_lock_irq(&gt->irq_lock);
 	gen6_gt_pm_disable_irq(gt, GEN6_PM_RPS_EVENTS);
-- 
2.7.4

