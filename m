Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309BE5A1954
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 21:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbiHYTMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 15:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242704AbiHYTMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 15:12:08 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1EDBCC12
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 12:12:08 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id i77so16739910ioa.7
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 12:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=q+BEJd4Ibh7RrLk+WP02zwpRxnVe4S55Gu4awiljDw0=;
        b=sYe1bqsG1buPv8WYBHVu9LV8H/qwDqbG203kUVDdP8+N3ftpzuVifQWSZ5XB+t8cbd
         ciM9aEBwxlKRID1G+BAkLVoCWTejWukPJh0/r2hJdsktVhHpZDlAdZofxnaUe2yYsAaD
         Kw5b4Q9bVghiQ9xUptV64BKiB8JDrtH3urwe5yQufj72Hv+KlgnwZEf8VkQl4Jyf0lby
         8o/0OuUtKO+/2tqNjZIVE7nlFprzh+Cbhgv2Mz+8IjD1qxS3kS3iLY7ag3gCdu/Yqbw3
         vohSls7g7Z5dEXgdnTEiyH9sA8n/nOkNROh0wk0nVueXoV4wi9xHldpvUCMBqlDD4i3Q
         dRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=q+BEJd4Ibh7RrLk+WP02zwpRxnVe4S55Gu4awiljDw0=;
        b=GFlHb0immkRTsZmypSW4OcHWfpZC4yW/NA8zDOliTKT6dDxoe6hUPgP2Godtoi0GNQ
         eBBSS0lwzGKk/sqjBwrtpU37uK4QgkZi4+6KFaOtFzfmjH6F4dtIxnk3KZpvlkoTj4Jv
         5wPgab8XfvZuBfWLpjsbuyd8iV9KH5fk4PmtNE4N/b2GkyNAjtfEFw+8h35jHqp3EZ86
         n8d+H2u29+5MBN09PEYfdz1vApnRCPQhBuUK1sCCYBrhrjKrgkhtjSTVDNRoeQd7ys98
         7oBNumICXeG+D7EglP0WAPOAXOARO1qNdTdP0fuh69kb1HI9yV7+U2LPE/adrQif4GgP
         m1lw==
X-Gm-Message-State: ACgBeo19T8llH8CMV3lGaMJh5bp3sCmSglMOwyy3ALQJPSmh+VzqrKBv
        BtRyDf4RqSXyDjK9TKnn/Fazrg==
X-Google-Smtp-Source: AA6agR7SpU1XL/tRFdZlihXhRbSwW1y5wLCXg78jLRxlwn0vtzdxQqTuhgYzfvOOXFr0CgT2zLz/NA==
X-Received: by 2002:a05:6638:d02:b0:346:f5ef:6ab2 with SMTP id q2-20020a0566380d0200b00346f5ef6ab2mr2584983jaj.300.1661454727295;
        Thu, 25 Aug 2022 12:12:07 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o2-20020a92c682000000b002e7e8b88c02sm86149ilg.82.2022.08.25.12.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 12:12:06 -0700 (PDT)
Message-ID: <3114ed77-3802-8ca4-52e4-0e4b917d88b2@kernel.dk>
Date:   Thu, 25 Aug 2022 13:12:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Thomas Deutschmann <whissi@whissi.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        Vishal Verma <vverma@digitalocean.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
 <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
 <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
 <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de>
 <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
 <0192a465-d75d-c09a-732a-eb2215bf3479@whissi.de>
 <CAPhsuW6yLLcj3GtA+4mUFooQmfGo3cVTYn-xBEY2KuP1wwmQNA@mail.gmail.com>
 <b903abd4-d101-e6a5-06a0-667853286308@whissi.de>
 <4f69659f-7160-7854-0ed5-6867e3eb2edb@whissi.de>
 <CAPhsuW6Bq8rkiCzsWW7bkrCbYYEwFWtKaswOZcXsyk8tu3C5Dg@mail.gmail.com>
 <be8542cf-9b58-8861-11b5-8eeaa08f1421@whissi.de>
 <CAPhsuW45eYTjmA4C_wc_Z=ELbw9NStGpX6Mkf=tn1AEBknDg4Q@mail.gmail.com>
 <CAPhsuW7zdynykfXnz8X4CDEusHSHm9Vr01yiQSpEvizGwBUDkQ@mail.gmail.com>
 <172d7663-ce22-f87a-6aa0-0b6145115711@whissi.de>
 <CAPhsuW4ZeQXL2KsLD_xxUy2dz-aoe+1fZj_+tMEeaLwXJywf=g@mail.gmail.com>
 <CAPhsuW6OcFeyVO-=12opRDijXHpQh1drQZZ6nLAq9P5TzvpnMA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW6OcFeyVO-=12opRDijXHpQh1drQZZ6nLAq9P5TzvpnMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/25/22 10:47 AM, Song Liu wrote:
