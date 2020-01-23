Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917D31470C8
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 19:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgAWSbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 13:31:51 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37760 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgAWSbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 13:31:51 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so1926218pfn.4
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 10:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LqCb1Dt+8mE8Agcb/iqdFZzhbVwp04Pt6cT0H4D6ED4=;
        b=bRBVYENXWp60SUcaoF11dpBkoJCBql2gRZ4VyfCikfWJvaHAA/cJ5AI1rjE8FBH/7R
         4Y27VAmrHM8kJfv56gArb5Tk68B4NEnMe6bWgqN1IGXwkjg69uBbx3w06NeYNipNRW0l
         58pixsljpnJfZkDnboLZmNO25dV2wOt0LN/tmA0qRI9ojbVymHj1ewAueb1GoIPrIYK0
         F7HTw+8Ifj1gMusJIaqU5sRvPTfjqR65G8TSbqv+Tnr8OR9nGkcid3nmgTqtwjkkcoZl
         e/26jQqCncB1+Itzo0BDb3Oqi0qksRHLbxzdsZ2mvmlXXf7/MT60unpSX0wn/NsYkZtc
         pIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LqCb1Dt+8mE8Agcb/iqdFZzhbVwp04Pt6cT0H4D6ED4=;
        b=QSQ9GoEK2KJ2R9CRQjVc7E3ynKkyQbxfuTdr9KoOK4aiiMN/KZPxtxHdAdpQDxi2ma
         daeTgdq7rqKonsqH/NJozy78GpKwQUmQdUxdvBVbniaotDo/WG35/qNYNtYY0Zw+ROOa
         MqqSEcfRyDnsQ6LBltp3FqIx17VJTncIfYlzeEd8R+AHPu0Nt9bsMJ6B/paYgnx7nRKz
         OIZ6AlWvR7HalMoyAMyMREPvjFWUaH4IUHagnNwZOxrZZ51hAOwHH+v8POngOKG/3UhY
         Aefii+wUq07sTGZsDZRJdKta3ot5nInQgdKPuD7vCn6aHtGcgL4NQkqRqipZPRdX/dox
         /LJA==
X-Gm-Message-State: APjAAAXT4F5zJrzidRfA9x2dyLKpvsvQqln7I/JZfdfZrxNRpEr3IV2J
        u4ToU+1pBuVN/3pfWsJUtIVt4huCgyY=
X-Google-Smtp-Source: APXvYqygJNTq990y7Czijur2ORNhRHnzVsQiRaBxQJNIhUFa/R3VZxrjI0VS4GOCnri2QJp/Ezz+KA==
X-Received: by 2002:a63:4287:: with SMTP id p129mr147630pga.122.1579804310189;
        Thu, 23 Jan 2020 10:31:50 -0800 (PST)
Received: from ?IPv6:2600:380:4562:fb25:b980:6664:b71f:35b5? ([2600:380:4562:fb25:b980:6664:b71f:35b5])
        by smtp.gmail.com with ESMTPSA id f81sm3305215pfa.118.2020.01.23.10.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 10:31:49 -0800 (PST)
Subject: Re: [PATCH 14/17] bcache: back to cache all readahead I/Os
To:     Coly Li <colyli@suse.de>, Michael Lyle <mlyle@lyle.org>
Cc:     linux-bcache <linux-bcache@vger.kernel.org>,
        linux-block@vger.kernel.org, stable <stable@vger.kernel.org>
References: <20200123170142.98974-1-colyli@suse.de>
 <20200123170142.98974-15-colyli@suse.de>
 <CAJ+L6qckUd+Kw8_jKov0dNnSiGxxvXSgc=2dPai+1ANaEdfWPQ@mail.gmail.com>
 <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <31f7f6b4-98ea-3cf6-44cc-a9ba67484eb0@kernel.dk>
Date:   Thu, 23 Jan 2020 11:31:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <efdfdd2b-b22e-42d1-c642-6c398db6864c@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/20 10:27 AM, Coly Li wrote:
> On 2020/1/24 1:19 上午, Michael Lyle wrote:
>> Hi Coly and Jens--
>>
>> One concern I have with this is that it's going to wear out
>> limited-lifetime SSDs a -lot- faster.  Was any thought given to making
>> this a tunable instead of just changing the behavior?  Even if we have
>> an anecdote or two that it seems to have increased performance for
>> some workloads, I don't expect it will have increased performance in
>> general and it may even be costly for some workloads (it all comes
>> down to what is more useful in the cache-- somewhat-recently readahead
>> data, or the data that it is displacing).
> 
> Hi Mike,
> 
> Copied. This is good suggestion, I will do it after I back from Lunar
> New Year vacation, and submit it with other tested patches in following
> v5.6-rc versions.

Do you want me to just drop this patch for now from the series?

-- 
Jens Axboe

