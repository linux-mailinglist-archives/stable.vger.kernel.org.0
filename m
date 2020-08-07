Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A7B23F2F0
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 21:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHGTCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 15:02:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42897 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgHGTCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 15:02:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id 17so1501918pfw.9;
        Fri, 07 Aug 2020 12:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=e/4L0H4SJbPs3M2E8mZc8AFfRIMo45dy4anV29SuqcE=;
        b=F4rRx5fxxRap48M+j4AFPEECNvdrXT7+aS336MhbcFfHXsKghxJ5CChf8ZtkULboE6
         AvjRNbhw/HrCya67ak8mb1wYM3Mbtsst/np2M5bNDhtRao6tGlS30Bapw1w3DG0ZoR+8
         cjRd396iNaNfnNKDAIAmdkC7JZQMUzbQcQLaYpLtc7Ot1I1J7GNh1LBP83gcR5Fyx7Uu
         2jX8eq1b5JgOvO+hv+rhJQLbIYhhbLtEtxcalElMn7N+Fy3eOd5Fv/aC0SLOoWOKVZxo
         sI9A3Bdk8/4u3NvbJQ8wyTg8YFXVzQS4drkskjdFfVri+HVe9TK8H2P4Bynh7fOwd7uc
         rnDg==
X-Gm-Message-State: AOAM533xLlNmHx8IMCoCAwvhXnf+tDvTn033tcP9AFR4rh6FNmFuY/nq
        fm0m6QwAJZD4mhOo0BOEatqYE6CI
X-Google-Smtp-Source: ABdhPJzhP+lbCK+ZrgyIsiqOeUAhPzeXQG2oBUkxyxdQspWyl2prnnYwJIk7dq7y2EcI8U3Rn8Hrug==
X-Received: by 2002:a62:7644:: with SMTP id r65mr14291885pfc.271.1596826952786;
        Fri, 07 Aug 2020 12:02:32 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id t17sm12037827pgu.30.2020.08.07.12.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 12:02:31 -0700 (PDT)
Subject: Re: [PATCH] block: fix get_max_io_size()
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Eric Deal <eric.deal@wdc.com>, stable@vger.kernel.org
References: <20200806215837.3968445-1-kbusch@kernel.org>
 <88d4db76-b912-8987-cfac-a2b926fbfe3d@acm.org>
 <c2275412-5106-e0a3-63db-a7b0ceedd1d3@acm.org>
 <20200807032437.GC3797376@dhcp-10-100-145-180.wdl.wdc.com>
 <60baf63a-6264-812e-15e6-b0a28b07329f@acm.org>
 <20200807171001.GA4155677@dhcp-10-100-145-180.wdl.wdc.com>
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
Message-ID: <170914cf-b8f3-a262-7679-989d0182d6d0@acm.org>
Date:   Fri, 7 Aug 2020 12:02:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807171001.GA4155677@dhcp-10-100-145-180.wdl.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-07 10:10, Keith Busch wrote:
> On Fri, Aug 07, 2020 at 07:18:49AM -0700, Bart Van Assche wrote:
>> Hi Keith,
>>
>> How about replacing your patch with the (untested) patch below?
> 
> 
> I believe that should be fine, but I broke the kernel last time I did
> something like that. I still think it was from incorrect queue_limits,
> but Linus disagreed.
> 
>  * http://lkml.iu.edu/hypermail/linux/kernel/1601.2/03994.html

Hi Keith,

Thanks for the interesting link. Regarding Linus' comments about bio
splitting: if the last return statement in get_max_io_size() is reached
then it is guaranteed that sectors < pbs (physical block size). So I think
that Linus' comment applies to the previous return statement instead of to
the last ("return max_sectors - start_offset;"). However, I think it is
already guaranteed that that value is a multiple of the logical block size
because start_offset is a multiple of the logical block size and because
of the following statement: "max_sectors &= ~(pbs - 1);".

Bart.


