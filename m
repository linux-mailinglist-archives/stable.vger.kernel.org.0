Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EF270A2E
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 21:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbfGVTzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 15:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbfGVTzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 15:55:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACC7C2229C;
        Mon, 22 Jul 2019 19:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563825332;
        bh=3fdTQuhu48SYi/ohNJ3eO9+ZaBd/wuTZNlDvwgwndeg=;
        h=Date:From:To:Subject:From;
        b=BVDUFPU+tbos1qt52kYb4gOsbH9g7ZpXXWxOBCJCNtJA9wimDB7M+DBLk1zuy354j
         ZXbDT34vDnioAEK4tC1hJTK6Png+elxNADgnkSWY6XXXidPYmOWx+vBGJe0UI8ZrBa
         gU+W0UIJMv84lzyTx4hycl/QFkDxlZqOZ5NdsVTw=
Date:   Mon, 22 Jul 2019 12:55:31 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bhelgaas@google.com, bp@suse.de,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, namit@vmware.com,
        peterz@infradead.org, stable@vger.kernel.org, toshi.kani@hpe.com
Subject:  [merged]
 resource-fix-locking-in-find_next_iomem_res.patch removed from -mm tree
Message-ID: <20190722195531.Co-3WdP7L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: resource: fix locking in find_next_iomem_res()
has been removed from the -mm tree.  Its filename was
     resource-fix-locking-in-find_next_iomem_res.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: resource: fix locking in find_next_iomem_res()

Since resources can be removed, locking should ensure that the resource is
not removed while accessing it.  However, find_next_iomem_res() does not
hold the lock while copying the data of the resource.

Keep holding the lock while the data is copied.  While at it, change the
return value to a more informative value.  It is disregarded by the
callers.

[akpm@linux-foundation.org: fix find_next_iomem_res() documentation]
Link: http://lkml.kernel.org/r/20190613045903.4922-2-namit@vmware.com
Fixes: ff3cc952d3f00 ("resource: Add remove_resource interface")
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/kernel/resource.c~resource-fix-locking-in-find_next_iomem_res
+++ a/kernel/resource.c
@@ -326,7 +326,7 @@ EXPORT_SYMBOL(release_resource);
  *
  * If a resource is found, returns 0 and @*res is overwritten with the part
  * of the resource that's within [@start..@end]; if none is found, returns
- * -1 or -EINVAL for other invalid parameters.
+ * -ENODEV.  Returns -EINVAL for invalid parameters.
  *
  * This function walks the whole tree and not just first level children
  * unless @first_lvl is true.
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


