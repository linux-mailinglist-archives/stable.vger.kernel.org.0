Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22654717CD
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbfGWMJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:09:57 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:58465 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730000AbfGWMJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:09:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4371120A;
        Tue, 23 Jul 2019 08:09:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xGXKfp
        sgixZJF2OKBDISjtJwM/tgKCPcZgEXDzxYJuA=; b=LImRIMBDq2e1AtQnJhLB5R
        7nVXicx/Fuug7QHFtwj4CCkAom5YbSvWBCxK5R/packEPUtIafWAh2jtX53Qiiav
        kujdblIs9CnRETQrTfUg+dMmxlOQ/uzDfVhcE2q993IJ9Dzb/sKwSgyKWlh65qCP
        PuiLZmObkDreCYSeccLOBEosNfbjKDKZxPZAlmDh4+bw25vSQomoBjr2ptx1RNny
        lJojc1sHzW4+xGNwlVuBpZuztUotNiiU5ieL8lbOeqoxe/yc1lI1071LoBSL5XDY
        m6887Jjmzn1CeADNnE8KXVmm1OtoIgyd2Vn1HMIdsN4cPXAyG42vmT9vgdxCQXKQ
        ==
X-ME-Sender: <xms:FPk2Xe6NZ2y9xF9jiTQtvmdUJTQkVEStmw5lLZNARBtHsSQU2bENRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:FPk2XfGxv6NTqHaO1LVfEhFvOwbYdua5yTFWhS6UX4BG5p4NU3a_Fw>
    <xmx:FPk2Xcqp9dzTadnjRxro7N9kXraKh-pOUgGGHI1ric00GEfeXaaQZA>
    <xmx:FPk2XcnnKGcSx5Z1pWYFAopxpON4E4-dgzS6ajpT2fBJq67nPnOViw>
    <xmx:FPk2XdQBkVI0NdP71PSQDm0QJmx0nru9pd7ir4-zhVc90vYZilUm9g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8ACF380074;
        Tue, 23 Jul 2019 08:09:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] resource: fix locking in find_next_iomem_res()" failed to apply to 4.9-stable tree
To:     namit@vmware.com, akpm@linux-foundation.org, bhelgaas@google.com,
        bp@suse.de, dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        mingo@kernel.org, peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, toshi.kani@hpe.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:09:46 +0200
Message-ID: <156388378610475@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 49f17c26c123b60fd1c74629eef077740d16ffc2 Mon Sep 17 00:00:00 2001
From: Nadav Amit <namit@vmware.com>
Date: Thu, 18 Jul 2019 15:57:31 -0700
Subject: [PATCH] resource: fix locking in find_next_iomem_res()

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

diff --git a/kernel/resource.c b/kernel/resource.c
index d22423e85cf8..3ced0cd45bdd 100644
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
@@ -365,16 +365,16 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
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

