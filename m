Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2BB3B6C84
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 04:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhF2Cf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 22:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2Cf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 22:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2AC261D00;
        Tue, 29 Jun 2021 02:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934010;
        bh=p9sknuIGh8NWIXEu1WPEFEJe5WD0FVv0xHeIgbTPyS8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yoWTjBI+TEfuYMJNhdj6U3+sCDLKMQeNEAu8HocPtZxm2aLSXEdkGAac73mjOUt9g
         /FjDxMeIqfpfhLu4aLrUEZra2dQeJeGYhSlOmjxT9KoUJ7q1kOUnKDfI/3jV9ht9fe
         GUkdUV2xLWyN6IfKoR8G8sLTiuGik+vhRxj0pzKs=
Date:   Mon, 28 Jun 2021 19:33:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brouer@redhat.com,
        dan.carpenter@oracle.com, davej@codemonkey.org.uk,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 003/192] mm/page_alloc: correct return value of
 populated elements if bulk array is populated
Message-ID: <20210629023329.M3l2xeWtg%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
