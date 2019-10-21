Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9300DF0BB
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 17:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfJUPDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 11:03:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36171 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfJUPDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 11:03:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so7988142pgk.3;
        Mon, 21 Oct 2019 08:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YysD+jLXOtCHN+Nj/7OSWUXgBwzuMOL8wpxsblD8TUk=;
        b=e0k7twuaZUExyk2fa3QcR5GERKGKEuyxy5qa6k63guOvao8TsoRvRBxOohSEGsAyC0
         4Rc1HSBIfkXLMKfTZRG1Wm1xRTYU6zEiDny0jFo5rWDYjrBNg36YCxjDWjjxYJrPyZIF
         v2RmDLhaMQfvBfqSWTS2GgEYd20JT1F7ya8gYCS+MxR2Ksg3mslIIfnXveuQBl7LO3sO
         uK/i8fNw3+7OLK8VLTuXFYV1Xi7IGW9cNBKxilQDVdbHsky5/zRutbCO1KL8TFqUcfsA
         T+k40Emj1X+obvSw4BDFFFCQ/pJang7/oL759d8ZSLd4DJE9aOTQi7vbyc23e4RIVGfe
         TfPg==
X-Gm-Message-State: APjAAAUEYCwbeIo6RzqLaWF/oC7Dx2EINzNBty1c9TSFY56eTunbN9U4
        fLWPnyGfIGVXJPnOnDVR8VvFpZ9NcKw=
X-Google-Smtp-Source: APXvYqwQEilLnY9QBdQTKCAP8SsgsY9R3ViUViiCw5GzHbxRATrxaLjOK3VY9v6KP4bsc5qcb8RzDQ==
X-Received: by 2002:a63:5813:: with SMTP id m19mr26410611pgb.43.1571670214224;
        Mon, 21 Oct 2019 08:03:34 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w134sm17137669pfd.4.2019.10.21.08.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:03:33 -0700 (PDT)
Subject: Re: [PATCH 1/4] RDMA/core: Fix ib_dma_max_seg_size()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20191021021030.1037-1-bvanassche@acm.org>
 <20191021021030.1037-2-bvanassche@acm.org> <20191021140917.GB25178@ziepe.ca>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bf742476-89cd-51ef-0047-da813ab318fb@acm.org>
Date:   Mon, 21 Oct 2019 08:03:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021140917.GB25178@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/21/19 7:09 AM, Jason Gunthorpe wrote:
> On Sun, Oct 20, 2019 at 07:10:27PM -0700, Bart Van Assche wrote:
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 6a47ba85c54c..e6c167d03aae 100644
>> +++ b/include/rdma/ib_verbs.h
>> @@ -4043,9 +4043,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
>>    */
>>   static inline unsigned int ib_dma_max_seg_size(struct ib_device *dev)
>>   {
>> -	struct device_dma_parameters *p = dev->dma_device->dma_parms;
>> -
>> -	return p ? p->max_segment_size : UINT_MAX;
>> +	return dma_get_max_seg_size(dev->dma_device);
>>   }
> 
> Should we get rid of this wrapper?

Hi Jason,

In general I agree that getting rid of single line inline functions is 
good. In this case however I'd like to keep the wrapper such that RDMA 
ULP code does not have to deal with the choice between dev->dma_device 
and &dev->dev. From struct ib_device:
  /* Do not access @dma_device directly from ULP nor from HW drivers. */
struct device                *dma_device;

Thanks,

Bart.
