Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAC9392A5D
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhE0JP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:15:29 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:45590 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbhE0JPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 05:15:25 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 14R9DNft029992; Thu, 27 May 2021 18:13:23 +0900
X-Iguazu-Qid: 2wGrNQa8dpXigRuRYh
X-Iguazu-QSIG: v=2; s=0; t=1622106803; q=2wGrNQa8dpXigRuRYh; m=RUZJyYgTrYRO1XQOLTvc9ibRFM4kOsu/d9uMmQiN/8Y=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1110) id 14R9DJLZ006642
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 May 2021 18:13:22 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id C71681000EC;
        Thu, 27 May 2021 18:13:19 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 14R9DJOS014681;
        Thu, 27 May 2021 18:13:19 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, wens@csie.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Pavel Machek <pavel@denx.de>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [Resend PATCH for 4.4, 4.9, 4.14] netfilter: x_tables: Use correct memory barriers.
Date:   Thu, 27 May 2021 18:13:03 +0900
X-TSB-HOP: ON
Message-Id: <20210527091303.941790-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

commit 175e476b8cdf2a4de7432583b49c871345e4f8a1 upstream.

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
[Ported to stable, affected barrier is added by d3d40f237480abf3268956daf18cdc56edd32834 in mainline]
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/netfilter/x_tables.c           | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 6923e4049de3af..304b60b4952627 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -327,7 +327,7 @@ static inline unsigned int xt_write_recseq_begin(void)
 	 * since addend is most likely 1
 	 */
 	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
+	smp_mb();
 
 	return addend;
 }
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 7e261fab7ef8de..480ccd52a73fdb 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1140,6 +1140,9 @@ xt_replace_table(struct xt_table *table,
 	smp_wmb();
 	table->private = newinfo;
 
+	/* make sure all cpus see new ->private value */
+	smp_mb();
+
 	/*
 	 * Even though table entries have now been swapped, other CPU's
 	 * may still be using the old entries. This is okay, because
-- 
2.31.1

