Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77923E523
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgHGA2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 20:28:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43833 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgHGA2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 20:28:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id y206so54304pfb.10;
        Thu, 06 Aug 2020 17:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+4o407zV94mbsPb+EOGZW2X9RdfSjImoOL/K/PZfbck=;
        b=WqbA+coNPY1kaxkyIXVqxe7z88KxwItYmCLb6DMNlXh7N8RQq5/tginAW4FsuCknJS
         5Zl4FUu8nTI3beW20f5HmEZUuXuuM1QOKXRrXASFqt/AVWGTJG3q1uZNMOztxFpAPLb9
         Piik7yhHLJa8844p7fd8fXBqQCZEGM9sdUMG2LWnvxqaIaHrq4NR3P822RZ1piviVMO2
         fUxWTu0K7PC5DigdnVz4SNsD3vfooKIRRimp1AIuCTgo4J06D+kQ7l/j+2IdB8IqS2Qp
         fGWc86j3mZMxNmH3JHtkve/TlpgFzl6uqTVrjuBIS9V1X/uVOkfxPHKNsBpZNBoSLZTH
         qGyg==
X-Gm-Message-State: AOAM531CDbWdpqpKwSx3hu82L7uWqlEZTdVLDXeD7zfTEnG4B/ytNZS2
        WWvu3h7EMPmiJ6QeCagKOFPnsWn2
X-Google-Smtp-Source: ABdhPJyPgE3AJW5uwUPQ3zS11cbCXI4R6fxpGq1wE6pxJOu+fGmjJLQfWkwQvT+D6L2Q5YcPjocroQ==
X-Received: by 2002:a62:7687:: with SMTP id r129mr10840783pfc.308.1596760099387;
        Thu, 06 Aug 2020 17:28:19 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c207sm9577892pfc.64.2020.08.06.17.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 17:28:18 -0700 (PDT)
Subject: Re: [PATCH] block: fix get_max_io_size()
To:     Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Cc:     Eric Deal <eric.deal@wdc.com>, stable@vger.kernel.org
References: <20200806215837.3968445-1-kbusch@kernel.org>
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
Message-ID: <88d4db76-b912-8987-cfac-a2b926fbfe3d@acm.org>
Date:   Thu, 6 Aug 2020 17:28:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806215837.3968445-1-kbusch@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-06 14:58, Keith Busch wrote:
> A previous commit aligning splits to physical block sizes inadvertently
> modified one return case such that that it now returns 0 length splits
> when the number of sectors doesn't exceed the physical offset. This
> later hits a BUG in bio_split(). Restore the previous working behavior.
> 
> Reported-by: Eric Deal <eric.deal@wdc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: stable@vger.kernel.org
> Fixes: 9cc5169cd478b ("block: Improve physical block alignment of split bios")
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  block/blk-merge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 5196dc145270..d7fef954d42f 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -154,7 +154,7 @@ static inline unsigned get_max_io_size(struct request_queue *q,
>  	if (max_sectors > start_offset)
>  		return max_sectors - start_offset;
>  
> -	return sectors & (lbs - 1);
> +	return sectors & ~(lbs - 1);
>  }

I think we agree that get_max_io_size() should never return zero. However, the above
change seems wrong to me because it will cause get_max_io_size() to return zero if
the logical block size is larger than 512 bytes and if sectors < lbs. How about
changing the return statement as follows (untested):

	return max(sectors & (lbs - 1), sectors);

Thanks,

Bart.
