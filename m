Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC0474594
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhLNOwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:52:03 -0500
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:36961
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230350AbhLNOwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 09:52:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj13B254QTQi7t284EddrDpwTVVmbnmdlwxuzTxwWLVk8dxA7mNPna0lmpvA0LFHcvxgqfbhk54o5ZLgpoXsOfzFVaCl1yElMTNGX1IUc0DaUOH4rRVMioXYyfDrFDLgQbVqlQh2ezCzjfsls53GYUtvoij9D3OrMb3LClLiaonMWEInp477IHbsEIQloTkYVUzn3sSnqlzxFiRYjqNHCJLR6BPAeWrV48mQdNFWR/TqkpHXhh0dEKBe+4ZHWCc6U7tkJyRFKbh9f22g0D0QnI7wjNcJCjDOF/Pdt5d0WjxHQt7p51BnGRb6PiGxS+CWCBS63PF02SMgXyQN3b/0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIR1Vz6ITBaCk6RaPrxl0OGkg81nldnyZoJKWX6a9O4=;
 b=Bch+NNdw12eN0mR0Fh3tDMou+Zb++O6ZsH5C2UDJe2X7qQg5z4tIJ1+CKvJTMfAMHNnwoVmTBije84ceCBwFOPBgfKX2P6OFMb5MxbdCbj07Oq4pERRMKAX6uGhkDzTOHDQI79w9GqgUgO9NTKBbekF5Oi57Pn1J1DMf1HyYj9QiYftlCa9YmEh+Fs8ltNBrLnvzsFywNiTtvq2i8n8pSkgq8geAU7ClCkKRcrLUNdQUHIyfL8W0+GL8F8TzKzpItjNIu0DBpjz+jIGslQFXjQTvNReHJrzW3egffX+HEjfWVmB5dKV+ErN4b+tYOePOB+c5q3LLtSRKANBo3+gZ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIR1Vz6ITBaCk6RaPrxl0OGkg81nldnyZoJKWX6a9O4=;
 b=qphP7ainWp2lGo4wKR7ORTz2L/FF21B+mPAq0zwmli7CVoppnvQFA9rXVLsUiCsWIeaFChy1jCR0u6TJ4MCrQUlFiUNtWY+u+wF9ilJP1HtMkgcOHnhzS3Hxy6aXW9wt8T2V03mO+riXKBupv9w61GiMSkEV0m/w4JonY9s9Jgo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14) by MW2PR12MB2491.namprd12.prod.outlook.com
 (2603:10b6:907:f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Tue, 14 Dec
 2021 14:51:59 +0000
Received: from MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4]) by MWHPR1201MB0192.namprd12.prod.outlook.com
 ([fe80::d16c:a6d5:5d2e:f9d4%12]) with mapi id 15.20.4778.018; Tue, 14 Dec
 2021 14:51:59 +0000
Subject: Re: [PATCH] tee: handle lookup of shm with reference count 0
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>,
        Patrik Lantz <patrik.lantz@axis.com>
References: <20211214123540.1789434-1-jens.wiklander@linaro.org>
 <YbifvnSBjW5m19hZ@kroah.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <0b974205-4420-52b9-7491-38e830a93bc4@amd.com>
