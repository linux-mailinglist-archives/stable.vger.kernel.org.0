Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373D636C9F1
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbhD0RBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 13:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236611AbhD0RBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 13:01:47 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3545C061760
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 10:01:00 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id s16so55036718iog.9
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VQWN2MoFbn+ZbCk3aYL+k6MgSUCrIcFC3HaPv/js1xI=;
        b=OaOMNgPxt/xHeJgQVxLE6f72BpwsMmGEJih3XGIyAjUwveuQuWYqu3MUwp1RDIDDYu
         j18lhg451O/piqwlezSI4e4g7ypGmhg8lB9h6Yrbce47IQ1EJyjjCDsUgBf3A4O8vHVD
         5AB/qq/lKfpd0xUkoF23qnpHg7tB6gRt8w7Hg/kiMCNl3bncwew6mS7Ma5/kMSlQiU50
         2cGgPmp770CSqthj01CndSCdD7LQEErsmYgTK0gZ24POEzU2Aua4ftJIJl0T0CFonMdh
         lPnCIJd77o7djc/Db4PEjZqLGj+ujNQe1IYvgLjX7Sjt8xrTZ5Dx6yZW2HOLgYhLvljK
         N0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VQWN2MoFbn+ZbCk3aYL+k6MgSUCrIcFC3HaPv/js1xI=;
        b=SnWG6ZiQfLbKUcSt+a/5Dqly8a/4jYUtdHnrj5G4haR6Z+szV5MSreoR3R/W9bUjXT
         mCANq7BafRzhyqdu588/k43EBbkQQbQEeHRDcHViliRtVwZpZ5Di7gDD6EAwuqsMSGbk
         l2c49AqvYMAL33yP2o6Ghurj7+lmbu67tta4KPZvdOlZkRQoXCFPjccxqjlKTWzUp7B9
         fZ3efJPOkb3cYZTaMsqZiGwnRKCh6VQlbxzuXGgrvskwfkHgfo02sk25nLW7pM4NH54P
         MNp6Yk0zNtZ/VzzCjB5hJH95XGEWKQ2BIhonapPHqieP+SdjV/lxmVAhndLosn/qHbH6
         Z4SQ==
X-Gm-Message-State: AOAM533irw1tz5ptlLWpmOQxix8b3PIQjvAGtwZaZ8eXUb6vqN+JGc0y
        /GZzXWiQ2sPK5c/UayagAfIHonux89YuEA==
X-Google-Smtp-Source: ABdhPJwXKXj//hDEP/+qXuNdiHIhM4QvOLWkMCd7LmQgFDvUZ28eQJWewPRtGPpUytn/c7kDSg0X0g==
X-Received: by 2002:a5e:880c:: with SMTP id l12mr20315619ioj.195.1619542859956;
        Tue, 27 Apr 2021 10:00:59 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l8sm198227ioq.35.2021.04.27.10.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 10:00:59 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: Check current->io_uring in
 io_uring_cancel_sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Palash Oswal <hello@oswalpalash.com>
Cc:     dvyukov@google.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, oswalpalash@gmail.com,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, stable@vger.kernel.org
References: <e67b2f55-dd0a-1e1f-e34b-87e8613cd701@gmail.com>
 <20210427125148.21816-1-hello@oswalpalash.com>
 <decd444f-701d-6960-0648-b145b6fcccfb@kernel.dk>
 <8204f859-7249-580e-9cb1-7e255dbcb982@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de97e0f0-1c47-1a96-eb24-e62c37d2a06b@kernel.dk>
Date:   Tue, 27 Apr 2021 11:00:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8204f859-7249-580e-9cb1-7e255dbcb982@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/21 11:00 AM, Pavel Begunkov wrote:
> On 4/27/21 2:37 PM, Jens Axboe wrote:
>> On 4/27/21 6:51 AM, Palash Oswal wrote:
>>> syzkaller identified KASAN: null-ptr-deref Write in
>>> io_uring_cancel_sqpoll on v5.12
>>>
>>> io_uring_cancel_sqpoll is called by io_sq_thread before calling
>>> io_uring_alloc_task_context. This leads to current->io_uring being
>>> NULL. io_uring_cancel_sqpoll should not have to deal with threads
>>> where current->io_uring is NULL.
>>>
>>> In order to cast a wider safety net, perform input sanitisation
>>> directly in io_uring_cancel_sqpoll and return for NULL value of
>>> current->io_uring.
>>
>> Thanks applied - I augmented the commit message a bit.
> 
> btw, does it fixes the replied before syz report? Should 
> syz fix or tag it if so.
> Reported-by: syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com

That tag was already there.

-- 
Jens Axboe

