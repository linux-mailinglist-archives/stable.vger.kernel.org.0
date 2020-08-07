Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D1823EEEC
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 16:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHGOSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 10:18:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41654 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgHGOSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 10:18:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id a79so1062787pfa.8;
        Fri, 07 Aug 2020 07:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vBRHyUc21azmd6xaDUZbWsKVxRjpm6e6+tvjQl/2xak=;
        b=eJYqPPi/1KFptQXoGFMgGYoSYt3W75JN24VxABIy4yg+PNzjug5W9SJuV9gblELDYp
         eBNzbHAbGWlRJpJPgcdOWFOzV65H8IEOYaZZ9RvPqfNRkrXyYno4INqVdrwdm6IkSobx
         /hVYMklUs9QtLW38V4YEvhkuQbWCZ4H3bPTWHr9+iAt9fYr3lquOZ89PWfUS3LoX+EPB
         Jj07fpjf7kf75vRlcvaPbHhR9BX9YpzgNh3vHf+knG9KUH7NVF3w1DUtX9CpsgNzB5G7
         4OLP44WZa3Q/RQThq8JrAXSuMfo8xBLAGWKi5354uEXR7Un6UOZguxyYaluk/iscA83u
         DEhw==
X-Gm-Message-State: AOAM5302+N2CsRMaA3afSJljy0pit5bCFd+Tfjd09RMNUfJgoMTCooE5
        h6GsjaG6bj4S80Qk7dzQBgp3RnWP
X-Google-Smtp-Source: ABdhPJyOXmMHsGYFzjBK+TU4A4P77NLrV4mUoR8ZzI+CpW05XdgocoKmsByxbTs9aFgnr9OzIbwvDA==
X-Received: by 2002:a65:6106:: with SMTP id z6mr12183143pgu.310.1596809931902;
        Fri, 07 Aug 2020 07:18:51 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 25sm13137703pfh.133.2020.08.07.07.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 07:18:51 -0700 (PDT)
Subject: Re: [PATCH] block: fix get_max_io_size()
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Eric Deal <eric.deal@wdc.com>, stable@vger.kernel.org
References: <20200806215837.3968445-1-kbusch@kernel.org>
 <88d4db76-b912-8987-cfac-a2b926fbfe3d@acm.org>
 <c2275412-5106-e0a3-63db-a7b0ceedd1d3@acm.org>
 <20200807032437.GC3797376@dhcp-10-100-145-180.wdl.wdc.com>
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
Message-ID: <60baf63a-6264-812e-15e6-b0a28b07329f@acm.org>
Date:   Fri, 7 Aug 2020 07:18:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200807032437.GC3797376@dhcp-10-100-145-180.wdl.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-06 20:24, Keith Busch wrote:
> On Thu, Aug 06, 2020 at 06:25:50PM -0700, Bart Van Assche wrote:
>> This should work better than what was mentioned in my previous email:
>>
>> -	return sectors & (lbs - 1);
>> +	return sectors;
> 
> It used to be something like that. There were some situations where it
> didn't work, which brought d0e5fbb01a67e, but I think the real problem
> was from mismatched queue_limits, which I think I addressed with
> 5f009d3f8e668, so maybe this is okay now.

Hi Keith,

How about replacing your patch with the (untested) patch below?

Thanks,

Bart.


diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5196dc145270..2d10fa3768a3 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -135,10 +135,9 @@ static struct bio *blk_bio_write_same_split(struct request_queue *q,
 /*
  * Return the maximum number of sectors from the start of a bio that may be
  * submitted as a single request to a block device. If enough sectors remain,
- * align the end to the physical block size. Otherwise align the end to the
- * logical block size. This approach minimizes the number of non-aligned
- * requests that are submitted to a block device if the start of a bio is not
- * aligned to a physical block boundary.
+ * align the end to the physical block size. This approach minimizes the
+ * number of non-aligned requests that are submitted to a block device if the
+ * start of a bio is not aligned to a physical block boundary.
  */
 static inline unsigned get_max_io_size(struct request_queue *q,
 				       struct bio *bio)
@@ -146,7 +145,6 @@ static inline unsigned get_max_io_size(struct request_queue *q,
 	unsigned sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector);
 	unsigned max_sectors = sectors;
 	unsigned pbs = queue_physical_block_size(q) >> SECTOR_SHIFT;
-	unsigned lbs = queue_logical_block_size(q) >> SECTOR_SHIFT;
 	unsigned start_offset = bio->bi_iter.bi_sector & (pbs - 1);

 	max_sectors += start_offset;
@@ -154,7 +152,7 @@ static inline unsigned get_max_io_size(struct request_queue *q,
 	if (max_sectors > start_offset)
 		return max_sectors - start_offset;

-	return sectors & (lbs - 1);
+	return sectors;
 }

 static inline unsigned get_max_segment_size(const struct request_queue *q,
