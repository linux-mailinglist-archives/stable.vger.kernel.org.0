Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9706A6F48
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbfICQbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbfICQbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:31:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A440238CE;
        Tue,  3 Sep 2019 16:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528302;
        bh=rkqcKpaAl5k6JghFCig/QH6Jn5EnL2Ec9Nqq3twxghg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3PTu+yW8jvolbjaLbhehZ0NndWWQCLxXzEFaQpFkiuf9mXRf+CxOLYTkRmqDcZVs
         EwtDWOy8JreTgZjIUZAKDGq4SmuYphA6YPRj+IRM+MooR40eCYQ4tb+YtGJbv69MFf
         ++jXv5EXXoMp1qFj+KCqM9jagtikzWdPwWHF2YpU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>, Toshi Kani <toshi.kani@hpe.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 144/167] resource: fix locking in find_next_iomem_res()
Date:   Tue,  3 Sep 2019 12:24:56 -0400
Message-Id: <20190903162519.7136-144-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

[ Upstream commit 49f17c26c123b60fd1c74629eef077740d16ffc2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 38b8d11c9eaf4..bce773cc5e416 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -325,7 +325,7 @@ EXPORT_SYMBOL(release_resource);
  *
  * If a resource is found, returns 0 and *res is overwritten with the part
  * of the resource that's within [start..end]; if none is found, returns
- * -1.
+ * -ENODEV.  Returns -EINVAL for invalid parameters.
  *
  * This function walks the whole tree and not just first level children
  * unless @first_level_children_only is true.
@@ -359,16 +359,16 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			break;
 	}
 
+	if (p) {
+		/* copy data */
+		res->start = max(start, p->start);
+		res->end = min(end, p->end);
+		res->flags = p->flags;
+		res->desc = p->desc;
+	}
+
 	read_unlock(&resource_lock);
-	if (!p)
-		return -1;
-
-	/* copy data */
-	res->start = max(start, p->start);
-	res->end = min(end, p->end);
-	res->flags = p->flags;
-	res->desc = p->desc;
-	return 0;
+	return p ? 0 : -ENODEV;
 }
 
 static int __walk_iomem_res_desc(resource_size_t start, resource_size_t end,
-- 
2.20.1

