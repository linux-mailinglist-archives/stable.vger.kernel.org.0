Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347A72908B2
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410107AbgJPPn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408621AbgJPPn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 11:43:29 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Oct 2020 08:43:29 PDT
Received: from manul.sfritsch.de (manul.sfritsch.de [IPv6:2a01:4f8:172:195f:112::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFCEC061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 08:43:29 -0700 (PDT)
From:   Stefan Fritsch <sf@sfritsch.de>
To:     intel-gfx@lists.freedesktop.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Stefan Fritsch <sf@sfritsch.de>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Rate limit 'Fault errors' message
Date:   Fri, 16 Oct 2020 17:23:40 +0200
Message-Id: <20201016152340.15906-1-sf@sfritsch.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If linux is running as a guest and the host is doing igd pass-through
with VT-d enabled, this message is logged dozens of times per second.

Cc: stable@vger.kernel.org
Signed-off-by: Stefan Fritsch <sf@sfritsch.de>
---

The i915 driver should also detect VT-d in this case, but that is a
different issue.  I have sent a separate mail with subject 'Detecting
Vt-d when running as guest os'.


 drivers/gpu/drm/i915/i915_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 759f523c6a6b..29096634e697 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2337,7 +2337,7 @@ gen8_de_irq_handler(struct drm_i915_private *dev_priv, u32 master_ctl)
 
 		fault_errors = iir & gen8_de_pipe_fault_mask(dev_priv);
 		if (fault_errors)
-			drm_err(&dev_priv->drm,
+			drm_err_ratelimited(&dev_priv->drm,
 				"Fault errors on pipe %c: 0x%08x\n",
 				pipe_name(pipe),
 				fault_errors);
-- 
2.28.0

