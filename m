Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22177BCBBD
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 17:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389817AbfIXPpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 11:45:10 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42309 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388100AbfIXPpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 11:45:10 -0400
Received: by mail-ed1-f66.google.com with SMTP id y91so2274739ede.9;
        Tue, 24 Sep 2019 08:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DE8+FbEIcVR5ddCwEcV8fUyORS7y9yBce98R3wD5OgQ=;
        b=pZBYEkeVsAqETL/uX9Sj2naqOG8d+iinZSGaRqymbfiuKbrI6MofbnAFRwc5OLY3cO
         YOlxDd0On4ZdH2Ky124tzY/ibHUWgiJiiJGbhBztbeI0bhyPQGbD7OcGHVaJ9W6Nn4Np
         wq6Km+svcYXMdF7Nz26ZcNkE11DNi2VxX5hBWT0aHjx0D/t5e8c+KwBracz1Ufv+WKYr
         84dTzlUKoyXePov4O8iwWqUSozztRxrz3xgXIUaqZ9UiKE0DmZ4tFKm9VF9RkVpqmGKA
         JODq+clchBGEIkSKM1mWRy6fImcBkEoDFFvr2Nf194avzVldEo+vqmbsqrubNcSANTDC
         rPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DE8+FbEIcVR5ddCwEcV8fUyORS7y9yBce98R3wD5OgQ=;
        b=T0VS0c7i9QC1wB9X59R9+L9ij2yWwH1bQ2Nz/y4CHg1U+0a3N4D6jhoV8nYMs//VfX
         1oXL4naOO8Ii8zmKlmBrbiYsAVBtRT8O2L1vNV72eBiCxe7jTI/DXQXqOt7b2cz33MwA
         hCKml3nO4OAeT2r91s4IHlzXuJHhfiUieksVRt56gai49oM5vJXZXgI01CnwR6hGFndZ
         omPkR09S4j9xXrZn8uqbKprIz9xj2nG0l1Vy4QaETyQuQrZpvJHkH9hWXnraM9Lo7dbd
         2ivj87wge0ryI+QAr1j6kKHrVSU/cAfsaCFpKo/1SjWWOFjsEMkcUz8r67s7O5/Ol8w6
         ltBg==
X-Gm-Message-State: APjAAAU9wyHM7APUSDqbpx2oNLSK8fbX1X7OWKbn9XyoefErvfIBE6f/
        S/+tvN+DPfxp34ZDRlCCdPVjvJvd
X-Google-Smtp-Source: APXvYqz79VUZxlZWSAwnN9wusrngQi4fEktGTKUykQjNFq8gWnp4jcOcSgjJMSzCQNGJiOvGK83DNw==
X-Received: by 2002:a17:906:3485:: with SMTP id g5mr2971417ejb.76.1569339906538;
        Tue, 24 Sep 2019 08:45:06 -0700 (PDT)
Received: from [10.68.217.182] ([217.70.210.43])
        by smtp.gmail.com with ESMTPSA id s9sm245584ejf.44.2019.09.24.08.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 08:45:05 -0700 (PDT)
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
To:     Jan Kara <jack@suse.cz>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20190829131034.10563-1-jack@suse.cz>
 <20190829131034.10563-4-jack@suse.cz> <20190829155204.GD5354@magnolia>
 <20190830152449.GA25069@quack2.suse.cz>
 <20190918123123.GC31891@quack2.suse.cz>
 <53b7b7b9-7ada-650c-0a32-291a242601f3@gmail.com>
 <20190924152337.GE11819@quack2.suse.cz>
From:   Boaz Harrosh <openosd@gmail.com>
Message-ID: <6ba323dc-57aa-ffc1-3807-e7209979abcc@gmail.com>
Date:   Tue, 24 Sep 2019 18:45:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190924152337.GE11819@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/09/2019 18:23, Jan Kara wrote:
> On Mon 23-09-19 15:33:05, Boaz Harrosh wrote:
>> On 18/09/2019 15:31, Jan Kara wrote:
>> <>
>>>>> Is there a test on xfstests to demonstrate this race?
>>>>
>>>> No, but I can try to create one.
>>>
>>> I was experimenting with this but I could not reproduce the issue in my
>>> test VM without inserting artificial delay at appropriate place... So I
>>> don't think there's much point in the fstest for this.
>>>
>>> 								Honza
>>>
>>
>> If I understand correctly you will need threads that direct-write
>> files, then fadvise(WILL_NEED) - in parallel to truncate (punch_hole) these
>> files - In parallel to trash caches.
>> (Direct-write is so data is not present in cache when you come to WILL_NEED
>>  it into the cache, otherwise the xfs b-trees are not exercised. Or are you
>>  more worried about the page_cache races?
>> )
> 
> What I was testing was:
>   Fill file with data.

But are you sure data is not in page cache after this stage?

Also this stage sould create multiple extents perhaps with gaps in between

>   One process does fadvise(WILLNEED) block by block from end of the file.
>   Another process punches hole into the file.
> 

(Perhaps randome placement that spans multiple extents in one go)

> If they race is the right way, following read will show old data instead of
> zeros. And as I said I'm able to hit this but only if I add artificial
> delay between truncating page cache and actually removing blocks.
> 

I was more afraid of iterating on a btree or xarray in parallel of it being
destroyed / punched.

I think if you iterate backwards in the WILLNEED case the tree/xarry corruption is
less likely

But now that I think about it. Maybe your case is very different to mine, because
read_pages() in xfs does take the ilock. I'm not familiar with this code.

> 								Honza
> 

But I guess the window is very small then

Thanks
Boaz
