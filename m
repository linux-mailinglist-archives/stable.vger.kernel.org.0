Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7C42525AA
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 04:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHZC6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 22:58:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33645 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgHZC6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 22:58:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id h2so204044plr.0;
        Tue, 25 Aug 2020 19:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=T59q79yyURdGZxxwN54BfP5lytwNSmSa/FUiPL5dqk8=;
        b=a32rQd4ub+sFLjdLzcAMbwlnPr6df8Lq7C6wcvg18PeI8zPAWcL3Y3OLQS3IoJPnwO
         ZAzgInwmsk4vZI2wPo1pmS2wSiJcNm0zpFDx4IdZhp8d8cBqeFo0MeUYH/KiEAnifVg6
         2azkG71Qvqy7iFK5JJxuInjS1MXwPQglPaGdmN6Sk7PrGSRSVPYi2iMWx8wIy2M5epxj
         xoAAjbu7uJtcyMG46K+cvdQp2wKhNlXCEekikwZ8SKiKBDhW00BRaIXzVPrZCxw89vDS
         CKuUyxh10KPs1ZTkgW5UNY9GXnrotN4Pcjtrvr3ns0Su6ud27R1w4yOJNU3jL4JUtQP4
         DCFA==
X-Gm-Message-State: AOAM533Q6H+lrARhK8VMrjCEWc7ilheoFFw0p2CJRUoyYetpqSabzRRJ
        Km4sfG9bECAHa5lc0aciaJA=
X-Google-Smtp-Source: ABdhPJxtkSfzqUM3KCQIzDdUi2/mb/cJsGU0X1pkb/GeKZbGwJ/yfb+ErIx5cbtZ9AFCWXVJEHeZ8g==
X-Received: by 2002:a17:902:be0f:: with SMTP id r15mr10494261pls.84.1598410694753;
        Tue, 25 Aug 2020 19:58:14 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id fs12sm403898pjb.21.2020.08.25.19.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 19:58:13 -0700 (PDT)
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
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
Message-ID: <ee6b4ab1-d118-ef5d-a075-e13dfdb678a7@acm.org>
Date:   Tue, 25 Aug 2020 19:58:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1598346681.10649.8.camel@mtkswgap22>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-25 02:11, Stanley Chu wrote:
>> diff --git a/block/blk-pm.c b/block/blk-pm.c
>> index b85234d758f7..17bd020268d4 100644
>> --- a/block/blk-pm.c
>> +++ b/block/blk-pm.c
>> @@ -67,6 +67,10 @@ int blk_pre_runtime_suspend(struct request_queue *q)
>>  
>>  	WARN_ON_ONCE(q->rpm_status != RPM_ACTIVE);
>>  
>> +	spin_lock_irq(&q->queue_lock);
>> +	q->rpm_status = RPM_SUSPENDING;
>> +	spin_unlock_irq(&q->queue_lock);
>> +
> 
> Has below alternative way been considered that RPM_SUSPENDING is set
> after blk_freeze_queue_start()?
> 
> 	blk_freeze_queue_start(q);
> 
> +	spin_lock_irq(&q->queue_lock);
> +	q->rpm_status = RPM_SUSPENDING;
> +	spin_unlock_irq(&q->queue_lock);
> 
> 
> Otherwise requests can enter queue while rpm_status is RPM_SUSPENDING
> during a small window, i.e., before blk_set_pm_only() is invoked. This
> would make the definition of rpm_status ambiguous.
> 
> In this way, the racing could be also solved:
> 
> - Before blk_freeze_queue_start(), any requests shall be allowed to
> enter queue
> - blk_freeze_queue_start() freezes the queue and blocks all upcoming
> requests (make them wait_event(q->mq_freeze_wq))
> - rpm_status is set as RPM_SUSPENDING
> - blk_mq_unfreeze_queue() wakes up q->mq_freeze_wq and then
> blk_pm_request_resume() can be executed

Hi Stanley,

I prefer the order from the patch. I think it is important to change
q->rpm_status into RPM_SUSPENDING before blk_queue_enter() calls
blk_queue_pm_only(). Otherwise it could happen that blk_queue_enter()
calls blk_pm_request_resume() while q->rpm_status == RPM_ACTIVE, resulting
in blk_queue_enter() not resuming a queue although that queue should be
resumed.

Thanks,

Bart.
