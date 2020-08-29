Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C5925643D
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 04:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgH2C54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 22:57:56 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34335 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgH2C5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 22:57:54 -0400
Received: by mail-pj1-f67.google.com with SMTP id n3so464331pjq.1;
        Fri, 28 Aug 2020 19:57:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OqUGPUYdN7PULuDA/9YzFTy96hztr5ZfPQ1srP/K7ws=;
        b=q2AGikpOu3FvfRKzSk4kT5gdTtd8qZCQ1OWModG9GveA1N+e3eLiD8C/zz6+GyGA6H
         izc8q/n+v1F6XpF4BZDmF0vzbHWAAVLoE6p4T9EKtDnDK0rFiOECSFuM5je/0QLRegN4
         Ek1/EyJQLKThZxcovCRpQJxJVklIeMYL/4ShB10dOEyGntaRBr1I5A49rAmKa+sgFHC9
         0PNXw9j1wn0d0D0D5EpNlK6BjoSMyHg6Dqg8eTOaAi+8EYH43nrzE1PYHXDHcOSbNvTl
         GbqSZTO/BHl/Ck+5l/2Vxeapsv59TKXhcgGc0LdBP1x08YnUIIK7CEI3JaAumtkE0La8
         Fh5g==
X-Gm-Message-State: AOAM530z5yQ3NbWg2r1taE6KqmnHda0IRlDXfOZCFaG2iBwrEe66Nz5P
        61wTUjpBCpT3rUnXT3sZyOBDruqXZ3g=
X-Google-Smtp-Source: ABdhPJzc12rnL+4Y6fTQZ0ErNqLeLKKxhhDYfDr+ujFhlxMtSuQkGAJ9tNTp/t8eMx7hIAWTn/Kg+w==
X-Received: by 2002:a17:90a:bc48:: with SMTP id t8mr1643027pjv.224.1598669873065;
        Fri, 28 Aug 2020 19:57:53 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id gv21sm584500pjb.39.2020.08.28.19.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 19:57:52 -0700 (PDT)
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        SCSI development list <linux-scsi@vger.kernel.org>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
 <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
 <20200826015159.GA387575@rowland.harvard.edu>
 <af1b1f57-59ff-0133-8108-0f3d1e1254e1@acm.org>
 <20200827203321.GB449067@rowland.harvard.edu>
 <5da883fe-b5ec-b98d-ae0c-bc053b6e22cb@acm.org>
 <20200828153745.GB470612@rowland.harvard.edu>
 <31d6f204-21ae-88da-dbfc-3d7132f8bc03@acm.org>
 <20200829011203.GA486691@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <874cc075-5990-bd37-10e5-6456c1c324ac@acm.org>
Date:   Fri, 28 Aug 2020 19:57:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200829011203.GA486691@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-28 18:12, Alan Stern wrote:
> On Fri, Aug 28, 2020 at 05:51:03PM -0700, Bart Van Assche wrote:
>> On 2020-08-28 08:37, Alan Stern wrote:
>>> There may be an even simpler solution: Ensure that SCSI domain 
>>> validation is mutually exclusive with runtime PM.  It's already mutually 
>>> exclusive with system PM, so this makes sense.
>>>
>>> What do you think of the patch below?
>>>
>>> Alan Stern
>>>
>>>
>>> Index: usb-devel/drivers/scsi/scsi_transport_spi.c
>>> ===================================================================
>>> --- usb-devel.orig/drivers/scsi/scsi_transport_spi.c
>>> +++ usb-devel/drivers/scsi/scsi_transport_spi.c
>>> @@ -1001,7 +1001,7 @@ spi_dv_device(struct scsi_device *sdev)
>>>  	 * Because this function and the power management code both call
>>>  	 * scsi_device_quiesce(), it is not safe to perform domain validation
>>>  	 * while suspend or resume is in progress. Hence the
>>> -	 * lock/unlock_system_sleep() calls.
>>> +	 * lock/unlock_system_sleep() and scsi_autopm_get/put_device() calls.
>>>  	 */
>>>  	lock_system_sleep();
>>>  
>>> @@ -1018,10 +1018,13 @@ spi_dv_device(struct scsi_device *sdev)
>>>  	if (unlikely(!buffer))
>>>  		goto out_put;
>>>  
>>> +	if (scsi_autopm_get_device(sdev))
>>> +		goto out_free;
>>> +
>>>  	/* We need to verify that the actual device will quiesce; the
>>>  	 * later target quiesce is just a nice to have */
>>>  	if (unlikely(scsi_device_quiesce(sdev)))
>>> -		goto out_free;
>>> +		goto out_autopm_put;
>>>  
>>>  	scsi_target_quiesce(starget);
>>>  
>>> @@ -1041,6 +1044,8 @@ spi_dv_device(struct scsi_device *sdev)
>>>  
>>>  	spi_initial_dv(starget) = 1;
>>>  
>>> + out_autopm_put:
>>> +	scsi_autopm_put_device(sdev);
>>>   out_free:
>>>  	kfree(buffer);
>>>   out_put:
>>
>> Hi Alan,
>>
>> I think this is only a part of the solution. scsi_target_quiesce() invokes
>> scsi_device_quiesce() and that function in turn calls blk_set_pm_only(). So
>> I think that the above is not sufficient to fix the deadlock mentioned in
>> my previous email.
> 
> Sorry, it sounds like you misinterpreted my preceding email.  I meant to 
> suggest that the patch above should be considered _instead of_ the patch 
> that introduced BLK_MQ_REQ_PM.  So blk_queue_enter() would remain 
> unchanged, using the BLK_MQ_REQ_PREEMPT flag to decide whether or not to 
> postpone new requests.  Thus the deadlock you're concerned about would 
> not arise.

Hi Alan,

Thanks for the clarification. I agree that the above patch should serialize
SCSI DV and runtime PM. I'm fine with the above patch.

Thanks,

Bart.
