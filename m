Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8DE2563C7
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 02:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgH2AvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 20:51:14 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50774 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgH2AvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 20:51:08 -0400
Received: by mail-pj1-f68.google.com with SMTP id i13so332502pjv.0;
        Fri, 28 Aug 2020 17:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NRYpVPGRXJgIGFvsFxO5FGJ0RPuinwbeNGS/M1X2Egw=;
        b=JWNnIppTKgnD0s+98YnXoWKa6sa0hpn9mQuhtFXw/4/9Q6nrjbnznDHmJnT36is8IH
         iFw5OEhOf4+xbteiqGnvtkAQYUW9KpCAYmq55O/w7behP/UpCvekaZgidgE8ooRlJIAI
         akFT/6fSHUCq9q3MWvkKujusO4WxOsa3i19NqmRxI0En1SIen0/aFCZGrBDHem6gP79a
         tNp3itQtsHHVGWiGnLKBGFLUNa3GNk3ktoNT8WIxZN2BSeELV980xsZSkGoacI6Kpcz4
         L5vGacw76XIINnNrDhyCwfGbXpBuxSpHxOMSxVTzRqhJlmdN8kgsVluauPEKLhyS1uQN
         ++LQ==
X-Gm-Message-State: AOAM531Kfxl+YZE3/8nHMaeuPT+I9YbrEfj68viafMq/OXEvyuSo7axS
        LnTyK/4sFtziBZ5nNeI6VER1O6J7UG4=
X-Google-Smtp-Source: ABdhPJwwLcNnS8nLgjCEuJiYBGPYQQaK7KtXegf1Vf6KmHW3Srse66OMotVryd/YCjCfY0rRP/txYg==
X-Received: by 2002:a17:90a:468d:: with SMTP id z13mr1267151pjf.105.1598662266326;
        Fri, 28 Aug 2020 17:51:06 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id e12sm449787pjl.9.2020.08.28.17.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 17:51:05 -0700 (PDT)
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
Message-ID: <31d6f204-21ae-88da-dbfc-3d7132f8bc03@acm.org>
Date:   Fri, 28 Aug 2020 17:51:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200828153745.GB470612@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-28 08:37, Alan Stern wrote:
> On Thu, Aug 27, 2020 at 08:27:49PM -0700, Bart Van Assche wrote:
>> On 2020-08-27 13:33, Alan Stern wrote:
>>> It may not need to be that complicated.  what about something like this?
> 
>> I think this patch will break SCSI domain validation. The SCSI domain
>> validation code calls scsi_device_quiesce() and that function in turn calls
>> blk_set_pm_only(). The SCSI domain validation code submits SCSI commands with
>> the BLK_MQ_REQ_PREEMPT flag. Since the above code postpones such requests
>> while blk_set_pm_only() is in effect, I think the above patch will cause the
>> SCSI domain validation code to deadlock.
> 
> Yes, you're right.
> 
> There may be an even simpler solution: Ensure that SCSI domain 
> validation is mutually exclusive with runtime PM.  It's already mutually 
> exclusive with system PM, so this makes sense.
> 
> What do you think of the patch below?
> 
> Alan Stern
> 
> 
> Index: usb-devel/drivers/scsi/scsi_transport_spi.c
> ===================================================================
> --- usb-devel.orig/drivers/scsi/scsi_transport_spi.c
> +++ usb-devel/drivers/scsi/scsi_transport_spi.c
> @@ -1001,7 +1001,7 @@ spi_dv_device(struct scsi_device *sdev)
>  	 * Because this function and the power management code both call
>  	 * scsi_device_quiesce(), it is not safe to perform domain validation
>  	 * while suspend or resume is in progress. Hence the
> -	 * lock/unlock_system_sleep() calls.
> +	 * lock/unlock_system_sleep() and scsi_autopm_get/put_device() calls.
>  	 */
>  	lock_system_sleep();
>  
> @@ -1018,10 +1018,13 @@ spi_dv_device(struct scsi_device *sdev)
>  	if (unlikely(!buffer))
>  		goto out_put;
>  
> +	if (scsi_autopm_get_device(sdev))
> +		goto out_free;
> +
>  	/* We need to verify that the actual device will quiesce; the
>  	 * later target quiesce is just a nice to have */
>  	if (unlikely(scsi_device_quiesce(sdev)))
> -		goto out_free;
> +		goto out_autopm_put;
>  
>  	scsi_target_quiesce(starget);
>  
> @@ -1041,6 +1044,8 @@ spi_dv_device(struct scsi_device *sdev)
>  
>  	spi_initial_dv(starget) = 1;
>  
> + out_autopm_put:
> +	scsi_autopm_put_device(sdev);
>   out_free:
>  	kfree(buffer);
>   out_put:

Hi Alan,

I think this is only a part of the solution. scsi_target_quiesce() invokes
scsi_device_quiesce() and that function in turn calls blk_set_pm_only(). So
I think that the above is not sufficient to fix the deadlock mentioned in
my previous email.

Maybe it is possible to fix this by creating a new request queue and by
submitting the DV SCSI commands to that new request queue. There may be
better solutions.

Bart.
