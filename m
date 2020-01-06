Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5841D13123B
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 13:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgAFMj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 07:39:26 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:61139 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgAFMj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 07:39:26 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 19784132-1500050 
        for multiple; Mon, 06 Jan 2020 12:39:22 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/i915/gt: Mark up virtual engine uabi_instance
Date:   Mon,  6 Jan 2020 12:39:21 +0000
Message-Id: <20200106123921.2543886-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Be sure to initialise the uabi_instance on the virtual engine to the
special invalid value, just in case we ever peek at it from the uAPI.

Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 750e76b4f9f6 ("drm/i915/gt: Move the [class][inst] lookup for engines onto the GT")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/gt/intel_lrc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index 170b5a0139a3..f07d93514a7c 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -4601,9 +4601,11 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
 	ve->base.gt = siblings[0]->gt;
 	ve->base.uncore = siblings[0]->uncore;
 	ve->base.id = -1;
+
 	ve->base.class = OTHER_CLASS;
 	ve->base.uabi_class = I915_ENGINE_CLASS_INVALID;
 	ve->base.instance = I915_ENGINE_CLASS_INVALID_VIRTUAL;
+	ve->base.uabi_instance = I915_ENGINE_CLASS_INVALID_VIRTUAL;
 
 	/*
 	 * The decision on whether to submit a request using semaphores
-- 
2.25.0.rc1

