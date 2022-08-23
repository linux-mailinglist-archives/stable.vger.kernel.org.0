Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C68A59CF4D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 05:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbiHWDQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 23:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240073AbiHWDPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 23:15:38 -0400
Received: from yamato.tf-network.de (yamato.tf-network.de [93.186.202.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20704E869
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 20:15:36 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 4MBZ9g1czqz4R4W;
        Tue, 23 Aug 2022 05:15:35 +0200 (CEST)
X-Virus-Scanned: amavisd-new at amavis3.tf-network.de
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id 8l3EdAy_eX_Z; Tue, 23 Aug 2022 05:15:34 +0200 (CEST)
Received: from [10.1.0.10] (xdsl-213-196-226-148.nc.de [213.196.226.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.tf-network.de (Postfix) with ESMTPSA id 4MBZ9f36ncz3wff;
        Tue, 23 Aug 2022 05:15:34 +0200 (CEST)
Message-ID: <172d7663-ce22-f87a-6aa0-0b6145115711@whissi.de>
Date:   Tue, 23 Aug 2022 05:15:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vverma@digitalocean.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Jens Axboe <axboe@kernel.dk>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <000001d8ad7e$c340ad70$49c20850$@whissi.de>
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
From:   Thomas Deutschmann <whissi@whissi.de>
In-Reply-To: <CAPhsuW7zdynykfXnz8X4CDEusHSHm9Vr01yiQSpEvizGwBUDkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-08-23 03:37, Song Liu wrote:
> Thomas, have you tried to bisect with the fio repro?

Yes, just finished:

> d32d3d0b47f7e34560ae3c55ddfcf68694813501 is the first bad commit
> commit d32d3d0b47f7e34560ae3c55ddfcf68694813501
> Author: Christoph Hellwig
> Date:   Mon Jun 14 13:17:34 2021 +0200
> 
>     nvme-multipath: set QUEUE_FLAG_NOWAIT
> 
>     The nvme multipathing code just dispatches bios to one of the blk-mq
>     based paths and never blocks on its own, so set QUEUE_FLAG_NOWAIT
>     to support REQ_NOWAIT bios.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d32d3d0b47f7e34560ae3c55ddfcf68694813501 


So another NOWAIT issue -- similar to the bad commit which is causing 
the mdraid issue I already found 
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0f9650bd838efe5c52f7e5f40c3204ad59f1964d).

Reverting the commit, i.e. deleting

   blk_queue_flag_set(QUEUE_FLAG_NOWAIT, head->disk->queue);

fixes the problem for me. Well, sort of. Looks like this will disable 
io_uring. fio reproducer fails with

> $ fio reproducer.fio
> filename0: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=1
> fio-3.30
> Starting 1 thread
> fio: io_u error on file /srv/machines/fio/filename0.0.0: Operation not supported: write offset=12648448, buflen=4096
> fio: pid=1585, err=95/file:io_u.c:1846, func=io_u error, error=Operation not supported

My MariaDB reproducer also doesn't trigger the problem anymore, but 
probably for the same reason -- it cannot use io_uring anymore.


-- 
Regards,
Thomas

