Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0E5328C3F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbhCASrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237533AbhCASmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:42:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAECB6524B;
        Mon,  1 Mar 2021 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619672;
        bh=7A1pKqdKYGdgYqyvoPripE2AZTpzpJRB9fEwNEElYK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMQD55B1vLyTwgP8L0td6xwlFnV1MnkACPb2cKpKUCVji4Ayta/wbea0xGTk+7q5f
         I8SjhexlqW++gAYRCjTlX8PL8nAeX0BUx5eohvjXT3Ys0T4ye43H/fcAu8dbnhxAtu
         hFLVMSRvAg7CRheNKF2css4lZPh9vs2Os6QqgrT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Diego Calleja <diegocg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 540/663] drm/i915/gt: Flush before changing register state
Date:   Mon,  1 Mar 2021 17:13:08 +0100
Message-Id: <20210301161208.580668320@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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


