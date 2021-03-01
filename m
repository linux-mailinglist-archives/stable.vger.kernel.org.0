Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8122D328AA3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhCASUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239326AbhCASOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:14:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01831652AD;
        Mon,  1 Mar 2021 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620079;
        bh=WZ3X56eG9ykqM8LQZ8+a19QmUyU6Zls8kWGf0YuSpsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMr9b3KuYFJ0fqy+F3N4pUcSaBGXMYbRJ5+N7LZmbujpvwyt5qQ/jtI16P9UxFAIE
         SikeT5AwlS1R0s2hH68cgfNlxcmGk0HYdiomui377Fcl9ucrKbNNgyZjWqwJOOQ8Fq
         n2e50hK/TL+jDLHGfY2uni+nwr2x5zWdw7pPq9MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Diego Calleja <diegocg@gmail.com>
Subject: [PATCH 5.11 022/775] drm/i915/gt: One more flush for Baytrail clear residuals
Date:   Mon,  1 Mar 2021 17:03:10 +0100
Message-Id: <20210301161202.807563627@linuxfoundation.org>
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

commit e627d5923cae93fa4188f4c4afba6486169a1337 upstream.

CI reports that Baytail requires one more invalidate after CACHE_MODE
for it to be happy.

Fixes: ace44e13e577 ("drm/i915/gt: Clear CACHE_MODE prior to clearing residuals")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Diego Calleja <diegocg@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210119110802.22228-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/gen7_renderclear.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
+++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
@@ -353,19 +353,21 @@ static void gen7_emit_pipeline_flush(str
 
 static void gen7_emit_pipeline_invalidate(struct batch_chunk *batch)
 {
-	u32 *cs = batch_alloc_items(batch, 0, 8);
+	u32 *cs = batch_alloc_items(batch, 0, 10);
 
 	/* ivb: Stall before STATE_CACHE_INVALIDATE */
-	*cs++ = GFX_OP_PIPE_CONTROL(4);
+	*cs++ = GFX_OP_PIPE_CONTROL(5);
 	*cs++ = PIPE_CONTROL_STALL_AT_SCOREBOARD |
 		PIPE_CONTROL_CS_STALL;
 	*cs++ = 0;
 	*cs++ = 0;
+	*cs++ = 0;
 
-	*cs++ = GFX_OP_PIPE_CONTROL(4);
+	*cs++ = GFX_OP_PIPE_CONTROL(5);
 	*cs++ = PIPE_CONTROL_STATE_CACHE_INVALIDATE;
 	*cs++ = 0;
 	*cs++ = 0;
+	*cs++ = 0;
 
 	batch_advance(batch, cs);
 }
@@ -397,6 +399,7 @@ static void emit_batch(struct i915_vma *
 	batch_add(&cmds, 0xffff0000);
 	batch_add(&cmds, i915_mmio_reg_offset(CACHE_MODE_1));
 	batch_add(&cmds, 0xffff0000 | PIXEL_SUBSPAN_COLLECT_OPT_DISABLE);
+	gen7_emit_pipeline_invalidate(&cmds);
 	gen7_emit_pipeline_flush(&cmds);
 
 	/* Switch to the media pipeline and our base address */


