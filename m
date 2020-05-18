Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0791D828F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgERR52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731791AbgERR52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E76B20674;
        Mon, 18 May 2020 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824647;
        bh=u9Dmuq/K6ryDJMtzgJQEABHCn0tfGryZO0R5fm4zHtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bl+bgb47g1si813xS79UDlBTQmwDHNmKeqUNMmzdp79NfWXE54TK4K74lRFAfBEV6
         Mj11z2oC4e/3YnrCFKk5xjqJQadQTsZDfbscsRdw4G6idXnC048/lyYQ0+Whk/nZRd
         v0iMOMQx+EsO3Q96jNzUtJLO8gdtZ7czTlXNzJC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiong Zhang <xiong.y.zhang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/147] drm/i915/gvt: Fix kernel oops for 3-level ppgtt guest
Date:   Mon, 18 May 2020 19:36:41 +0200
Message-Id: <20200518173523.488172832@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenyu Wang <zhenyuw@linux.intel.com>

[ Upstream commit 72a7a9925e2beea09b109dffb3384c9bf920d9da ]

As i915 won't allocate extra PDP for current default PML4 table,
so for 3-level ppgtt guest, we would hit kernel pointer access
failure on extra PDP pointers. So this trys to bypass that now.
It won't impact real shadow PPGTT setup, so guest context still
works.

This is verified on 4.15 guest kernel with i915.enable_ppgtt=1
to force on old aliasing ppgtt behavior.

Fixes: 4f15665ccbba ("drm/i915: Add ppgtt to GVT GEM context")
Reviewed-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200506095918.124913-1-zhenyuw@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 6c79d16b381ea..058dcd5416440 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -374,7 +374,11 @@ static void set_context_ppgtt_from_shadow(struct intel_vgpu_workload *workload,
 		for (i = 0; i < GVT_RING_CTX_NR_PDPS; i++) {
 			struct i915_page_directory * const pd =
 				i915_pd_entry(ppgtt->pd, i);
-
+			/* skip now as current i915 ppgtt alloc won't allocate
+			   top level pdp for non 4-level table, won't impact
+			   shadow ppgtt. */
+			if (!pd)
+				break;
 			px_dma(pd) = mm->ppgtt_mm.shadow_pdps[i];
 		}
 	}
-- 
2.20.1



