Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CC75C6D5
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 03:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBByn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 21:54:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42961 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfGBBym (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 21:54:42 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so3501324pgb.9
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 18:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D2g0s0JUGomRLeX7dDerJhRH+KgNtz7R3e0skhYcLEg=;
        b=SkDMBCd3SUFo6ihA0QikeMboxta1FQi/bn9Yu3kDfMuHhS3cnAZAt+tCkm3jYfivPL
         YXGDR+OtVOTOqarwDNDY8T8ZMGdoIY5Q9XkwOr5GaF89ns8H4ffEsc2Ghx302cwhhr6K
         b+YYQqi94Ij238cGuapznFvcu0nLxJ/eJjDTPvO4Nsrn5QjtWDEfNpSJczK6Cy7Mqblm
         AP50M9Gv4pLyuLpS7tQbCNXYYA9qKrKsLr93a0tBzBc+2JhLu2C/umBOs9D293vO2N7g
         VxrBZ6e9b2vgx38v8zt9snQ6HhuqkFR9GFEg32UlRLBF3h9hFcxleNMleqrR961eMg8i
         MF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D2g0s0JUGomRLeX7dDerJhRH+KgNtz7R3e0skhYcLEg=;
        b=hZciuhLu/QPXHdo0ZGrBuo7Cxs7oSWjF7XSikWGv0UKJyxI5yg/4efKQNSHSt+lgQQ
         7KX4r7cbf9T43+OKMMdvYH3+GxjFBVqKSZlTt3xxuC1W4kYc9N3pd/ms0B7tSb0dFOpV
         jQbtTfQVv26FN+sYWf9EuaK3as7LKfp+pcKdgF6HQUdCQse2sXyQX1RwYPebrOZwXn8z
         eoEkJJ4t/1/sfP0Iz2NoxIs214w0EXEiihVGc3apMPRm5WeQPXjfhTOnfOAZFV18MOeF
         jr0r1dA95NVmeyGQMt2qjFMh3Xxx8ABaVt8qpW4l5RJm6JzhIzec9qqqtGS4qQ/n51nD
         PT0Q==
X-Gm-Message-State: APjAAAUQdDxovRNt4peXrLGxG4Xp0arPOd2hiWbVXgA7+KU3iAse89e6
        2A6P5OZFHDri/3426iSsikJi5ZW4RZI=
X-Google-Smtp-Source: APXvYqxeN84yuR5dgrIUqvA6+LTJjiA2KJVz6fa2lNJVfKI04RgFYHvXaZZkoY1xThpS337V/9zIrQ==
X-Received: by 2002:a17:90a:3310:: with SMTP id m16mr2553249pjb.7.1562032481771;
        Mon, 01 Jul 2019 18:54:41 -0700 (PDT)
Received: from [192.168.1.121] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id q10sm9889974pgg.35.2019.07.01.18.54.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 18:54:40 -0700 (PDT)
Subject: Re: [PATCH V2] block: fix .bi_size overflow
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20190701071446.22028-1-ming.lei@redhat.com>
 <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
 <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
 <8b8dc953-e663-e3d8-b991-9d8dba9270be@kernel.dk>
 <20190702013829.GB8356@ming.t460p>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7c3987b1-ac39-276b-da6d-511bfc4485bf@kernel.dk>
Date:   Mon, 1 Jul 2019 19:54:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702013829.GB8356@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/1/19 7:38 PM, Ming Lei wrote:
> On Mon, Jul 01, 2019 at 08:20:13AM -0600, Jens Axboe wrote:
>> On 7/1/19 8:14 AM, Jens Axboe wrote:
>>> On 7/1/19 8:05 AM, Jens Axboe wrote:
>>>> On 7/1/19 1:14 AM, Ming Lei wrote:
>>>>> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
>>>>> bytes.
>>>>>
>>>>> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
>>>>> include very limited pages, and usually at most 256, so the fs bio
>>>>> size won't be bigger than 1M bytes most of times.
>>>>>
>>>>> Since we support multi-page bvec, in theory one fs bio really can
>>>>> be added > 1M pages, especially in case of hugepage, or big writeback
>>>>> with too many dirty pages. Then there is chance in which .bi_size
>>>>> is overflowed.
>>>>>
>>>>> Fixes this issue by using bio_full() to check if the added segment may
>>>>> overflow .bi_size.
>>>>
>>>> Any objections to queuing this up for 5.3? It's not a new regression
>>>> this series.
>>>
>>> I took a closer look, and applied for 5.3 and removed the stable tag.
>>> We'll need to apply your patch for stable, and I added an adapted
>>> one for 5.3. I don't want a huge merge hassle because of this.
>>
>> OK, so we still get conflicts with that, due to both the same page
>> merge fix, and Christophs 5.3 changes.
>>
>> I ended up pulling in 5.2-rc6 in for-5.3/block, which resolves at
>> least most of it, and kept the stable tag since now it's possible
>> to backport without too much trouble.
> 
> Thanks for merging it.
> 
> BTW, we need the -stable tag, since Yiding has test case to reproduce
> the issue reliably, which just needs one big machine with enough memory,
> and fast storage, I guess.

Just to be clear, I wasn't saying it shouldn't go to stable. But it's
pointless to mark something for stable if you know it'll reject, and
won't be easily fixable by the person applying it. For that case, it's
better to NOT CC stable, and just send in an appropriate patch instead.

But that's all moot now, as per last section in the email you are
replying to.

-- 
Jens Axboe

