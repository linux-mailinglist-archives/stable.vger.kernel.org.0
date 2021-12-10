Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28A8470210
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 14:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbhLJNum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 08:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbhLJNul (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 08:50:41 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5375C0617A1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 05:47:06 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso7558001pjl.3
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 05:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/XHNEFU4xNOPB2g5/JDHm28V6shvBN8CfNunFgwpivc=;
        b=It2Z24jJyy3jB0JduETsmmzz8PTMeWG/VcptIGSLuxbllZkfgvPB9qiD+Au7AIaGl8
         akmezun/ZTWWm/5+Tq9934jZZGGYMnRvcAt/GqZYXfepfSWfWJ5OQ07nHJKEzcyHYnoP
         +Wo9wqBeMV9TdG6gWosmR971HyLAjKBlqyRj2sqeyhRagah7vKFovE+xof6JU56UTrq/
         9/hN6ST5fLw3F/BduTX6Xz3jCrsIlLG6uoIuq+X2jS74FK4zD1Z1oIdB+g+0nMn7QIg3
         kVLB4KA4xkOsY38y3YJYI+dOAGKG4LU/767E3bO+pvZoBFv82mypRZsvqw+dEvafZKoN
         LzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XHNEFU4xNOPB2g5/JDHm28V6shvBN8CfNunFgwpivc=;
        b=k6vZxVsYB13loUWq6Wcdu7A9DBMbEdLG9qzRYttYPRa/47L9O3fwWH1DPI0M3rc+nc
         TfQ1tpQxWOlR08qRPHYd1JSueIfRggHY00pxBBeXB60JWHjQ3UqdqsO1vvLtXatWFMbv
         jRkHlFN3xXC1K1FHbR9ZiY/NIBeR/L7h6AV1UisYp8h4/nIzhjHRXyYWTeYmeu8GUDA2
         XXJlaRlk+cLG3RO6bTmzDgZf9shN7/Z/Nvo3XZq8R5gF3BTM5A3/AY6412TqgfMr4Qrs
         QtDNUFmdntYqZQ+RpD/hAs0g8ioSeeChjEUi1eqC6HqTkHI6xXC5pVuOlun2ByLvqgVL
         bOwA==
X-Gm-Message-State: AOAM531wEyoIhdnLzKsyN1dwAZ3D1/f15eJLVQeqVnrpNwLiEj14MWoq
        FUKbIt14WCsVtfIVDsSlUxMw0m8Uso/8lg==
X-Google-Smtp-Source: ABdhPJyYnDvY0bYSPGruH7X/OafeDlCTlVwZKCGrzc7iK/3gHpT38apJuzWBsk7vv4UUvgpdUs/QSQ==
X-Received: by 2002:a17:902:a605:b0:143:d289:f3fb with SMTP id u5-20020a170902a60500b00143d289f3fbmr75872436plq.41.1639144026036;
        Fri, 10 Dec 2021 05:47:06 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id p49sm3246530pfw.43.2021.12.10.05.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:47:05 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: check tctx->in_idle when decrementing
 inflight_tracked
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211209155956.383317-1-axboe@kernel.dk>
 <20211209155956.383317-2-axboe@kernel.dk>
 <2c527587-36c4-900b-bda6-1357d9bb5ba0@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e93fe3ce-e690-3118-62a3-aeec3bfaadee@kernel.dk>
Date:   Fri, 10 Dec 2021 06:47:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2c527587-36c4-900b-bda6-1357d9bb5ba0@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/21 12:21 AM, Hao Xu wrote:
> 
> 在 2021/12/9 下午11:59, Jens Axboe 写道:
>> If we have someone potentially waiting for tracked requests to finish,
>> ensure that we check in_idle and wake them up appropriately.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> 
> Hi Jens,
> 
> I saw every/several( in batching cases)  io_clean_op() followed by an 
> io_put_task() which does the same thing
> 
> as this patch, so it seems this one is not neccessary? Correct me if I'm 
> wrong since I haven't touch this code for

Hard to deduce as it also depends on whether it's the task itself or not.
Making it explicit is better imho.

-- 
Jens Axboe

