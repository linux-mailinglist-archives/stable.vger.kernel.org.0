Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27782139A8F
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 21:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAMUJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 15:09:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36271 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728733AbgAMUJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 15:09:52 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8D2FA223A8;
        Mon, 13 Jan 2020 15:09:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 13 Jan 2020 15:09:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Uh/bui
        0Dsf1j1v4LuDKGUhHsGgGopg0114PAMSnEtkU=; b=f69ndUuhv7+xfSiPhUn2VA
        MBRagWf4FaHiuFpr/J8COX5ulRxJQiKvk3oV3/TA+bCkGcAxWBr8RhsyHeOjSFfg
        nl7z7sOrRJqKeIjnhTi8ubKkqoyhtiQ3K848QxjFHJ0Ycvh2nBKn4Hg8vqNloA/b
        zKzxU9PL+4WkSzVVXFbKcgmO1bEHmIV97QmxBQbcTDKsg0coYV8K8ydRlpCKhyfq
        RL3b/eN2xKgUzEkcDJ+WtlmyPUH7D5cNX0hk/RVRDPwzzH2f/GHZBRD8eYfg23Sm
        KkV3pf/2JE0COzvzQgeezgk3uw6PJYTDlBObqtoTQtgb1JItcPCYvVr0twwhcBsw
        ==
X-ME-Sender: <xms:js4cXuaBcPF5T6xy2WWo13VrARtcYc0B_Odr3kVUiuW0yd4IJWqHYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejtddgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrd
    ekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:js4cXrdS8WfB4d809pIPy4LiEmyVp7jEvE83nGWc_18Z2f27ilycBg>
    <xmx:js4cXo39nngUKsjRdLlmv4GZFpm8C3hCienckjAcDqxwej9_QXheJw>
    <xmx:js4cXiKe48W6Fc21cuTJvB0ZPWfWcnI9SuyC58neun351AnF2hj7CQ>
    <xmx:js4cXusd1K2A36TeGHLcN-xSUfuTNyJXWJ0aT-XlWjUYwr31a9OkNw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C6A380065;
        Mon, 13 Jan 2020 15:09:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Do not restore invalid RS state" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        matthew.auld@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jan 2020 21:09:47 +0100
Message-ID: <15789461874550@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 103309977589fe6be0f4314de4925737cdfc146f Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 29 Dec 2019 18:31:50 +0000
Subject: [PATCH] drm/i915/gt: Do not restore invalid RS state

Only restore valid resource streamer state from the context image, i.e.
avoid restoring if we know the image is invalid.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/446
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191229183153.3719869-4-chris@chris-wilson.co.uk
Cc: stable@vger.kernel.org
(cherry picked from commit ecfcd2da335816516dc27434a65899a77886d80a)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_ring_submission.c b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
index a47d5a7c32c9..93026217c121 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -1413,14 +1413,6 @@ static inline int mi_set_context(struct i915_request *rq, u32 flags)
 	int len;
 	u32 *cs;
 
-	flags |= MI_MM_SPACE_GTT;
-	if (IS_HASWELL(i915))
-		/* These flags are for resource streamer on HSW+ */
-		flags |= HSW_MI_RS_SAVE_STATE_EN | HSW_MI_RS_RESTORE_STATE_EN;
-	else
-		/* We need to save the extended state for powersaving modes */
-		flags |= MI_SAVE_EXT_STATE_EN | MI_RESTORE_EXT_STATE_EN;
-
 	len = 4;
 	if (IS_GEN(i915, 7))
 		len += 2 + (num_engines ? 4 * num_engines + 6 : 0);
@@ -1589,22 +1581,21 @@ static int switch_context(struct i915_request *rq)
 	}
 
 	if (ce->state) {
-		u32 hw_flags;
+		u32 flags;
 
 		GEM_BUG_ON(rq->engine->id != RCS0);
 
-		/*
-		 * The kernel context(s) is treated as pure scratch and is not
-		 * expected to retain any state (as we sacrifice it during
-		 * suspend and on resume it may be corrupted). This is ok,
-		 * as nothing actually executes using the kernel context; it
-		 * is purely used for flushing user contexts.
-		 */
-		hw_flags = 0;
-		if (i915_gem_context_is_kernel(rq->gem_context))
-			hw_flags = MI_RESTORE_INHIBIT;
+		/* For resource streamer on HSW+ and power context elsewhere */
+		BUILD_BUG_ON(HSW_MI_RS_SAVE_STATE_EN != MI_SAVE_EXT_STATE_EN);
+		BUILD_BUG_ON(HSW_MI_RS_RESTORE_STATE_EN != MI_RESTORE_EXT_STATE_EN);
+
+		flags = MI_SAVE_EXT_STATE_EN | MI_MM_SPACE_GTT;
+		if (!i915_gem_context_is_kernel(rq->gem_context))
+			flags |= MI_RESTORE_EXT_STATE_EN;
+		else
+			flags |= MI_RESTORE_INHIBIT;
 
-		ret = mi_set_context(rq, hw_flags);
+		ret = mi_set_context(rq, flags);
 		if (ret)
 			return ret;
 	}

