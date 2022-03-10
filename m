Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552034D4764
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242185AbiCJM4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242233AbiCJM4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:56:30 -0500
Received: from iris.vrvis.at (iris.vrvis.at [92.60.8.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25585149963;
        Thu, 10 Mar 2022 04:55:28 -0800 (PST)
Received: from [10.43.0.34]
        by iris.vrvis.at with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <valentin@vrvis.at>)
        id 1nSIKE-000714-3U; Thu, 10 Mar 2022 13:55:26 +0100
Message-ID: <9dd4a25a-7deb-fcdf-0c05-d37d4c894d86@vrvis.at>
Date:   Thu, 10 Mar 2022 13:55:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>, linux-block@vger.kernel.org
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
 <YinpIKY0HVlJ+TLR@kroah.com> <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
 <YinufgnQtSeTA18w@kroah.com>
From:   Valentin Kleibel <valentin@vrvis.at>
In-Reply-To: <YinufgnQtSeTA18w@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: [PATCH] block: aoe: fix page fault in freedev()
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/03/2022 13:26, Greg Kroah-Hartman wrote:
> On Thu, Mar 10, 2022 at 01:24:38PM +0100, Valentin Kleibel wrote:
>> On 10/03/2022 13:03, Greg Kroah-Hartman wrote:
>>>> This patch applies to kernels 5.4 and 5.10.
>>>
>>> We need a fix for Linus's tree first before we can backport anything to
>>> older kernels.  Does this also work there?
>>
>> It is fixed in Linus' tree starting with 5.14.
> 
> What commit fixes it there?  Why not just backport that one only?

commit 6560ec961a08 (aoe: use blk_mq_alloc_disk and blk_cleanup_disk)
This commit uses the function blk_cleanup_disk() in freedev() in 
drivers/block/aoe/aoedev.c which fixes the issue.
The function was introduced in f525464a8000 (block: add blk_alloc_disk 
and blk_cleanup_disk APIs):
void blk_cleanup_disk(struct gendisk *disk)
{
	blk_cleanup_queue(disk->queue);
	put_disk(disk);
}
EXPORT_SYMBOL(blk_cleanup_disk);

I tried to backport the fix to the lts kernels without introducing a new 
API by just adjusting the order of the two function calls.
Is it preferable to introduce and use the function blk_cleanup_disk()?

cheers,
valentin
