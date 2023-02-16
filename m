Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2241869A280
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 00:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBPXmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 18:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPXmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 18:42:21 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7556B4D61D;
        Thu, 16 Feb 2023 15:42:19 -0800 (PST)
Received: from [192.168.192.83] (unknown [50.47.134.245])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 784ED3F34A;
        Thu, 16 Feb 2023 23:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676590936;
        bh=XhSn8XMnKTe4tskDZD8rvgpWInRsukK5YFNIKX9b1NU=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=rrQWk23i2Cg7CegpOtOoSMPw2pWDDCstMgDVi9Tx2w6MOUhbU6+6RliUgBtpon5uh
         FYxlzA/Uwd0gQzN+uptHxDvttoA/sNIgWa4Lxx9ikDXssFSVQ2MSgTZrYTMZiRW599
         SE8d1JtxzdkLv2qxVfjEji10TI3rl6jJceu/74Y73uTciPBMng4spLICktxWkb7Ja2
         Z+egb8Ms1IXjaMP3MRsTAqRQUYAt/i+W8J23edHgCkpyakFgzk832uxzKk0yHkPL5Y
         JMQ4YYuoGVfEcQbC2aua6rbGBJBuEfyjac7XlGrM4Ek9JHB6Nqs1wA2/lIM1LEiMmW
         ovz1NP07qi7Aw==
Message-ID: <a1f3a093-f86a-0200-8fbf-9cd17956669a@canonical.com>
Date:   Thu, 16 Feb 2023 15:42:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/1] apparmor: cache buffers on percpu list if there is
 lock contention
Content-Language: en-US
To:     Anil Altinay <aaltinay@google.com>,
        linux-security-module@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
References: <20230216214651.3514675-1-aaltinay@google.com>
 <20230216214651.3514675-2-aaltinay@google.com>
From:   John Johansen <john.johansen@canonical.com>
Organization: Canonical
In-Reply-To: <20230216214651.3514675-2-aaltinay@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/23 13:46, Anil Altinay wrote:
> On a heavily loaded machine there can be lock contention on the
> global buffers lock. Add a percpu list to cache buffers on when
> lock contention is encountered.
> 
> When allocating buffers attempt to use cached buffers first,
> before taking the global buffers lock. When freeing buffers
> try to put them back to the global list but if contention is
> encountered, put the buffer on the percpu list.
> 
> The length of time a buffer is held on the percpu list is dynamically
> adjusted based on lock contention.  The amount of hold time is rapidly
> increased and slow ramped down.
> 
> Fixes: df323337e507 ("apparmor: Use a memory pool instead per-CPU caches")
> Link: https://lore.kernel.org/lkml/cfd5cc6f-5943-2e06-1dbe-f4b4ad5c1fa1@canonical.com/
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> Reported-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Anil Altinay <aaltinay@google.com>
> Cc: stable@vger.kernel.org

NAK, this version of the patch has an issue that prevented it from
being pushed upstream.

I can send out the revised version for people to look at but I
haven't been able to get proper testing on it yet, hence why
I haven't pushed it yet either.


