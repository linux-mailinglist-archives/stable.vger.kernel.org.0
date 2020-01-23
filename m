Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C65146B51
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAWOaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:30:12 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:39202 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgAWOaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 09:30:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579789812; x=1611325812;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0qUKYox3EHrN2Mp5mqxTHCZige/bzIP3a1E1n9uI5cc=;
  b=hRR5gIVTO5O7PhRuj9jKmDFR8yk9RexI8TOlAnl0trE4Ww6xplyc/OWC
   jEWAKKN7+OkL/punGclOCV4VEMwky4PYYF4Mz4v7UOlh64MVdaH9DBdkK
   qA80XFvrRu9d2HA7WODx39IalTVkpJiPB2yw5yBbNIhI1yBBg812FgEtS
   A=;
IronPort-SDR: 0sWCUyL7hcOYf1XgHKmS+NegDBylUXnxwDYnghSDUb8U09OvhdbzIFXa8SoGomT76TYjdslAkl
 kftUegeHIeAw==
X-IronPort-AV: E=Sophos;i="5.70,354,1574121600"; 
   d="scan'208";a="20596650"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 23 Jan 2020 14:30:01 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 160B2A286D;
        Thu, 23 Jan 2020 14:30:00 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Thu, 23 Jan 2020 14:29:59 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.8) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 23 Jan 2020 14:29:55 +0000
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous memory
 blocks aligned to device supported page size"
To:     Leon Romanovsky <leon@kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        <stable@vger.kernel.org>, "Leybovich, Yossi" <sleybo@amazon.com>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
 <20200121162436.GL51881@unreal>
 <47c20471-2251-b93b-053d-87880fa0edf5@amazon.com>
 <20200123142443.GN7018@unreal>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <60d8c528-1088-df8d-76f0-4746acfcfc7a@amazon.com>
Date:   Thu, 23 Jan 2020 16:29:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200123142443.GN7018@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.8]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/01/2020 16:24, Leon Romanovsky wrote:
> On Wed, Jan 22, 2020 at 09:57:07AM +0200, Gal Pressman wrote:
>> On 21/01/2020 18:24, Leon Romanovsky wrote:
>>> On Tue, Jan 21, 2020 at 11:07:21AM +0200, Gal Pressman wrote:
>>>> On 20/01/2020 16:10, Gal Pressman wrote:
>>>>> The cited commit leads to register MR failures and random hangs when
>>>>> running different MPI applications. The exact root cause for the issue
>>>>> is still not clear, this revert brings us back to a stable state.
>>>>>
>>>>> This reverts commit 40ddb3f020834f9afb7aab31385994811f4db259.
>>>>>
>>>>> Fixes: 40ddb3f02083 ("RDMA/efa: Use API to get contiguous memory blocks aligned to device supported page size")
>>>>> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
>>>>> Cc: stable@vger.kernel.org # 5.3
>>>>> Signed-off-by: Gal Pressman <galpress@amazon.com>
>>>>
>>>> Shiraz, I think I found the root cause here.
>>>> I'm noticing a register MR of size 32k, which is constructed from two sges, the
>>>> first sge of size 12k and the second of 20k.
>>>>
>>>> ib_umem_find_best_pgsz returns page shift 13 in the following way:
>>>>
>>>> 0x103dcb2000      0x103dcb5000       0x103dd5d000           0x103dd62000
>>>>           +----------+                      +------------------+
>>>>           |          |                      |                  |
>>>>           |  12k     |                      |     20k          |
>>>>           +----------+                      +------------------+
>>>>
>>>>           +------+------+                 +------+------+------+
>>>>           |      |      |                 |      |      |      |
>>>>           | 8k   | 8k   |                 | 8k   | 8k   | 8k   |
>>>>           +------+------+                 +------+------+------+
>>>> 0x103dcb2000       0x103dcb6000   0x103dd5c000              0x103dd62000
>>>>
>>>>
>>>> The top row is the original umem sgl, and the bottom is the sgl constructed by
>>>> rdma_for_each_block with page size of 8k.
>>>>
>>>> Is this the expected output? The 8k pages cover addresses which aren't part of
>>>> the MR. This breaks some of the assumptions in the driver (for example, the way
>>>> we calculate the number of pages in the MR) and I'm not sure our device can
>>>> handle such sgl.
>>>
>>> Artemy wrote this fix that can help you.
>>>
>>> commit 60c9fe2d18b657df950a5f4d5a7955694bd08e63
>>> Author: Artemy Kovalyov <artemyko@mellanox.com>
>>> Date:   Sun Dec 15 12:43:13 2019 +0200
>>>
>>>     RDMA/umem: Fix ib_umem_find_best_pgsz()
>>>
>>>     Except for the last entry, the ending iova alignment sets the maximum
>>>     possible page size as the low bits of the iova must be zero when
>>>     starting the next chunk.
>>>
>>>     Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
>>>     Signed-off-by: Artemy Kovalyov <artemyko@mellanox.com>
>>>     Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>>
>>> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
>>> index c3769a5f096d..06b6125b5ae1 100644
>>> --- a/drivers/infiniband/core/umem.c
>>> +++ b/drivers/infiniband/core/umem.c
>>> @@ -166,10 +166,13 @@ unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
>>>                  * for any address.
>>>                  */
>>>                 mask |= (sg_dma_address(sg) + pgoff) ^ va;
>>> -               if (i && i != (umem->nmap - 1))
>>> -                       /* restrict by length as well for interior SGEs */
>>> -                       mask |= sg_dma_len(sg);
>>>                 va += sg_dma_len(sg) - pgoff;
>>> +               /* Except for the last entry, the ending iova alignment sets
>>> +                * the maximum possible page size as the low bits of the iova
>>> +                * must be zero when starting the next chunk.
>>> +                */
>>> +               if (i != (umem->nmap - 1))
>>> +                       mask |= va;
>>>                 pgoff = 0;
>>>         }
>>>         best_pg_bit = rdma_find_pg_bit(mask, pgsz_bitmap);
>>
>> Thanks Leon, I'll test this and let you know if it fixes the issue.
>> When are you planning to submit this?
> 
> If it fixes your issues, I will be happy to do it.

So far it looks good to me, I'll let it run over the weekend to be on the safe side.

Shiraz, does this fix make sense to you?
