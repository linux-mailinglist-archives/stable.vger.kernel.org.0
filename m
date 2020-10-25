Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1A29835A
	for <lists+stable@lfdr.de>; Sun, 25 Oct 2020 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418499AbgJYTTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Oct 2020 15:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgJYTS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Oct 2020 15:18:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F33C061755
        for <stable@vger.kernel.org>; Sun, 25 Oct 2020 12:18:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d22so539923pjz.1
        for <stable@vger.kernel.org>; Sun, 25 Oct 2020 12:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DoU9NQLX1NykhWAskyruDhfbGmsrk4ODYZDTBdcokRY=;
        b=uUmIpYkEwmFyVJU2P6Xfq7wO3UHQrorRYU4OukRPYpIcaw+zeWUy6zI4jdOsvdWoWi
         tbvU8vlYBnwyH9XYzxStl17P4DKcLmkh2Nsb2iogGeUIf9comqE3CKrjaEG+HF6sDhpr
         ouHE/QZwXFw9yKOY14QUR3z0qFH6qK3hKqMWKwLq0hCF2fdSgoJXfVOZHCHWg5El2Jx1
         Wuw5i2G5eo+wt0Cii3/QRPA7Rvf6Kz/4/opR9caUjE0IRHM/hdZNenOAj8xOiNg8+PV9
         kQHOstHbvFJRDmZfMDwEAmzzyfOgSzdMl2wuo2yQNs2yk6aaHOIM1cAUFd1rMG/XN86Q
         TIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DoU9NQLX1NykhWAskyruDhfbGmsrk4ODYZDTBdcokRY=;
        b=VWxU9HhtK7JwDqCUc5zkotW6HyrNjgPjKDTercPhFOqlZ5J6DNh87DjcPHfwo31qcB
         as81NW8jmiNNmMCKsmUwyfoeEc/IWI0HUFHOR6uHnkgX6IbCoWrch8ee8Fv+7etJP+9K
         QIpl1ARHEZ0/Jfb5Y0rqvFu6crDl0Nf7ZFRycZJd/AJkyLV5mEjTSe6tMjF4kluAjFMG
         WKiUI5tvc0Afb20oJctrehXioRcGExDweUeCHiBmGESSUKH+pWNJUcEpyY+MeDH6QOzW
         MjLzx5gjgXUdB/pdLROUVLMocM5AwxlD3CA4gGjTR+k4II75OTipkadNjg/rFz1HUfQj
         2XNg==
X-Gm-Message-State: AOAM530znQjujtqD22SGYrcxWw/dF9fyFMgj2cgbCXoUEDdI6q7b4eVO
        Klox5x/orZJ4LzjBqAm5fydtMplfl/TzBA==
X-Google-Smtp-Source: ABdhPJwsnCAqytatl45m0jqwa7ZtfVuz3R1etGHFPiWKgXJWjKPPd5WVO7i+QyOr0UBETQ7xVUCbhg==
X-Received: by 2002:a17:902:bd95:b029:d5:ccf8:9f5e with SMTP id q21-20020a170902bd95b02900d5ccf89f5emr10603465pls.9.1603653538898;
        Sun, 25 Oct 2020 12:18:58 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m129sm549105pfd.177.2020.10.25.12.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 12:18:58 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix invalid handler for double apoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <1bf1093730a68f8939bfd7e6747add7af37ad321.1603635991.git.asml.silence@gmail.com>
 <1ea94ec7-d80a-527b-5366-b91815496f4a@kernel.dk>
 <2022677d-6783-468d-6e77-43208a91edba@gmail.com>
 <83e9fd0e-9136-0ca7-5eb9-01f8da6bd212@kernel.dk>
 <94e07136-2be5-2981-79ae-d4f714803143@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2e5105f-88e3-c6aa-1d91-cfd604a848e7@kernel.dk>
Date:   Sun, 25 Oct 2020 13:18:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <94e07136-2be5-2981-79ae-d4f714803143@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/20 1:01 PM, Pavel Begunkov wrote:
> On 25/10/2020 18:42, Jens Axboe wrote:
>> On 10/25/20 10:24 AM, Pavel Begunkov wrote:
>>> On 25/10/2020 15:53, Jens Axboe wrote:
>>>> On 10/25/20 8:26 AM, Pavel Begunkov wrote:
>>>>> io_poll_double_wake() is called for both: poll requests and as apoll
>>>>> (internal poll to make rw and other requests), hence when it calls
>>>>> __io_async_wake() it should use a right callback depending on the
>>>>> current poll type.
>>>>
>>>> Can we do something like this instead? Untested...
>>>
>>> It should work, but looks less comprehensible. Though, it'll need
>>
>> Not sure I agree, with a comment it'd be nicer im ho:
> 
> I don't really care enough to start a bikeshedding, let's get yours
> tested and merged.

Not really bikeshedding I think, we're not debating names of
functions :-)

My approach would need conditional clearing of ->private as well,
as far as I can tell. I'll give it a spin.

-- 
Jens Axboe

