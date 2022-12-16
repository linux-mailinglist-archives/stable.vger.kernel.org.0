Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AC164F1EE
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 20:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiLPTpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 14:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiLPTps (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 14:45:48 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4302DFA;
        Fri, 16 Dec 2022 11:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1671219944;
        bh=m6euT/AHHIicwNDOAp3nHcZWM1Blrtk8U8hPYxizTig=;
        h=From:To:Cc:Subject:Date:From;
        b=PIk5P77FwZkcBK/nqbbLY5gPhFLweG3xvdRtJ+7pucyP8Tc/+b6Zl9dsvj8VYKvel
         st/7dYXU3zi6oJgrAVmdq/cSMhRdx59rRpbdtyghSzJ8QUJRppTGvoKDo4E6INIRom
         i3G7vN5gD9MrhgZuWFHR9TgQSLMO6Q/6L/6+9NAFCUT00sQxLEGVqLnrp5MzgyakYb
         6bFuOyfWvv+cqM9Ft4aEBmfxLMow78XFricxKUvRrDbv1Ch4xC6PubN2uBQwLeukWb
         /sS5cQ6fAupXA74fIZGS/Lg2UwsO5QF3XuhTT9E7a+bRskff/B/CUv8Aq6dzoq289b
         3EVjmEbeywJww==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NYfj36pGkzbGk;
        Fri, 16 Dec 2022 14:45:43 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     linux-mm@kvack.org
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] mm/mempolicy: Fix memory leak in set_mempolicy_home_node system call
Date:   Fri, 16 Dec 2022 14:45:36 -0500
Message-Id: <20221216194537.238047-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When encountering any vma in the range with policy other than MPOL_BIND
or MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put
on the policy just allocated with mpol_dup().

This allows arbitrary users to leak kernel memory.

[ Mathieu: compile-tested only. Tested-by would be welcome. ]

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
Cc: linux-api@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org # 5.17+
---
 mm/mempolicy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 61aa9aedb728..02c8a712282f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1540,6 +1540,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		 * the home node for vmas we already updated before.
 		 */
 		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
+			mpol_put(new);
 			err = -EOPNOTSUPP;
 			break;
 		}
-- 
2.25.1

