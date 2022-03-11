Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06AB4D6A11
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 00:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiCKWoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 17:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiCKWob (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 17:44:31 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBABE034;
        Fri, 11 Mar 2022 14:20:05 -0800 (PST)
Received: from [192.168.0.3] (ip5f5aef8b.dynamic.kabel-deutschland.de [95.90.239.139])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id CCD1E61EA1927;
        Fri, 11 Mar 2022 22:41:56 +0100 (CET)
Message-ID: <11a4c611-ed0c-789f-b5d0-8a127539daf1@molgen.mpg.de>
Date:   Fri, 11 Mar 2022 22:41:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, stable@vger.kernel.org,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Song,


Am 11.03.22 um 17:59 schrieb Song Liu:

> On Fri, Mar 11, 2022 at 6:16 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/10/22 5:07 PM, Jens Axboe wrote:
>>> In any case, just doing larger reads would likely help quite a bit, but
>>> would still be nice to get to the bottom of why we're not seeing the
>>> level of merging we expect.
>>
>> Song, can you try this one? It'll do the dispatch in a somewhat saner
>> fashion, bundling identical queues. And we'll keep iterating the plug
>> list for a merge if we have multiple disks, until we've seen a queue
>> match and checked.
> 
> This one works great! We are seeing 99% read request merge and
> 500kB+ average read size. The original patch in this thread only got
> 88% and 34kB for these two metrics.

Nice. I am curious, how these metrics can be obtained?

[…]


Kind regards,

Paul
