Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348F546F623
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 22:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhLIVuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 16:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhLIVuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 16:50:24 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9E1C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 13:46:50 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so6886094pjb.1
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 13:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vf4TIwD+NYGLfUvsVBzvm6KTrX/kuwp6DG0JCw/tbN4=;
        b=LJQiHrQfWFbYXRJtjNk9fFYI8I34vblEonCdAFxlecTtI+VVQqat2507DLVawWV9Xn
         85uF/A5v31X+7Fqo3RPkkJCdhvULIYvwqGRikkTMqKRKT/pp7M4WYeXu68PY8NoccBBh
         XyPnT1yQj+X4yZZbaxvCy+T4XliTQzhVVr46nOgTumvxQwPBtVffvll6F0K6A4JB2+r6
         1xW+Y0sxbjLwpir4qu69l5OnA1JqgpouTKF8knAvMIPHTFvVdMK3FZ6xCC3/yY66OVOV
         xEWWzZeWGmbkXuAtZTSlotaQcmL1CK7j3pYizodYL/OUDKB7deoR8HghDrptNOABl1w/
         I8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vf4TIwD+NYGLfUvsVBzvm6KTrX/kuwp6DG0JCw/tbN4=;
        b=eEGFyjN1xzilKV7InNha1FHgBdBYfYdBgjkHTeBOfyXxiuBZPy1cTPlxG0GgAkcZqy
         nF9ywwBjAnvqrXMCNfGTuMQPiUiC+fKgvqNavJFrgcDYFSUA88gzBVzd35kxrGxAApZz
         HdqlgYCC5KuGKb7XsdF5ruupg3oGAdUEbb+fCHpvhK5pnquN2R4S1ttI7R8ZYGvc2P+w
         30xGUvZqmA+v9ZoKkZbAWHLZnABT5Puic0A2tsU5hHrzlxFZOn/vhEWMclyN7yZ8F5P8
         T4nh8hPEfw+XurHGvj3cm8n776HCN6dWywBO8zmCDrh7MvhJq7ZQFt3sM2fsTCPQY+Sj
         ORXw==
X-Gm-Message-State: AOAM533v5US/564bo5EThLFsu5MVqmjn3jT0nlBrLpZHDHPc/norcQSQ
        q7byt8yBKDoGiMuMhhNXDFaP6efmeor3vQ==
X-Google-Smtp-Source: ABdhPJwFfq4AiojDvIZ/q+AQ4fwI8wKrkR8oEUmtKTC1fgL914aZj29dxWODGPFmhQDvz438H89biA==
X-Received: by 2002:a17:902:b682:b0:143:7eb8:222 with SMTP id c2-20020a170902b68200b001437eb80222mr71023268pls.31.1639086409458;
        Thu, 09 Dec 2021 13:46:49 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id f5sm558267pju.15.2021.12.09.13.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 13:46:48 -0800 (PST)
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Martijn Coenen <maco@android.com>,
        stable <stable@vger.kernel.org>
References: <20211209010455.42744-1-ebiggers@kernel.org>
 <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4a472e72-d527-db79-d46e-efa9d4cad5bb@kernel.dk>
Date:   Thu, 9 Dec 2021 14:46:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjkXez+ugCbF3YpODQQS-g=-4poCwXaisLW4p2ZN_=hxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/9/21 11:00 AM, Linus Torvalds wrote:
> On Wed, Dec 8, 2021 at 5:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> Careful review is appreciated; the aio poll code is very hard to work
>> with, and it doesn't appear to have many tests.  I've verified that it
>> passes the libaio test suite, which provides some coverage of poll.
>>
>> Note, it looks like io_uring has the same bugs as aio poll.  I haven't
>> tried to fix io_uring.
> 
> I'm hoping Jens is looking at the io_ring case, but I'm also assuming
> that I'll just get a pull request for this at some point.

Yes, when I saw this original posting I did discuss it with Pavel as
well, and we agree that the same issue exists there. Which isn't too
surprising, as that's where the io_uring poll code from originally.

Eric, do you have a test case for this? aio is fine, we can convert it
to io_uring as well. Would be nice for both verifying the fix, but also
to carry in the io_uring regression tests for the future.

-- 
Jens Axboe

