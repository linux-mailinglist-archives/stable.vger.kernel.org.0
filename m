Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54347E4FEC
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 17:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440582AbfJYPRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 11:17:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51654 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439061AbfJYPRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 11:17:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wnD87SJx6lKsZsUrTYB01i6mFsKAYC9XIXrBi0X2yaQ=; b=UpxPiSJ9dKwzMBowzOeApoA9a
        3A//h++j8jOOZxPe8AAmMhWc3HvHpTPVot8a6Q3cdOayAkc9Rt52E/P2HNwUaohJ7rP+8EGEZgEUG
        W3s6bD3aS5tEKHOFD3FDXq8CuGjcot3jRq8o0unCNt0eme31janUb3+s8TbdebHbSlUuqOqvDNFJQ
        BCMNWAKuIayY/bqVVovy8hP23yTNVKic852aDK8XlHoauEc3EFJ+yUUuEwBD7BqjKI9VwiLpp3Yo8
        7of3k8nb3ByyMbk4hg7Nyc4nrzQWR1J1iLj+eJycz9QRBmg/9AdW39eb/DNK5vFQs6QmLIt+17SGV
        DyYVudAIQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO1LO-00048W-8B; Fri, 25 Oct 2019 15:17:38 +0000
Date:   Fri, 25 Oct 2019 08:17:38 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org, vbabka@suse.cz,
        mhocko@suse.com, linux-mm@kvack.org
Subject: Re: [RPF STABLE PATCH] mm/memfd: should be lock the radix_tree when
 iterating its slot
Message-ID: <20191025151738.GP2963@bombadil.infradead.org>
References: <1571929400-12147-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571929400-12147-1-git-send-email-zhongjiang@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 11:03:20PM +0800, zhong jiang wrote:
> +	xa_lock_irq(&mapping->i_pages);
...
>  		if (need_resched()) {
>  			slot = radix_tree_iter_resume(slot, &iter);
> -			cond_resched_rcu();
> +			cond_resched_lock(&mapping->i_pages.xa_lock);

Ooh, this isn't right.  We're taking the lock, disabling interrupts,
then dropping the lock and rescheduling without reenabling interrupts.
If this ever triggers then we'll get a scheduling-while-atomic error.

Fortunately (?) need_resched() can almost never be set while we're holding
a spinlock with interrupts disabled (thanks to peterz for telling me that
when I asked for a cond_resched_lock_irq() a few years ago).  So we need
to take this patch further towards the current code.

Here's a version for 4.14.y.  Compile tested only.

diff --git a/mm/shmem.c b/mm/shmem.c
index 6c10f1d92251..deaea74ec1b3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2657,11 +2657,12 @@ static void shmem_tag_pins(struct address_space *mapping)
 	void **slot;
 	pgoff_t start;
 	struct page *page;
+	unsigned int tagged = 0;
 
 	lru_add_drain();
 	start = 0;
-	rcu_read_lock();
 
+	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		page = radix_tree_deref_slot(slot);
 		if (!page || radix_tree_exception(page)) {
@@ -2670,18 +2671,19 @@ static void shmem_tag_pins(struct address_space *mapping)
 				continue;
 			}
 		} else if (page_count(page) - page_mapcount(page) > 1) {
-			spin_lock_irq(&mapping->tree_lock);
 			radix_tree_tag_set(&mapping->page_tree, iter.index,
 					   SHMEM_TAG_PINNED);
-			spin_unlock_irq(&mapping->tree_lock);
 		}
 
-		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
-			cond_resched_rcu();
-		}
+		if (++tagged % 1024)
+			continue;
+
+		slot = radix_tree_iter_resume(slot, &iter);
+		spin_unlock_irq(&mapping->tree_lock);
+		cond_resched();
+		spin_lock_irq(&mapping->tree_lock);
 	}
-	rcu_read_unlock();
+	spin_unlock_irq(&mapping->tree_lock);
 }
 
 /*


