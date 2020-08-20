Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE86C24BE1A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgHTNU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgHTJe3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34C222B4E;
        Thu, 20 Aug 2020 09:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916068;
        bh=zKJiumy7WB1VYARPCxK033zbGDpdPY66nkNZtcYczqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS7gCum0AP59NWW72rw2IwYlyCr7CRrVasIqQUf4Z7p11GtxapVw33aGVWY4OWgPK
         hyYVGUTKoiPABoKLdwoMYAxRP5Do6ZI2UOK9VYQEz6aPsWvAvThrmriWK0oV1DUKXs
         dHTgJfng0Yx/DT96qjXH02ixNyIUlx07kZsF9BRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        stable@kernel.org, Mika Kuoppala <mika.kuoppala@linux.intel.com>
Subject: [PATCH 5.8 221/232] drm/i915/gt: Force the GT reset on shutdown
Date:   Thu, 20 Aug 2020 11:21:12 +0200
Message-Id: <20200820091623.485949565@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7c4541a37bbbf83c0f16f779e85eb61d9348ed29 upstream.

Before we return control to the system, and letting it reuse all the
pages being accessed by HW, we must disable the HW. At the moment, we
dare not reset the GPU if it will clobber the display, but once we know
the display has been disabled, we can proceed with the reset as we
shutdown the module. We know the next user must reinitialise the HW for
their purpose.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/489
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@kernel.org
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200525151459.12083-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_gt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -616,6 +616,11 @@ void intel_gt_driver_unregister(struct i
 void intel_gt_driver_release(struct intel_gt *gt)
 {
 	struct i915_address_space *vm;
+	intel_wakeref_t wakeref;
+
+	/* Scrub all HW state upon release */
+	with_intel_runtime_pm(gt->uncore->rpm, wakeref)
+		__intel_gt_reset(gt, ALL_ENGINES);
 
 	vm = fetch_and_zero(&gt->vm);
 	if (vm) /* FIXME being called twice on error paths :( */