> On Tue, Aug 23, 2022 at 10:13 AM Song Liu <song@kernel.org> wrote:
>>
>> On Mon, Aug 22, 2022 at 8:15 PM Thomas Deutschmann <whissi@whissi.de> wrote:
>>>
>>> On 2022-08-23 03:37, Song Liu wrote:
>>>> Thomas, have you tried to bisect with the fio repro?
>>>
>>> Yes, just finished:
>>>
>>>> d32d3d0b47f7e34560ae3c55ddfcf68694813501 is the first bad commit
>>>> commit d32d3d0b47f7e34560ae3c55ddfcf68694813501
>>>> Author: Christoph Hellwig
>>>> Date:   Mon Jun 14 13:17:34 2021 +0200
>>>>
>>>>     nvme-multipath: set QUEUE_FLAG_NOWAIT
>>>>
>>>>     The nvme multipathing code just dispatches bios to one of the blk-mq
>>>>     based paths and never blocks on its own, so set QUEUE_FLAG_NOWAIT
>>>>     to support REQ_NOWAIT bios.
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d32d3d0b47f7e34560ae3c55ddfcf68694813501
>>>
>>>
>>> So another NOWAIT issue -- similar to the bad commit which is causing
>>> the mdraid issue I already found
>>> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0f9650bd838efe5c52f7e5f40c3204ad59f1964d).
>>>
>>> Reverting the commit, i.e. deleting
>>>
>>>    blk_queue_flag_set(QUEUE_FLAG_NOWAIT, head->disk->queue);
>>>
>>> fixes the problem for me. Well, sort of. Looks like this will disable
>>> io_uring. fio reproducer fails with
>>
>> My system doesn't have multipath enabled. I guess bisect will point to something
>> else here.
>>
>> I am afraid we won't get more information from bisect.
> 
> OK, I am able to pinpoint the issue, and Jens found the proper fix for
> it (see below,
> also available in [1]). It survived 100 runs of the repro fio job.
> 
> Thomas, please give it a try.
> 
> Thanks,
> Song
> 
> diff --git c/fs/io_uring.c w/fs/io_uring.c
> index 3f8a79a4affa..72a39f5ec5a5 100644
> --- c/fs/io_uring.c
> +++ w/fs/io_uring.c
> @@ -4551,7 +4551,12 @@ static int io_write(struct io_kiocb *req,
> unsigned int issue_flags)
>  copy_iov:
>                 iov_iter_restore(&s->iter, &s->iter_state);
>                 ret = io_setup_async_rw(req, iovec, s, false);
> -               return ret ?: -EAGAIN;
> +               if (!ret) {
> +                       if (kiocb->ki_flags & IOCB_WRITE)
> +                               kiocb_end_write(req);
> +                       return -EAGAIN;
> +               }
> +               return 0;

This should be 'return ret;' for that last line. I had to double check
the ones I did, but they did get it right. But I did a double take when
I saw this one :-)

It'll work fine for testing as we won't hit errors here unless we run
out of memory, so...

-- 
Jens Axboe