> ---
>   security/apparmor/lsm.c | 73 ++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index c6728a629437..56b22e2def4c 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -49,12 +49,19 @@ union aa_buffer {
>   	char buffer[1];
>   };
>   
> +struct aa_local_cache {
> +	unsigned int contention;
> +	unsigned int hold;
> +	struct list_head head;
> +};
> +
>   #define RESERVE_COUNT 2
>   static int reserve_count = RESERVE_COUNT;
>   static int buffer_count;
>   
>   static LIST_HEAD(aa_global_buffers);
>   static DEFINE_SPINLOCK(aa_buffers_lock);
> +static DEFINE_PER_CPU(struct aa_local_cache, aa_local_buffers);
>   
>   /*
>    * LSM hook functions
> @@ -1634,14 +1641,43 @@ static int param_set_mode(const char *val, const struct kernel_param *kp)
>   	return 0;
>   }
>   
> +static void update_contention(struct aa_local_cache *cache)
> +{
> +	cache->contention += 3;
> +	if (cache->contention > 9)
> +		cache->contention = 9;
> +	cache->hold += 1 << cache->contention;		/* 8, 64, 512 */
> +}
> +
>   char *aa_get_buffer(bool in_atomic)
>   {
>   	union aa_buffer *aa_buf;
> +	struct aa_local_cache *cache;
>   	bool try_again = true;
>   	gfp_t flags = (GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN);
> +	/* use per cpu cached buffers first */
> +	cache = get_cpu_ptr(&aa_local_buffers);
> +	if (!list_empty(&cache->head)) {
> +		aa_buf = list_first_entry(&cache->head, union aa_buffer, list);
> +		list_del(&aa_buf->list);
> +		cache->hold--;
> +		put_cpu_ptr(&aa_local_buffers);
> +		return &aa_buf->buffer[0];
> +	}
> +	put_cpu_ptr(&aa_local_buffers);
>   
> +	if (!spin_trylock(&aa_buffers_lock)) {
> +		cache = get_cpu_ptr(&aa_local_buffers);
> +		update_contention(cache);
> +		put_cpu_ptr(&aa_local_buffers);
> +		spin_lock(&aa_buffers_lock);
> +	} else {
> +		cache = get_cpu_ptr(&aa_local_buffers);
> +		if (cache->contention)
> +			cache->contention--;
> +		put_cpu_ptr(&aa_local_buffers);
> +	}
>   retry:
> -	spin_lock(&aa_buffers_lock);
>   	if (buffer_count > reserve_count ||
>   	    (in_atomic && !list_empty(&aa_global_buffers))) {
>   		aa_buf = list_first_entry(&aa_global_buffers, union aa_buffer,
> @@ -1667,6 +1703,7 @@ char *aa_get_buffer(bool in_atomic)
>   	if (!aa_buf) {
>   		if (try_again) {
>   			try_again = false;
> +			spin_lock(&aa_buffers_lock);
>   			goto retry;
>   		}
>   		pr_warn_once("AppArmor: Failed to allocate a memory buffer.\n");
> @@ -1678,15 +1715,32 @@ char *aa_get_buffer(bool in_atomic)
>   void aa_put_buffer(char *buf)
>   {
>   	union aa_buffer *aa_buf;
> +	struct aa_local_cache *cache;
>   
>   	if (!buf)
>   		return;
>   	aa_buf = container_of(buf, union aa_buffer, buffer[0]);
>   
> -	spin_lock(&aa_buffers_lock);
> -	list_add(&aa_buf->list, &aa_global_buffers);
> -	buffer_count++;
> -	spin_unlock(&aa_buffers_lock);
> +	cache = get_cpu_ptr(&aa_local_buffers);
> +	if (!cache->hold) {
> +		put_cpu_ptr(&aa_local_buffers);
> +		if (spin_trylock(&aa_buffers_lock)) {
> +			list_add(&aa_buf->list, &aa_global_buffers);
> +			buffer_count++;
> +			spin_unlock(&aa_buffers_lock);
> +			cache = get_cpu_ptr(&aa_local_buffers);
> +			if (cache->contention)
> +				cache->contention--;
> +			put_cpu_ptr(&aa_local_buffers);
> +			return;
> +		}
> +		cache = get_cpu_ptr(&aa_local_buffers);
> +		update_contention(cache);
> +	}
> +
> +	/* cache in percpu list */
> +	list_add(&aa_buf->list, &cache->head);
> +	put_cpu_ptr(&aa_local_buffers);
>   }
>   
>   /*
> @@ -1728,6 +1782,15 @@ static int __init alloc_buffers(void)
>   	union aa_buffer *aa_buf;
>   	int i, num;
>   
> +	/*
> +	 * per cpu set of cached allocated buffers used to help reduce
> +	 * lock contention
> +	 */
> +	for_each_possible_cpu(i) {
> +		per_cpu(aa_local_buffers, i).contention = 0;
> +		per_cpu(aa_local_buffers, i).hold = 0;
> +		INIT_LIST_HEAD(&per_cpu(aa_local_buffers, i).head);
> +	}
>   	/*
>   	 * A function may require two buffers at once. Usually the buffers are
>   	 * used for a short period of time and are shared. On UP kernel buffers

