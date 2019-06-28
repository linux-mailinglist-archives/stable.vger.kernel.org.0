Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841B75A4C4
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 21:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF1TGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 15:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1TGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 15:06:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 912AA208CB;
        Fri, 28 Jun 2019 19:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561748803;
        bh=fHZE1TZlPnMoQXolxjL+lg3a7yO9d5Vi1W9+7YFIkzM=;
        h=Date:From:To:Subject:From;
        b=h0Om8nTqeuUP7PjsKQ2CekQbPYCr0hvLZpXgab8553N0aLYGYlywPEOnBzUO1YKrp
         n+iJ+PxK1KPhG1AWzyK9edIaE8UvvxbknfDfsI5Wv6n4JtnEf4QhS6yPyPX4Qxwa4Y
         d4EEKOZl7ENRJVhJLGGNHkYyzpWcQJ63xSj2LomY=
Date:   Fri, 28 Jun 2019 12:06:43 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        khandual@linux.vnet.ibm.com, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rcampbell@nvidia.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        zhongjiang@huawei.com
Subject:  [patch 03/15] mm/mempolicy.c: fix an incorrect rebind
 node in mpol_rebind_nodemask
Message-ID: <20190628190643.WID2--HZl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask

mpol_rebind_nodemask() is called for MPOL_BIND and MPOL_INTERLEAVE
mempoclicies when the tasks's cpuset's mems_allowed changes.  For
policies created without MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES,
it works by remapping the policy's allowed nodes (stored in v.nodes)
using the previous value of mems_allowed (stored in
w.cpuset_mems_allowed) as the domain of map and the new mems_allowed
(passed as nodes) as the range of the map (see the comment of
bitmap_remap() for details).

The result of remapping is stored back as policy's nodemask in v.nodes,
and the new value of mems_allowed should be stored in
w.cpuset_mems_allowed to facilitate the next rebind, if it happens.

However, 213980c0f23b ("mm, mempolicy: simplify rebinding mempolicies
when updating cpusets") introduced a bug where the result of remapping
is stored in w.cpuset_mems_allowed instead.  Thus, a mempolicy's
allowed nodes can evolve in an unexpected way after a series of
rebinding due to cpuset mems_allowed changes, possibly binding to a
wrong node or a smaller number of nodes which may e.g.  overload them. 
This patch fixes the bug so rebinding again works as intended.

[vbabka@suse.cz: new changlog]
  Link: http://lkml.kernel.org/r/ef6a69c6-c052-b067-8f2c-9d615c619bb9@suse.cz
Link: http://lkml.kernel.org/r/1558768043-23184-1-git-send-email-zhongjiang@huawei.com
Fixes: 213980c0f23b ("mm, mempolicy: simplify rebinding mempolicies when updating cpusets")
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
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
