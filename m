Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B165E171D0B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389388AbgB0ORX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389688AbgB0ORX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E559B246AD;
        Thu, 27 Feb 2020 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813042;
        bh=MGK1Qur0NJz7SAyjMCCjz28nH5j++Jd4iAwKVDhsT+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=put39t7SukgZ5l4XLbhYtOrdGiWVZ53aPIRvJdf1YYCmKgHCSiQ0NTmRAS9PMtEk6
         DG3CZeynuU1Jh/zbFKCLfMsCG5M8vO3SePwccIXRCfMZf1hR71Yizj2xEbL5oPezBq
         Oi1Zn949WIinMc4u5CTJAP/x3CguXqkmlTk3jDEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 115/150] drm/i915/gem: Require per-engine reset support for non-persistent contexts
Date:   Thu, 27 Feb 2020 14:37:32 +0100
Message-Id: <20200227132249.678010614@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit dea8d5ce46d7e7f7270b9804df7d1174f88bfd99 upstream.

To enable non-persistent contexts, we require a means of cancelling any
inflight work from that context. This is first done "gracefully" by
using preemption to kick the active context off the engine, and then
forcefully by resetting the engine if it is active. If we are unable to
reset the engine to remove hostile userspace, we should not allow
userspace to opt into using non-persistent contexts.

If the per-engine reset fails, we still do a full GPU reset, but that is
rare and usually indicative of much deeper issues. The damage is already
done. However, the goal of the interface to allow long running compute
jobs without causing collateral damage elsewhere, and if we are unable
to support that we should make that known by not providing the
interface (and falsely pretending we can).

Fixes: a0e047156cde ("drm/i915/gem: Make context persistence optional")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Reviewed-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200130164553.1937718-1-chris@chris-wilson.co.uk
(cherry picked from commit d1b9b5f127bc3797fc274cfa4f363e039f045c3a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -484,6 +484,22 @@ static int __context_set_persistence(str
 		if (!(ctx->i915->caps.scheduler & I915_SCHEDULER_CAP_PREEMPTION))
 			return -ENODEV;
 
+		/*
+		 * If the cancel fails, we then need to reset, cleanly!
+		 *
+		 * If the per-engine reset fails, all hope is lost! We resort
+		 * to a full GPU reset in that unlikely case, but realistically
+		 * if the engine could not reset, the full reset does not fare
+		 * much better. The damage has been done.
+		 *
+		 * However, if we cannot reset an engine by itself, we cannot
+		 * cleanup a hanging persistent context without causing
+		 * colateral damage, and we should not pretend we can by
+		 * exposing the interface.
+		 */
+		if (!intel_has_reset_engine(&ctx->i915->gt))
+			return -ENODEV;
+
 		i915_gem_context_clear_persistence(ctx);
 	}
 


