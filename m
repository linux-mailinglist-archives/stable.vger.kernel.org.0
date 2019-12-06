Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0FB114D06
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLFH6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 02:58:07 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34892 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfLFH6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 02:58:07 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so6727851wro.2;
        Thu, 05 Dec 2019 23:58:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZaY9V6y1V5MsDjFDz10SfPw/VXwiIICF1N4b4ZGmkwQ=;
        b=p1Zu8BXfPLTU2q2y4ObjJNRt4AZUm9nTUdXhH4wwLz/OU0+T9zME3nP17nHPSw21Fa
         xcYbf9pr43yUZTQeNI0p/O2PYiXrmvWf+qiuc9SLLxEkGKZOxoQ4qYIwdGjzdqBBNvUx
         ySD6+WuOg4u1NnyIy4h7Cj8+d9lgxpHDclts58MzwqnO5YK8IS7BxwGQn8UYd3uvrg+U
         Y/CyOZjjiK5i7WgBj7MjGYaSJHy9iqq1VGfz6Hb9OyJdwycopy0Pi8xWrDQqqNQivjj+
         BOjdk4GWAIypy2KlEWmN7PTxzIyCSlkCJpI9wx3UmeVJxR1OOdAs24Idv/0NA/PqARqu
         KZXw==
X-Gm-Message-State: APjAAAUrjoMzFeyNTquijwAeiEYZFGUWYKpmxeOKzv/1R9Re6cJA19pF
        nMwkfh1DgTt91PwKSqWwm2Y=
X-Google-Smtp-Source: APXvYqyWCkNQjW16kFjaRbAj+qrdynxSV3xnUz5xyhlTj/rhN4BFkPM7WqIoHmDZWl058MZeT2ELow==
X-Received: by 2002:a5d:4481:: with SMTP id j1mr14792795wrq.348.1575619084381;
        Thu, 05 Dec 2019 23:58:04 -0800 (PST)
Received: from localhost (ip-37-188-170-11.eurotel.cz. [37.188.170.11])
        by smtp.gmail.com with ESMTPSA id a127sm2693839wmh.43.2019.12.05.23.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 23:58:03 -0800 (PST)
Date:   Fri, 6 Dec 2019 08:58:02 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, cl@linux.com,
        vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v4 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
Message-ID: <20191206075802.GJ28317@dhcp22.suse.cz>
References: <1575584353-125392-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575584353-125392-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 06-12-19 06:19:13, Yang Shi wrote:
> Felix Abecassis reports move_pages() would return random status if the
> pages are already on the target node by the below test program:
> 
> ---8<---
> 
> int main(void)
> {
> 	const long node_id = 1;
> 	const long page_size = sysconf(_SC_PAGESIZE);
> 	const int64_t num_pages = 8;
> 
> 	unsigned long nodemask =  1 << node_id;
> 	long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	void **pages = malloc(sizeof(void*) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
> 				MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
> 				-1, 0);
> 		if (pages[i] == MAP_FAILED)
> 			return (EXIT_FAILURE);
> 	}
> 
> 	ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	int *nodes = malloc(sizeof(int) * num_pages);
> 	int *status = malloc(sizeof(int) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		nodes[i] = node_id;
> 		status[i] = 0xd0; /* simulate garbage values */
> 	}
> 
> 	ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
> 	printf("move_pages: %ld\n", ret);
> 	for (int i = 0; i < num_pages; ++i)
> 		printf("status[%d] = %d\n", i, status[i]);
> }
> ---8<---
> 
> Then running the program would return nonsense status values:
> $ ./move_pages_bug
> move_pages: 0
> status[0] = 208
> status[1] = 208
> status[2] = 208
> status[3] = 208
> status[4] = 208
> status[5] = 208
> status[6] = 208
> status[7] = 208
> 
> This is because the status is not set if the page is already on the
> target node, but move_pages() should return valid status as long as it
> succeeds.  The valid status may be errno or node id.
> 
> We can't simply initialize status array to zero since the pages may be
> not on node 0.  Fix it by updating status with node id which the page is
> already on.
> 
> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Reported-by: Felix Abecassis <fabecassis@nvidia.com>
> Tested-by: Felix Abecassis <fabecassis@nvidia.com>
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: <stable@vger.kernel.org> 4.17+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
> v4: * Fixed the comments from Christopher and John and added their Acked-by
>       and Reviewed-by.
> v3: * Adopted the suggestion from Michal.
> v2: * Correted the return value when add_page_for_migration() returns 1.
> 
>  mm/migrate.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a8f87cb..6b44818f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1512,9 +1512,11 @@ static int do_move_pages_to_node(struct mm_struct *mm,
>  /*
>   * Resolves the given address to a struct page, isolates it from the LRU and
>   * puts it to the given pagelist.
> - * Returns -errno if the page cannot be found/isolated or 0 when it has been
> - * queued or the page doesn't need to be migrated because it is already on
> - * the target node
> + * Returns:
> + *     errno - if the page cannot be found/isolated
> + *     0 - when it doesn't have to be migrated because it is already on the
> + *         target node
> + *     1 - when it has been queued
>   */
>  static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  		int node, struct list_head *pagelist, bool migrate_all)
> @@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  	if (PageHuge(page)) {
>  		if (PageHead(page)) {
>  			isolate_huge_page(page, pagelist);
> -			err = 0;
> +			err = 1;
>  		}
>  	} else {
>  		struct page *head;
> @@ -1563,7 +1565,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  		if (err)
>  			goto out_putpage;
>  
> -		err = 0;
> +		err = 1;
>  		list_add_tail(&head->lru, pagelist);
>  		mod_node_page_state(page_pgdat(head),
>  			NR_ISOLATED_ANON + page_is_file_cache(head),
> @@ -1640,8 +1642,17 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  		 */
>  		err = add_page_for_migration(mm, addr, current_node,
>  				&pagelist, flags & MPOL_MF_MOVE_ALL);
> -		if (!err)
> +
> +		if (!err) {
> +			/* The page is already on the target node */
> +			err = store_status(status, i, current_node, 1);
> +			if (err)
> +				goto out_flush;
>  			continue;
> +		} else if (err > 0) {
> +			/* The page is successfully queued for migration */
> +			continue;
> +		}
>  
>  		err = store_status(status, i, err, 1);
>  		if (err)
> -- 
> 1.8.3.1
> 

-- 
Michal Hocko
SUSE Labs
