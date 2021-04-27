Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF8A36C9ED
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 19:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhD0RBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 13:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237946AbhD0RAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 13:00:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DAEC061574;
        Tue, 27 Apr 2021 10:00:10 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m9so47462146wrx.3;
        Tue, 27 Apr 2021 10:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p7dGgXSikaYUsY1yMu1X7zpaE+PGIoIuI+9TbGbxFDs=;
        b=Z+76bRFlmbrOFYVE+awuR0dIFUs+Fr+vYvOgUpbzSPFOCWhz8VXyzUPeD2VtH+gm/8
         6aYFr9rd6wa3EMx0NHPDSKiN+0xGJDajGNYOajbTMOJo5OZcEVQDNqnn9Rar12lFMKhP
         DfrzX8KoL1WHwFQdxgUKYOTtAfa14U9HiCIBXUlV7oD2i5i9egeX6SQUqjoVz21VV7I/
         Q5r4EmANIPAQrS7yyoVXXHUY0ko4bnn2LRzhww/e8i1KaCfrSbjVopJUza3zL0rqhKzG
         PRWhrPtthinUQ47CkykhegQS16AaQkTDnDTNnzKA1aFdUBxC7pc1PnzQkMknZtGdMLJq
         Iccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p7dGgXSikaYUsY1yMu1X7zpaE+PGIoIuI+9TbGbxFDs=;
        b=Yf+QmdjAzXO4YGT2u4Og8viITTzzXB0eWJa7tIyIJhZdYHq3Q9U/40E0hKFcxEpMIG
         XVUBie1Twp/ShiwSU1jy/pjTqaN9RSMYnmRRCeqNkZKDi+5nA0855XZNB18OzeaeI6/e
         3PyztKfAPbbebHwBxFw/XjNmwU6WyrcXPXZqsOmjqi/ZHUbrJqrdWf04AVL/dK1FJTK5
         Y97iTVtYWp7f+xhJP3NIVTi7O76L9+32higT5zkKfkT0rIcTTq+hsdn2i4nVejmJaJQQ
         XR9SgUoUJ1L9QO6S27poALKEPJsu0VwAz44SaShpDrRm43ok3ouyEoJifpYNA7cYywJ8
         ZSLA==
X-Gm-Message-State: AOAM533+uVByGIjExIpdqpJ7V0BunNn/ddRunmOwSHDJdk6FCMhzRcEY
        TT7LpaeU0scri5wPQOwAxbYREWz8mU4=
X-Google-Smtp-Source: ABdhPJxfKcKDT2v4rajFmcELvVywyaj1JXc+52c7lp2slstb1ViVxljWM4yKzsaxnR4mnmONEe/2BQ==
X-Received: by 2002:a5d:480b:: with SMTP id l11mr8006864wrq.242.1619542808559;
        Tue, 27 Apr 2021 10:00:08 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id l12sm5680439wrq.36.2021.04.27.10.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 10:00:07 -0700 (PDT)
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8204f859-7249-580e-9cb1-7e255dbcb982@gmail.com>
Date:   Tue, 27 Apr 2021 18:00:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <decd444f-701d-6960-0648-b145b6fcccfb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/27/21 2:37 PM, Jens Axboe wrote:
> On 4/27/21 6:51 AM, Palash Oswal wrote:
>> syzkaller identified KASAN: null-ptr-deref Write in
>> io_uring_cancel_sqpoll on v5.12
>>
>> io_uring_cancel_sqpoll is called by io_sq_thread before calling
>> io_uring_alloc_task_context. This leads to current->io_uring being
>> NULL. io_uring_cancel_sqpoll should not have to deal with threads
>> where current->io_uring is NULL.
>>
>> In order to cast a wider safety net, perform input sanitisation
>> directly in io_uring_cancel_sqpoll and return for NULL value of
>> current->io_uring.
> 
> Thanks applied - I augmented the commit message a bit.

btw, does it fixes the replied before syz report? Should 
syz fix or tag it if so.
Reported-by: syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com

-- 
Pavel Begunkov
