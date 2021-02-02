Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5030C016
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhBBNtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:49:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232933AbhBBNrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3281F64F8F;
        Tue,  2 Feb 2021 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273298;
        bh=rIGhx9RV0NM5CnYpvOuwXFg43rqk9ofNndTN5YDJgTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqtSnkwlB9TH/JdSNfKmqFqX7TCFIVlCZXzG2C8eC7Eued5FtjjyElFR/Et4FrLly
         kEHhxO6Y4aI4gq8xyUgM/5kWXnnIU4UWR4N73/ZI5Ul3akDHGAdwphC3QSV6l8jmzy
         4CH6XBne1ffGGd6P4vdL581I+BfhMMBW/vlLvBYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 055/142] drm/i915/gt: Clear CACHE_MODE prior to clearing residuals
Date:   Tue,  2 Feb 2021 14:36:58 +0100
Message-Id: <20210202132959.988068617@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit ef99a60ffd9b918354e038bc5e61f007ff7e901d upstream.

Since we do a bare context switch with no restore, the clear residual
kernel runs on dirty state, and we must be careful to avoid executing
with bad state from context registers inherited from a malicious client.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2955
Fixes: 09aa9e45863e ("drm/i915/gt: Restore clear-residual mitigations for Ivybridge, Baytrail")
Testcase: igt/gem_ctx_isolation # ivb,vlv
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Reviewed-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210117093015.29143-1-chris@chris-wilson.co.uk
(cherry picked from commit ace44e13e577c2ae59980e9a6ff5ca253b1cf831)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/gen7_renderclear.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
+++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
@@ -390,6 +390,16 @@ static void emit_batch(struct i915_vma *
 						     &cb_kernel_ivb,
 						     desc_count);
 
+	/* Reset inherited context registers */
+	gen7_emit_pipeline_invalidate(&cmds);
+	batch_add(&cmds, MI_LOAD_REGISTER_IMM(2));
+	batch_add(&cmds, i915_mmio_reg_offset(CACHE_MODE_0_GEN7));
+	batch_add(&cmds, 0xffff0000);
+	batch_add(&cmds, i915_mmio_reg_offset(CACHE_MODE_1));
+	batch_add(&cmds, 0xffff0000 | PIXEL_SUBSPAN_COLLECT_OPT_DISABLE);
+	gen7_emit_pipeline_flush(&cmds);
+
+	/* Switch to the media pipeline and our base address */
 	gen7_emit_pipeline_invalidate(&cmds);
 	batch_add(&cmds, PIPELINE_SELECT | PIPELINE_SELECT_MEDIA);
 	batch_add(&cmds, MI_NOOP);
@@ -399,9 +409,11 @@ static void emit_batch(struct i915_vma *
 	gen7_emit_state_base_address(&cmds, descriptors);
 	gen7_emit_pipeline_invalidate(&cmds);
 
+	/* Set the clear-residual kernel state */
 	gen7_emit_vfe_state(&cmds, bv, urb_size - 1, 0, 0);
 	gen7_emit_interface_descriptor_load(&cmds, descriptors, desc_count);
 
+	/* Execute the kernel on all HW threads */
 	for (i = 0; i < num_primitives(bv); i++)
 		gen7_emit_media_object(&cmds, i);
 


