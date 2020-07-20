Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D21A2266A0
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbgGTQEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732900AbgGTQEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:04:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80C42064B;
        Mon, 20 Jul 2020 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261090;
        bh=7PZOFXk17VGnGVAqGGJMfRQ5uY/5PQ1p83UE4wOgt2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SD4nRsjmegGuoD8lGeCxgIE9C+fdwxkWTW9zliwnMM34RanKsUCfO243LOywjSXzQ
         apyB7UCr/QN3YP8C4/ek5LKdbv3sM/fHoRv9/MQ0I8cjIH0N6DNoUgk6rFUAjS4rrG
         VAatWG4lWOtZ74uny71g3TnbBBM18J4AHd6bkoFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 206/215] drm/i915/gt: Ignore irq enabling on the virtual engines
Date:   Mon, 20 Jul 2020 17:38:08 +0200
Message-Id: <20200720152829.960018885@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 858f1299fd6f7518ddef19ddd304c8398ac79fa5 upstream.

We do not use the virtual engines for interrupts (they have physical
components), but we do use them to decouple the fence signaling during
submission. Currently, when we submit a completed request, we try to
enable the interrupt handler for the virtual engine, but we never disarm
it. A quick fix is then to mark the irq as enabled, and it will then
remain enabled -- and this prevents us from waking the device and never
letting it sleep again.

Fixes: f8db4d051b5e ("drm/i915: Initialise breadcrumb lists on the virtual engine")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200711203236.12330-1-chris@chris-wilson.co.uk
(cherry picked from commit 4fe6abb8f51355224808ab02a9febf65d184c40b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3751,6 +3751,7 @@ intel_execlists_create_virtual(struct i9
 	intel_engine_init_active(&ve->base, ENGINE_VIRTUAL);
 
 	intel_engine_init_execlists(&ve->base);
+	ve->base.breadcrumbs.irq_armed = true; /* fake HW, used for irq_work */
 
 	ve->base.cops = &virtual_context_ops;
 	ve->base.request_alloc = execlists_request_alloc;


