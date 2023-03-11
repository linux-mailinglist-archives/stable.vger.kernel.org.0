Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFB56B57B5
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 03:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCKCIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 21:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCKCID (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 21:08:03 -0500
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556E6DBC6;
        Fri, 10 Mar 2023 18:07:59 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PYRCG39GWz4f3jXZ;
        Sat, 11 Mar 2023 10:07:54 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgBnFCJ64gtk+wnUEg--.33533S3;
        Sat, 11 Mar 2023 10:07:56 +0800 (CST)
Subject: Re: Possible kernel fs block code regression in 6.2.3 umounting usb
 drives
To:     Genes Lists <lists@sapience.com>, Jens Axboe <axboe@kernel.dk>,
        Eric Biggers <ebiggers@kernel.org>,
        Mike Cloaked <mike.cloaked@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <CAOCAAm7AEY9tkZpu2j+Of91fCE4UuE_PqR0UqNv2p2mZM9kqKw@mail.gmail.com>
 <CAOCAAm4reGhz400DSVrh0BetYD3Ljr2CZen7_3D4gXYYdB4SKQ@mail.gmail.com>
 <ZAuPkCn49urWBN5P@sol.localdomain> <ZAuQOHnfa7xGvzKI@sol.localdomain>
 <ad021e89-c05c-f85a-2210-555837473734@kernel.dk>
 <88b36c03-780f-61a5-4a66-e69072aa7536@sapience.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8acad7a9-4ecc-7985-ebbe-932e6db41cd9@huaweicloud.com>
Date:   Sat, 11 Mar 2023 10:07:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <88b36c03-780f-61a5-4a66-e69072aa7536@sapience.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgBnFCJ64gtk+wnUEg--.33533S3
X-Coremail-Antispam: 1UD129KBjvdXoWrAFy3uw47ZrW7JF1kZrWDArb_yoWxArcEvw
        4YkF93Gws3Xws3ZF4xJFZ0yFWqqF4UZr15Zry5Wa4rZayrXFZ7Crnrur97A398GFZayr4q
        9FWSgr9xWFs0gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbzkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
        0EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

在 2023/03/11 5:08, Genes Lists 写道:
> On 3/10/23 15:23, Jens Axboe wrote:
>> On 3/10/23 1:16 PM, Eric Biggers wrote:
> ...
>> But I would revert:
>>
>> bfe46d2efe46c5c952f982e2ca94fe2ec5e58e2a
>> 57a425badc05c2e87e9f25713e5c3c0298e4202c
>>
>> in that order from 6.2.3 and see if that helps. Adding Yu.

So, The reason is that patch dfd6200a0954 ("blk-cgroup: support to track
if policy is online") is missed, this will absolutely cause some
problems.

Thanks,
Kuai
>>
> Confirm the 2 Reverts fixed in my tests as well (nvme + sata drives).
> Nasty crash - some needed to be power cycled as they hung on shutdown.
> 
> Thank you!
> 
> gene
> 
> 
> .
> 

