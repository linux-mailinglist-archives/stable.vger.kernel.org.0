Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B4463DC8F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiK3SAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiK3SAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2FB2C105
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F09EBB81C5E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602E1C433D6;
        Wed, 30 Nov 2022 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669831211;
        bh=Dpdi/zWlxc8d09s4RikLCYmWgAXoywZWWqeR6Y4U4Mk=;
        h=Subject:To:Cc:From:Date:From;
        b=vHL/7Hb4mqOZvlRiqJjUfz+JgH2Hsqh1wFgG1DT9U40S6ynLWv0HOolWe409EnWsg
         qJKZ+xzwwPwDTduZSyXv6RHu8kGw139I86ts1PB90c16APKIM/+RaZOZZBcYEtRJGe
         VYWnOgRZwjKfjX0TkzJRSt1RMhiofqY4E9i4gmOw=
Subject: FAILED: patch "[PATCH] drm/i915: fix TLB invalidation for Gen12 video and compute" failed to apply to 5.4-stable tree
To:     andrzej.hajda@intel.com, chris.p.wilson@intel.com,
        daniel.vetter@ffwll.ch, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:59:59 +0100
Message-ID: <166983119922053@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
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

