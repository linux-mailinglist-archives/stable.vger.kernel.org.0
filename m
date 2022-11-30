Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540DA63E053
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiK3Sz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiK3Sz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D759702F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68995B81CA9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECE0C433C1;
        Wed, 30 Nov 2022 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834555;
        bh=9DsdmpoIkCxuUwjz+xAM8ITITmonZJUuh86GCvRCLOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7RTOIGxF+jrU4T5zPol8v11raUv8gawjbNnDzt0EfJRqu3C9tvDFJdOC6jycGaCC
         iHwAadY9VDz3LkHiSvMuDyXeWwvdXV58rU+79w88DqhmjywwHkAugwXWasWsxo980A
         mDPqz0toLAsHABnCp+js0fmh+Lag0zvT30vutc8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Wilson <chris.p.wilson@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.0 289/289] drm/i915: fix TLB invalidation for Gen12 video and compute engines
Date:   Wed, 30 Nov 2022 19:24:34 +0100
Message-Id: <20221130180550.653919544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Hajda <andrzej.hajda@intel.com>

commit 04aa64375f48a5d430b5550d9271f8428883e550 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -961,6 +961,11 @@ static void mmio_invalidate_full(struct
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


