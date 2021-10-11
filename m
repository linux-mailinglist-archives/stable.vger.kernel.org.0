Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC794291F2
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237438AbhJKOgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236626AbhJKOgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 10:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633962839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mjdKdphfY7KPZN5wR0QNaH0Etrrinh6FGNhtNUHIDSg=;
        b=VP3BEl7XYan3TWGoPP6gwqrQOUaoiHF5tZs9K2MM6ZzTN/LMVSfczz6hv4K91AvwmoBebc
        WjVRlFAQavFXCDkPWiuP2iARdYZayypZyrm9ks2RS2p/7rjDNuF1+sqyaOn3tAW5L7Bg6r
        yJG3ntzwUyfTnse5B4BZENsShQeF35o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-De9s4r4PNaWkljdQSEIPzg-1; Mon, 11 Oct 2021 10:33:54 -0400
X-MC-Unique: De9s4r4PNaWkljdQSEIPzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84A571007302;
        Mon, 11 Oct 2021 14:33:47 +0000 (UTC)
Received: from localhost (unknown [10.39.193.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26D3B5D6D5;
        Mon, 11 Oct 2021 14:33:46 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, bfu@redhat.com
Subject: Re: [RFC PATCH 1/1] s390/cio: make ccw_device_dma_* more robust
In-Reply-To: <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
Organization: Red Hat GmbH
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
 <466de207-e88d-ea93-beec-fbfe10e63a26@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 11 Oct 2021 16:33:45 +0200
Message-ID: <874k9ny6k6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 10/11/21 1:59 PM, Halil Pasic wrote:
>> diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
>> index 0fe7b2f2e7f5..c533d1dadc6b 100644
>> --- a/drivers/s390/cio/device_ops.c
>> +++ b/drivers/s390/cio/device_ops.c
>> @@ -825,13 +825,23 @@ EXPORT_SYMBOL_GPL(ccw_device_get_chid);
>>    */
>>   void *ccw_device_dma_zalloc(struct ccw_device *cdev, size_t size)
>>   {
>> -	return cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
>> +	void *addr;
>> +
>> +	if (!get_device(&cdev->dev))
>> +		return NULL;
>> +	addr = cio_gp_dma_zalloc(cdev->private->dma_pool, &cdev->dev, size);
>> +	if (IS_ERR_OR_NULL(addr))
>
> I can be wrong but it seems that only dma_alloc_coherent() used in 
> cio_gp_dma_zalloc() report an error but the error is ignored and used as 
> a valid pointer.

Hm, I thought dma_alloc_coherent() returned either NULL or a valid
address?

>
> So shouldn't we modify this function and just test for a NULL address here?

If I read cio_gp_dma_zalloc() correctly, we either get NULL or a valid
address, so yes.

