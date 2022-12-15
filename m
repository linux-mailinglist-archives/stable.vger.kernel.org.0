Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F1064DD1D
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 15:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLOOtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 09:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOOtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 09:49:03 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDA12F66B;
        Thu, 15 Dec 2022 06:49:02 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E573121DEE;
        Thu, 15 Dec 2022 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671115740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/05kX5zbvi3NUUBWHtzWjv0InClnlmKra/u1zbe89QA=;
        b=cwB0qmah1kasZ+JJ4slx+vkMaAn8Nlsf738RNidmI3V6V2s9ug8TrV8At/IC/+oDCrlE0H
        /l87zNolT0duVZ1Ixuh0aJiDlokSr7jAH9iyt6VgN+7JA1Jjjtac/D6rgr5QeHGvWiJBRu
        dAR8wRMYdWHTTsGo9yTcfWaNZW3GUlI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BE941138E5;
        Thu, 15 Dec 2022 14:49:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 92ZELNwzm2PcbAAAMHmgww
        (envelope-from <mhocko@suse.com>); Thu, 15 Dec 2022 14:49:00 +0000
Date:   Thu, 15 Dec 2022 15:49:00 +0100
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
Subject: [PATCH] mm/mempolicy: do not duplicate policy if it is not
 applicable for set_mempolicy_home_node
Message-ID: <Y5sz3Ax+tONdWgbN@dhcp22.suse.cz>
References: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
 <Y5rR9n5HSvlATV5A@dhcp22.suse.cz>
 <72a402db-b156-74ff-2241-a018cd8ee885@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72a402db-b156-74ff-2241-a018cd8ee885@efficios.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 15-12-22 09:33:54, Mathieu Desnoyers wrote:
> On 2022-12-15 02:51, Michal Hocko wrote:
[...]
> > Btw. looking at the code again it seems rather pointless to duplicate
> > the policy just to throw it away anyway. A slightly bigger diff but this
> > looks more reasonable to me. What do you think? I can also send it as a
> > clean up on top of your fix.
> 
> I think it would be best if this comes as a cleanup on top of my fix. The
> diff is larger than the minimal change needed to fix the leak in stable
> branches.
> 
> Your approach looks fine, except for the vma_policy(vma) -> old change
> already spotted by Aneesh.

This shouldn't have any real effect on the functionality. Anyway, here
is a follow up cleanup:
--- 
From f3fdb6f65fa3977aab13378b8e299b168719577c Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Thu, 15 Dec 2022 15:41:27 +0100
Subject: [PATCH] mm/mempolicy: do not duplicate policy if it is not applicable
 for set_mempolicy_home_node

set_mempolicy_home_node tries to duplicate a memory policy before
checking it whether it is applicable for the operation. There is
no real reason for doing that and it might actually be a pointless
memory allocation and deallocation exercise for MPOL_INTERLEAVE.

Not a big problem but we can do better. Simply check the policy before
acting on it.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/mempolicy.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 02c8a712282f..becf41e10076 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1489,7 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct mempolicy *new;
+	struct mempolicy *new, *old;
 	unsigned long vmstart;
 	unsigned long vmend;
 	unsigned long end;
@@ -1521,31 +1521,27 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
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
-			mpol_put(new);
+		old = vma_policy(vma);
+		if (!old)
+			continue;
+		if (old->mode != MPOL_BIND && old->mode != MPOL_PREFERRED_MANY) {
 			err = -EOPNOTSUPP;
 			break;
 		}
+		new = mpol_dup(old);
+		if (IS_ERR(new)) {
+			err = PTR_ERR(new);
+			break;
+		}
 
 		new->home_node = home_node;
+		vmstart = max(start, vma->vm_start);
+		vmend   = min(end, vma->vm_end);
 		err = mbind_range(mm, vmstart, vmend, new);
 		mpol_put(new);
 		if (err)
-- 
2.30.2

-- 
Michal Hocko
SUSE Labs
