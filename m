Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CCE2B6281
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgKQN3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:29:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731534AbgKQN3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE53E2078D;
        Tue, 17 Nov 2020 13:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619753;
        bh=w8XOlxJaAOn+/e+5QFRCN5A04FHeFp13fckscBopjnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wxqpVicsVH6eP+k7r+EUcPuWBfm/TG/9xENQXR2cJX1FzetxLH7vvUHbq6iFRbVi
         iPK8ftojHHI5o8l9NJHkop482qZ/ZSPJN7jvmch5yZAERemIX0tNlf7KwUhWBbI5zE
         Fd60K8ysX6zm0dT8MTWMyDfl8LeJrIoUCT140Urw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Roper <matthew.d.roper@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 145/151] drm/i915: Correctly set SFC capability for video engines
Date:   Tue, 17 Nov 2020 14:06:15 +0100
Message-Id: <20201117122128.481273627@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>

commit 5ce6861d36ed5207aff9e5eead4c7cc38a986586 upstream.

SFC capability of video engines is not set correctly because i915
is testing for incorrect bits.

Fixes: c5d3e39caa45 ("drm/i915: Engine discovery query")
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201106011842.36203-1-daniele.ceraolospurio@intel.com
(cherry picked from commit ad18fa0f5f052046cad96fee762b5c64f42dd86a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -354,7 +354,8 @@ static void __setup_engine_capabilities(
 		 * instances.
 		 */
 		if ((INTEL_GEN(i915) >= 11 &&
-		     RUNTIME_INFO(i915)->vdbox_sfc_access & engine->mask) ||
+		     (RUNTIME_INFO(i915)->vdbox_sfc_access &
+		      BIT(engine->instance))) ||
 		    (INTEL_GEN(i915) >= 9 && engine->instance == 0))
 			engine->uabi_capabilities |=
 				I915_VIDEO_AND_ENHANCE_CLASS_CAPABILITY_SFC;


