Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4743C6D5848
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 07:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjDDF4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 01:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjDDF4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 01:56:16 -0400
Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410BB1997
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 22:56:14 -0700 (PDT)
Message-ID: <2f2bcc75-e46b-6849-734c-2e646d9bb382@0.smtp.remotehost.it>
Date:   Tue, 4 Apr 2023 07:56:10 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 6.1 021/181] blk-mq: move the srcu_struct used for
 quiescing to the tagset
Content-Language: en-US, de-DE, lb-LU, fr-FR
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chao Leng <lengchao@huawei.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
References: <20230403140415.090615502@linuxfoundation.org>
 <20230403140415.825266522@linuxfoundation.org>
 <401a5df3-b13b-fb56-a305-9c82f5f0ca77@0.smtp.remotehost.it>
 <ZCt6vpfpJCk0J451@ovpn-8-16.pek2.redhat.com>
From:   Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <ZCt6vpfpJCk0J451@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[2023-04-04 03:17] Ming Lei:
> On Mon, Apr 03, 2023 at 11:06:53PM +0200, Pascal Ernster wrote:
>> [2023-04-03 16:07] Greg Kroah-Hartman:
>>> From: Christoph Hellwig <hch@lst.de>
>>>
>>> [ Upstream commit 80bd4a7aab4c9ce59bf5e35fdf52aa23d8a3c9f5 ]
>>>
>>> All I/O submissions have fairly similar latencies, and a tagset-wide
>>> quiesce is a fairly common operation.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Keith Busch <kbusch@kernel.org>
>>> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>>> Reviewed-by: Chao Leng <lengchao@huawei.com>
>>> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
>>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>>> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
>>> Link: https://lore.kernel.org/r/20221101150050.3510-12-hch@lst.de
>>> [axboe: fix whitespace]
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Stable-dep-of: 00e885efcfbb ("blk-mq: fix "bad unlock balance detected" on q->srcu in __blk_mq_run_dispatch_ops")
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>    block/blk-core.c       | 27 +++++----------------------
>>>    block/blk-mq.c         | 33 +++++++++++++++++++++++++--------
>>>    block/blk-mq.h         | 14 +++++++-------
>>>    block/blk-sysfs.c      |  9 ++-------
>>>    block/blk.h            |  9 +--------
>>>    block/genhd.c          |  2 +-
>>>    include/linux/blk-mq.h |  4 ++++
>>>    include/linux/blkdev.h |  9 ---------
>>>    8 files changed, 45 insertions(+), 62 deletions(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 24ee7785a5ad5..d5da62bb4bc06 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -65,7 +65,6 @@ DEFINE_IDA(blk_queue_ida);
>>>     * For queue allocation
>>>     */
>>>    struct kmem_cache *blk_requestq_cachep;
>>> -struct kmem_cache *blk_requestq_srcu_cachep;
>>>    /*
>>>     * Controlling structure to kblockd
>>> @@ -373,26 +372,20 @@ static void blk_timeout_work(struct work_struct *work)
>>>    {
>>>    }
>>> -struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
>>> +struct request_queue *blk_alloc_queue(int node_id)
>>>    {
>>>    	struct request_queue *q;
>>> -	q = kmem_cache_alloc_node(blk_get_queue_kmem_cache(alloc_srcu),
>>> -			GFP_KERNEL | __GFP_ZERO, node_id);
>>> +	q = kmem_cache_alloc_node(blk_requestq_cachep, GFP_KERNEL | __GFP_ZERO,
>>> +				  node_id);
>>>    	if (!q)
>>>    		return NULL;
>>> -	if (alloc_srcu) {
>>> -		blk_queue_flag_set(QUEUE_FLAG_HAS_SRCU, q);
>>> -		if (init_srcu_struct(q->srcu) != 0)
>>> -			goto fail_q;
>>> -	}
>>> -
>>>    	q->last_merge = NULL;
>>>    	q->id = ida_alloc(&blk_queue_ida, GFP_KERNEL);
>>>    	if (q->id < 0)
>>> -		goto fail_srcu;
>>> +		goto fail_q;
>>>    	q->stats = blk_alloc_queue_stats();
>>>    	if (!q->stats)
>>> @@ -434,11 +427,8 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
>>>    	blk_free_queue_stats(q->stats);
>>>    fail_id:
>>>    	ida_free(&blk_queue_ida, q->id);
>>> -fail_srcu:
>>> -	if (alloc_srcu)
>>> -		cleanup_srcu_struct(q->srcu);
>>>    fail_q:
>>> -	kmem_cache_free(blk_get_queue_kmem_cache(alloc_srcu), q);
>>> +	kmem_cache_free(blk_requestq_cachep, q);
>>>    	return NULL;
>>>    }
>>> @@ -1190,9 +1180,6 @@ int __init blk_dev_init(void)
>>>    			sizeof_field(struct request, cmd_flags));
>>>    	BUILD_BUG_ON(REQ_OP_BITS + REQ_FLAG_BITS > 8 *
>>>    			sizeof_field(struct bio, bi_opf));
>>> -	BUILD_BUG_ON(ALIGN(offsetof(struct request_queue, srcu),
>>> -			   __alignof__(struct request_queue)) !=
>>> -		     sizeof(struct request_queue));
>>>    	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
>>>    	kblockd_workqueue = alloc_workqueue("kblockd",
>>> @@ -1203,10 +1190,6 @@ int __init blk_dev_init(void)
>>>    	blk_requestq_cachep = kmem_cache_create("request_queue",
>>>    			sizeof(struct request_queue), 0, SLAB_PANIC, NULL);
>>> -	blk_requestq_srcu_cachep = kmem_cache_create("request_queue_srcu",
>>> -			sizeof(struct request_queue) +
>>> -			sizeof(struct srcu_struct), 0, SLAB_PANIC, NULL);
>>> -
>>>    	blk_debugfs_root = debugfs_create_dir("block", NULL);
>>>    	return 0;
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index aa67a52c5a069..f8c97d75b8d1a 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -261,8 +261,8 @@ EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue_nowait);
>>>     */
>>>    void blk_mq_wait_quiesce_done(struct request_queue *q)
>>>    {
>>> -	if (blk_queue_has_srcu(q))
>>> -		synchronize_srcu(q->srcu);
>>> +	if (q->tag_set->flags & BLK_MQ_F_BLOCKING)
>>> +		synchronize_srcu(q->tag_set->srcu);
>>>    	else
>>>    		synchronize_rcu();
>>>    }
>>> @@ -4022,7 +4022,7 @@ static struct request_queue *blk_mq_init_queue_data(struct blk_mq_tag_set *set,
>>>    	struct request_queue *q;
>>>    	int ret;
>>> -	q = blk_alloc_queue(set->numa_node, set->flags & BLK_MQ_F_BLOCKING);
>>> +	q = blk_alloc_queue(set->numa_node);
>>>    	if (!q)
>>>    		return ERR_PTR(-ENOMEM);
>>>    	q->queuedata = queuedata;
>>> @@ -4194,9 +4194,6 @@ static void blk_mq_update_poll_flag(struct request_queue *q)
>>>    int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
>>>    		struct request_queue *q)
>>>    {
>>> -	WARN_ON_ONCE(blk_queue_has_srcu(q) !=
>>> -			!!(set->flags & BLK_MQ_F_BLOCKING));
>>> -
>>>    	/* mark the queue as mq asap */
>>>    	q->mq_ops = set->ops;
>>> @@ -4453,8 +4450,18 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>>>    	if (set->nr_maps == 1 && set->nr_hw_queues > nr_cpu_ids)
>>>    		set->nr_hw_queues = nr_cpu_ids;
>>> -	if (blk_mq_alloc_tag_set_tags(set, set->nr_hw_queues) < 0)
>>> -		return -ENOMEM;
>>> +	if (set->flags & BLK_MQ_F_BLOCKING) {
>>> +		set->srcu = kmalloc(sizeof(*set->srcu), GFP_KERNEL);
>>> +		if (!set->srcu)
>>> +			return -ENOMEM;
>>> +		ret = init_srcu_struct(set->srcu);
>>> +		if (ret)
>>> +			goto out_free_srcu;
>>> +	}
>>> +
>>> +	ret = blk_mq_alloc_tag_set_tags(set, set->nr_hw_queues);
>>> +	if (ret)
>>> +		goto out_cleanup_srcu;
>>>    	ret = -ENOMEM;
>>>    	for (i = 0; i < set->nr_maps; i++) {
>>> @@ -4484,6 +4491,12 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>>>    	}
>>>    	kfree(set->tags);
>>>    	set->tags = NULL;
>>> +out_cleanup_srcu:
>>> +	if (set->flags & BLK_MQ_F_BLOCKING)
>>> +		cleanup_srcu_struct(set->srcu);
>>> +out_free_srcu:
>>> +	if (set->flags & BLK_MQ_F_BLOCKING)
>>> +		kfree(set->srcu);
>>>    	return ret;
>>>    }
>>>    EXPORT_SYMBOL(blk_mq_alloc_tag_set);
>>> @@ -4523,6 +4536,10 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
>>>    	kfree(set->tags);
>>>    	set->tags = NULL;
>>> +	if (set->flags & BLK_MQ_F_BLOCKING) {
>>> +		cleanup_srcu_struct(set->srcu);
>>> +		kfree(set->srcu);
>>> +	}
>>>    }
>>>    EXPORT_SYMBOL(blk_mq_free_tag_set);
>>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>>> index 0b2870839cdd6..ef59fee62780d 100644
>>> --- a/block/blk-mq.h
>>> +++ b/block/blk-mq.h
>>> @@ -377,17 +377,17 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>>>    /* run the code block in @dispatch_ops with rcu/srcu read lock held */
>>>    #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
>>>    do {								\
>>> -	if (!blk_queue_has_srcu(q)) {				\
>>> -		rcu_read_lock();				\
>>> -		(dispatch_ops);					\
>>> -		rcu_read_unlock();				\
>>> -	} else {						\
>>> +	if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {		\
>>>    		int srcu_idx;					\
>>>    								\
>>>    		might_sleep_if(check_sleep);			\
>>> -		srcu_idx = srcu_read_lock((q)->srcu);		\
>>> +		srcu_idx = srcu_read_lock((q)->tag_set->srcu);	\
>>>    		(dispatch_ops);					\
>>> -		srcu_read_unlock((q)->srcu, srcu_idx);		\
>>> +		srcu_read_unlock((q)->tag_set->srcu, srcu_idx);	\
>>> +	} else {						\
>>> +		rcu_read_lock();				\
>>> +		(dispatch_ops);					\
>>> +		rcu_read_unlock();				\
>>>    	}							\
>>>    } while (0)
>>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>>> index e71b3b43927c0..e7871665825a3 100644
>>> --- a/block/blk-sysfs.c
>>> +++ b/block/blk-sysfs.c
>>> @@ -739,10 +739,8 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
>>>    static void blk_free_queue_rcu(struct rcu_head *rcu_head)
>>>    {
>>> -	struct request_queue *q = container_of(rcu_head, struct request_queue,
>>> -					       rcu_head);
>>> -
>>> -	kmem_cache_free(blk_get_queue_kmem_cache(blk_queue_has_srcu(q)), q);
>>> +	kmem_cache_free(blk_requestq_cachep,
>>> +			container_of(rcu_head, struct request_queue, rcu_head));
>>>    }
>>>    /**
>>> @@ -779,9 +777,6 @@ static void blk_release_queue(struct kobject *kobj)
>>>    	if (queue_is_mq(q))
>>>    		blk_mq_release(q);
>>> -	if (blk_queue_has_srcu(q))
>>> -		cleanup_srcu_struct(q->srcu);
>>> -
>>>    	ida_free(&blk_queue_ida, q->id);
>>>    	call_rcu(&q->rcu_head, blk_free_queue_rcu);
>>>    }
>>> diff --git a/block/blk.h b/block/blk.h
>>> index a186ea20f39d8..4849a2efa4c50 100644
>>> --- a/block/blk.h
>>> +++ b/block/blk.h
>>> @@ -27,7 +27,6 @@ struct blk_flush_queue {
>>>    };
>>>    extern struct kmem_cache *blk_requestq_cachep;
>>> -extern struct kmem_cache *blk_requestq_srcu_cachep;
>>>    extern struct kobj_type blk_queue_ktype;
>>>    extern struct ida blk_queue_ida;
>>> @@ -428,13 +427,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
>>>    		struct page *page, unsigned int len, unsigned int offset,
>>>    		unsigned int max_sectors, bool *same_page);
>>> -static inline struct kmem_cache *blk_get_queue_kmem_cache(bool srcu)
>>> -{
>>> -	if (srcu)
>>> -		return blk_requestq_srcu_cachep;
>>> -	return blk_requestq_cachep;
>>> -}
>>> -struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu);
>>> +struct request_queue *blk_alloc_queue(int node_id);
>>>    int disk_scan_partitions(struct gendisk *disk, fmode_t mode);
>>> diff --git a/block/genhd.c b/block/genhd.c
>>> index 0b6928e948f31..4db1f905514c5 100644
>>> --- a/block/genhd.c
>>> +++ b/block/genhd.c
>>> @@ -1436,7 +1436,7 @@ struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass)
>>>    	struct request_queue *q;
>>>    	struct gendisk *disk;
>>> -	q = blk_alloc_queue(node, false);
>>> +	q = blk_alloc_queue(node);
>>>    	if (!q)
>>>    		return NULL;
>>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>>> index a9764cbf7f8d2..8e942e36f1c48 100644
>>> --- a/include/linux/blk-mq.h
>>> +++ b/include/linux/blk-mq.h
>>> @@ -7,6 +7,7 @@
>>>    #include <linux/lockdep.h>
>>>    #include <linux/scatterlist.h>
>>>    #include <linux/prefetch.h>
>>> +#include <linux/srcu.h>
>>>    struct blk_mq_tags;
>>>    struct blk_flush_queue;
>>> @@ -507,6 +508,8 @@ enum hctx_type {
>>>     * @tag_list_lock: Serializes tag_list accesses.
>>>     * @tag_list:	   List of the request queues that use this tag set. See also
>>>     *		   request_queue.tag_set_list.
>>> + * @srcu:	   Use as lock when type of the request queue is blocking
>>> + *		   (BLK_MQ_F_BLOCKING).
>>>     */
>>>    struct blk_mq_tag_set {
>>>    	struct blk_mq_queue_map	map[HCTX_MAX_TYPES];
>>> @@ -527,6 +530,7 @@ struct blk_mq_tag_set {
>>>    	struct mutex		tag_list_lock;
>>>    	struct list_head	tag_list;
>>> +	struct srcu_struct	*srcu;
>>>    };
>>>    /**
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>> index 891f8cbcd0436..36c286d22fb23 100644
>>> --- a/include/linux/blkdev.h
>>> +++ b/include/linux/blkdev.h
>>> @@ -22,7 +22,6 @@
>>>    #include <linux/blkzoned.h>
>>>    #include <linux/sched.h>
>>>    #include <linux/sbitmap.h>
>>> -#include <linux/srcu.h>
>>>    #include <linux/uuid.h>
>>>    #include <linux/xarray.h>
>>> @@ -544,18 +543,11 @@ struct request_queue {
>>>    	struct mutex		debugfs_mutex;
>>>    	bool			mq_sysfs_init_done;
>>> -
>>> -	/**
>>> -	 * @srcu: Sleepable RCU. Use as lock when type of the request queue
>>> -	 * is blocking (BLK_MQ_F_BLOCKING). Must be the last member
>>> -	 */
>>> -	struct srcu_struct	srcu[];
>>>    };
>>>    /* Keep blk_queue_flag_name[] in sync with the definitions below */
>>>    #define QUEUE_FLAG_STOPPED	0	/* queue is stopped */
>>>    #define QUEUE_FLAG_DYING	1	/* queue being torn down */
>>> -#define QUEUE_FLAG_HAS_SRCU	2	/* SRCU is allocated */
>>>    #define QUEUE_FLAG_NOMERGES     3	/* disable merge attempts */
>>>    #define QUEUE_FLAG_SAME_COMP	4	/* complete on same CPU-group */
>>>    #define QUEUE_FLAG_FAIL_IO	5	/* fake timeout */
>>> @@ -591,7 +583,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
>>>    #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
>>>    #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
>>> -#define blk_queue_has_srcu(q)	test_bit(QUEUE_FLAG_HAS_SRCU, &(q)->queue_flags)
>>>    #define blk_queue_init_done(q)	test_bit(QUEUE_FLAG_INIT_DONE, &(q)->queue_flags)
>>>    #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
>>>    #define blk_queue_noxmerges(q)	\
>>
>>
>> On systems with their (btrfs) root filesystem residing on an LVM volume,
>> this patch is reproducibly causing a complete freeze during shutdowns and
>> reboots.
>>
>> I had previously replied with the same message to patch 022/181 instead of
>> this one, but had gotten the subject mixed up actually meant this patch.
> 
> That is because the dependency patch is missed:
> 
> commit 8537380bb988 ("blk-mq: skip non-mq queues in blk_mq_quiesce_queue")
> 
> https://lore.kernel.org/linux-block/Y6qpwYaPOxgsZjp9@T590/


Thanks a lot Ming, this does indeed fix the issue for me. :)


Regards
Pascal
