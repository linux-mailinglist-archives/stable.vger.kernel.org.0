Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E384F3D59D2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 14:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhGZMNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 08:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbhGZMNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 08:13:17 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551B6C061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 05:53:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c16so1105057wrp.13
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 05:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HuvdB2DqUeXuvdghIoO8Ydv/CVSQweOoVvydyGQFMiw=;
        b=ff4+uSEHPjnD9faVnREW1qykg72yeIhh9dMSzygP/PnlwoC0VsA0+eqtmgRIi5pHwk
         PqhUVY7CB75Fr/i8vzocb4xlCdC/25GtpXXYl2u+EbwQQyqfqtVF8sagrnJCIHYCAeVT
         fAYRvKs325bH+0ee4pj1lyM7tGH+X3SrHzOO1Tn1yJvkUT97kNPUBzffXSDlq4uYyrNn
         1cIsC90T+J0IPqOjvL8Z5KGERxniyP33DEV4YI0EgllOLiISJHZkkfQZLD+JEPvjFDXA
         /tmRYS6C8mTS3+FRnbjThZWmE3LT6Y2RjTPqdIdrtEktfNj5ccfuSZuQgaW9QWZldCWx
         rzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HuvdB2DqUeXuvdghIoO8Ydv/CVSQweOoVvydyGQFMiw=;
        b=GUJNJ9Uc0ixy57Eg2AnKptuhH8TQoMJ73LwJ02yXv33cf5IFmJ6laHM7XS3jabphuh
         ACKjlCAGHUkytxix0A6EEVMemeI/TTppCv2ldATgdIBsj2fsOC6vH/CGXr6q6QfslapA
         ebQMuYlX7pygaODwS9JHsN3qOjXoObO0GmRdVI+6AQVJfksDAPqCvCUf8q6siatKvvVg
         mOCWGp2Nx+SbCgb9yQmS+zxMtK1EE9ZyO8oO0DuKm/pMCcfaLZx4Zu2b5aGybsoswalP
         2OD/9a5oa2yo9F+ou+K2lCvb4Z59r8a3KIGJFLwf6awCXdFj25gALzaTBvO5gTae/Zbn
         UdDA==
X-Gm-Message-State: AOAM533xmpNDx3WqRJBZFdr2PwSY/1O79Tdidzjuc4v/YJ1t/FSAEo0l
        4syjahycwUyjNVRgSxxyLMQ=
X-Google-Smtp-Source: ABdhPJzY7gq7DNgabVVFcv5BROz/VpZDiMrxdDzU5dh1jbDK/2q7RH2Jo2egw8Kz/GD+ddO5+czKaw==
X-Received: by 2002:a5d:55c1:: with SMTP id i1mr19136954wrw.77.1627304025043;
        Mon, 26 Jul 2021 05:53:45 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.244])
        by smtp.gmail.com with ESMTPSA id m7sm106178wmq.20.2021.07.26.05.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 05:53:44 -0700 (PDT)
Subject: Re: use-after-free" with v5.10.y caused by backport of a298232ee6b9
 ("io_uring: fix link timeout refs")
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
References: <YP6OkehtVdkjKikL@debian>
 <d1ff5d9c-2e13-acc2-fd8f-a8f4f180a8bb@gmail.com> <YP6Xtjg3Eu4UfTxF@kroah.com>
 <YP6uHKj/HWgZsrc1@debian>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b78ebb50-8e96-607a-1d23-44241a44b18a@gmail.com>
Date:   Mon, 26 Jul 2021 13:53:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YP6uHKj/HWgZsrc1@debian>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 1:44 PM, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jul 26, 2021 at 01:08:38PM +0200, Greg Kroah-Hartman wrote:
>> On Mon, Jul 26, 2021 at 11:57:22AM +0100, Pavel Begunkov wrote:
>>> On 7/26/21 11:29 AM, Sudip Mukherjee wrote:
>>>> Hi Pavel,
>>>>
>>>> We had been running syzkaller on v5.10.y and a "use after free" is being
>>>> reported for v5.10.43+ kernels.
>>>
>>> "... # 5.12+", weird, but perhaps due to dependencies.
>>> Thanks for letting know.
>>>
>>>
>>> Greg, Sasha, should be same as reported for 5.12
>>>
>>> https://www.spinics.net/lists/stable/msg485116.html
>>>
>>> Can you try to apply it to 5.10 or should I resend?
>>
>> I just tried applying those patches and they did not work.  So can you
>> provide some new backports?
> 
> Here is the backport for v5.10.y. I have also tested these with the
> syzkaller repro and the issue is fixed.

Thanks trying out, but it should be leaking requests (rarely),
because io_cqring_add_event() doesn't put a ref unlike
io_req_complete_post() from the original patch.

I'll get to it today double checking refcounting.

-- 
Pavel Begunkov
