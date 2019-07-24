Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6611E73E60
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390202AbfGXTld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389610AbfGXTl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:41:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC35520665;
        Wed, 24 Jul 2019 19:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997287;
        bh=B7m4baX6UanuRsGECnWTZXi5zT2+G5/6xl7S3Vw6AJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqRmqCapzS4HsAp3G6cwdu5bDQLbQe/AkJTVrV/XZs/tj5TBlfWQUFT6XrDStlZ3Z
         uGUNOy8b3R0zRXVtiGX2u65Mhp8ApP+Mu4Ok2Yqi6NbHHqoSfgAcn2G0pNh4jTbjFU
         PIbNDwIKQM3JxOVfmF1BIVUyXflY3kQznmGgQi0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>, Toshi Kani <toshi.kani@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 382/413] resource: fix locking in find_next_iomem_res()
Date:   Wed, 24 Jul 2019 21:21:13 +0200
Message-Id: <20190724191802.405370162@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit 49f17c26c123b60fd1c74629eef077740d16ffc2 upstream.

Since resources can be removed, locking should ensure that the resource
is not removed while accessing it.  However, find_next_iomem_res() does
not hold the lock while copying the data of the resource.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/resource.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/kernel/resource.c
+++ b/kernel/resource.c
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


