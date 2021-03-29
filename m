Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D133034C7B0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhC2IR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233046AbhC2IPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D59546196D;
        Mon, 29 Mar 2021 08:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005727;
        bh=43SFuyqFDg25OjiCtBvWthzGUpSNIkUtCbK5kUNqPKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AxwziBZNUNTd8RDABUV3XIGFKno5el/5F+HRbPrcpROmKC/kaI8Gc8s4u0V6Dkis
         i6PF7BuRNOGhY741AhJ5xXN8JSNdr1FZ5fLKBMkiP9pqhIwMPA7Vgw8v0VO5o1zYMz
         FHLcNKgXqVhNjOozYMv3muDFEKnGiJUIoHGZRTsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/111] netfilter: x_tables: Use correct memory barriers.
Date:   Mon, 29 Mar 2021 09:58:43 +0200
Message-Id: <20210329075618.372991371@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit 175e476b8cdf2a4de7432583b49c871345e4f8a1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/netfilter/x_tables.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1b261c51b3a3..04e7f5630509 100644
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
index ef6d51a3798b..5c35d64d1f34 100644
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



