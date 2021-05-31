Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558C1395D3B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhEaNnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232622AbhEaNlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F1F2613CB;
        Mon, 31 May 2021 13:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467677;
        bh=ZwhSOuAOb9G91WJC5RB/EU3X4jcj4Zz/IXtSP7M61L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnM0tUB6pOhNNwYEgFcoU535adCYeFGAr9tJm9eQ9+7sOuIOVhB2Jvxhcp6qv7uNn
         W5/MsafC75zLPif6W/QTq4EXLiJP3F8k9aSXTM0uDREjgGE20TpJJv4srRSzrjXN1l
         fTHKn9sd4xjUIDSNgxXBH2WMrbsZ7MobZSzw6xdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Pavel Machek (CIP)" <pavel@denx.de>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.14 05/79] netfilter: x_tables: Use correct memory barriers.
Date:   Mon, 31 May 2021 15:13:50 +0200
Message-Id: <20210531130636.175330012@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netfilter/x_tables.h |    2 +-
 net/netfilter/x_tables.c           |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -373,7 +373,7 @@ static inline unsigned int xt_write_recs
 	 * since addend is most likely 1
 	 */
 	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
+	smp_mb();
 
 	return addend;
 }
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1249,6 +1249,9 @@ xt_replace_table(struct xt_table *table,
 	smp_wmb();
 	table->private = newinfo;
 
+	/* make sure all cpus see new ->private value */
+	smp_mb();
+
 	/*
 	 * Even though table entries have now been swapped, other CPU's
 	 * may still be using the old entries. This is okay, because


