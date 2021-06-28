Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DBE3B5FEF
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhF1OV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232766AbhF1OVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2292661C77;
        Mon, 28 Jun 2021 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889928;
        bh=grNtQweGzB7ChagePlEAlU9l3SqOz7A4AqMo/2eyJ+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEjjUQ7x7NLgwm3x0mhMG5zAYOnOOWfWFjkxmcf2YRj2voDyJd+bJ6TC+H6+6MpSH
         n7EKJYdtYOZB7KBWKrQlr2qJOusudkju6UqzjVk8KtLxb0IHUnY6hNXl6NJ+z8ZJ/3
         qCMMJUXcuTB6yBm8k7OqJ869qr0rh3H2I25hm7Wqgfawhy01KFRogvP6BkkMnM8QNB
         5lMvap6sfSG4g/pTASLnMSvb2P5hYGEhU5q+jhQh6p2zKcSgaYaERaWVStGbOCbbJd
         vbiSkyd/ywBFqMSNmHzEPhXmn3ll8jWeoZbMbI5BqVXuOGcEXA/7BX1vWytRHxtcOz
         yEDF0ZSDApm1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 021/110] perf/x86/intel/lbr: Zero the xstate buffer on allocation
Date:   Mon, 28 Jun 2021 10:16:59 -0400
Message-Id: <20210628141828.31757-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 7f049fbdd57f6ea71dc741d903c19c73b2f70950 ]

XRSTORS requires a valid xstate buffer to work correctly. XSAVES does not
guarantee to write a fully valid buffer according to the SDM:

  "XSAVES does not write to any parts of the XSAVE header other than the
   XSTATE_BV and XCOMP_BV fields."

XRSTORS triggers a #GP:

  "If bytes 63:16 of the XSAVE header are not all zero."

It's dubious at best how this can work at all when the buffer is not zeroed
before use.

Allocate the buffers with __GFP_ZERO to prevent XRSTORS failure.

Fixes: ce711ea3cab9 ("perf/x86/intel/lbr: Support XSAVES/XRSTORS for LBR context switch")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/87wnr0wo2z.ffs@nanos.tec.linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/lbr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 22d0e40a1920..991715886246 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -730,7 +730,8 @@ void reserve_lbr_buffers(void)
 		if (!kmem_cache || cpuc->lbr_xsave)
 			continue;
 
-		cpuc->lbr_xsave = kmem_cache_alloc_node(kmem_cache, GFP_KERNEL,
+		cpuc->lbr_xsave = kmem_cache_alloc_node(kmem_cache,
+							GFP_KERNEL | __GFP_ZERO,
 							cpu_to_node(cpu));
 	}
 }
-- 
2.30.2

