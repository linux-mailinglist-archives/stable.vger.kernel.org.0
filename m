Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37306609AA4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 08:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJXGh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 02:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJXGh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 02:37:27 -0400
Received: from zombie.net4u.de (zombie.net4u.de [5.9.79.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CEFC52DED
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 23:37:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by zombie.net4u.de (Postfix) with ESMTP id 482CA2A40402;
        Mon, 24 Oct 2022 06:37:19 +0000 (UTC)
Received: from zombie.net4u.de ([127.0.0.1])
        by localhost (zombie.net4u.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id iyd8ZLevT0NB; Mon, 24 Oct 2022 06:37:18 +0000 (UTC)
Received: from [IPV6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3] (unknown [IPv6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3])
        by zombie.net4u.de (Postfix) with ESMTPSA id 87F012A40365;
        Mon, 24 Oct 2022 06:37:18 +0000 (UTC)
Message-ID: <68509772-71ee-88b0-6c82-be97c669cd98@net4u.de>
Date:   Mon, 24 Oct 2022 08:37:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [Regression] v6.0.3 rcu_preempt detected expedited stalls
 btrfs-cache btrfs_work_helper
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>, stable@vger.kernel.org,
        josef@toxicpanda.com
References: <10522366-5c17-c18f-523c-b97c1496927b@net4u.de>
 <5eaf893b-15f6-92c3-6cf1-9f78683eb49e@gmail.com>
From:   Ernst Herzberg <earny@net4u.de>
In-Reply-To: <5eaf893b-15f6-92c3-6cf1-9f78683eb49e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 24.10.22 um 03:55 schrieb Bagas Sanjaya:
> On 10/23/22 13:21, Ernst Herzberg wrote:
>>
>> Kernel v5.19.16 works without issues.
>> Booting v6.0.3:
>>
> 
> Can you try bisecting v5.19..v6.0 instead?
> 

See the other mail:
With v5.19.17-rc1 i can reproduce it, reverting

commit 1789c776ec788d544d9e1f4e5f6cd937b3527407
Author: Josef Bacik <josef@toxicpanda.com>
Date:   Mon Aug 8 16:10:26 2022 -0400

     btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure
         [ Upstream commit 8a1ae2781dee9fc21ca82db682d37bea4bd074ad ]

solved it.

Wild guesses:

On one of my partitions i have a 'free space cache' problem. Digging into older
logfiles shows it exists for longer time undetected (some month...).

# btrfs check --force /dev/sdb3
Opening filesystem to check...
WARNING: filesystem mounted, continuing because of --force
Checking filesystem on /dev/sdb3
UUID: 4c4e7222-5fa0-4a18-bdc0-3ba1c8577ab8
[1/7] checking root items
[2/7] checking extents
[3/7] checking free space cache
block group 35530997760 has wrong amount of free space, free space cache has 1019756544 block group has 1019813888
failed to load free space cache for block group 35530997760
[4/7] checking fs roots
[5/7] checking only csums items (without verifying data)
[6/7] checking root refs
[7/7] checking quota groups skipped (not enabled on this FS)
found 11095502848 bytes used, no error found
total csum bytes: 10721436
total tree bytes: 113082368
total fs tree bytes: 94044160
total extent tree bytes: 6356992
btree space waste bytes: 27086059
file data blocks allocated: 10982420480
  referenced 10982379520

# grep "failed to load free space" messages.2022-*
messages.2022-05:May 10 06:48:30.374 dunno kernel: BTRFS warning (device sdb3): failed to load free space cache for block group 35530997760, rebuilding it now
messages.2022-05:May 11 07:08:11.120 dunno kernel: BTRFS warning (device sdb3): failed to load free space cache for block group 35530997760, rebuilding it now
messages.2022-05:May 12 06:16:57.244 dunno kernel: BTRFS warning (device sdb3): failed to load free space cache for block group 35530997760, rebuilding it now
[...]
messages.2022-10:Oct 23 18:11:47.518 dunno kernel: BTRFS warning (device sdb3): failed to load free space cache for block group 35530997760, rebuilding it now
messages.2022-10:Oct 23 18:16:36.474 dunno kernel: BTRFS warning (device sdb3): failed to load free space cache for block group 35530997760, rebuilding it now

Booting into v6.0.3 or 5.19.17-rc lead to a full hang of the machine, all kernel before
shown only the message above.

Reverting the patch above cures the hang. But for whatever reason the free space cache rebuild seems to fail
without any message.

    -- Earny
