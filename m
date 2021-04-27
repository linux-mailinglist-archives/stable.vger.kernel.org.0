Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2143E36CA03
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 19:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhD0RFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 13:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhD0RFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 13:05:01 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D823DC061574;
        Tue, 27 Apr 2021 10:04:17 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t18so2636278wry.1;
        Tue, 27 Apr 2021 10:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EVsEChLdWoFL+wsmaTrHSUndg2V44Glyh6M+8T9aF4I=;
        b=aV6PPsqxSMZoNx0kbAB2N60Ob182OJmGe8Q8ldE6uo3LbB4Lj4UOIyxl9hCgQJqLZF
         A7Pi4QwjqxCoNZe/zOglV/yTStKP7m4Grv3v1We2NnhdV8E1K9fDuVfa796D65Z4uajN
         IJ7+DXz+4Y4eKFuolh2XNOuVJk2mV+JCNKDrvxQwrrhgPDmRPo8k95iXBg8o9W7NTLA+
         31iwzJObIalGxyXvKba9rn3HzFfxL5AbRBN8CxF2/JNMYsm8jjuFDCKpqWr3x9TKXxdS
         tnYry4VBkWQejhJVicqPjIaMZF0ffMSObs5Xga3A005Ef14gazAfu3VW5vQ4IHwBDvE7
         +FCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVsEChLdWoFL+wsmaTrHSUndg2V44Glyh6M+8T9aF4I=;
        b=fGWLpPqnRJxW93CIeZpctuEiah4UWQABAOs6ZEn6s9bxeedD9nNJsxj9qAJeO5Ak3I
         F5Qks9oms3IGMJAlIme6HkFfuTZn2MMJmqOZgWCNgM6W8xJTD8fK3ygNLBwurhLpanl1
         LI2jVHmRGUQIgF+ye7z6jB5kkisSugLgWH+qWbdpzdu0dXrDFG99UOnouPkPfwqiqTRv
         rq0TuBciiVYp6SvIdSmpzsNYEeborinTcW3d1SLwAww3HZIGIC38uQjXzaADj1D9eELD
         vvDrM/4IgqW0e1oG0t/W26RUZPghVpL8MDfEpxWnCWRap3zMnMkNhbrfCRf4Gb4vOKBX
         udAQ==
X-Gm-Message-State: AOAM531A0bHLCmyWM9MtCsOl1wDKAQw4rMl/8W5c3HFYY0svioG/rzY1
        gTZhMcJcf4Lc7fRvXeZYQxA0uRjwx/A=
X-Google-Smtp-Source: ABdhPJyHJS/OFuTk0fO4l/8cp+BwLNfYXXfTjhBGPNX3i3SKZHy9c7Xp9zSVcywoOMWzB2E9zIkZVQ==
X-Received: by 2002:adf:fdcd:: with SMTP id i13mr29934671wrs.185.1619543056463;
        Tue, 27 Apr 2021 10:04:16 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id i11sm4986224wrx.47.2021.04.27.10.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 10:04:16 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: Check current->io_uring in
 io_uring_cancel_sqpoll
To:     Jens Axboe <axboe@kernel.dk>, Palash Oswal <hello@oswalpalash.com>
Cc:     dvyukov@google.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, oswalpalash@gmail.com,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, stable@vger.kernel.org
References: <e67b2f55-dd0a-1e1f-e34b-87e8613cd701@gmail.com>
 <20210427125148.21816-1-hello@oswalpalash.com>
 <decd444f-701d-6960-0648-b145b6fcccfb@kernel.dk>
 <8204f859-7249-580e-9cb1-7e255dbcb982@gmail.com>
 <de97e0f0-1c47-1a96-eb24-e62c37d2a06b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <964956e9-e75a-257c-ac9e-4365b2be0020@gmail.com>
Date:   Tue, 27 Apr 2021 18:04:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <de97e0f0-1c47-1a96-eb24-e62c37d2a06b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/21 6:00 PM, Jens Axboe wrote:
> On 4/27/21 11:00 AM, Pavel Begunkov wrote:
>> On 4/27/21 2:37 PM, Jens Axboe wrote:
>>> On 4/27/21 6:51 AM, Palash Oswal wrote:
>>>> syzkaller identified KASAN: null-ptr-deref Write in
>>>> io_uring_cancel_sqpoll on v5.12
>>>>
>>>> io_uring_cancel_sqpoll is called by io_sq_thread before calling
>>>> io_uring_alloc_task_context. This leads to current->io_uring being
>>>> NULL. io_uring_cancel_sqpoll should not have to deal with threads
>>>> where current->io_uring is NULL.
>>>>
>>>> In order to cast a wider safety net, perform input sanitisation
>>>> directly in io_uring_cancel_sqpoll and return for NULL value of
>>>> current->io_uring.
>>>
>>> Thanks applied - I augmented the commit message a bit.
>>
>> btw, does it fixes the replied before syz report? Should 
>> syz fix or tag it if so.
>> Reported-by: syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
> 
> That tag was already there.

Oh, right, missed it

-- 
Pavel Begunkov
