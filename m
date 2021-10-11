Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A68428E7F
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhJKNsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:48:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32410 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233144AbhJKNsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 09:48:03 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BDg5qN010407;
        Mon, 11 Oct 2021 09:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KNCbvxOv4HZOMGLoYWRwmVJ86+IBx86BffwVvgZzZfM=;
 b=acxv02kMMcwO68CNwY5tUrc8w7xMPAxFL0gd8arDEBjoMjyZzm4yCw7Vf9Q25pCcZcZF
 4mrQdT/maMBBkbTSo8vVYqMdNFd2CwGUxSrWCeYe93nxZXK004WSGvzk7aGjEXKZEmVS
 8GXvOgsjEB9Ycbgt61Gf1w2NWn/yJFe6qGPZDpLYsQdzrrok8FafTBR7GMfw9cyieTDB
 FuQq1CoIMSUuqlhy1JU1V7hYYSZC/PR99BWTzrpS8aPY3jMpwRBkgXKJ/mGUi2uve+ZE
 P4Ahz0WPUKN6Bahixtl0cxifm5tIe6ZpyNm9uQW9CmsJNYfoFDLJIVriRM7FZZ86ZRo6 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmpcm037f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 09:46:03 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19BDgVuE010992;
        Mon, 11 Oct 2021 09:46:02 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmpcm036q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 09:46:02 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BDcf6s004391;
        Mon, 11 Oct 2021 13:46:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3bk2q9d3mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 13:46:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BDjufC3146446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 13:45:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CA8BAE061;
        Mon, 11 Oct 2021 13:45:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D99DAE058;
        Mon, 11 Oct 2021 13:45:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.40.188])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Oct 2021 13:45:55 +0000 (GMT)
Subject: Re: [RFC PATCH 1/1] s390/cio: make ccw_device_dma_* more robust
To:     Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, bfu@redhat.com
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
Date:   Mon, 11 Oct 2021 15:45:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211011115955.2504529-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IWzA1ARGY-O7cWGTjfAacpDTC4wcb-Og
X-Proofpoint-GUID: nOqrVsdteWAgsF5pMM1XMuIR6dxFFz9B
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1011 adultscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110078
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/11/21 1:59 PM, Halil Pasic wrote:
> Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
> classic notifiers") we were supposed to make sure that
> virtio_ccw_release_dev() completes before the ccw device and the
> attached dma pool are torn down, but unfortunately we did not.  Before
> that commit it used to be OK to delay cleaning up the memory allocated
> by virtio-ccw indefinitely (which isn't really intuitive for guys used
> to destruction happens in reverse construction order), but now we
> trigger a BUG_ON if the genpool is destroyed before all memory allocated
> form it. Which brings down the guest. We can observe this problem, when
> unregister_virtio_device() does not give up the last reference to the
> virtio_device (e.g. because a virtio-scsi attached scsi disk got removed
> without previously unmounting its previously mounted  partition).
> 
> To make sure that the genpool is only destroyed after all the necessary
> freeing is done let us take a reference on the ccw device on each
> ccw_device_dma_zalloc() and give it up on each ccw_device_dma_free().
> 
> Actually there are multiple approaches to fixing the problem at hand
> that can work. The upside of this one is that it is the safest one while
> remaining simple. We don't crash the guest even if the driver does not
> pair allocations and frees. The downside is the reference counting
> overhead, that the reference counting for ccw devices becomes more
> complex, in a sense that we need to pair the calls to the aforementioned
> functions for it to be correct, and that if we happen to leak, we leak
> more than necessary (the whole ccw device instead of just the genpool).
> 
> Some alternatives to this approach are taking a reference in
> virtio_ccw_online() and giving it up in virtio_ccw_release_dev() or
> making sure virtio_ccw_release_dev() completes its work before
> virtio_ccw_remove() returns. The downside of these approaches is that
> these are less safe against programming errors.
> 
> Cc: <stable@vger.kernel.org> # v5.3
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
> classic notifiers")
> Reported-by: bfu@redhat.com
> 
> ---
> 
> FYI I've proposed a different fix to this very same problem:
> https://lore.kernel.org/lkml/20210915215742.1793314-1-pasic@linux.ibm.com/
> 
> This patch is more or less a result of that discussion.
> ---
>   drivers/s390/cio/device_ops.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
> index 0fe7b2f2e7f5..c533d1dadc6b 100644
> --- a/drivers/s390/cio/device_ops.c
> +++ b/drivers/s390/cio/device_ops.c
> @@ -825,13 +825,23 @@ EXPORT_SYMBOL_GPL(ccw_device_get_chid);
>    */
>   void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
>   {
> -	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
> +	void *addr;
> +
> +	if (!get_device(&cdev->dev))
> +		return NULL;
> +	addr = cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
> +	if (IS_ERR_OR_NULL(addr))

I can be wrong but it seems that only dma_alloc_coherent() used in 
cio_gp_dma_zalloc() report an error but the error is ignored and used as 
a valid pointer.

So shouldn't we modify this function and just test for a NULL address here?

here what I mean:---------------------------------

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 2bc55ccf3f23..b45fbaa7131b 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -1176,7 +1176,7 @@ void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, 
struct device *dma_dev,
                 chunk_size = round_up(size, PAGE_SIZE);
                 addr = (unsigned long) dma_alloc_coherent(dma_dev,
                                          chunk_size, &dma_addr, 
CIO_DMA_GFP);
-               if (!addr)
+               if (IS_ERR_OR_NULL(addr))
                         return NULL;
                 gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
                 addr = gen_pool_alloc(gp_dma, size);

---------------------------------

> +		put_device(&cdev->dev);

addr is not null if addr is ERR.

> +	return addr;

may be return IS_ERR_OR_NULL(addr)? NULL : addr;

>   }
>   EXPORT_SYMBOL(ccw_device_dma_zalloc);
>   
>   void ccw_device_dma_free(struct ccw_device *cdev, void *cpu_addr, size_t size)
>   {
> +	if (!cpu_addr)
> +		return;

no need, cpu_addr is already tested in cio_gp_dma_free()

>   	cio_gp_dma_free(cdev->private->dma_pool, cpu_addr, size);
> +	put_device(&cdev->dev);
>   }
>   EXPORT_SYMBOL(ccw_device_dma_free);
>   
> 
> base-commit: 64570fbc14f8d7cb3fe3995f20e26bc25ce4b2cc
> 

-- 
Pierre Morel
IBM Lab Boeblingen
