Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651F54F3559
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241837AbiDEIfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiDEIT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20337BB917;
        Tue,  5 Apr 2022 01:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D43A6B81B92;
        Tue,  5 Apr 2022 08:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445B6C385A1;
        Tue,  5 Apr 2022 08:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146291;
        bh=EKYlKmPt0IA/3YLvn2Y3q/HEN685jP6kWQm/KNHNy1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s85NPSiogpwGsrktv9KUZl1xfWYW2keAea4fduMBbRgZfdS+PSnM0Na31boH2e1IF
         49GROKc5SnT6dikZjdifzIYAleksX+lh5ytAXAUF+54dmSO4L9cGHLt6NGlhJ1Owhz
         /l5baNGhOqMY93rqw+WWzkDpOTXhAIgCWrcVxYJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0710/1126] kernel/resource: fix kfree() of bootmem memory again
Date:   Tue,  5 Apr 2022 09:24:17 +0200
Message-Id: <20220405070428.440638540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 0cbcc92917c5de80f15c24d033566539ad696892 ]

Since commit ebff7d8f270d ("mem hotunplug: fix kfree() of bootmem
memory"), we could get a resource allocated during boot via
alloc_resource().  And it's required to release the resource using
free_resource().  Howerver, many people use kfree directly which will
result in kernel BUG.  In order to fix this without fixing every call
site, just leak a couple of bytes in such corner case.

Link: https://lkml.kernel.org/r/20220217083619.19305-1-linmiaohe@huawei.com
Fixes: ebff7d8f270d ("mem hotunplug: fix kfree() of bootmem memory")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 9c08d6e9eef2..34eaee179689 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -56,14 +56,6 @@ struct resource_constraint {
 
 static DEFINE_RWLOCK(resource_lock);
 
-/*
- * For memory hotplug, there is no way to free resource entries allocated
- * by boot mem after the system is up. So for reusing the resource entry
- * we need to remember the resource.
- */
-static struct resource *bootmem_resource_free;
-static DEFINE_SPINLOCK(bootmem_resource_lock);
-
 static struct resource *next_resource(struct resource *p)
 {
 	if (p->child)
@@ -160,36 +152,19 @@ __initcall(ioresources_init);
 
 static void free_resource(struct resource *res)
 {
-	if (!res)
-		return;
-
-	if (!PageSlab(virt_to_head_page(res))) {
-		spin_lock(&bootmem_resource_lock);
-		res->sibling = bootmem_resource_free;
-		bootmem_resource_free = res;
-		spin_unlock(&bootmem_resource_lock);
-	} else {
+	/**
+	 * If the resource was allocated using memblock early during boot
+	 * we'll leak it here: we can only return full pages back to the
+	 * buddy and trying to be smart and reusing them eventually in
+	 * alloc_resource() overcomplicates resource handling.
+	 */
+	if (res && PageSlab(virt_to_head_page(res)))
 		kfree(res);
-	}
 }
 
 static struct resource *alloc_resource(gfp_t flags)
 {
-	struct resource *res = NULL;
-
-	spin_lock(&bootmem_resource_lock);
-	if (bootmem_resource_free) {
-		res = bootmem_resource_free;
-		bootmem_resource_free = res->sibling;
-	}
-	spin_unlock(&bootmem_resource_lock);
-
-	if (res)
-		memset(res, 0, sizeof(struct resource));
-	else
-		res = kzalloc(sizeof(struct resource), flags);
-
-	return res;
+	return kzalloc(sizeof(struct resource), flags);
 }
 
 /* Return the conflict entry if you can't request it */
-- 
2.34.1



