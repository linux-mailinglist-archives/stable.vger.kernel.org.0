Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588D434D58C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhC2Qvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231404AbhC2QvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 975456196E;
        Mon, 29 Mar 2021 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617036678;
        bh=wZVa1phDDnsLOm6DwbhMvBlsylxST9slJ7Izp0GKTAk=;
        h=From:To:Cc:Subject:Date:From;
        b=CpKGoa5GUd+JakwCPqjb2BnKflOnfAuh4y6XTw7wvIxWm4SbmFdAWaLMPqdmw7Os+
         rc1aBP4Xup7HHVcFWSWA4ljzCez21RIszUMOKad+CcaizjLeseDpS1UbwjdjgsbIlt
         +FWyok5jNrf9rMHvAUcU3eExSJoItpDgjxf61JAtzd+XkwrnuValkGJakOFhdMt08W
         YM7UUfoKn4QQXEJrjUARwvtOyJDhFwCkUh1Fycw+GWNPY2TAKaUe0L4HU0sMiCQgbR
         8z+o3ojhayQCZqCCTIlQYJNR50RK8JIZ9vHZRyLE0AVA3gXLVxbgTHejvw5QWEZmYo
         xahUoO2GtrPfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, mark.tomlinson@alliedtelesis.co.nz
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: FAILED: Patch "netfilter: x_tables: Use correct memory barriers." failed to apply to 4.4-stable tree
Date:   Mon, 29 Mar 2021 12:51:16 -0400
Message-Id: <20210329165116.2359676-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.4-stable tree.
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




