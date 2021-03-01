Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E963F32914F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbhCAUXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242896AbhCAUQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:16:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC104653D9;
        Mon,  1 Mar 2021 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621783;
        bh=7A1pKqdKYGdgYqyvoPripE2AZTpzpJRB9fEwNEElYK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+d3UKPRl7gQXhWAexzPWuPAEWW4kpFmFfvoBogmpHH9RGwkRHv1lkxny1GomYB3U
         /0eGmDdeIMa3JGmiAmuJ3EQWCz9cjzTKAqtZwIdAuY65LkTw+mCdRi2rVc2vDlIWXl
         +pHYWpcnTJdGVvq6yQMfbWZijSkN84CDjX7XdVy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Diego Calleja <diegocg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.11 643/775] drm/i915/gt: Flush before changing register state
Date:   Mon,  1 Mar 2021 17:13:31 +0100
Message-Id: <20210301161233.166453387@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit d5109f739c9f14a3bda249cb48b16de1065932f0 upstream.

Flush; invalidate; change registers; invalidate; flush.

Will this finally work on every device? Or will Baytrail complain again?

On the positive side, we immediately see the benefit of having hsw-gt1 in
CI.

Fixes: ace44e13e577 ("drm/i915/gt: Clear CACHE_MODE prior to clearing residuals")
Testcase: igt/gem_render_tiled_blits # hsw-gt1
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Acked-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210125220247.31701-1-chris@chris-wilson.co.uk
(cherry picked from commit d30bbd62b1bfd9e0a33c3583c5a9e5d66f60cbd7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Diego Calleja <diegocg@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/gen7_renderclear.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
+++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
@@ -393,6 +393,7 @@ static void emit_batch(struct i915_vma *
 						     desc_count);
 
 	/* Reset inherited context registers */
+	gen7_emit_pipeline_flush(&cmds);
 	gen7_emit_pipeline_invalidate(&cmds);
 	batch_add(&cmds, MI_LOAD_REGISTER_IMM(2));
 	batch_add(&cmds, i915_mmio_reg_offset(CACHE_MODE_0_GEN7));


