Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1601F485681
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 17:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241852AbiAEQLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 11:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241847AbiAEQLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 11:11:34 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1F1C061201
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 08:11:34 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id i14so48178040ioj.12
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 08:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jhqeMcG2tRiIaFP/5tlL9AeEOUXxieFWeJV5lNZQQTo=;
        b=kAX8kDcSz0UK2eUUa2bgD+twqctqIEEtpzqJq2WtfO+Co/Vr5ubyxTimR7JrHwlONb
         TwL/i6CM4r6IR9oEz6CUCctIAedmOCv1+RjoveQHxzH94esjtPC3KXF5neJEc0I8Gxmi
         kVnwcx6ZO4XJfei76juANG1zmH7GtVT7zK6GXos1XVOdilv7/5wTnv14qhTWCit0HA/D
         0QPIXMqECsUm98uFHzj6dm1HMLsL3/LYgPnMpb+7ia2sQ45HgB2rEscaQZNOIx60nfDq
         y/9Wunbr8Th4R64alhLOSPCFWTSXe3zZ9hW54qTWGkdR70KkL/7v5JCivrOCUvfthxsv
         m60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jhqeMcG2tRiIaFP/5tlL9AeEOUXxieFWeJV5lNZQQTo=;
        b=LMEuh4oauyYsZzA8XUvfvLUznIgVUYtuMsVOU9HE/6C7vNvYzRhEH0ff2fBYRg3TV/
         tSpUVXFEXP50pOxQtZTjgp+53ucOSzTOuyRu77h4KTqfG9y2aSrR66ynGW7AhmpENWgT
         83wmuXTLSFu3K5BeeCpht2JHEM9evVD1UljH+9SYIIU5bjOTJKkQVp0/XLGmbks2MTEb
         c6ifLq3q046In7heJPc2sj7WD29wjUZOLATtHhZhkXqI6wlWDreGbIkka+qoCAaaKM6m
         3FWiXqCBXWPPk/Ke21OO6zM0JLNK26Vze0cqfWiDpWBl68ghFbDY7mF8gac5Yh/OUc7P
         hDfQ==
X-Gm-Message-State: AOAM530SQ5dkdsJrH131UymwNVGM6ysqBfHsNtz7bvegJ4FDl+wLqqe1
        Os0tH9A1/EyUiuvbz8WnRy5hyMJ4Gw0hFw==
X-Google-Smtp-Source: ABdhPJy5WyTP6kBKm3mZ7Q+fKR6ckyKxiZ3Qrefqhp65+jXCj3qTmYGpSMbFfk2FHQlAwM3ioVSbJQ==
X-Received: by 2002:a05:6638:1302:: with SMTP id r2mr24186773jad.37.1641399093189;
        Wed, 05 Jan 2022 08:11:33 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j2sm24138705ilr.71.2022.01.05.08.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 08:11:32 -0800 (PST)
Subject: Re: [PATCH v3 0/5] aio: fix use-after-free and missing wakeups
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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
 <4a472e72-d527-db79-d46e-efa9d4cad5bb@kernel.dk>
 <YdW4sApUUBi/5UHh@sol.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8289804d-dc19-2ecd-d03e-d4af97b5ee18@kernel.dk>
Date:   Wed, 5 Jan 2022 09:11:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YdW4sApUUBi/5UHh@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/22 7:26 AM, Eric Biggers wrote:
> On Thu, Dec 09, 2021 at 02:46:45PM -0700, Jens Axboe wrote:
>> On 12/9/21 11:00 AM, Linus Torvalds wrote:
>>> On Wed, Dec 8, 2021 at 5:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
>>>>
>>>> Careful review is appreciated; the aio poll code is very hard to work
>>>> with, and it doesn't appear to have many tests.  I've verified that it
>>>> passes the libaio test suite, which provides some coverage of poll.
>>>>
>>>> Note, it looks like io_uring has the same bugs as aio poll.  I haven't
>>>> tried to fix io_uring.
>>>
>>> I'm hoping Jens is looking at the io_ring case, but I'm also assuming
>>> that I'll just get a pull request for this at some point.
>>
>> Yes, when I saw this original posting I did discuss it with Pavel as
>> well, and we agree that the same issue exists there. Which isn't too
>> surprising, as that's where the io_uring poll code from originally.
>>
> 
> Jens, any update on fixing the io_uring version of the bug?  Note,
> syzbot has managed to use io_uring poll to hit the WARN_ON_ONCE() that
> I added in __wake_up_pollfree(), which proves that it is broken.

There are two parts to this, first part is queued up for 5.17 for a few
weeks. Work in progress...

-- 
Jens Axboe

