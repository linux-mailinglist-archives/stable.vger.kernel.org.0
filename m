Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6437B4990F3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347287AbiAXUHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:07:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39910 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354724AbiAXTv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:51:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37A9CB811F3;
        Mon, 24 Jan 2022 19:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D57C340E5;
        Mon, 24 Jan 2022 19:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053884;
        bh=RTtE72TEKRptEnT9avhBLidZKHxVwDtJvr7QQ0QGyVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+TUmL3nh3/phT4BMuw7tcwY4ABe9QcDEegr32klRSRrRkC+JWzyKLVp3Cs2n30Bs
         2VC/wRG5eWsU6DEZ/KTT5JtT9t2hYc0wI+AjUN6k3vxn8KwaQTKtEZswTqmXOmv/KO
         2xd6N4HmAbXG1Je4994OevbprSPzpzyK++xi6B2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, etkaar <lists.netfilter.org@prvy.eu>,
        Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/563] netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone
Date:   Mon, 24 Jan 2022 19:39:32 +0100
Message-Id: <20220124184031.583468907@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 23c54263efd7cb605e2f7af72717a2a951999217 ]

This is needed in case a new transaction is made that doesn't insert any
new elements into an already existing set.

Else, after second 'nft -f ruleset.txt', lookups in such a set will fail
because ->lookup() encounters raw_cpu_ptr(m->scratch) == NULL.

For the initial rule load, insertion of elements takes care of the
allocation, but for rule reloads this isn't guaranteed: we might not
have additions to the set.

Fixes: 3c4287f62044a90e ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: etkaar <lists.netfilter.org@prvy.eu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 2d73f265b12c9..f67c4436c5d31 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1290,6 +1290,11 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	if (!new->scratch_aligned)
 		goto out_scratch;
 #endif
+	for_each_possible_cpu(i)
+		*per_cpu_ptr(new->scratch, i) = NULL;
+
+	if (pipapo_realloc_scratch(new, old->bsize_max))
+		goto out_scratch_realloc;
 
 	rcu_head_init(&new->rcu);
 
@@ -1334,6 +1339,9 @@ out_lt:
 		kvfree(dst->lt);
 		dst--;
 	}
+out_scratch_realloc:
+	for_each_possible_cpu(i)
+		kfree(*per_cpu_ptr(new->scratch, i));
 #ifdef NFT_PIPAPO_ALIGN
 	free_percpu(new->scratch_aligned);
 #endif
-- 
2.34.1



