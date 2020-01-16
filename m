Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5228613D6ED
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 10:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgAPJfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 04:35:18 -0500
Received: from relay.sw.ru ([185.231.240.75]:33056 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgAPJfS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 04:35:18 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1is1YL-00005M-OE; Thu, 16 Jan 2020 12:35:01 +0300
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
To:     Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        yang.shi@linux.alibaba.com
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        rientjes@google.com, stable@vger.kernel.org
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
Date:   Thu, 16 Jan 2020 12:35:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200116013100.7679-1-richardw.yang@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.01.2020 04:31, Wei Yang wrote:
> As all the other places, we grab the lock before manipulate the defer list.
> Current implementation may face a race condition.
> 
> For example, the potential race would be:
> 
>     CPU1                      CPU2
>     mem_cgroup_move_account   deferred_split_huge_page
>       list_empty
>                                 lock
>                                 list_empty
>                                 list_add_tail
>                                 unlock
>       lock
>       # list_empty might not hold anymore
>       list_add_tail
>       unlock
> 
> When this sequence happens, the list_add_tail() in
> mem_cgroup_move_account() corrupt the list since which is already been
> added to some split_queue in split_huge_page_to_list().
> 
> Besides this, David Rientjes points out the split_queue_len would be in
> a wrong state, which would be a significant issue for shrinkers.
> 
> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> 
> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> Cc: <stable@vger.kernel.org>    [5.4+]
> 
> ---
> v3:
>   * remove all review/ack tag since rewrite the changelog
>   * use deferred_split_huge_page as the example of race
>   * add cc stable 5.4+ tag as suggested by David Rientjes
> 
> v2:
>   * move check on compound outside suggested by Alexander
>   * an example of the race condition, suggested by Michal
> ---
>  mm/memcontrol.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c5b5f74cfd4d..6450bbe394e2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
>  	}
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && !list_empty(page_deferred_list(page))) {
> +	if (compound) {
>  		spin_lock(&from->deferred_split_queue.split_queue_lock);
> -		list_del_init(page_deferred_list(page));
> -		from->deferred_split_queue.split_queue_len--;
> +		if (!list_empty(page_deferred_list(page))) {
> +			list_del_init(page_deferred_list(page));
> +			from->deferred_split_queue.split_queue_len--;
> +		}
>  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>  	}
>  #endif
> @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
>  	page->mem_cgroup = to;
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && list_empty(page_deferred_list(page))) {
> +	if (compound) {
>  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> -		list_add_tail(page_deferred_list(page),
> -			      &to->deferred_split_queue.split_queue);
> -		to->deferred_split_queue.split_queue_len++;
> +		if (list_empty(page_deferred_list(page))) {
> +			list_add_tail(page_deferred_list(page),
> +				      &to->deferred_split_queue.split_queue);
> +			to->deferred_split_queue.split_queue_len++;
> +		}
>  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
>  	}
>  #endif

The patch looks OK for me. But there is another question. I forget, why we unconditionally
add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
it was initially in the list? Something like:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4394ae4e5be..0be0136adaa6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
 	struct pglist_data *pgdat;
 	unsigned long flags;
 	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
+	bool split = false;
 	int ret;
 	bool anon;
 
@@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
 		if (!list_empty(page_deferred_list(page))) {
 			list_del_init(page_deferred_list(page));
 			from->deferred_split_queue.split_queue_len--;
+			split = true;
 		}
 		spin_unlock(&from->deferred_split_queue.split_queue_lock);
 	}
@@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
 	page->mem_cgroup = to;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound) {
+	if (compound && split) {
 		spin_lock(&to->deferred_split_queue.split_queue_lock);
 		if (list_empty(page_deferred_list(page))) {
 			list_add_tail(page_deferred_list(page),
