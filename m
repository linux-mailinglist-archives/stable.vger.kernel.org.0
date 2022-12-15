Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287B264D76C
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 08:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiLOHvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 02:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOHvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 02:51:22 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D64420995;
        Wed, 14 Dec 2022 23:51:21 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6AFA120CA9;
        Thu, 15 Dec 2022 07:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671090679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ApTPtm4BpVUmJDkiZyC1YdPf5EgpdLIlVfUqGS4nvKM=;
        b=a41MyVNd5CeVoWrJcB4xuBEUNfYo4yDh603pgccImOnX5OCtr1gya9icfuLNk75R7Tk1id
        gSDLYnn/xsqXVWQ/tro/OCo9PqlVcQRku5Sc/vAZfPj2iATPKyx+oom9eFMvCeJ+2W3Tsm
        /ufa51Ym/t8u3pVUN7hd/OkttdwJEH0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4203A138E5;
        Thu, 15 Dec 2022 07:51:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0LftDffRmmMJewAAMHmgww
        (envelope-from <mhocko@suse.com>); Thu, 15 Dec 2022 07:51:19 +0000
Date:   Thu, 15 Dec 2022 08:51:18 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Huang Ying <ying.huang@intel.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC PATCH] mm/mempolicy: Fix memory leak in
 set_mempolicy_home_node system call
Message-ID: <Y5rR9n5HSvlATV5A@dhcp22.suse.cz>
References: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 14-12-22 17:21:10, Mathieu Desnoyers wrote:
> When encountering any vma in the range with policy other than MPOL_BIND
> or MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put
> on the policy just allocated with mpol_dup().
> 
> This allows arbitrary users to leak kernel memory.
> 
> Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: <linux-api@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org # 5.17+

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks for catching this!

Btw. looking at the code again it seems rather pointless to duplicate
the policy just to throw it away anyway. A slightly bigger diff but this
looks more reasonable to me. What do you think? I can also send it as a
clean up on top of your fix.
---
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 61aa9aedb728..918cdc8a7f0c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1489,7 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct mempolicy *new;
+	struct mempolicy *new. *old;
 	unsigned long vmstart;
 	unsigned long vmend;
 	unsigned long end;
@@ -1521,30 +1521,28 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		return 0;
 	mmap_write_lock(mm);
 	for_each_vma_range(vmi, vma, end) {
-		vmstart = max(start, vma->vm_start);
-		vmend   = min(end, vma->vm_end);
-		new = mpol_dup(vma_policy(vma));
-		if (IS_ERR(new)) {
-			err = PTR_ERR(new);
-			break;
-		}
-		/*
-		 * Only update home node if there is an existing vma policy
-		 */
-		if (!new)
-			continue;
-
 		/*
 		 * If any vma in the range got policy other than MPOL_BIND
 		 * or MPOL_PREFERRED_MANY we return error. We don't reset
 		 * the home node for vmas we already updated before.
 		 */
-		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
+		old = vma_policy(vma);
+		if (!old)
+			continue;
+		if (old->mode != MPOL_BIND && old->mode != MPOL_PREFERRED_MANY) {
 			err = -EOPNOTSUPP;
 			break;
 		}
 
+		new = mpol_dup(vma_policy(vma));
+		if (IS_ERR(new)) {
+			err = PTR_ERR(new);
+			break;
+		}
+
 		new->home_node = home_node;
+		vmstart = max(start, vma->vm_start);
+		vmend   = min(end, vma->vm_end);
 		err = mbind_range(mm, vmstart, vmend, new);
 		mpol_put(new);
 		if (err)
-- 
Michal Hocko
SUSE Labs
