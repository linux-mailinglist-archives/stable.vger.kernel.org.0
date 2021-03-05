Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE5132E2C2
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 08:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCEHEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 02:04:55 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:45993 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEHEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 02:04:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UQXT3KS_1614927892;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQXT3KS_1614927892)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Mar 2021 15:04:52 +0800
Subject: Re: [PATCH 4.19.y 3/5] dm table: fix partial completion
 iterate_devices based device capability checks
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, snitzer@redhat.com
References: <1614606251118245@kroah.com>
 <20210305065526.72663-1-jefflexu@linux.alibaba.com>
 <20210305065526.72663-4-jefflexu@linux.alibaba.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <8ccdf13a-aff5-445d-0d5b-022d8089c1b6@linux.alibaba.com>
Date:   Fri, 5 Mar 2021 15:04:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305065526.72663-4-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/5/21 2:55 PM, Jeffle Xu wrote:
> Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
> device capability checks"), fix partial completion capability check and
> invert logic of the corresponding iterate_devices_callout_fn so that all
> devices' partial completion capabilities are properly checked.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Fixes: 22c11858e800 ("dm: introduce DM_TYPE_NVME_BIO_BASED")



Similarly, the code this patch fixes, i.e., commit 22c11858e800 ("dm:
introduce DM_TYPE_NVME_BIO_BASED"), was removed since commit
9c37de297f65 ("dm: remove special-casing of bio-based immutable
singleton target on NVMe") in v5.10. Thus the code base doesn't exist in
the latest master branch.

It needs Mike's review.

-- 
Thanks,
Jeffle

> ---
>  drivers/md/dm-table.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 5a94e6dc0b70..1f745d371957 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1772,18 +1772,18 @@ static int queue_no_sg_merge(struct dm_target *ti, struct dm_dev *dev,
>  	return q && test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
>  }
>  
> -static int device_no_partial_completion(struct dm_target *ti, struct dm_dev *dev,
> +static int device_is_partial_completion(struct dm_target *ti, struct dm_dev *dev,
>  					sector_t start, sector_t len, void *data)
>  {
>  	char b[BDEVNAME_SIZE];
>  
>  	/* For now, NVMe devices are the only devices of this class */
> -	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) == 0);
> +	return (strncmp(bdevname(dev->bdev, b), "nvme", 4) != 0);
>  }
>  
>  static bool dm_table_does_not_support_partial_completion(struct dm_table *t)
>  {
> -	return dm_table_all_devices_attribute(t, device_no_partial_completion);
> +	return !dm_table_any_dev_attr(t, device_is_partial_completion);
>  }
>  
>  static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
> 


