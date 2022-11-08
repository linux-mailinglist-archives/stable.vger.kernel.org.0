Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390C3620B6B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 09:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiKHIov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 03:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiKHIou (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 03:44:50 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A783418361;
        Tue,  8 Nov 2022 00:44:47 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N61lk2PRVzpWKG;
        Tue,  8 Nov 2022 16:41:06 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 16:44:45 +0800
Message-ID: <65863340-b32f-a2fe-67ae-f1079b19eee4@huawei.com>
Date:   Tue, 8 Nov 2022 16:44:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
To:     Qi Zheng <zhengqi.arch@bytedance.com>, <dvyukov@google.com>,
        <jgg@nvidia.com>, <willy@infradead.org>, <akinobu.mita@gmail.com>
CC:     <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <Y2kxrerISWIxQsFO@nvidia.com>
 <20221108035232.87180-1-zhengqi.arch@bytedance.com>
From:   Wei Yongjun <weiyongjun1@huawei.com>
In-Reply-To: <20221108035232.87180-1-zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Zheng Qi,

On 2022/11/8 11:52, Qi Zheng wrote:
> When we specify __GFP_NOWARN, we only expect that no warnings
> will be issued for current caller. But in the __should_failslab()
> and __should_fail_alloc_page(), the local GFP flags alter the
> global {failslab|fail_page_alloc}.attr, which is persistent and
> shared by all tasks. This is not what we expected, let's fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  v1: https://lore.kernel.org/lkml/20221107033109.59709-1-zhengqi.arch@bytedance.com/
> 
>  Changelog in v1 -> v2:
>   - add comment for __should_failslab() and __should_fail_alloc_page()
>     (suggested by Jason)
> 
>  include/linux/fault-inject.h |  7 +++++--
>  lib/fault-inject.c           | 14 +++++++++-----
>  mm/failslab.c                | 12 ++++++++++--
>  mm/page_alloc.c              |  7 +++++--
>  4 files changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
> index 9f6e25467844..444236dadcf0 100644
> --- a/include/linux/fault-inject.h
> +++ b/include/linux/fault-inject.h
> @@ -20,7 +20,6 @@ struct fault_attr {
>  	atomic_t space;
>  	unsigned long verbose;
>  	bool task_filter;
> -	bool no_warn;
>  	unsigned long stacktrace_depth;
>  	unsigned long require_start;
>  	unsigned long require_end;
> @@ -32,6 +31,10 @@ struct fault_attr {
>  	struct dentry *dname;
>  };
>  
> +enum fault_flags {
> +	FAULT_NOWARN =	1 << 0,
> +};
> +
>  #define FAULT_ATTR_INITIALIZER {					\
>  		.interval = 1,						\
>  		.times = ATOMIC_INIT(1),				\
> @@ -40,11 +43,11 @@ struct fault_attr {
>  		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
>  		.verbose = 2,						\
>  		.dname = NULL,						\
> -		.no_warn = false,					\

How about keep no_warn attr as it be, and export it to user?

When testing with fault injection, and each fault will print an backtrace.
but not all of the testsuit can tell us which one is fault injection
message or other is a real warning/crash like syzkaller do.

In my case, to make things simple, we usually used a regex to detect whether
wanring/error happend. So we disabled the slab/page fault warning message by
default, and only enable it when debug real issue.

Regards,


>  	}
>  
>  #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
>  int setup_fault_attr(struct fault_attr *attr, char *str);
> +bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags);
>  bool should_fail(struct fault_attr *attr, ssize_t size);
>  
>  #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
> diff --git a/lib/fault-inject.c b/lib/fault-inject.c
> index 4b8fafce415c..5971f7c3e49e 100644
> --- a/lib/fault-inject.c
> +++ b/lib/fault-inject.c
> @@ -41,9 +41,6 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
>  
>  static void fail_dump(struct fault_attr *attr)
>  {
> -	if (attr->no_warn)
> -		return;
> -
>  	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
>  		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
>  		       "name %pd, interval %lu, probability %lu, "
> @@ -103,7 +100,7 @@ static inline bool fail_stacktrace(struct fault_attr *attr)
>   * http://www.nongnu.org/failmalloc/
>   */
>  
> -bool should_fail(struct fault_attr *attr, ssize_t size)
> +bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
>  {
>  	bool stack_checked = false;
>  
> @@ -152,13 +149,20 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
>  		return false;
>  
>  fail:
> -	fail_dump(attr);
> +	if (!(flags & FAULT_NOWARN))
> +		fail_dump(attr);
>  
>  	if (atomic_read(&attr->times) != -1)
>  		atomic_dec_not_zero(&attr->times);
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(should_fail_ex);
> +
> +bool should_fail(struct fault_attr *attr, ssize_t size)
> +{
> +	return should_fail_ex(attr, size, 0);
> +}
>  EXPORT_SYMBOL_GPL(should_fail);
>  
>  #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
> diff --git a/mm/failslab.c b/mm/failslab.c
> index 58df9789f1d2..ffc420c0e767 100644
> --- a/mm/failslab.c
> +++ b/mm/failslab.c
> @@ -16,6 +16,8 @@ static struct {
>  
>  bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
>  {
> +	int flags = 0;
> +
>  	/* No fault-injection for bootstrap cache */
>  	if (unlikely(s == kmem_cache))
>  		return false;
> @@ -30,10 +32,16 @@ bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
>  	if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
>  		return false;
>  
> +	/*
> +	 * In some cases, it expects to specify __GFP_NOWARN
> +	 * to avoid printing any information(not just a warning),
> +	 * thus avoiding deadlocks. See commit 6b9dbedbe349 for
> +	 * details.
> +	 */
>  	if (gfpflags & __GFP_NOWARN)
> -		failslab.attr.no_warn = true;
> +		flags |= FAULT_NOWARN;
>  
> -	return should_fail(&failslab.attr, s->object_size);
> +	return should_fail_ex(&failslab.attr, s->object_size, flags);
>  }
>  
>  static int __init setup_failslab(char *str)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7192ded44ad0..cb6fe715d983 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3902,6 +3902,8 @@ __setup("fail_page_alloc=", setup_fail_page_alloc);
>  
>  static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
>  {
> +	int flags = 0;
> +
>  	if (order < fail_page_alloc.min_order)
>  		return false;
>  	if (gfp_mask & __GFP_NOFAIL)
> @@ -3912,10 +3914,11 @@ static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
>  			(gfp_mask & __GFP_DIRECT_RECLAIM))
>  		return false;
>  
> +	/* See comment in __should_failslab() */
>  	if (gfp_mask & __GFP_NOWARN)
> -		fail_page_alloc.attr.no_warn = true;
> +		flags |= FAULT_NOWARN;
>  
> -	return should_fail(&fail_page_alloc.attr, 1 << order);
> +	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
>  }
>  
>  #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
