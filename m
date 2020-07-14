Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7521E879
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 08:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgGNGpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 02:45:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbgGNGpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 02:45:07 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 968014325CAC56413F9B;
        Tue, 14 Jul 2020 14:45:04 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.211) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Jul 2020
 14:45:01 +0800
Subject: Re: [PATCH 4.19] IB/umem: fix reference count leak in
 ib_umem_odp_get()
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <sashal@kernel.org>,
        <dledford@redhat.com>, <jgg@ziepe.ca>
References: <20200714105748.1151138-1-yangyingliang@huawei.com>
 <20200714060813.GD657428@kroah.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5f8d0a3d-31d1-e753-5440-4bfbe07c054b@huawei.com>
Date:   Tue, 14 Jul 2020 14:45:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200714060813.GD657428@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.211]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/7/14 14:08, Greg KH wrote:
> On Tue, Jul 14, 2020 at 10:57:48AM +0000, Yang Yingliang wrote:
>> Add missing mmput() on error path to avoid ref-count leak.
>>
>> This problem has already been resolved in mainline by
>> f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
>>
>> Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/infiniband/core/umem_odp.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
> $ ./scripts/get_maintainer.pl --file drivers/infiniband/core/umem_odp.c
> Doug Ledford <dledford@redhat.com> (supporter:INFINIBAND SUBSYSTEM)
> Jason Gunthorpe <jgg@ziepe.ca> (supporter:INFINIBAND SUBSYSTEM,commit_signer:28/25=100%,authored:17/25=68%,added_lines:453/481=94%,removed_lines:662/722=92%)
> Leon Romanovsky <leon@kernel.org> (commit_signer:16/25=64%)
> Artemy Kovalyov <artemyko@mellanox.com> (commit_signer:4/25=16%)
> Yishai Hadas <yishaih@mellanox.com> (commit_signer:3/25=12%,authored:3/25=12%)
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:2/25=8%)
> Moni Shoua <monis@mellanox.com> (authored:2/25=8%)
> linux-rdma@vger.kernel.org (open list:INFINIBAND SUBSYSTEM)
> linux-kernel@vger.kernel.org (open list)
>
> Any reason you ignored the mailing list for the whole IB developer
> community?

It's my first time to send patch to stable mail list, I thought cc the 
maintainer/supporter is enough.

I will re-send to the supporter and devlep mail list.

>
> And you need to make this REALLY obvious that this is a stable-tree-only
> patch, for a specific kernel version (and why only that one version),
> and a whole lot more description to allow everyone to know what is going
> on, and what you expect them to review this for.

OK, I will describe the version in change log.


Thanks,

Yang

>
> thanks,
>
> greg k-h
> .

