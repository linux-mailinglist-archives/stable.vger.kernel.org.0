Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DCD34D580
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhC2QvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhC2QvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66C6661920;
        Mon, 29 Mar 2021 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617036659;
        bh=Ik7Z/nJYau465zLkc93kev1gTADBkAhQ+2dKLDgW2wQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ngg7vB56nx6FT4FKrc2rzfAVOi62Lvn1JBvdfC59S03EJw5L2soPh15AF6N2pHRZU
         RiRXcem5DdjeOr9NEeYHEpGiW32KsDktLLEykOfCz8vRLDwQuoz8/7eQvgJrJLdzfN
         9dIhERmsDdbvUjrKbeaPWfWR3OPKhTCAkhTq1m7sjpIDOJF4ECL65igolSBnk5JUBw
         4otb12WMGp5Te+QRsHbQDc5NNHQJLesxnpD3m7tOVUfQg3Sw2QV8uGwWVOMPTeXWCl
         h3SU+cCLstTaccXxLMg/82AnjpwJklj7e0KH1eqrKFNXPUFR6jz2XJhk0PF6zlYI4j
         NI5r+15Tp2/gA==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, mark.tomlinson@alliedtelesis.co.nz
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: FAILED: Patch "netfilter: x_tables: Use correct memory barriers." failed to apply to 4.14-stable tree
Date:   Mon, 29 Mar 2021 12:50:58 -0400
Message-Id: <20210329165058.2359071-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 175e476b8cdf2a4de7432583b49c871345e4f8a1 Mon Sep 17 00:00:00 2001
From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Date: Mon, 8 Mar 2021 14:24:13 +1300
Subject: [PATCH] netfilter: x_tables: Use correct memory barriers.

When a new table value was assigned, it was followed by a write memory
barrier. This ensured that all writes before this point would complete
before any writes after this point. However, to determine whether the
rules are unused, the sequence counter is read. To ensure that all
writes have been done before these reads, a full memory barrier is
needed, not just a write memory barrier. The same argument applies when
incrementing the counter, before the rules are read.

Changing to using smp_mb() instead of smp_wmb() fixes the kernel panic
reported in cc00bcaa5899 (which is still present), while still
maintaining the same speed of replacing tables.

The smb_mb() barriers potentially slow the packet path, however testing
has shown no measurable change in performance on a 4-core MIPS64
platform.

Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/netfilter/x_tables.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 5deb099d156d..8ec48466410a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -376,7 +376,7 @@ static inline unsigned int xt_write_recseq_begin(void)
 	 * since addend is most likely 1
 	 */
 	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
+	smp_mb();
 
 	return addend;
 }
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 7df3aef39c5c..6bd31a7a27fc 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1389,7 +1389,7 @@ xt_replace_table(struct xt_table *table,
 	table->private = newinfo;
 
 	/* make sure all cpus see new ->private value */
-	smp_wmb();
+	smp_mb();
 
 	/*
 	 * Even though table entries have now been swapped, other CPU's
-- 
2.30.1




