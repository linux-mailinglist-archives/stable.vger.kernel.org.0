Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD764D24E
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 23:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLNWVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 17:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiLNWV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 17:21:28 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA8F116E;
        Wed, 14 Dec 2022 14:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1671056483;
        bh=OwPacgMfzq+t+Js+BScNggpyccUTyftXnAv/AFiH6zw=;
        h=From:To:Cc:Subject:Date:From;
        b=GqNGuGANib8ov9H9kk3JHTVguBne0Fq6w32B7YeuElmDddZfC27OijEBZF7qvDIE9
         AmvlSGspDuxrtk4kL/DETEYf/C7U7oYscCP0hWIZaIiIluj+uTGSnOQSqHWQ1KpZU0
         /OXQkcNEx4e7kTGF9Jtj6Hb4W4E51/Aw/v91jLhyCupDRCTlO2FT4qbPjHW3PAFUFG
         +1/O1ngi4uSX2uBoe4rS08zGUXzL2EQQZyoMidwsGjvstKyTvw8V4ujqxyfmhYPGX4
         pKE2v8TtOdqEylTqOZVNW8tiw1+PXWERuLKuG4payC+03Xn1JD3N0vPYJJWTZQCLdJ
         /iHSF+ynCAWSQ==
Received: from localhost.localdomain (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NXVFb1fSJzbZs;
        Wed, 14 Dec 2022 17:21:23 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Huang Ying <ying.huang@intel.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
Subject: [RFC PATCH] mm/mempolicy: Fix memory leak in set_mempolicy_home_node system call
Date:   Wed, 14 Dec 2022 17:21:10 -0500
Message-Id: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When encountering any vma in the range with policy other than MPOL_BIND
or MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put
on the policy just allocated with mpol_dup().

This allows arbitrary users to leak kernel memory.

Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
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
Cc: <linux-api@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

