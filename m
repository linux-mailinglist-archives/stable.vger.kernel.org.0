Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94BDF63DC47
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiK3Ros (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiK3Rop (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:44:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F32578FE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:44:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A259D61D21
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A02EC433C1;
        Wed, 30 Nov 2022 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669830284;
        bh=ilGmJmeKjDBTcY7YUxCLLss7ohJD36I2PGY6fjgBcn0=;
        h=Subject:To:Cc:From:Date:From;
        b=LsbcspNgrYtlob0fTTHayAd0pSxPwX3CO4WIdXNWS/L8yyH/r+eAHRcySQj8ACXGF
         ysrNTWwWCWl4oDd0N1mz488B1dmPsmNr2XP66wjNk3Ua+8VeWRuWAuzKQ34cpZBiQw
         sYRs5avcbc6V18fUSHkM9tuJX3YMuYwYui7b2pBA=
Subject: FAILED: patch "[PATCH] drm/i915: fix TLB invalidation for Gen12 video and compute" failed to apply to 4.19-stable tree
To:     andrzej.hajda@intel.com, chris.p.wilson@intel.com,
        daniel.vetter@ffwll.ch, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:44:41 +0100
Message-ID: <166983028113234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

04aa64375f48 ("drm/i915: fix TLB invalidation for Gen12 video and compute engines")
33da97894758 ("drm/i915/gt: Serialize TLB invalidates with GT resets")
7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
1176d15f0f6e ("Merge tag 'drm-intel-gt-next-2021-10-08' of git://anongit.freedesktop.org/drm/drm-intel into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 04aa64375f48a5d430b5550d9271f8428883e550 Mon Sep 17 00:00:00 2001
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Mon, 14 Nov 2022 11:38:24 +0100
Subject: [PATCH] drm/i915: fix TLB invalidation for Gen12 video and compute
 engines

In case of Gen12 video and compute engines, TLB_INV registers are masked -
to modify one bit, corresponding bit in upper half of the register must
be enabled, otherwise nothing happens.

CVE: CVE-2022-4139
Suggested-by: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index d0b03a928b9a..5c931b6696c3 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -1017,6 +1017,11 @@ static void mmio_invalidate_full(struct intel_gt *gt)
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
+		if (GRAPHICS_VER(i915) == 12 && (engine->class == VIDEO_DECODE_CLASS ||
+		    engine->class == VIDEO_ENHANCEMENT_CLASS ||
+		    engine->class == COMPUTE_CLASS))
+			rb.bit = _MASKED_BIT_ENABLE(rb.bit);
+
 		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 		awake |= engine->mask;
 	}

