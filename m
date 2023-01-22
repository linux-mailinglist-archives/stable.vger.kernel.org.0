Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB62676BF3
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 10:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjAVJz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 04:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAVJz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 04:55:58 -0500
X-Greylist: delayed 40911 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 Jan 2023 01:55:55 PST
Received: from ns2.wdyn.eu (ns2.wdyn.eu [IPv6:2a03:4000:40:5b2::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF8556A4D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 01:55:55 -0800 (PST)
Message-ID: <211e827e-e778-72a9-de02-42549f2e4faa@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1674381352;
        bh=+g5xvfxrbHIwjY5ZCBJEq9MNrL4EV40ogIYZ6WL9MJ0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=oh0iY0yZIShpA3JgE4xPm9QKRhqx2EMgH9L1cy7QrYmJI/7rDB6MR37jvfNHWkAzW
         RyvltVLDgfPsdiE8cY4Loq18WrRwmQNucwFvFjl+5PC01rndKzbSxg5yo313MtF39H
         kQN3bwlK5AelV0m9Wd2rYDlZm5UTEpu/v71sWOd8=
Date:   Sun, 22 Jan 2023 10:55:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Patch "wifi: mac80211: Drop support for TX push path" has been
 added to the 6.1-stable tree
To:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230122042805.209191-1-sashal@kernel.org>
Content-Language: en-US
From:   Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <20230122042805.209191-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.01.23 05:28, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>      wifi: mac80211: Drop support for TX push path
> 
> to the 6.1-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       wifi-mac80211-drop-support-for-tx-push-path.patch
> and it can be found in the queue-6.1 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 

We should at least have a discussion about that.
While I think we have sorted out all related regressions it's still way 
too early to be sure.

The patch is also changing most mac80211 driver interfaces from queuing 
to non-queuing and is thus nothing I would do within a fix release.

All in all it's more likely to cause issues than fix them, at last at 
this point in time.

So do we really want to backport that to (all) stable kernels?

I've also just backported the two for stable relevant patches which 
depend on the iTXQ transformation:
https://lore.kernel.org/r/20230121223330.389255-2-alexander@wetzel-home.de
https://lore.kernel.org/r/20230121223330.389255-2-alexander@wetzel-home.de

If there are more patches can point them out to me and I'll should be 
able port them, too.

All in all I see no pressing need to retire the old push path for stable 
kernels at that time.
Question is also where to stop if we back port it now:

The transition to iTXQ is only the first step to get rid of the old push 
path in mac80211. Working patch titels are:
1) wifi: mac80211: Always provide the MMPDU TXQ
2) wifi: mac80211: Convert vif->txq to an array
3) wifi: mac80211: add new iTXQs to replace remaining legacy TX
4) wifi: mac80211: Stop using legacy TX path
5) wifi: mac80211: Cleanup legacy TX path - AMPDU
6) WIP: Drop pending
7) wifi: mac80211: integrate PS buffering into iTXQ
8) wifi: mac80211: handle filtered frames within iTXQs

Patch 6) is only a rough skeleton so far and 4-8 still need at least 
some moderate work. All in all thinks seem to hash out quite well and 
I'm hoping to get them merged for 6.4.

Together they are fundamentally altering the TX path and nothing I would 
like to backport to stable.

Alexander
