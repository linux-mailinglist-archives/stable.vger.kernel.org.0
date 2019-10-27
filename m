Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAABE62B2
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfJ0Nlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:41:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57221 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfJ0Nlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 09:41:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8CC6D21AD2;
        Sun, 27 Oct 2019 09:41:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 09:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oLTYxs
        8f9a3m0pl6OW8lstc2KEyFK29AG+wsQFrodBc=; b=UXa8i86Y/kOxk+5nI6MElA
        YOCAyeYP7AWDDUVWbzh3XNK9Tda+jUKEPrObPXlUILGIg8HLhMtlmUMfSnOTqHrc
        gWu617XWp8OR2e3gki8VIa/NDklyGOS/17LcBnDwO3JwmiR0CkBDSwjaNURmV5+P
        207wd/aZB2VH8d42sAGgr6MZCCzRwet/44A7e8BTHRDUOchXfZaM0knVUz+0mv96
        TQy6adnQi/Ba7RM6U0LIT+r3qmwcysyEH+4TPjJdO5FIgYGS4k/7c8FSxaRyAR6U
        zpc0ogunxCxTmThI6d+tWLYrJazpKOGSVyQIiexZMAWQ4gq6sWrqQUNPNd7hWMAQ
        ==
X-ME-Sender: <xms:jZ61XZOCP-yZgnumLJASeSxbjcafjNP0WOJzJxhVrpv-RVvA3B381Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeejjedrvdeguddrvddvle
    drvdefvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:jZ61XYR0YC1D-8IuK3xWg71icu0ho88JRvDHj9sbtfOSu2kP-echJA>
    <xmx:jZ61XZ7WZZZg9crIzQTu4mtCnfKAOjmi9Ap0yC84ehsTWtBe2YY1NQ>
    <xmx:jZ61XS0UG6-QWK1iUij3CgFihVB3YhIDvLi1iKqRx5DDuTgXG1ERnQ>
    <xmx:jZ61XTlXU4PXU_-WPvGD63eOxkPj5X_urHYnSeD-VH2XiX6QD_AszA>
Received: from localhost (unknown [77.241.229.232])
        by mail.messagingengine.com (Postfix) with ESMTPA id 05502D60057;
        Sun, 27 Oct 2019 09:41:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/memory-failure.c: don't access uninitialized memmaps in" failed to apply to 4.14-stable tree
To:     david@redhat.com, akpm@linux-foundation.org, mhocko@kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 14:41:31 +0100
Message-ID: <1572183691251118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 96c804a6ae8c59a9092b3d5dd581198472063184 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Fri, 18 Oct 2019 20:19:23 -0700
Subject: [PATCH] mm/memory-failure.c: don't access uninitialized memmaps in
 memory_failure()

We should check for pfn_to_online_page() to not access uninitialized
memmaps.  Reshuffle the code so we don't have to duplicate the error
message.

Link: http://lkml.kernel.org/r/20191009142435.3975-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0ae72b6acee7..3151c87dff73 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1257,17 +1257,19 @@ int memory_failure(unsigned long pfn, int flags)
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
 
-	if (!pfn_valid(pfn)) {
+	p = pfn_to_online_page(pfn);
+	if (!p) {
+		if (pfn_valid(pfn)) {
+			pgmap = get_dev_pagemap(pfn, NULL);
+			if (pgmap)
+				return memory_failure_dev_pagemap(pfn, flags,
+								  pgmap);
+		}
 		pr_err("Memory failure: %#lx: memory outside kernel control\n",
 			pfn);
 		return -ENXIO;
 	}
 
-	pgmap = get_dev_pagemap(pfn, NULL);
-	if (pgmap)
-		return memory_failure_dev_pagemap(pfn, flags, pgmap);
-
-	p = pfn_to_page(pfn);
 	if (PageHuge(p))
 		return memory_failure_hugetlb(pfn, flags);
 	if (TestSetPageHWPoison(p)) {

