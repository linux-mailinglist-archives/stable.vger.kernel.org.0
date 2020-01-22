Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942D4144CAB
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 08:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAVH5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 02:57:21 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:58167 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgAVH5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 02:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579679840; x=1611215840;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=JalNXEE3xWqcF6hF2pWv5DdqCkyNQRWEPPh45V7LLV4=;
  b=WNpqg4PVj/OBm/Feq0eeCjSK092pABXq+SRvGqPGUplfajXd4bO3KpP2
   4OLxS9CJ1gaJZecGCm5pxwGMLAAG7jCUXC/7R3SYDWLjICcBFGNFSKJZV
   BatKfFL+P3X7ZwRzls/KKISzv675nUmzbY/icZgWqcGWYAb+b4QqbHkka
   c=;
IronPort-SDR: lalxcvz+0C40cuWFZTYa4R4Yh9ENnRLrcq5v4tgc7LJycuyRL+TOQZLwEHmdWuR6SvNkKnL4go
 LWn5eLs9AIrg==
X-IronPort-AV: E=Sophos;i="5.70,348,1574121600"; 
   d="scan'208";a="14170844"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Jan 2020 07:57:18 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 675FDA2661;
        Wed, 22 Jan 2020 07:57:17 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 22 Jan 2020 07:57:16 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.8) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 22 Jan 2020 07:57:12 +0000
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous memory
 blocks aligned to device supported page size"
To:     Leon Romanovsky <leon@kernel.org>
CC:     Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>,
        "Alexander Matushevsky" <matua@amazon.com>,
        <stable@vger.kernel.org>, "Leybovich, Yossi" <sleybo@amazon.com>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
 <20200121162436.GL51881@unreal>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <47c20471-2251-b93b-053d-87880fa0edf5@amazon.com>
Date:   Wed, 22 Jan 2020 09:57:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200121162436.GL51881@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D36UWA003.ant.amazon.com (10.43.160.237) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/01/2020 18:24, Leon Romanovsky wrote:
> On Tue, Jan 21, 2020 at 11:07:21AM +0200, Gal Pressman wrote:
>> On 20/01/2020 16:10, Gal Pressman wrote:
>>> The cited commit leads to register MR failures and random hangs when
>>> running different MPI applications. The exact root cause for the issue
>>> is still not clear, this revert brings us back to a stable state.
>>>
>>> This reverts commit 40ddb3f020834f9afb7aab31385994811f4db259.
>>>
>>> Fixes: 40ddb3f02083 ("RDMA/efa: Use API to get contiguous memory blocks aligned to device supported page size")
>>> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
>>> Cc: stable@vger.kernel.org # 5.3
>>> Signed-off-by: Gal Pressman <galpress@amazon.com>
>>
>> Shiraz, I think I found the root cause here.
>> I'm noticing a register MR of size 32k, which is constructed from two sges, the
>> first sge of size 12k and the second of 20k.
>>
>> ib_umem_find_best_pgsz returns page shift 13 in the following way:
>>
>> 0x103dcb2000      0x103dcb5000       0x103dd5d000           0x103dd62000
>>           +----------+                      +------------------+
>>           |          |                      |                  |
>>           |  12k     |                      |     20k          |
>>           +----------+                      +------------------+
>>
>>           +------+------+                 +------+------+------+
>>           |      |      |                 |      |      |      |
>>           | 8k   | 8k   |                 | 8k   | 8k   | 8k   |
>>           +------+------+                 +------+------+------+
>> 0x103dcb2000       0x103dcb6000   0x103dd5c000              0x103dd62000
>>
>>
>> The top row is the original umem sgl, and the bottom is the sgl constructed by
>> rdma_for_each_block with page size of 8k.
>>
>> Is this the expected output? The 8k pages cover addresses which aren't part of
>> the MR. This breaks some of the assumptions in the driver (for example, the way
>> we calculate the number of pages in the MR) and I'm not sure our device can
>> handle such sgl.
> 
> Artemy wrote this fix that can help you.
> 
> commit 60c9fe2d18b657df950a5f4d5a7955694bd08e63
> Author: Artemy Kovalyov <artemyko@mellanox.com>
> Date:   Sun Dec 15 12:43:13 2019 +0200
> 
>     RDMA/umem: Fix ib_umem_find_best_pgsz()
> 
>     Except for the last entry, the ending iova alignment sets the maximum
>     possible page size as the low bits of the iova must be zero when
>     starting the next chunk.
> 
>     Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
>     Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
>     Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index c3769a5f096d..06b6125b5ae1 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -166,10 +166,13 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
>                  * for any address.
>                  */
>                 mask |= (sg_dma_address(sg) + pgoff) ^ va;
> -               if (i && i != (umem->nmap - 1))
> -                       /* restrict by length as well for interior SGEs */
> -                       mask |= sg_dma_len(sg);
>                 va += sg_dma_len(sg) - pgoff;
> +               /* Except for the last entry, the ending iova alignment sets
> +                * the maximum possible page size as the low bits of the iova
> +                * must be zero when starting the next chunk.
> +                */
> +               if (i != (umem->nmap - 1))
> +                       mask |= va;
>                 pgoff = 0;
>         }
>         best_pg_bit = rdma_find_pg_bit(mask, pgsz_bitmap);

Thanks Leon, I'll test this and let you know if it fixes the issue.
When are you planning to submit this?
