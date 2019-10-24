Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA9EE3A44
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 19:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503934AbfJXRlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 13:41:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38970 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbfJXRlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 13:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bbHi+CPS0oLvTOmcrwEQV5yp9EVMpVORfx0TlETSG/o=; b=bl84XKbqTO/8OGreKg9b6au8R
        n7qu+lPh9pMFl8qImUbT4oVFUQrjf7EaRStrfvfTEKxVVlPrPrNALUl4f6nauWpr9HS1RhTD7R78i
        DltWfolFaA6WXN03A+UiZ+5l7wUgLyRD6jdMXlLTcpfo++JH96RS0O5dZ5mEyWAYUZHenths+Ebuz
        22PFVuR1rQshTwK7vSbFj7dIXUuZmJa0t51SdfafzHDyFB3HXj0AWLiYDQDU0kgD2T46uJxx7Q0Eg
        Ud11y63oq799uGxai5k0bKfbYRYoPRH4AMazoTfbGwi812Jafz/Sdvtw7DBP+K3jYLNLVfxeXlppA
        rWNmTyHMg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNh6p-0003ge-4o; Thu, 24 Oct 2019 17:41:15 +0000
Date:   Thu, 24 Oct 2019 10:41:15 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org, vbabka@suse.cz,
        mhocko@suse.com, linux-mm@kvack.org
Subject: Re: [RPF STABLE PATCH] mm/memfd: should be lock the radix_tree when
 iterating its slot
Message-ID: <20191024174115.GI2963@bombadil.infradead.org>
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
> By reviewing the code, I find that there is an race between iterate
> the radix_tree and radix_tree_insert/delete. Because the former just
> access its slot in rcu protected period. but it fails to prevent the
> radix_tree from being changed.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

The locking here now matches the locking in memfd_tag_pins() that
was changed in ef3038a573aa8bf2f3797b110f7244b55a0e519c (part of 4.20-rc1).
I didn't notice that I was fixing a bug when I changed the locking.
This bug has been present since 05f65b5c70909ef686f865f0a85406d74d75f70f
(part of 3.17) so backports will need to go further back.  This code has
moved around a bit (mm/shmem.c) and the APIs have changed, so it will
take some effort.

> Cc: stable@vger.kernel.org
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  mm/memfd.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 2bb5e25..0b3fedc 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -37,8 +37,8 @@ static void memfd_tag_pins(struct address_space *mapping)
>  
>  	lru_add_drain();
>  	start = 0;
> -	rcu_read_lock();
>  
> +	xa_lock_irq(&mapping->i_pages);
>  	radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start) {
>  		page = radix_tree_deref_slot(slot);
>  		if (!page || radix_tree_exception(page)) {
> @@ -47,18 +47,16 @@ static void memfd_tag_pins(struct address_space *mapping)
>  				continue;
>  			}
>  		} else if (page_count(page) - page_mapcount(page) > 1) {
> -			xa_lock_irq(&mapping->i_pages);
>  			radix_tree_tag_set(&mapping->i_pages, iter.index,
>  					   MEMFD_TAG_PINNED);
> -			xa_unlock_irq(&mapping->i_pages);
>  		}
>  
>  		if (need_resched()) {
>  			slot = radix_tree_iter_resume(slot, &iter);
> -			cond_resched_rcu();
> +			cond_resched_lock(&mapping->i_pages.xa_lock);
>  		}
>  	}
> -	rcu_read_unlock();
> +	xa_unlock_irq(&mapping->i_pages);
>  }
>  
>  /*
> -- 
> 1.7.12.4
> 
> 
