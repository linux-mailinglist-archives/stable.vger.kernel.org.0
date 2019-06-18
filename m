Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D34987E
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 06:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfFRE6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 00:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfFRE6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 00:58:13 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4872085A;
        Tue, 18 Jun 2019 04:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560833892;
        bh=Oyexl6jzsfG0YYmLyoy0+A4Kq2uB5kj4o61/a22Xxrs=;
        h=Date:From:To:Subject:From;
        b=D6a+Ff8+YT70yd9XSPZoNFwAz9V6dat4lALABr5owG4a5rvWEuoKgfavBVv3Q1Ec5
         PL1Rjgs3ygRW5fzkZTG+d8l8rzLD+8s2/a5OON46TfLI02bkULZ/B3L4ZLjJExEkQU
         +u8KVQz+5nlxzS1nH8XD41xcG8bGdodUY82+U2Qo=
Date:   Mon, 17 Jun 2019 21:58:11 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bhelgaas@google.com, bp@suse.de,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, namit@vmware.com,
        peterz@infradead.org, stable@vger.kernel.org, toshi.kani@hpe.com
Subject:  + resource-fix-locking-in-find_next_iomem_res.patch added
 to -mm tree
Message-ID: <20190618045811.GVMYvRpT0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: resource: fix locking in find_next_iomem_res()
has been added to the -mm tree.  Its filename is
     resource-fix-locking-in-find_next_iomem_res.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/resource-fix-locking-in-find_next_iomem_res.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/resource-fix-locking-in-find_next_iomem_res.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: resource: fix locking in find_next_iomem_res()

Since resources can be removed, locking should ensure that the resource is
not removed while accessing it.  However, find_next_iomem_res() does not
hold the lock while copying the data of the resource.

Keep holding the lock while the data is copied.  While at it, change the
return value to a more informative value.  It is disregarded by the
callers.

Link: http://lkml.kernel.org/r/20190613045903.4922-2-namit@vmware.com
Fixes: ff3cc952d3f00 ("resource: Add remove_resource interface")
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/resource.c~resource-fix-locking-in-find_next_iomem_res
+++ a/kernel/resource.c
@@ -365,16 +365,16 @@ static int find_next_iomem_res(resource_
 			break;
 	}
 
-	read_unlock(&resource_lock);
-	if (!p)
-		return -1;
+	if (p) {
+		/* copy data */
+		res->start = max(start, p->start);
+		res->end = min(end, p->end);
+		res->flags = p->flags;
+		res->desc = p->desc;
+	}
 
-	/* copy data */
-	res->start = max(start, p->start);
-	res->end = min(end, p->end);
-	res->flags = p->flags;
-	res->desc = p->desc;
-	return 0;
+	read_unlock(&resource_lock);
+	return p ? 0 : -ENODEV;
 }
 
 static int __walk_iomem_res_desc(resource_size_t start, resource_size_t end,
_

Patches currently in -mm which might be from namit@vmware.com are

resource-fix-locking-in-find_next_iomem_res.patch
resource-avoid-unnecessary-lookups-in-find_next_iomem_res.patch
resource-introduce-resource-cache.patch

