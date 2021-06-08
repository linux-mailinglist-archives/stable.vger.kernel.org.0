Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E9D39F74F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhFHNH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232690AbhFHNH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 09:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7256B6128A;
        Tue,  8 Jun 2021 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623157564;
        bh=rML/Od6nt6/Z070AIuHAgjY0uZdJJ/Ai2SxWk5AyFTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s0JCCvkTmq5w3gSDnFJksDRhKPLNxRk2YjhMdYmt3oB+38wSPyvy91DpcVJ5ISZNc
         aAIwKIvHjd8/4KptvSAzHlBKeHqPYq3uKCoBC7VYFG69G/ZOwLAfHxKUVdDkKf7394
         ccv9wEo4fO7CSGrxpfqh/0zhmHb++JiSHq1IAh+ToMlahwBQLyE/qaHUL0/wGt+ba3
         e0rZ5WeMD5uce3N/TAQicFOuXrhIem0jo3/GTMpHsS6gdHxPXogDGjE83tab1DNULF
         ERYjU9hM3F9UFaRJpik6d2JlwsKzPZS3rSzzyGbpKnHrIvfCoQzHy+YPDmvLaajcJN
         o4BfJdF2FqA3w==
Date:   Tue, 8 Jun 2021 09:06:03 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net,
        syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "net: kcm: fix memory leak in kcm_sendmsg" has been added
 to the 5.12-stable tree
Message-ID: <YL9rOzzzMw1amwrD@sashalap>
References: <16231555432043@kroah.com>
 <20210608154159.0ddf6bcc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210608154159.0ddf6bcc@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 03:41:59PM +0300, Pavel Skripkin wrote:
>On Tue, 08 Jun 2021 14:32:23 +0200
><gregkh@linuxfoundation.org> wrote:
>
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>     net: kcm: fix memory leak in kcm_sendmsg
>>
>> to the 5.12-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      net-kcm-fix-memory-leak-in-kcm_sendmsg.patch
>> and it can be found in the queue-5.12 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable
>> tree, please let <stable@vger.kernel.org> know about it.
>>
>>
>> From c47cc304990a2813995b1a92bbc11d0bb9a19ea9 Mon Sep 17 00:00:00 2001
>> From: Pavel Skripkin <paskripkin@gmail.com>
>> Date: Wed, 2 Jun 2021 22:26:40 +0300
>> Subject: net: kcm: fix memory leak in kcm_sendmsg
>>
>> From: Pavel Skripkin <paskripkin@gmail.com>
>>
>> commit c47cc304990a2813995b1a92bbc11d0bb9a19ea9 upstream.
>>
>> Syzbot reported memory leak in kcm_sendmsg()[1].
>> The problem was in non-freed frag_list in case of error.
>>
>> In the while loop:
>>
>> 	if (head == skb)
>> 		skb_shinfo(head)->frag_list = tskb;
>> 	else
>> 		skb->next = tskb;
>>
>> frag_list filled with skbs, but nothing was freeing them.
>>
>> backtrace:
>>   [<0000000094c02615>] __alloc_skb+0x5e/0x250 net/core/skbuff.c:198
>>   [<00000000e5386cbd>] alloc_skb include/linux/skbuff.h:1083 [inline]
>>   [<00000000e5386cbd>] kcm_sendmsg+0x3b6/0xa50 net/kcm/kcmsock.c:967
>> [1] [<00000000f1613a8a>] sock_sendmsg_nosec net/socket.c:652 [inline]
>>   [<00000000f1613a8a>] sock_sendmsg+0x4c/0x60 net/socket.c:672
>>
>> Reported-and-tested-by:
>> syzbot+b039f5699bd82e1fb011@syzkaller.appspotmail.com Fixes:
>> ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module") Cc:
>> stable@vger.kernel.org Signed-off-by: Pavel Skripkin
>> <paskripkin@gmail.com> Signed-off-by: David S. Miller
>> <davem@davemloft.net> Signed-off-by: Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> ---
>>  net/kcm/kcmsock.c |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>
>Hi, Greg!
>
>I CCed stable. This patch is broken and I've already sent a revert for
>this.
>
>https://git.kernel.org/netdev/net/c/a47c397bb29f
>
>Please, don't add this to stable trees. Im sorry

I've dropped it, thanks!

-- 
Thanks,
Sasha
