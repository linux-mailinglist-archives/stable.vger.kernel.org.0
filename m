Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C8D3B6110
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhF1Obo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234582AbhF1OaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D1BD61C94;
        Mon, 28 Jun 2021 14:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890388;
        bh=sY5GkAsi8S0B9bZc0hbk9eW1X2mvJjUu4b2F0g8rmGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRxOMpnE1hDtJ0iScUOlm8kV4ZkZvueeO10Isx7svTDPWydqWw754jC/9zQWwoFAG
         6KVqOYgQSygbgW/wovqGPKUF63u194ui/Af9z16lvDzJcxWCowmxDM74ZwcGOlB4wb
         AtZCs8pmukmtEQah21BezTxMcWySsm5RcirEv7BFzHLzsFI0pdIoK2Brp7V20CalZd
         exAjWcYOC87FDYEUt4XfHjX81vCUslO+ZFTPVn1oDrEQZlaAgq8T9gdhw1iGmLT2Cw
         Qxh2Uc2Whze5p0sjkfSw0vpmKQyxLeK06gCQhw5rmSQdxHqt0Jz/dmKHQFPux/fAbN
         QwaMhZv+ze+3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/101] perf/x86/intel/lbr: Zero the xstate buffer on allocation
Date:   Mon, 28 Jun 2021 10:24:47 -0400
Message-Id: <20210628142607.32218-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 6c1231837382..29ec4fe48507 100644
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

