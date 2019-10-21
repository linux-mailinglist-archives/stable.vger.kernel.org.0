Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EDDDF21A
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfJUP4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 11:56:06 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38519 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfJUP4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 11:56:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so8683392pfe.5;
        Mon, 21 Oct 2019 08:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nmMJ1XMy+G4APPVAliYZbq+tibtbnshggDeFdmEFPZg=;
        b=snriiRdIhFIMwr9XlhZwxcH5Eazuxz8AHXF/ngw6p6XdvdkWvzlfCgHPmVyhkNy4Cc
         SzrJte1zDziHX+zM6k/hEKJ/8zh5/52Gmlsi+nMYMT2rNep1Ssdqns6FVnI7FVZPCW6T
         mQsLR/bbrk7SHw/JIbwKaCwBX8NRYoInEtxrX0hJFM7U966lpTBBfmIO/lZYOEZ3d+zL
         DKquLF0NdwIMg3ls6oww3nNdZkmDS4V2qJx2jWXp50F/ZY8ujPA2x4CXmexzGHy7DTER
         /axpquLD+FS5amGa//Z+OzEV0nhY1L+tCLNXM1zx7zAhkGUzldOMu25s3AK6anizkBCR
         tavw==
X-Gm-Message-State: APjAAAWFumPwrHYv1nd8gsWVMeG6TKoX0fOF7jWAcPAXsJfysxcTkjTu
        DvdXFvj46w7hsCEwNdfBkXZK3yVd/Kk=
X-Google-Smtp-Source: APXvYqx3I3AMjnOZpxMKMvTXtybM893AEO20L4kpp69Rhjy5Glk3MMF7tLwwnvQGmwlgMKDbDlTI6A==
X-Received: by 2002:a62:6411:: with SMTP id y17mr24042112pfb.158.1571673364835;
        Mon, 21 Oct 2019 08:56:04 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id k9sm15458934pfk.72.2019.10.21.08.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:56:03 -0700 (PDT)
Subject: Re: [PATCH 1/4] RDMA/core: Fix ib_dma_max_seg_size()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20191021021030.1037-1-bvanassche@acm.org>
 <20191021021030.1037-2-bvanassche@acm.org> <20191021140917.GB25178@ziepe.ca>
 <bf742476-89cd-51ef-0047-da813ab318fb@acm.org>
 <20191021152721.GE25178@ziepe.ca>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f594b855-7dc3-7346-eb6e-349c8cd0500e@acm.org>
Date:   Mon, 21 Oct 2019 08:56:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021152721.GE25178@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/21/19 8:27 AM, Jason Gunthorpe wrote:
> On Mon, Oct 21, 2019 at 08:03:32AM -0700, Bart Van Assche wrote:
>> On 10/21/19 7:09 AM, Jason Gunthorpe wrote:
>>> On Sun, Oct 20, 2019 at 07:10:27PM -0700, Bart Van Assche wrote:
>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>> index 6a47ba85c54c..e6c167d03aae 100644
>>>> +++ b/include/rdma/ib_verbs.h
>>>> @@ -4043,9 +4043,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
>>>>     */
>>>>    static inline unsigned int ib_dma_max_seg_size(struct ib_device *dev)
>>>>    {
>>>> -	struct device_dma_parameters *p = dev->dma_device->dma_parms;
>>>> -
>>>> -	return p ? p->max_segment_size : UINT_MAX;
>>>> +	return dma_get_max_seg_size(dev->dma_device);
>>>>    }
>>>
>>> Should we get rid of this wrapper?
>>
>> Hi Jason,
>>
>> In general I agree that getting rid of single line inline functions is good.
>> In this case however I'd like to keep the wrapper such that RDMA ULP code
>> does not have to deal with the choice between dev->dma_device and &dev->dev.
>>  From struct ib_device:
>>   /* Do not access @dma_device directly from ULP nor from HW drivers. */
>> struct device                *dma_device;
> 
> Do you think it is a mistake we have dma_device at all?
> 
> Can the modern dma framework let us make the 'struct ib_device' into a
> full dma_device that is still connected to some PCI device?

Hi Jason,

My understanding is that dma_device is passed as the first argument to 
DMA mapping functions. Before PCIe P2P support was introduced in the 
RDMA code, the only struct device members used by DMA mapping functions 
were dma_ops, dma_mask, coherent_dma_mask, bus_dma_mask and dma_parms. I 
think it would have been sufficient to copy all these members from the 
PCI device into struct ib_device before PCIe P2P support was introduced. 
The dma_device pointer however is also passed to the pci_p2pdma_map_sg() 
and pci_p2pdma_unmap_sg() functions. These functions use several 
additional members of struct pci_dev. Although it may be possible to 
eliminate the dma_device member, this may make maintaining the RDMA core 
harder because setup_dma_device() will have to be modified every time a 
DMA mapping function uses an additional member from struct device.

Bart.
