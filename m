Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06095CA68
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfGBIDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfGBIDt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6222184B;
        Tue,  2 Jul 2019 08:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054628;
        bh=S1kh1bXZ5dfYqxiow65Xl1WwtAYi5ustmwpUQVQ3SRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ts6Ipx4KkXR/AePnt3JFxtYq+FX97C4XqB4NU7Qr633tnmVu+3iacCkvfSJot+5x7
         /7/61wjpsUu0E0/UxCKq4g5+i2aaNEiwsiej1sOrkJhRwppVxNG6GY4bVcLKplXftK
         /AIRyEkOGojdJVmo4z+CCDb1f1MGBWgjvhbpwF7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhong jiang <zhongjiang@huawei.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 05/55] mm/mempolicy.c: fix an incorrect rebind node in mpol_rebind_nodemask
Date:   Tue,  2 Jul 2019 10:01:13 +0200
Message-Id: <20190702080124.339370580@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

commit 29b190fa774dd1b72a1a6f19687d55dc72ea83be upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -306,7 +306,7 @@ static void mpol_rebind_nodemask(struct
 	else {
 		nodes_remap(tmp, pol->v.nodes,pol->w.cpuset_mems_allowed,
 								*nodes);
-		pol->w.cpuset_mems_allowed = tmp;
+		pol->w.cpuset_mems_allowed = *nodes;
 	}
 
 	if (nodes_empty(tmp))


