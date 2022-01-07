Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EED4872EA
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 06:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiAGF54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 00:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAGF54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 00:57:56 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD44AC061245;
        Thu,  6 Jan 2022 21:57:55 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1n5iG8-0006EQ-5O; Fri, 07 Jan 2022 06:57:52 +0100
Message-ID: <3802192c-d9ce-8f4a-88c5-a87f58eaf37b@leemhuis.info>
Date:   Fri, 7 Jan 2022 06:57:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5.15 04/42] RDMA/mlx5: Fix releasing unallocated memory in
 dereg MR flow
Content-Language: en-BS
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
References: <20211215172026.641863587@linuxfoundation.org>
 <20211215172026.789963312@linuxfoundation.org>
 <bbb587b1-4555-ba8d-fe43-d56d41a3c652@leemhuis.info>
In-Reply-To: <bbb587b1-4555-ba8d-fe43-d56d41a3c652@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1641535075;deaf4f67;
X-HE-SMSGID: 1n5iG8-0006EQ-5O
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg!

On 01.01.22 11:56, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> On 15.12.21 18:20, Greg Kroah-Hartman wrote:
>> From: Alaa Hleihel <alaa@nvidia.com>
>>
>> [ Upstream commit f0ae4afe3d35e67db042c58a52909e06262b740f ]
>>
>> For the case of IB_MR_TYPE_DM the mr does doesn't have a umem, even though
>> it is a user MR. This causes function mlx5_free_priv_descs() to think that
>> it is a kernel MR, leading to wrongly accessing mr->descs that will get
>> wrong values in the union which leads to attempt to release resources that
>> were not allocated in the first place.
> 
> TWIMC, that commit made it into 5.15.y, but is known to cause a
> regression in v5.16-rc:
> 
> https://lore.kernel.org/lkml/f298db4ec5fdf7a2d1d166ca2f66020fd9397e5c.1640079962.git.leonro@nvidia.com/
> https://lore.kernel.org/all/EEBA2D1C-F29C-4237-901C-587B60CEE113@oracle.com/
> 
> A fix for mainline was posted, but got stuck afaics:
> https://lore.kernel.org/lkml/f298db4ec5fdf7a2d1d166ca2f66020fd9397e5c.1640079962.git.leonro@nvidia.com/
> 
> A revert was also discussed, but not performed:
> https://lore.kernel.org/all/20211222101312.1358616-1-maorg@nvidia.com/

I assume your scripts will catch this, nevertheless FYI:

Below patch was reverted in mainline, as it "is not the full fix and
still causes to call traces". You likely want to revert it from v5.15.y
as well. For details see

4163cb3d1980 ("Revert "RDMA/mlx5: Fix releasing unallocated memory in
dereg MR flow"")

https://git.kernel.org/torvalds/c/4163cb3d1980383220ad7043002b930995dcba33

Ciao, Thorsten

