Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB59F3BDDD0
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhGFTKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 15:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B7161C6D;
        Tue,  6 Jul 2021 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598485;
        bh=PThm40DjLBnSudVd8PzIw7okdraYPRbyLdhlgwwXXV4=;
        h=Date:From:To:Subject:From;
        b=o4TFh2hz4Yd268ny4cSOTCIFQLfk7pTSfe7Z1yyRc3MH280rPFfg+cBNZZEZ6boy/
         xtZHCBD+cDMZGIu55qmnod8tBzJSAsH73He3vjsV5yfNqkTG/9DrK7xHNYJQ+wiIH/
         2k2crFi98isQ0QHxatQ3Zm/o4NMCc8SHPQnl+aPg=
Date:   Tue, 06 Jul 2021 12:08:05 -0700
From:   akpm@linux-foundation.org
To:     brouer@redhat.com, dan.carpenter@oracle.com,
        davej@codemonkey.org.uk, geert+renesas@glider.be,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Falloc-correct-return-value-of-populated-elements-?=
 =?US-ASCII?Q?if-bulk-array-is-populated.patch?= removed from -mm tree
Message-ID: <20210706190805.sDeWWHBcA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: correct return value of populated elements if bulk array is populated
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: correct return value of populated elements if bulk array is populated

Dave Jones reported the following

	This made it into 5.13 final, and completely breaks NFSD for me
	(Serving tcp v3 mounts).  Existing mounts on clients hang, as do
	new mounts from new clients.  Rebooting the server back to rc7
	everything recovers.

The commit b3b64ebd3822 ("mm/page_alloc: do bulk array bounds check after
checking populated elements") returns the wrong value if the array is
already populated which is interpreted as an allocation failure.  Dave
reported this fixes his problem and it also passed a test running dbench
over NFS.

Link: https://lkml.kernel.org/r/20210628150219.GC3840@techsingularity.net
Fixes: b3b64ebd3822 ("mm/page_alloc: do bulk array bounds check after checking populated elements")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Tested-by: Dave Jones <davej@codemonkey.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org> [5.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-return-value-of-populated-elements-if-bulk-array-is-populated
+++ a/mm/page_alloc.c
@@ -5058,7 +5058,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 
 	/* Already populated array? */
 	if (unlikely(page_array && nr_pages - nr_populated == 0))
-		return 0;
+		return nr_populated;
 
 	/* Use the single page allocator for one page. */
 	if (nr_pages - nr_populated == 1)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


