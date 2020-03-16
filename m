Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E97381867A0
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 10:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgCPJQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 05:16:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:54722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbgCPJQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 05:16:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA0D6AC69;
        Mon, 16 Mar 2020 09:16:36 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 83CDC1E10DA; Mon, 16 Mar 2020 10:16:33 +0100 (CET)
Date:   Mon, 16 Mar 2020 10:16:33 +0100
From:   Jan Kara <jack@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] xarray: Fix premature termination of
 xas_for_each_marked()
Message-ID: <20200316091633.GA12783@quack2.suse.cz>
References: <20200204142514.15826-1-jack@suse.cz>
 <20200204142514.15826-2-jack@suse.cz>
 <20200312214548.GL22433@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312214548.GL22433@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 12-03-20 14:45:48, Matthew Wilcox wrote:
> Hi Jan,
> 
> I fixed this in a different way ... also, I added a test to the test-suite
> so this shouldn't regress.  Thanks for writing the commit message ;-)
> 
> From 7e934cf5ace1dceeb804f7493fa28bb697ed3c52 Mon Sep 17 00:00:00 2001
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Thu, 12 Mar 2020 17:29:11 -0400
> Subject: [PATCH] xarray: Fix early termination of xas_for_each_marked
> 
> xas_for_each_marked() is using entry == NULL as a termination condition
> of the iteration. When xas_for_each_marked() is used protected only by
> RCU, this can however race with xas_store(xas, NULL) in the following
> way:
> 
> TASK1                                   TASK2
> page_cache_delete()         	        find_get_pages_range_tag()
>                                           xas_for_each_marked()
>                                             xas_find_marked()
>                                               off = xas_find_chunk()
> 
>   xas_store(&xas, NULL)
>     xas_init_marks(&xas);
>     ...
>     rcu_assign_pointer(*slot, NULL);
>                                               entry = xa_entry(off);
> 
> And thus xas_for_each_marked() terminates prematurely possibly leading
> to missed entries in the iteration (translating to missing writeback of
> some pages or a similar problem).
> 
> If we find a NULL entry that has been marked, skip it (unless we're trying
> to allocate an entry).
> 
> Reported-by: Jan Kara <jack@suse.cz>
> CC: stable@vger.kernel.org
> Fixes: ef8e5717db01 ("page cache: Convert delete_batch to XArray")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

