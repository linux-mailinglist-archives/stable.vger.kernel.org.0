Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3481667F3F3
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 03:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjA1CVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 21:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjA1CVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 21:21:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572F76D5F0;
        Fri, 27 Jan 2023 18:21:46 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P3dSr1SBKzJs8H;
        Sat, 28 Jan 2023 10:20:12 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sat, 28 Jan 2023 10:21:43 +0800
Subject: Re: Patch "bpf: Always use raw spinlock for hash bucket lock" has
 been added to the 5.15-stable tree
To:     Sasha Levin <sashal@kernel.org>, <stable-commits@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
References: <20230124113323.598714-1-sashal@kernel.org>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <fa6c2876-a3f8-f37e-f3c3-97f0cd4e39d5@huawei.com>
Date:   Sat, 28 Jan 2023 10:21:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20230124113323.598714-1-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/24/2023 7:33 PM, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
>
>     bpf: Always use raw spinlock for hash bucket lock
>
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      bpf-always-use-raw-spinlock-for-hash-bucket-lock.patch
> and it can be found in the queue-5.15 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
Please drop it for v5.15. The fix depends on bpf memory allocator [0] which was
merged in v6.1.

[0]: 7c8199e24fa0 bpf: Introduce any context BPF specific memory allocator.
>
>
>
> commit 9515b63fddd8c96797b0513c8d6509a9cc767611
> Author: Hou Tao <houtao1@huawei.com>
> Date:   Wed Sep 21 15:38:26 2022 +0800
>
>     bpf: Always use raw spinlock for hash bucket lock
>     
>     [ Upstream commit 1d8b82c613297f24354b4d750413a7456b5cd92c ]
>     
>     For a non-preallocated hash map on RT kernel, regular spinlock instead
>     of raw spinlock is used for bucket lock. The reason is that on RT kernel
>     memory allocation is forbidden under atomic context and regular spinlock
>     is sleepable under RT.
>     
>     Now hash map has been fully converted to use bpf_map_alloc, and there
>     will be no synchronous memory allocation for non-preallocated hash map,
>     so it is safe to always use raw spinlock for bucket lock on RT. So
>     removing the usage of htab_use_raw_lock() and updating the comments
>     accordingly.
>     
>     Signed-off-by: Hou Tao <houtao1@huawei.com>
>     Link: https://lore.kernel.org/r/20220921073826.2365800-1-houtao@huaweicloud.com
>     Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>     Stable-dep-of: 9f907439dc80 ("bpf: hash map, avoid deadlock with suitable hash mask")
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index e7f45a966e6b..ea2051a913fb 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -66,24 +66,16 @@
>   * In theory the BPF locks could be converted to regular spinlocks as well,
>   * but the bucket locks and percpu_freelist locks can be taken from
>   * arbitrary contexts (perf, kprobes, tracepoints) which are required to be
> - * atomic contexts even on RT. These mechanisms require preallocated maps,
> - * so there is no need to invoke memory allocations within the lock held
> - * sections.
> - *
> - * BPF maps which need dynamic allocation are only used from (forced)
> - * thread context on RT and can therefore use regular spinlocks which in
> - * turn allows to invoke memory allocations from the lock held section.
> - *
> - * On a non RT kernel this distinction is neither possible nor required.
> - * spinlock maps to raw_spinlock and the extra code is optimized out by the
> - * compiler.
> + * atomic contexts even on RT. Before the introduction of bpf_mem_alloc,
> + * it is only safe to use raw spinlock for preallocated hash map on a RT kernel,
> + * because there is no memory allocation within the lock held sections. However
> + * after hash map was fully converted to use bpf_mem_alloc, there will be
> + * non-synchronous memory allocation for non-preallocated hash map, so it is
> + * safe to always use raw spinlock for bucket lock.
>   */
>  struct bucket {
>  	struct hlist_nulls_head head;
> -	union {
> -		raw_spinlock_t raw_lock;
> -		spinlock_t     lock;
> -	};
> +	raw_spinlock_t raw_lock;
>  };
>  
>  #define HASHTAB_MAP_LOCK_COUNT 8
> @@ -132,26 +124,15 @@ static inline bool htab_is_prealloc(const struct bpf_htab *htab)
>  	return !(htab->map.map_flags & BPF_F_NO_PREALLOC);
>  }
>  
> -static inline bool htab_use_raw_lock(const struct bpf_htab *htab)
> -{
> -	return (!IS_ENABLED(CONFIG_PREEMPT_RT) || htab_is_prealloc(htab));
> -}
> -
>  static void htab_init_buckets(struct bpf_htab *htab)
>  {
>  	unsigned i;
>  
>  	for (i = 0; i < htab->n_buckets; i++) {
>  		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> -		if (htab_use_raw_lock(htab)) {
> -			raw_spin_lock_init(&htab->buckets[i].raw_lock);
> -			lockdep_set_class(&htab->buckets[i].raw_lock,
> +		raw_spin_lock_init(&htab->buckets[i].raw_lock);
> +		lockdep_set_class(&htab->buckets[i].raw_lock,
>  					  &htab->lockdep_key);
> -		} else {
> -			spin_lock_init(&htab->buckets[i].lock);
> -			lockdep_set_class(&htab->buckets[i].lock,
> -					  &htab->lockdep_key);
> -		}
>  		cond_resched();
>  	}
>  }
> @@ -161,28 +142,17 @@ static inline int htab_lock_bucket(const struct bpf_htab *htab,
>  				   unsigned long *pflags)
>  {
>  	unsigned long flags;
> -	bool use_raw_lock;
>  
>  	hash = hash & HASHTAB_MAP_LOCK_MASK;
>  
> -	use_raw_lock = htab_use_raw_lock(htab);
> -	if (use_raw_lock)
> -		preempt_disable();
> -	else
> -		migrate_disable();
> +	preempt_disable();
>  	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
>  		__this_cpu_dec(*(htab->map_locked[hash]));
> -		if (use_raw_lock)
> -			preempt_enable();
> -		else
> -			migrate_enable();
> +		preempt_enable();
>  		return -EBUSY;
>  	}
>  
> -	if (use_raw_lock)
> -		raw_spin_lock_irqsave(&b->raw_lock, flags);
> -	else
> -		spin_lock_irqsave(&b->lock, flags);
> +	raw_spin_lock_irqsave(&b->raw_lock, flags);
>  	*pflags = flags;
>  
>  	return 0;
> @@ -192,18 +162,10 @@ static inline void htab_unlock_bucket(const struct bpf_htab *htab,
>  				      struct bucket *b, u32 hash,
>  				      unsigned long flags)
>  {
> -	bool use_raw_lock = htab_use_raw_lock(htab);
> -
>  	hash = hash & HASHTAB_MAP_LOCK_MASK;
> -	if (use_raw_lock)
> -		raw_spin_unlock_irqrestore(&b->raw_lock, flags);
> -	else
> -		spin_unlock_irqrestore(&b->lock, flags);
> +	raw_spin_unlock_irqrestore(&b->raw_lock, flags);
>  	__this_cpu_dec(*(htab->map_locked[hash]));
> -	if (use_raw_lock)
> -		preempt_enable();
> -	else
> -		migrate_enable();
> +	preempt_enable();
>  }
>  
>  static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node);
> .

