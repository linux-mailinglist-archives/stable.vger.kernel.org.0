Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762452A686
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfEYSaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 14:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfEYSaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 14:30:21 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC65B20863;
        Sat, 25 May 2019 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558809020;
        bh=/n40pMWGY3UvsrclxC/2hUuQcMp5e9l55v6czczyYyc=;
        h=Date:From:To:Subject:From;
        b=tQY2lvTl4vBgtvpzT6T1CD90PC8jr0nqtL0pHplk23HvXxqrDCDGpVRuUOdXo8Ug1
         buET0viSUm+ajWQfjfe8ikvSUL0exJVOr7w61+ukrdXA32P+/sjzdzgzTVqc6Yv3nS
         LbwPCjYoCO18plCgBr+vI40102gcEeEiStDmwI50=
Date:   Sat, 25 May 2019 11:30:19 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, khandual@linux.vnet.ibm.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        rcampbell@nvidia.com, stable@vger.kernel.org, vbabka@suse.cz,
        zhongjiang@huawei.com
Subject:  +
 mm-mempolicy-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask.patch
 added to -mm tree
Message-ID: <20190525183019.OmfezoMns%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask
has been added to the -mm tree.  Its filename is
     mm-mempolicy-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask

We bind an different node to different vma, Unluckily, it will bind a
different vma to the same node by checking /proc/pid/numa_maps.

213980c0f23b ("mm, mempolicy: simplify rebinding mempolicies when updating
cpusets") introduced the issue.  When we change memory policy by setting
cpuset.mems, a process will rebind the specified policy more than one
time.  If cpuset_mems_allowed is not equal to the user specified nodes the
issue will trigger.  This may result in an OOM when allocating memory from
the same node.

Link: http://lkml.kernel.org/r/1558768043-23184-1-git-send-email-zhongjiang@huawei.com
Fixes: 213980c0f23b ("mm, mempolicy: simplify rebinding mempolicies when updating cpusets")
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask
+++ a/mm/mempolicy.c
@@ -306,7 +306,7 @@ static void mpol_rebind_nodemask(struct
 	else {
 		nodes_remap(tmp, pol->v.nodes,pol->w.cpuset_mems_allowed,
 								*nodes);
-		pol->w.cpuset_mems_allowed = tmp;
+		pol->w.cpuset_mems_allowed = *nodes;
 	}
 
 	if (nodes_empty(tmp))
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-mempolicy-fix-an-incorrect-rebind-node-in-mpol_rebind_nodemask.patch

