Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D665330655
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 04:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhCHDV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 22:21:29 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:54539 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233906AbhCHDVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 22:21:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UQoi3cO_1615173665;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQoi3cO_1615173665)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Mar 2021 11:21:06 +0800
Subject: Re: [PATCH 4.4.y 2/2] dm table: fix no_sg_merge iterate_devices based
 device capability checks
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        sashal@kernel.org
References: <161460624611368@kroah.com>
 <20210305063051.51030-1-jefflexu@linux.alibaba.com>
 <20210305063051.51030-3-jefflexu@linux.alibaba.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <7a57dde6-7327-7517-1ece-d33329e5fc52@linux.alibaba.com>
Date:   Mon, 8 Mar 2021 11:21:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305063051.51030-3-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Mike,

Would you please spare some time to review the following patches for
stable tree?

- [1] for 4.4.y
- [2] for 4.9.y
- [3] for 4.14.y
- [4] for 4.19.y

While backporting [5] for stable tree, there's some extra code specific
to stable tree needs to be fixed, see [6] for the background info.

[1] https://www.spinics.net/lists/stable/msg448728.html
[2] https://www.spinics.net/lists/stable/msg448737.html
[3] https://www.spinics.net/lists/stable/msg448740.html
[4] https://www.spinics.net/lists/stable/msg448748.html
[5]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.12-rc2&id=a4c8dd9c2d0987cf542a2a0c42684c9c6d78a04e
[6] https://www.spinics.net/lists/stable/msg448757.html


Thanks,
Jeffle


On 3/5/21 2:30 PM, Jeffle Xu wrote:
> Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
> device capability checks"), fix NO_SG_MERGE capability check and invert
> logic of the corresponding iterate_devices_callout_fn so that all
> devices' NO_SG_MERGE capabilities are properly checked.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Fixes: 200612ec33e5 ("dm table: propagate QUEUE_FLAG_NO_SG_MERGE")
> ---
>  drivers/md/dm-table.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 6580de65b81d..7ee520d4d216 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1436,12 +1436,12 @@ static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
>  	return q && !blk_queue_add_random(q);
>  }
>  
> -static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
> -				   sector_t start, sector_t len, void *data)
> +static int queue_no_sg_merge(struct dm_target *ti, struct dm_dev *dev,
> +			     sector_t start, sector_t len, void *data)
>  {
>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>  
> -	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
> +	return q && test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
>  }
>  
>  static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
> @@ -1542,10 +1542,10 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	if (!dm_table_supports_write_same(t))
>  		q->limits.max_write_same_sectors = 0;
>  
> -	if (dm_table_all_devices_attribute(t, queue_supports_sg_merge))
> -		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
> -	else
> +	if (dm_table_any_dev_attr(t, queue_no_sg_merge))
>  		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
> +	else
> +		queue_flag_clear_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
>  
>  	dm_table_verify_integrity(t);
>  
> 

-- 
Thanks,
Jeffle
