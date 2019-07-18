Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8AC6D6FF
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 00:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391651AbfGRW5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 18:57:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391318AbfGRW5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 18:57:32 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52BBE20873;
        Thu, 18 Jul 2019 22:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563490651;
        bh=8h7mtRjZ0ObIDmy2Jd3Ri0NgWXmUhdbeXrGIpUUG23k=;
        h=Date:From:To:Subject:From;
        b=scogVnTTecj10msQvue869xoBKtUoJv2vH0YUg9nUFyfX4hHgPAwLW2uuRn9X0lLE
         QaQigs+sFz5IDleS3Apl4Q4INAMHSgLD2pFvat9wmlYQ1SQ97PVCzPNztaI8lGUu2d
         ifrDdt4nlSEuiudw04eygg5NMN09+HL/qHns2gjY=
Date:   Thu, 18 Jul 2019 15:57:31 -0700
From:   akpm@linux-foundation.org
To:     toshi.kani@hpe.com, stable@vger.kernel.org, peterz@infradead.org,
        mingo@kernel.org, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, bp@suse.de, bhelgaas@google.com,
        namit@vmware.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 15/38] resource: fix locking in
 find_next_iomem_res()
Message-ID: <20190718225731.F69TL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
