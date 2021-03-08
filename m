Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEDC3305D7
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 03:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhCHCQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 21:16:41 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48011 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhCHCQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 21:16:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UQohvjf_1615169767;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQohvjf_1615169767)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Mar 2021 10:16:07 +0800
Subject: Re: [PATCH 4.9.y 1/3] dm table: fix iterate_devices based device
 capability checks
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
References: <1614606248249199@kroah.com>
 <20210305064625.63098-1-jefflexu@linux.alibaba.com>
 <20210305064625.63098-2-jefflexu@linux.alibaba.com>
 <YETsrB8SFkf1n0Pa@kroah.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <1c1e5580-383c-639f-fa88-cb8888139359@linux.alibaba.com>
Date:   Mon, 8 Mar 2021 10:16:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YETsrB8SFkf1n0Pa@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/7/21 11:09 PM, Greg KH wrote:
> On Fri, Mar 05, 2021 at 02:46:23PM +0800, Jeffle Xu wrote:
>> commit a4c8dd9c2d0987cf542a2a0c42684c9c6d78a04e upstream.
>>
>> According to the definition of dm_iterate_devices_fn:
>>  * This function must iterate through each section of device used by the
>>  * target until it encounters a non-zero return code, which it then returns.
>>  * Returns zero if no callout returned non-zero.
>>
>> For some target type (e.g. dm-stripe), one call of iterate_devices() may
>> iterate multiple underlying devices internally, in which case a non-zero
>> return code returned by iterate_devices_callout_fn will stop the iteration
>> in advance. No iterate_devices_callout_fn should return non-zero unless
>> device iteration should stop.
>>
>> Rename dm_table_requires_stable_pages() to dm_table_any_dev_attr() and
>> elevate it for reuse to stop iterating (and return non-zero) on the
>> first device that causes iterate_devices_callout_fn to return non-zero.
>> Use dm_table_any_dev_attr() to properly iterate through devices.
>>
>> Rename device_is_nonrot() to device_is_rotational() and invert logic
>> accordingly to fix improper disposition.
>>
>> Fixes: c3c4555edd10 ("dm table: clear add_random unless all devices have it set")
>> Fixes: 4693c9668fdc ("dm table: propagate non rotational flag")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>> [jeffle: no stable writes]
>> ---
>>  drivers/md/dm-table.c | 71 ++++++++++++++++++++++++++++---------------
>>  1 file changed, 47 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 5d120c3cee57..ba56be34cd5d 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -1306,6 +1306,46 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
>>  	return &t->targets[(KEYS_PER_NODE * n) + k];
>>  }
>>  
>> +/*
>> + * type->iterate_devices() should be called when the sanity check needs to
>> + * iterate and check all underlying data devices. iterate_devices() will
>> + * iterate all underlying data devices until it encounters a non-zero return
>> + * code, returned by whether the input iterate_devices_callout_fn, or
>> + * iterate_devices() itself internally.
>> + *
>> + * For some target type (e.g. dm-stripe), one call of iterate_devices() may
>> + * iterate multiple underlying devices internally, in which case a non-zero
>> + * return code returned by iterate_devices_callout_fn will stop the iteration
>> + * in advance.
>> + *
>> + * Cases requiring _any_ underlying device supporting some kind of attribute,
>> + * should use the iteration structure like dm_table_any_dev_attr(), or call
>> + * it directly. @func should handle semantics of positive examples, e.g.
>> + * capable of something.
>> + *
>> + * Cases requiring _all_ underlying devices supporting some kind of attribute,
>> + * should use the iteration structure like dm_table_supports_nowait() or
>> + * dm_table_supports_discards(). Or introduce dm_table_all_devs_attr() that
>> + * uses an @anti_func that handle semantics of counter examples, e.g. not
>> + * capable of something. So: return !dm_table_any_dev_attr(t, anti_func);
>> + */
>> +static bool dm_table_any_dev_attr(struct dm_table *t,
>> +				  iterate_devices_callout_fn func)
>> +{
>> +	struct dm_target *ti;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
>> +		ti = dm_table_get_target(t, i);
>> +
>> +		if (ti->type->iterate_devices &&
>> +		    ti->type->iterate_devices(ti, func, NULL))
>> +			return true;
>> +        }
>> +
>> +	return false;
>> +}
>> +
>>  static int count_device(struct dm_target *ti, struct dm_dev *dev,
>>  			sector_t start, sector_t len, void *data)
>>  {
>> @@ -1476,12 +1516,12 @@ static bool dm_table_discard_zeroes_data(struct dm_table *t)
>>  	return true;
>>  }
>>  
>> -static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
>> -			    sector_t start, sector_t len, void *data)
>> +static int device_is_rotational(struct dm_target *ti, struct dm_dev *dev,
>> +				sector_t start, sector_t len, void *data)
>>  {
>>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>>  
>> -	return q && blk_queue_nonrot(q);
>> +	return q && !blk_queue_nonrot(q);
>>  }
>>  
>>  static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
>> @@ -1500,23 +1540,6 @@ static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
>>  	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
>>  }
>>  
>> -static bool dm_table_all_devices_attribute(struct dm_table *t,
>> -					   iterate_devices_callout_fn func)
>> -{
>> -	struct dm_target *ti;
>> -	unsigned i = 0;
>> -
>> -	while (i < dm_table_get_num_targets(t)) {
>> -		ti = dm_table_get_target(t, i++);
>> -
>> -		if (!ti->type->iterate_devices ||
>> -		    !ti->type->iterate_devices(ti, func, NULL))
>> -			return false;
>> -	}
>> -
>> -	return true;
>> -}
>> -
>>  static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
>>  					 sector_t start, sector_t len, void *data)
>>  {
>> @@ -1607,10 +1630,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>  		q->limits.discard_zeroes_data = 0;
>>  
>>  	/* Ensure that all underlying devices are non-rotational. */
>> -	if (dm_table_all_devices_attribute(t, device_is_nonrot))
>> -		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
>> -	else
>> +	if (dm_table_any_dev_attr(t, device_is_rotational))
>>  		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
>> +	else
>> +		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
>>  
>>  	if (!dm_table_supports_write_same(t))
>>  		q->limits.max_write_same_sectors = 0;
>> @@ -1628,7 +1651,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>  	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
>>  	 * have it set.
>>  	 */
>> -	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
>> +	if (blk_queue_add_random(q) && dm_table_any_dev_attr(t, device_is_not_random))
>>  		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
>>  
>>  	/*
>> -- 
>> 2.27.0
>>
> 
> This patch breaks the build :(
> 
> Please always test-build your patches.
> 

Sorry, could you please attach your fail log or steps to reproduce it? I
can't reproduce it with 'make allyesconfig && make' on x86.

Though I indeed know that this patch has one style problem found by
checpatch.py, though it's inherited from the upstream patch...

```
ERROR:CODE_INDENT: code indent should use tabs where possible
#77: FILE: drivers/md/dm-table.c:1333:
+        }$
```

-- 
Thanks,
Jeffle
