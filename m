Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EA847020C
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 14:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhLJNte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 08:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbhLJNtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 08:49:33 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18AFC0617A1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 05:45:58 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso7555256pjl.3
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 05:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cVysbT492yudFSclZYjhA7lIERHX0fHCAKUVZt2Q7pc=;
        b=LuHjx6I6tTOI8qG40ccLnOcOJc017D7UGwbrNr+ujg3sbgwGT5x9S7fAuzBONSd1Kq
         9Oz37Km6Do4aA2jBRVZEF7zewb1xtYZ6dWRH1eh/dj59qHUwN1QZ42sYn+smEy6P2iz0
         ATn57xgS1RftUA5IPIjhb0MXVskXriIn5ljB3KPLlli1egGB/ujuKvtKJWtordUILn5R
         Zuzn7NuQJhscRsSkrUAVZq3RPJOouXBTz19Mif97++0oWbSb0FMfW8Sm3svOvX75dmaJ
         KeRp13BwJapXUeb6PrZzxYnLJvnRrGN3VxKCu7+nasdR2O9Y/9DjftpRbBjW1rMgA9I9
         j63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cVysbT492yudFSclZYjhA7lIERHX0fHCAKUVZt2Q7pc=;
        b=0SY5hPrSnCIA/BJzy7UvjojFsd49v1EaTo5CbBJq8fwQyBgmHqqXmTKE6g7dHZbhK6
         wlbgUXu523B5IXOGttIVN1OYLIe2rqdv9naDdD98UgFaPwsIh+OBxLoEchU3dl6diwri
         jFujPokIRIb4EhLzt+RIhf7xH6UG5Ib7g1ob+gq6X2ODruTMddCQ/1fRjAWFaKgFzaA0
         /Z11vp0HoslPUXp20AekWa6O0qKjKQcQp1K2oIC97jHzKzreTxKFGw4sX3sWfn7brqdM
         GnJql5ygHfLRiN4xWQiUMzc04f6Dzqv7N7vvbYB4AGoRLBQ6/+BfYYL/3U+xWQSsJF8B
         WBVw==
X-Gm-Message-State: AOAM533QbMcwgEkOrcF2mFXrQpTjc8PnUA8OXss9hQycpXSQO1wDqpLX
        xFcX9u43h1aoFohYhXbxkH5VkvoadwtVrw==
X-Google-Smtp-Source: ABdhPJw9U0KToVR3UVrIGQa7WeAA5jzXqDRATn55GpZ5qiOg2xbfl5lmZfzyMpoGuoOi2zgKtKpCgg==
X-Received: by 2002:a17:902:b78b:b0:143:baac:2ebc with SMTP id e11-20020a170902b78b00b00143baac2ebcmr75561104pls.77.1639143958111;
        Fri, 10 Dec 2021 05:45:58 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id h66sm2760955pgc.34.2021.12.10.05.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:45:57 -0800 (PST)
Subject: Re: [PATCH v2 2/2] io_uring: ensure task_work gets run as part of
 cancelations
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com,
        stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-3-axboe@kernel.dk>
 <89990fca-63d3-cbac-85cc-bce2818dd30e@kernel.dk>
 <227847a6-a76c-3942-a563-7d492b0d2ced@linux.alibaba.com>
 <bfd55851-62d8-c9ea-bc49-c94efd40b38a@kernel.dk>
 <281d4248-676e-efc5-d95a-d848cbf0df41@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <deb94fec-ec14-7f9a-2e38-6bbdaac1178f@kernel.dk>
Date:   Fri, 10 Dec 2021 06:45:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <281d4248-676e-efc5-d95a-d848cbf0df41@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/21 12:31 AM, Hao Xu wrote:
> 
> 在 2021/12/10 下午12:22, Jens Axboe 写道:
>> On 12/9/21 8:29 PM, Hao Xu wrote:
>>> 在 2021/12/10 上午12:16, Jens Axboe 写道:
>>>> If we successfully cancel a work item but that work item needs to be
>>>> processed through task_work, then we can be sleeping uninterruptibly
>>>> in io_uring_cancel_generic() and never process it. Hence we don't
>>>> make forward progress and we end up with an uninterruptible sleep
>>>> warning.
>>>>
>>>> Add the waitqueue earlier to ensure that any wakeups from cancelations
>>>> are seen, and switch to using uninterruptible sleep so that postponed
>>> ^ typo
>> Not really a typo, but should be killed from v2 for sure. I'll do that.
>>
> Don't know why the ^ char doesn't align with 'uninterruptible' ... here 
> I mean 'uninterruptible' is a typo

Gotcha, I guess the end result is the same as I killed the section on
moving the sleep.

-- 
Jens Axboe

