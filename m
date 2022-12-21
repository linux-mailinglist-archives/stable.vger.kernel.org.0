Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076ED6538A8
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 23:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbiLUWcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 17:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiLUWca (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 17:32:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D06DAC;
        Wed, 21 Dec 2022 14:32:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0325761976;
        Wed, 21 Dec 2022 22:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52633C433F2;
        Wed, 21 Dec 2022 22:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671661948;
        bh=3+rfh8MFf+bj5ahrKd3nReKzsWjtAQ4k4/QwgG2HO40=;
        h=Date:To:From:Subject:From;
        b=sX2KnpAFKwqqzhgb7ahwVYQA0cCxZTf/GQJSB45i2J3n1Bd7DBUypKj20vWy7jDMy
         XBjyfCzwo9ACYTLwGqQ3FZksUd0sh865ZhmN8dNyUUDD+hTsnVk/hAzS+nLLM3pZ9A
         CtA589u9il8QRnWKHuYS32PPipVM2Uj/oGlm3Uvs=
Date:   Wed, 21 Dec 2022 14:32:27 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        stable@vger.kernel.org, rdunlap@infradead.org,
        mike.kravetz@oracle.com, mhocko@suse.com, mhocko@kernel.org,
        mgorman@techsingularity.net, feng.tang@intel.com,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        aneesh.kumar@linux.ibm.com, ak@linux.intel.com,
        aarcange@redhat.com, mathieu.desnoyers@efficios.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-fix-memory-leak-in-set_mempolicy_home_node-system-call.patch removed from -mm tree
Message-Id: <20221221223228.52633C433F2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: fix memory leak in set_mempolicy_home_node system call
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-memory-leak-in-set_mempolicy_home_node-system-call.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm/mempolicy: fix memory leak in set_mempolicy_home_node system call
Date: Thu, 15 Dec 2022 14:46:21 -0500

When encountering any vma in the range with policy other than MPOL_BIND or
MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put on
the policy just allocated with mpol_dup().

This allows arbitrary users to leak kernel memory.

Link: https://lkml.kernel.org/r/20221215194621.202816-1-mathieu.desnoyers@efficios.com
Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leak-in-set_mempolicy_home_node-system-call
+++ a/mm/mempolicy.c
@@ -1540,6 +1540,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		 * the home node for vmas we already updated before.
 		 */
 		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
+			mpol_put(new);
 			err = -EOPNOTSUPP;
 			break;
 		}
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are


