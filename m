Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5555D2B41B1
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 11:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgKPKre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 05:47:34 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:8944 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgKPKre (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 05:47:34 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGAbJbu017760;
        Mon, 16 Nov 2020 11:47:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=ZnFMeOsKLgn0Gfn0T/aAv7kklPoIvURiSXIZWk2Z01I=;
 b=uik4X0nCyvzFs6usxbIyAHGmsY18uLomUO3eqmzoq8mPdJFLaCBkMcXCWAI3K6paJQzA
 bLv7QazcOlv9CGhejn15zM05SJbrsFyaxlg5g/bcDdgU7i0SgZM7MYNav6KQDvR96T21
 t/u1SqJ0K4/WlJBFMWNcGdtUaEBEmNogUBgDb/BhMsXTC+JN2BoTafVRop8dB/Optur7
 BGr0ijplwNRfNyZRnbgsUUz3tg1zGGAc+d4fzVuJwFflBbFCq/fpFxHLCbC3t28WzF0B
 BOmd1PzXmyN0Dv39/rQmC1O1+RAdJU1GNj7dPdX/qG5mApkYLAntx+5R7/JsIjKEqawO Tw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34t5k4tbbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 11:47:04 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C9FA710002A;
        Mon, 16 Nov 2020 11:47:01 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9D869251AEB;
        Mon, 16 Nov 2020 11:47:01 +0100 (CET)
Received: from lmecxl0889.lme.st.com (10.75.127.50) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Nov
 2020 11:47:00 +0100
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
To:     Christoph Hellwig <hch@infradead.org>,
        Alexander Lobakin <alobakin@pm.me>
CC:     Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
From:   Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Message-ID: <ca183081-5a9f-0104-bf79-5fea544c9271@st.com>
Date:   Mon, 16 Nov 2020 11:46:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116091950.GA30524@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG3NODE1.st.com
 (10.75.127.7)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_03:2020-11-13,2020-11-16 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

On 11/16/20 10:19 AM, Christoph Hellwig wrote:
> I just noticed this showing up in Linus' tree and I'm not happy.
> 
> This whole model of the DMA subdevices in remoteproc is simply broken.
> 
> We really need to change the virtio code pass an expicit DMA device (
> similar to what e.g. the USB and RDMA code does), instead of faking up
> devices with broken adhoc inheritance of DMA properties and magic poking
> into device parent relationships.

For your formation I started some stuff on my side to be able to declare the
virtio device in DT as a remoteproc child node.

https://lkml.org/lkml/2020/4/16/1817

Quite big refactoring, but could be a way to answer...

Regards,
Arnaud

> 
> Bjorn, I thought you were going to look into this a while ago?


> 
> 
> On Wed, Nov 04, 2020 at 03:31:36PM +0000, Alexander Lobakin wrote:
>> Since commit 086d08725d34 ("remoteproc: create vdev subdevice with
>> specific dma memory pool"), every remoteproc has a DMA subdevice
>> ("remoteprocX#vdevYbuffer") for each virtio device, which inherits
>> DMA capabilities from the corresponding platform device. This allowed
>> to associate different DMA pools with each vdev, and required from
>> virtio drivers to perform DMA operations with the parent device
>> (vdev->dev.parent) instead of grandparent (vdev->dev.parent->parent).
>>
>> virtio_rpmsg_bus was already changed in the same merge cycle with
>> commit d999b622fcfb ("rpmsg: virtio: allocate buffer from parent"),
>> but virtio_console did not. In fact, operations using the grandparent
>> worked fine while the grandparent was the platform device, but since
>> commit c774ad010873 ("remoteproc: Fix and restore the parenting
>> hierarchy for vdev") this was changed, and now the grandparent device
>> is the remoteproc device without any DMA capabilities.
>> So, starting v5.8-rc1 the following warning is observed:
>>
>> [    2.483925] ------------[ cut here ]------------
>> [    2.489148] WARNING: CPU: 3 PID: 101 at kernel/dma/mapping.c:427 0x80e7eee8
>> [    2.489152] Modules linked in: virtio_console(+)
>> [    2.503737]  virtio_rpmsg_bus rpmsg_core
>> [    2.508903]
>> [    2.528898] <Other modules, stack and call trace here>
>> [    2.913043]
>> [    2.914907] ---[ end trace 93ac8746beab612c ]---
>> [    2.920102] virtio-ports vport1p0: Error allocating inbufs
>>
>> kernel/dma/mapping.c:427 is:
>>
>> WARN_ON_ONCE(!dev->coherent_dma_mask);
>>
>> obviously because the grandparent now is remoteproc dev without any
>> DMA caps:
>>
>> [    3.104943] Parent: remoteproc0#vdev1buffer, grandparent: remoteproc0
>>
>> Fix this the same way as it was for virtio_rpmsg_bus, using just the
>> parent device (vdev->dev.parent, "remoteprocX#vdevYbuffer") for DMA
>> operations.
>> This also allows now to reserve DMA pools/buffers for rproc serial
>> via Device Tree.
>>
>> Fixes: c774ad010873 ("remoteproc: Fix and restore the parenting hierarchy for vdev")
>> Cc: stable@vger.kernel.org # 5.1+
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>  drivers/char/virtio_console.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
>> index a2da8f768b94..1836cc56e357 100644
>> --- a/drivers/char/virtio_console.c
>> +++ b/drivers/char/virtio_console.c
>> @@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size
>>  		/*
>>  		 * Allocate DMA memory from ancestor. When a virtio
>>  		 * device is created by remoteproc, the DMA memory is
>> -		 * associated with the grandparent device:
>> -		 * vdev => rproc => platform-dev.
>> +		 * associated with the parent device:
>> +		 * virtioY => remoteprocX#vdevYbuffer.
>>  		 */
>> -		if (!vdev->dev.parent || !vdev->dev.parent->parent)
>> +		buf->dev = vdev->dev.parent;
>> +		if (!buf->dev)
>>  			goto free_buf;
>> -		buf->dev = vdev->dev.parent->parent;
>>  
>>  		/* Increase device refcnt to avoid freeing it */
>>  		get_device(buf->dev);
>> -- 
>> 2.29.2
>>
>>
> ---end quoted text---
> 