Date:   Tue, 14 Dec 2021 15:51:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YbifvnSBjW5m19hZ@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR0P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::11) To MWHPR1201MB0192.namprd12.prod.outlook.com
 (2603:10b6:301:5a::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5bff0e3-ff1c-499c-b085-08d9bf1147b7
X-MS-TrafficTypeDiagnostic: MW2PR12MB2491:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB24917476A43D8973299901C083759@MW2PR12MB2491.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCxM7k2bDHbBtCaOI7xh60EueacrDjjD/q+vDW/BmwQ/bQNfaKmXvA3uoAItFLa7D7yVXTJTCckX9Wo7gp5vLfye0HYeQaj00IZ3W9xNYguU3dD8ZUTWKZM90SmSE6zA0v5/nT6+fNedeZzLjkrvmfao9HwWcaEJIBlSCg6Y7D4XEZL+vrFUUK2hZ/dprAiMrVruYK//OWu4LEY1Ru3B+WDXeTj84NmPhwAh66uIz5AO0BOc0UNSXpnvIaUTnQQWTELhncFh8Knk6ES1QIW3JA/VfuqQa5kduMn8dicI5iPD2Qd1cYKv3d624Z5ttK0vLHtwqndBTewY0TcMQZleHoLLYB6VJuORP678AlgsyKGTHE/Ok4JioYdtssR5AT5VhgsOHfj1OQNRi5ppJSR4W2B6AmhtFek1W3CWBnFc/TGeEP/yRKszBJ+L2rSUgNMFSe83AbSx56TCH+gcZpQVIUyAA9WGm6gXm8yWZMHODJ/NlEPPFBpv9RcpoKZTqG35C75jl06GrabX4xp7BfPOEH3ArD/3XpZqj0oLjBDTK2lax5UqmJsit5DwZNrVcbQXhrWWAeJiOHJ5FPp1Ua/OMd4CUt3IlNd5D20+vtkmsR4mixnokLUNzDaYnStdZPdrug2PjG2yu3QWX6AyWIpvUQxYTUf9YN6TGKlShye+tV8QTsuxfkFXm7XVs+B0uYBYRALyKwsJ2+bpJArXJ3Z6oGV1nTF++kdaNdYPXJSkVAaMOGof5hnllBwxakAzM/K3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1201MB0192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(2906002)(54906003)(38100700002)(36756003)(5660300002)(316002)(30864003)(2616005)(110136005)(8936002)(66946007)(66476007)(6506007)(86362001)(508600001)(6666004)(6486002)(6512007)(83380400001)(186003)(66556008)(4326008)(8676002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXdIaGc3QnJoWHF3eG1PcWRsUmY0UzRncjhkUjdKNzdzNGxSYXFCRHdMMW1p?=
 =?utf-8?B?OC9JTVI2YkF2N0tFd3V0NmVjZXlyVGZ4dU1RSDZIb0ZqMDNQemg0Njl0M04y?=
 =?utf-8?B?cEZVUEhOTkVkWXNVaExoRDYwTTl1MW94TXRJRUlEbUZPMFhZTld5dDNUWC9E?=
 =?utf-8?B?STRQeFpOM01XN2xVU2UvcE15ZHl0KzJiRTVtV0tGMFlCalQrSVgwbGd0eHR3?=
 =?utf-8?B?WVR2UHc1dzQ2VlROdFR1M1EwTmIxSjJHbnlvUEc5cEFmU1ZFajJ6ZHZCZm94?=
 =?utf-8?B?ZDlOc0xkUzk1TDhrdTJkZ1plK2JURWhIQmRWMit2dDRRb3RteU9RWEd6Y21F?=
 =?utf-8?B?d1BiZms1clV1OC9JYlVQeDIyQUVyTkVOb1FpSWExZjdrT1lrTnFMZDNWUmlN?=
 =?utf-8?B?aFpPM1BxcHdwRTN0M1hPclo2WHhNNTNUQy82aTN3RVFFRTlYNU1RYy9mWERu?=
 =?utf-8?B?MlNPdzhjS3BGUW5hUkJqbjQxU3V6YjhBcHg1dng1Q3dCL3RjMDFkNlFPb21x?=
 =?utf-8?B?Nm5yU1M3YjNGUGFVVW11aWR0NnJnUTNJOEFwWndyQUZ1dC8rbk5LcTlQc2Ur?=
 =?utf-8?B?ZXkvaXZac21Eb3BOb0NzRzZ4M3VaN1ZURE52M1NpMW54M3Uzb2ZZSTV1M2Uw?=
 =?utf-8?B?OEs2c2l0THhMVmZFbDFvUk00cCtwaXZ3QklQUlJJZFJ1N1dmRVp2ZjNJSGxv?=
 =?utf-8?B?K2VnYXZOTHc1MWZrNnFNdG1TM0tWYlNsNUs3RW9iWGtEeVpIbm9ZNENUQ0hN?=
 =?utf-8?B?RlZITE9KWElXQ3BaVTh4N282Sk1KaFkzb1FtbnhjZHlieEVNRlZjUTNKR0wz?=
 =?utf-8?B?ck4yclV0d3cyNGh2bk5JcEtmVXpWN2x6cmE3MWh0dm5hbDJsUUVndTVBQnY5?=
 =?utf-8?B?MkZVQXV5ZXJ3WXVCSHBRczZXSUpnemJqbENuSTFYYUdQV0tvRitjNEVOSjNs?=
 =?utf-8?B?T2VkZlN0UDBHeFM3QmlTWEl6MGlhSDkwWFJHR0YxaW4wcS8yL090OFp0N1Jr?=
 =?utf-8?B?cjluTWFHK0oxNWQzWkFmc25TbTFNT3cyWmVqUStSMzBBR0R2U0NxOFRlMkI5?=
 =?utf-8?B?M0JwL2hTZ2hhT1R5aGVGZmk4RGcydU15b2JDaWUzdWoxQkJvSVc0SXZWZ01O?=
 =?utf-8?B?M2lqNFZzd1dsekI5YVZQNXZ0Rk1Id2gzcnZNQTR1ZTdZRzlGS3h6NXNzTC93?=
 =?utf-8?B?UHUrYVk2Z1pKSVgzZERZY2s4NTNPSCs2aGlIbXI0LzU2dGM1QTFNeWswYXVm?=
 =?utf-8?B?Q3hvTld6QllWWkxpcDNpck9ONjVoRFlzVGRRNGRtRDB6c3I1WEtlUUFZVCtr?=
 =?utf-8?B?dE1vbndPcWpRNUwyY3VWaEdkb3NFMFVHSUdReHlxNm1wc2w0ZUdqYmY4TUhi?=
 =?utf-8?B?SGprY0s0TmxWQW11V255bVp4RjBiUnZFV2ZyZ2pWTCtoZjZHQUhKYkRYdVlK?=
 =?utf-8?B?cnhGRTBsUEJZTjV6K01XNWtxalAvRkl1Q2MrdzdVZkZ6dGl2YmJVK3RGUnBM?=
 =?utf-8?B?UXpuYjhMZFllU3Q2Si84aVZmMlJWY3J1aTlwdks3R2NRTmFYeDZjUFB0U1pr?=
 =?utf-8?B?eUFzLytDTUJ5MWRCNWFvRDRZYlkxRWtaN0ZKbzBQbGVrb3dJNkswaGhYUnc3?=
 =?utf-8?B?T3RrbWYwWnRIaWtKNDJyVFNIZVZmZkMvcUxjREQ5blI2TUhJSHZtSnFNWXdU?=
 =?utf-8?B?RVBvMnFQZzkrMnBlcFhlNFdqd1dKamVTM05DMC9pNGxkQysvM3hMdU1ycFJF?=
 =?utf-8?B?bHpmS0k0emlJSFc5N1luTExBaEJtbVVocEdlS2pVd3ovT05lbk1SWkQwdGUx?=
 =?utf-8?B?WFN2dkc0alA1MGovNTMrN0pDelh2b2pGVHA0NytyeE56M1RkRzBPeXpydDJv?=
 =?utf-8?B?MndNTWFKeDExMWtWVWlzL01LWHVBcXhIRFNpZHc4Ui9uSlNZQzVISVNvOGxK?=
 =?utf-8?B?NTZEWi9Oa1RDM1lRbGpjMmphM2NUKzFtSW9KNlhYRHgwY09lVzFsSXNDU0xB?=
 =?utf-8?B?Q2xzMUVFSlB6WnVBcmlEZWgxMzFVaVNybzlOdTAzUDJBQW9oTFBvQmZIV3pI?=
 =?utf-8?B?cGRjTzlxSk5wU1BxYkVhTE5SeXlybjhxZkEwNHlVZVNEcUxHdG1SMEVHbjI1?=
 =?utf-8?B?ZzdZVW5tQXBZVTJIYWdjdURyY2NkL2xuelExc0JBS21kTlpHMFVzZUw3dDQw?=
 =?utf-8?Q?tlhewkHM8skPEy5kW/f5rd4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bff0e3-ff1c-499c-b085-08d9bf1147b7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1201MB0192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:51:59.0394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zw/fXoPNKjGXsU8KJhcVXaaxv2oXt9pQlsUPx7FdKTlH9Me9jLn2fJ83TfOoGUiT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2491
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 14.12.21 um 14:44 schrieb Greg KH:
> On Tue, Dec 14, 2021 at 01:35:40PM +0100, Jens Wiklander wrote:
>> Since the tee subsystem does not keep a strong reference to its idle
>> shared memory buffers, it races with other threads that try to destroy a
>> shared memory through a close of its dma-buf fd or by unmapping the
>> memory.
>>
>> In tee_shm_get_from_id() when a lookup in teedev->idr has been
>> successful, it is possible that the tee_shm is in the dma-buf teardown
>> path, but that path is blocked by the teedev mutex. Since we don't have
>> an API to tell if the tee_shm is in the dma-buf teardown path or not we
>> must find another way of detecting this condition.
>>
>> Fix this by doing the reference counting directly on the tee_shm using a
>> new refcount_t refcount field. dma-buf is replaced by using
>> anon_inode_getfd() instead, this separates the life-cycle of the
>> underlying file from the tee_shm. tee_shm_put() is updated to hold the
>> mutex when decreasing the refcount to 0 and then remove the tee_shm from
>> teedev->idr before releasing the mutex. This means that the tee_shm can
>> never be found unless it has a refcount larger than 0.
> So you are dropping dma-buf support entirely?  And anon_inode_getfd()
> works instead?  Why do more people not do this as well?

Well, I assume that mostly everybody else actually implements DMA-buf 
support and not just stubs for the callback function which rejects 
everybody trying to use it with an error.

So yeah, dropping it completely and using an anon file descriptor 
instead sounds totally like the right thing to do. Especially since the 
resulting implementation looks simpler over all.

Christian.

>> Fixes: 967c9cca2cc5 ("tee: generic TEE subsystem")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Lars Persson <larper@axis.com>
>> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
>> Reported-by: Patrik Lantz <patrik.lantz@axis.com>
>> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
>> ---
>>   drivers/tee/tee_shm.c   | 174 +++++++++++++++-------------------------
>>   include/linux/tee_drv.h |   2 +-
>>   2 files changed, 67 insertions(+), 109 deletions(-)
>>
>> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
>> index 8a8deb95e918..0c82cf981c46 100644
>> --- a/drivers/tee/tee_shm.c
>> +++ b/drivers/tee/tee_shm.c
>> @@ -1,20 +1,17 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>>   /*
>> - * Copyright (c) 2015-2016, Linaro Limited
>> + * Copyright (c) 2015-2021, Linaro Limited
> Nit, did Linaro really make a copyrightable change in 2017, 2018, 2019
> and 2020 as well?  If not, please do not claim it.
>
>>    */
>> +#include <linux/anon_inodes.h>
>>   #include <linux/device.h>
>> -#include <linux/dma-buf.h>
>> -#include <linux/fdtable.h>
>>   #include <linux/idr.h>
>> +#include <linux/mm.h>
>>   #include <linux/sched.h>
>>   #include <linux/slab.h>
>>   #include <linux/tee_drv.h>
>>   #include <linux/uio.h>
>> -#include <linux/module.h>
>>   #include "tee_private.h"
>>   
>> -MODULE_IMPORT_NS(DMA_BUF);
>> -
>>   static void release_registered_pages(struct tee_shm *shm)
>>   {
>>   	if (shm->pages) {
>> @@ -31,16 +28,8 @@ static void release_registered_pages(struct tee_shm *shm)
>>   	}
>>   }
>>   
>> -static void tee_shm_release(struct tee_shm *shm)
>> +static void tee_shm_release(struct tee_device *teedev, struct tee_shm *shm)
>>   {
>> -	struct tee_device *teedev = shm->ctx->teedev;
>> -
>> -	if (shm->flags & TEE_SHM_DMA_BUF) {
>> -		mutex_lock(&teedev->mutex);
>> -		idr_remove(&teedev->idr, shm->id);
>> -		mutex_unlock(&teedev->mutex);
>> -	}
>> -
>>   	if (shm->flags & TEE_SHM_POOL) {
>>   		struct tee_shm_pool_mgr *poolm;
>>   
>> @@ -67,45 +56,6 @@ static void tee_shm_release(struct tee_shm *shm)
>>   	tee_device_put(teedev);
>>   }
>>   
>> -static struct sg_table *tee_shm_op_map_dma_buf(struct dma_buf_attachment
>> -			*attach, enum dma_data_direction dir)
>> -{
>> -	return NULL;
>> -}
>> -
>> -static void tee_shm_op_unmap_dma_buf(struct dma_buf_attachment *attach,
>> -				     struct sg_table *table,
>> -				     enum dma_data_direction dir)
>> -{
>> -}
>> -
>> -static void tee_shm_op_release(struct dma_buf *dmabuf)
>> -{
>> -	struct tee_shm *shm = dmabuf->priv;
>> -
>> -	tee_shm_release(shm);
>> -}
>> -
>> -static int tee_shm_op_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
>> -{
>> -	struct tee_shm *shm = dmabuf->priv;
>> -	size_t size = vma->vm_end - vma->vm_start;
>> -
>> -	/* Refuse sharing shared memory provided by application */
>> -	if (shm->flags & TEE_SHM_USER_MAPPED)
>> -		return -EINVAL;
>> -
>> -	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
>> -			       size, vma->vm_page_prot);
>> -}
>> -
>> -static const struct dma_buf_ops tee_shm_dma_buf_ops = {
>> -	.map_dma_buf = tee_shm_op_map_dma_buf,
>> -	.unmap_dma_buf = tee_shm_op_unmap_dma_buf,
>> -	.release = tee_shm_op_release,
>> -	.mmap = tee_shm_op_mmap,
>> -};
>> -
>>   struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>>   {
>>   	struct tee_device *teedev = ctx->teedev;
>> @@ -140,6 +90,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>>   		goto err_dev_put;
>>   	}
>>   
>> +	refcount_set(&shm->refcount, 1);
>>   	shm->flags = flags | TEE_SHM_POOL;
>>   	shm->ctx = ctx;
>>   	if (flags & TEE_SHM_DMA_BUF)
>> @@ -153,10 +104,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>>   		goto err_kfree;
>>   	}
>>   
>> -
>>   	if (flags & TEE_SHM_DMA_BUF) {
>> -		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>> -
>>   		mutex_lock(&teedev->mutex);
>>   		shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
>>   		mutex_unlock(&teedev->mutex);
>> @@ -164,28 +112,11 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>>   			ret = ERR_PTR(shm->id);
>>   			goto err_pool_free;
>>   		}
>> -
>> -		exp_info.ops = &tee_shm_dma_buf_ops;
>> -		exp_info.size = shm->size;
>> -		exp_info.flags = O_RDWR;
>> -		exp_info.priv = shm;
>> -
>> -		shm->dmabuf = dma_buf_export(&exp_info);
>> -		if (IS_ERR(shm->dmabuf)) {
>> -			ret = ERR_CAST(shm->dmabuf);
>> -			goto err_rem;
>> -		}
>>   	}
>>   
>>   	teedev_ctx_get(ctx);
>>   
>>   	return shm;
>> -err_rem:
>> -	if (flags & TEE_SHM_DMA_BUF) {
>> -		mutex_lock(&teedev->mutex);
>> -		idr_remove(&teedev->idr, shm->id);
>> -		mutex_unlock(&teedev->mutex);
>> -	}
>>   err_pool_free:
>>   	poolm->ops->free(poolm, shm);
>>   err_kfree:
>> @@ -246,6 +177,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>>   		goto err;
>>   	}
>>   
>> +	refcount_set(&shm->refcount, 1);
>>   	shm->flags = flags | TEE_SHM_REGISTER;
>>   	shm->ctx = ctx;
>>   	shm->id = -1;
>> @@ -306,22 +238,6 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>>   		goto err;
>>   	}
>>   
>> -	if (flags & TEE_SHM_DMA_BUF) {
>> -		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>> -
>> -		exp_info.ops = &tee_shm_dma_buf_ops;
>> -		exp_info.size = shm->size;
>> -		exp_info.flags = O_RDWR;
>> -		exp_info.priv = shm;
>> -
>> -		shm->dmabuf = dma_buf_export(&exp_info);
>> -		if (IS_ERR(shm->dmabuf)) {
>> -			ret = ERR_CAST(shm->dmabuf);
>> -			teedev->desc->ops->shm_unregister(ctx, shm);
>> -			goto err;
>> -		}
>> -	}
>> -
>>   	return shm;
>>   err:
>>   	if (shm) {
>> @@ -339,6 +255,35 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>>   }
>>   EXPORT_SYMBOL_GPL(tee_shm_register);
>>   
>> +static int tee_shm_fop_release(struct inode *inode, struct file *filp)
>> +{
>> +	tee_shm_put(filp->private_data);
>> +	return 0;
>> +}
>> +
>> +static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
>> +{
>> +	struct tee_shm *shm = filp->private_data;
>> +	size_t size = vma->vm_end - vma->vm_start;
>> +
>> +	/* Refuse sharing shared memory provided by application */
>> +	if (shm->flags & TEE_SHM_USER_MAPPED)
>> +		return -EINVAL;
>> +
>> +	/* check for overflowing the buffer's size */
>> +	if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
>> +		return -EINVAL;
>> +
>> +	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
>> +			       size, vma->vm_page_prot);
>> +}
>> +
>> +static const struct file_operations tee_shm_fops = {
>> +	.owner = THIS_MODULE,
>> +	.release = tee_shm_fop_release,
>> +	.mmap = tee_shm_fop_mmap,
>> +};
>> +
>>   /**
>>    * tee_shm_get_fd() - Increase reference count and return file descriptor
>>    * @shm:	Shared memory handle
>> @@ -351,10 +296,11 @@ int tee_shm_get_fd(struct tee_shm *shm)
>>   	if (!(shm->flags & TEE_SHM_DMA_BUF))
>>   		return -EINVAL;
>>   
>> -	get_dma_buf(shm->dmabuf);
>> -	fd = dma_buf_fd(shm->dmabuf, O_CLOEXEC);
>> +	/* matched by tee_shm_put() in tee_shm_op_release() */
>> +	refcount_inc(&shm->refcount);
>> +	fd = anon_inode_getfd("tee_shm", &tee_shm_fops, shm, O_RDWR);
>>   	if (fd < 0)
>> -		dma_buf_put(shm->dmabuf);
>> +		tee_shm_put(shm);
>>   	return fd;
>>   }
>>   
>> @@ -364,17 +310,7 @@ int tee_shm_get_fd(struct tee_shm *shm)
>>    */
>>   void tee_shm_free(struct tee_shm *shm)
>>   {
>> -	/*
>> -	 * dma_buf_put() decreases the dmabuf reference counter and will
>> -	 * call tee_shm_release() when the last reference is gone.
>> -	 *
>> -	 * In the case of driver private memory we call tee_shm_release
>> -	 * directly instead as it doesn't have a reference counter.
>> -	 */
>> -	if (shm->flags & TEE_SHM_DMA_BUF)
>> -		dma_buf_put(shm->dmabuf);
>> -	else
>> -		tee_shm_release(shm);
>> +	tee_shm_put(shm);
>>   }
>>   EXPORT_SYMBOL_GPL(tee_shm_free);
>>   
>> @@ -481,10 +417,15 @@ struct tee_shm *tee_shm_get_from_id(struct tee_context *ctx, int id)
>>   	teedev = ctx->teedev;
>>   	mutex_lock(&teedev->mutex);
>>   	shm = idr_find(&teedev->idr, id);
>> +	/*
>> +	 * If the tee_shm was found in the IDR it must have a refcount
>> +	 * larger than 0 due to the guarantee in tee_shm_put() below. So
>> +	 * it's safe to use refcount_inc().
>> +	 */
>>   	if (!shm || shm->ctx != ctx)
>>   		shm = ERR_PTR(-EINVAL);
>> -	else if (shm->flags & TEE_SHM_DMA_BUF)
>> -		get_dma_buf(shm->dmabuf);
>> +	else
>> +		refcount_inc(&shm->refcount);
>>   	mutex_unlock(&teedev->mutex);
>>   	return shm;
>>   }
>> @@ -496,7 +437,24 @@ EXPORT_SYMBOL_GPL(tee_shm_get_from_id);
>>    */
>>   void tee_shm_put(struct tee_shm *shm)
>>   {
>> -	if (shm->flags & TEE_SHM_DMA_BUF)
>> -		dma_buf_put(shm->dmabuf);
>> +	struct tee_device *teedev = shm->ctx->teedev;
>> +	bool do_release = false;
>> +
>> +	mutex_lock(&teedev->mutex);
>> +	if (refcount_dec_and_test(&shm->refcount)) {
>> +		/*
>> +		 * refcount has reached 0, we must now remove it from the
>> +		 * IDR before releasing the mutex. This will guarantee that
>> +		 * the refcount_inc() in tee_shm_get_from_id() never starts
>> +		 * from 0.
>> +		 */
>> +		if (shm->flags & TEE_SHM_DMA_BUF)
>> +			idr_remove(&teedev->idr, shm->id);
>> +		do_release = true;
> As you are using a refcount in the "traditional" way, why not just use a
> kref instead?  That solves your "do_release" mess here.
>
> thanks,
>
> greg k-h

