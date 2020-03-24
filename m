Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5DD190324
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 02:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgCXBEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 21:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgCXBEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Mar 2020 21:04:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E7C820714;
        Tue, 24 Mar 2020 01:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585011838;
        bh=uGGoqYkk12Dhiif/0LKZN7D/gATzYrywbbLaYZL5UvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xmc53TGy1lYg/FgacCVbCE3vN0AYtiGyt42sLMLiBj7UOGuNKqnRYAC005PcKO5pq
         KZomxlxQuJIATJPd1VGvz4BgtxOCT5gYH7+uuS7w4by1sCZwJ2GDXofQsTSpvk3L24
         ApPeF3M1eSjO7/1dOWh3UqUBSgZ96Rt+3MsMGTGA=
Date:   Mon, 23 Mar 2020 18:03:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: fork: fix kernel_stack memcg stats for various
 stack implementations
Message-Id: <20200323180358.7603217aa9955f298255da4e@linux-foundation.org>
In-Reply-To: <20200324004221.GA36662@carbon.dhcp.thefacebook.com>
References: <20200303233550.251375-1-guro@fb.com>
        <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
        <20200324004221.GA36662@carbon.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Mar 2020 17:42:21 -0700 Roman Gushchin <guro@fb.com> wrote:

> How about this one? I've merged them into one and stripped it a little bit.
> 
> Thanks!
> 

Yes, that looks good.  Here's the delta from the previously reviewed
version.  I think it's valid to retain those acks and revewed-by's.


From: Roman Gushchin <guro@fb.com>
Subject: mm: fork: fix kernel_stack memcg stats for various stack implementations

--- a/include/linux/memcontrol.h~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2
+++ a/include/linux/memcontrol.h
@@ -1432,6 +1432,8 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 #else
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
@@ -1473,6 +1475,11 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+       return NULL;
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol.c~mm-fork-fix-kernel_stack-memcg-stats-for-various-stack-implementations-v2
+++ a/mm/memcontrol.c
@@ -2672,6 +2672,33 @@ static void commit_charge(struct page *p
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * Returns a pointer to the memory cgroup to which the kernel object is charged.
+ *
+ * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
+ * cgroup_mutex, etc.
+ */
+struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+	struct page *page;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	page = virt_to_head_page(p);
+
+	/*
+	 * Slab pages don't have page->mem_cgroup set because corresponding
+	 * kmem caches can be reparented during the lifetime. That's why
+	 * memcg_from_slab_page() should be used instead.
+	 */
+	if (PageSlab(page))
+		return memcg_from_slab_page(page);
+
+	/* All other pages use page->mem_cgroup */
+	return page->mem_cgroup;
+}
+
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
_