>> For example:
>>  DMA-API: mlx5_core 0000:08:00.1: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=0 bytes]
>>  WARNING: CPU: 8 PID: 1021 at kernel/dma/debug.c:961 check_unmap+0x54f/0x8b0
>>  RIP: 0010:check_unmap+0x54f/0x8b0
>>  Call Trace:
>>   debug_dma_unmap_page+0x57/0x60
>>   mlx5_free_priv_descs+0x57/0x70 [mlx5_ib]
>>   mlx5_ib_dereg_mr+0x1fb/0x3d0 [mlx5_ib]
>>   ib_dereg_mr_user+0x60/0x140 [ib_core]
>>   uverbs_destroy_uobject+0x59/0x210 [ib_uverbs]
>>   uobj_destroy+0x3f/0x80 [ib_uverbs]
>>   ib_uverbs_cmd_verbs+0x435/0xd10 [ib_uverbs]
>>   ? uverbs_finalize_object+0x50/0x50 [ib_uverbs]
>>   ? lock_acquire+0xc4/0x2e0
>>   ? lock_acquired+0x12/0x380
>>   ? lock_acquire+0xc4/0x2e0
>>   ? lock_acquire+0xc4/0x2e0
>>   ? ib_uverbs_ioctl+0x7c/0x140 [ib_uverbs]
>>   ? lock_release+0x28a/0x400
>>   ib_uverbs_ioctl+0xc0/0x140 [ib_uverbs]
>>   ? ib_uverbs_ioctl+0x7c/0x140 [ib_uverbs]
>>   __x64_sys_ioctl+0x7f/0xb0
>>   do_syscall_64+0x38/0x90
>>
>> Fix it by reorganizing the dereg flow and mlx5_ib_mr structure:
>>  - Move the ib_umem field into the user MRs structure in the union as it's
>>    applicable only there.
>>  - Function mlx5_ib_dereg_mr() will now call mlx5_free_priv_descs() only
>>    in case there isn't udata, which indicates that this isn't a user MR.
>>
>> Fixes: f18ec4223117 ("RDMA/mlx5: Use a union inside mlx5_ib_mr")
>> Link: https://lore.kernel.org/r/66bb1dd253c1fd7ceaa9fc411061eefa457b86fb.1637581144.git.leonro@nvidia.com
>> Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++---
>>  drivers/infiniband/hw/mlx5/mr.c      | 26 ++++++++++++--------------
>>  2 files changed, 15 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> index bf20a388eabe1..6204ae2caef58 100644
>> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> @@ -641,7 +641,6 @@ struct mlx5_ib_mr {
>>  
>>  	/* User MR data */
>>  	struct mlx5_cache_ent *cache_ent;
>> -	struct ib_umem *umem;
>>  
>>  	/* This is zero'd when the MR is allocated */
>>  	union {
>> @@ -653,7 +652,7 @@ struct mlx5_ib_mr {
>>  			struct list_head list;
>>  		};
>>  
>> -		/* Used only by kernel MRs (umem == NULL) */
>> +		/* Used only by kernel MRs */
>>  		struct {
>>  			void *descs;
>>  			void *descs_alloc;
>> @@ -675,8 +674,9 @@ struct mlx5_ib_mr {
>>  			int data_length;
>>  		};
>>  
>> -		/* Used only by User MRs (umem != NULL) */
>> +		/* Used only by User MRs */
>>  		struct {
>> +			struct ib_umem *umem;
>>  			unsigned int page_shift;
>>  			/* Current access_flags */
>>  			int access_flags;
>> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
>> index 22e2f4d79743d..69b2ce4c292ae 100644
>> --- a/drivers/infiniband/hw/mlx5/mr.c
>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>> @@ -1911,19 +1911,18 @@ mlx5_alloc_priv_descs(struct ib_device *device,
>>  	return ret;
>>  }
>>  
>> -static void
>> -mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
>> +static void mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
>>  {
>> -	if (!mr->umem && mr->descs) {
>> -		struct ib_device *device = mr->ibmr.device;
>> -		int size = mr->max_descs * mr->desc_size;
>> -		struct mlx5_ib_dev *dev = to_mdev(device);
>> +	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
>> +	int size = mr->max_descs * mr->desc_size;
>>  
>> -		dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
>> -				 DMA_TO_DEVICE);
>> -		kfree(mr->descs_alloc);
>> -		mr->descs = NULL;
>> -	}
>> +	if (!mr->descs)
>> +		return;
>> +
>> +	dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
>> +			 DMA_TO_DEVICE);
>> +	kfree(mr->descs_alloc);
>> +	mr->descs = NULL;
>>  }
>>  
>>  int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
>> @@ -1999,7 +1998,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
>>  	if (mr->cache_ent) {
>>  		mlx5_mr_cache_free(dev, mr);
>>  	} else {
>> -		mlx5_free_priv_descs(mr);
>> +		if (!udata)
>> +			mlx5_free_priv_descs(mr);
>>  		kfree(mr);
>>  	}
>>  	return 0;
>> @@ -2086,7 +2086,6 @@ static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd,
>>  	if (err)
>>  		goto err_free_in;
>>  
>> -	mr->umem = NULL;
>>  	kfree(in);
>>  
>>  	return mr;
>> @@ -2213,7 +2212,6 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
>>  	}
>>  
>>  	mr->ibmr.device = pd->device;
>> -	mr->umem = NULL;
>>  
>>  	switch (mr_type) {
>>  	case IB_MR_TYPE_MEM_REG:
> 