The patch looks good to me. Thanks for looking into this. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  include/linux/xarray.h                       |  6 +-
>  lib/xarray.c                                 |  2 +
>  tools/testing/radix-tree/Makefile            |  4 +-
>  tools/testing/radix-tree/iteration_check_2.c | 87 ++++++++++++++++++++
>  tools/testing/radix-tree/main.c              |  1 +
>  tools/testing/radix-tree/test.h              |  1 +
>  6 files changed, 98 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/radix-tree/iteration_check_2.c
> 
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index a491653d8882..14c893433139 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -1648,6 +1648,7 @@ static inline void *xas_next_marked(struct xa_state *xas, unsigned long max,
>  								xa_mark_t mark)
>  {
>  	struct xa_node *node = xas->xa_node;
> +	void *entry;
>  	unsigned int offset;
>  
>  	if (unlikely(xas_not_node(node) || node->shift))
> @@ -1659,7 +1660,10 @@ static inline void *xas_next_marked(struct xa_state *xas, unsigned long max,
>  		return NULL;
>  	if (offset == XA_CHUNK_SIZE)
>  		return xas_find_marked(xas, max, mark);
> -	return xa_entry(xas->xa, node, offset);
> +	entry = xa_entry(xas->xa, node, offset);
> +	if (!entry)
> +		return xas_find_marked(xas, max, mark);
> +	return entry;
>  }
>  
>  /*
> diff --git a/lib/xarray.c b/lib/xarray.c
> index f448bcd263ac..e9e641d3c0c3 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -1208,6 +1208,8 @@ void *xas_find_marked(struct xa_state *xas, unsigned long max, xa_mark_t mark)
>  		}
>  
>  		entry = xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
> +		if (!entry && !(xa_track_free(xas->xa) && mark == XA_FREE_MARK))
> +			continue;
>  		if (!xa_is_node(entry))
>  			return entry;
>  		xas->xa_node = xa_to_node(entry);
> diff --git a/tools/testing/radix-tree/Makefile b/tools/testing/radix-tree/Makefile
> index 397d6b612502..aa6abfe0749c 100644
> --- a/tools/testing/radix-tree/Makefile
> +++ b/tools/testing/radix-tree/Makefile
> @@ -7,8 +7,8 @@ LDLIBS+= -lpthread -lurcu
>  TARGETS = main idr-test multiorder xarray
>  CORE_OFILES := xarray.o radix-tree.o idr.o linux.o test.o find_bit.o bitmap.o
>  OFILES = main.o $(CORE_OFILES) regression1.o regression2.o regression3.o \
> -	 regression4.o \
> -	 tag_check.o multiorder.o idr-test.o iteration_check.o benchmark.o
> +	 regression4.o tag_check.o multiorder.o idr-test.o iteration_check.o \
> +	 iteration_check_2.o benchmark.o
>  
>  ifndef SHIFT
>  	SHIFT=3
> diff --git a/tools/testing/radix-tree/iteration_check_2.c b/tools/testing/radix-tree/iteration_check_2.c
> new file mode 100644
> index 000000000000..aac5c50a3674
> --- /dev/null
> +++ b/tools/testing/radix-tree/iteration_check_2.c
> @@ -0,0 +1,87 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * iteration_check_2.c: Check that deleting a tagged entry doesn't cause
> + * an RCU walker to finish early.
> + * Copyright (c) 2020 Oracle
> + * Author: Matthew Wilcox <willy@infradead.org>
> + */
> +#include <pthread.h>
> +#include "test.h"
> +
> +static volatile bool test_complete;
> +
> +static void *iterator(void *arg)
> +{
> +	XA_STATE(xas, arg, 0);
> +	void *entry;
> +
> +	rcu_register_thread();
> +
> +	while (!test_complete) {
> +		xas_set(&xas, 0);
> +		rcu_read_lock();
> +		xas_for_each_marked(&xas, entry, ULONG_MAX, XA_MARK_0)
> +			;
> +		rcu_read_unlock();
> +		assert(xas.xa_index >= 100);
> +	}
> +
> +	rcu_unregister_thread();
> +	return NULL;
> +}
> +
> +static void *throbber(void *arg)
> +{
> +	struct xarray *xa = arg;
> +
> +	rcu_register_thread();
> +
> +	while (!test_complete) {
> +		int i;
> +
> +		for (i = 0; i < 100; i++) {
> +			xa_store(xa, i, xa_mk_value(i), GFP_KERNEL);
> +			xa_set_mark(xa, i, XA_MARK_0);
> +		}
> +		for (i = 0; i < 100; i++)
> +			xa_erase(xa, i);
> +	}
> +
> +	rcu_unregister_thread();
> +	return NULL;
> +}
> +
> +void iteration_test2(unsigned test_duration)
> +{
> +	pthread_t threads[2];
> +	DEFINE_XARRAY(array);
> +	int i;
> +
> +	printv(1, "Running iteration test 2 for %d seconds\n", test_duration);
> +
> +	test_complete = false;
> +
> +	xa_store(&array, 100, xa_mk_value(100), GFP_KERNEL);
> +	xa_set_mark(&array, 100, XA_MARK_0);
> +
> +	if (pthread_create(&threads[0], NULL, iterator, &array)) {
> +		perror("create iterator thread");
> +		exit(1);
> +	}
> +	if (pthread_create(&threads[1], NULL, throbber, &array)) {
> +		perror("create throbber thread");
> +		exit(1);
> +	}
> +
> +	sleep(test_duration);
> +	test_complete = true;
> +
> +	for (i = 0; i < 2; i++) {
> +		if (pthread_join(threads[i], NULL)) {
> +			perror("pthread_join");
> +			exit(1);
> +		}
> +	}
> +
> +	xa_destroy(&array);
> +}
> diff --git a/tools/testing/radix-tree/main.c b/tools/testing/radix-tree/main.c
> index 7a22d6e3732e..f2cbc8e5b97c 100644
> --- a/tools/testing/radix-tree/main.c
> +++ b/tools/testing/radix-tree/main.c
> @@ -311,6 +311,7 @@ int main(int argc, char **argv)
>  	regression4_test();
>  	iteration_test(0, 10 + 90 * long_run);
>  	iteration_test(7, 10 + 90 * long_run);
> +	iteration_test2(10 + 90 * long_run);
>  	single_thread_tests(long_run);
>  
>  	/* Free any remaining preallocated nodes */
> diff --git a/tools/testing/radix-tree/test.h b/tools/testing/radix-tree/test.h
> index 1ee4b2c0ad10..34dab4d18744 100644
> --- a/tools/testing/radix-tree/test.h
> +++ b/tools/testing/radix-tree/test.h
> @@ -34,6 +34,7 @@ void xarray_tests(void);
>  void tag_check(void);
>  void multiorder_checks(void);
>  void iteration_test(unsigned order, unsigned duration);
> +void iteration_test2(unsigned duration);
>  void benchmark(void);
>  void idr_checks(void);
>  void ida_tests(void);
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
