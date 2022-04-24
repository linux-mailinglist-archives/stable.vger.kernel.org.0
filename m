Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5BF50D5FB
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 01:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbiDXXa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 19:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiDXXaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 19:30:25 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530C76A059;
        Sun, 24 Apr 2022 16:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1650842822;
        bh=u9/ZeejX6Y8bLkZxrZTFpJqr0CwF7H14gw+NaS2LIb4=;
        h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
        b=JNo6ROK/NXuO46/C11vRtXjl3mLH0xZ/oJk9sXRNmdrazGFGn6fpJO8aAr615HYgg
         mV8tpBUuKyMEG/Iy+VhbWBs87cWo4mScEaUl4+BS874sAMtIIwvIonO9Hoo1Vk6tQp
         lG4rloIkIoevy3iUQGxLVrsLB2edurQg5dXZZE3w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MY6Cl-1nNWvo1sRZ-00YRml; Mon, 25
 Apr 2022 01:27:02 +0200
Message-ID: <6fd7b901-15e8-277b-7255-5ca4f03254c4@gmx.com>
Date:   Mon, 25 Apr 2022 07:26:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
 <YlkQgTCv+Iw2QzPz@infradead.org>
 <37226b35-7d5a-dd86-7b20-7a0dfd3b96fc@gmx.com>
 <YlkayiTPf93aBpSD@infradead.org>
 <7e60b890-939b-c5c1-715e-3262793ef079@gmx.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when submit_one_bio()
 failed
In-Reply-To: <7e60b890-939b-c5c1-715e-3262793ef079@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gv2C/oF34J/7AF0Wlq3ngLtLof8RCVNDUq+P/A4yrJFm70KUy7O
 QAKKKQECAR9k2OnrrAweg1LqtRCYCCLU59VsZN2rdBrRJ4yRvt3nnpmT4SyZq8ufeinBzHp
 xTKotHnE4QZeGxTlsTEHxq+6XAFOFwND6om9s+ewCZ96H4NCzRKLn+SB8M21ewlDtR6nKyL
 KOK2FlvlHPaN+N4wuVKSQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:FDYXksRfQxk=:wpLAAHzl4zk/nV+IYDwCdz
 cIaTJOymCNZcbiBD9r/aVC1xlOdd3KOV1Js13qUxkh/jWS8pDL7ugChGObrSkKaTFgtqI3hl+
 erdkT3PCDCNYWXDXkqnsqYLCjodNIyAvH/yLTAFzb1dn2WdUZEkgMO613pIByM/Qaf1+pASxK
 NTjfz1anIOBmUWdllRrmNLSP03/EUsl5RhzfTIGyssXwK+K7/nByPQc8N/wUzLGnxGJiCqv+x
 mUc7G61kpAFgzfw6YuiV+C7iXXPhZVpyMcYvwwWpfA+BiE3KGVNi7JfnTPQJnTxlBwdzmJ0+/
 fa4dzHutxuJ5jk/e9hVAkyaOEruz1f/zdVU1D5h7GQxulSYKeIoG8kjWMg62tgqdZiuf5DO5h
 sSofl5CVqGeSy+juD9VWXpGJCJoWc3G7VQIGzo3UNllQOQVtRw4d5wYpBtU1nD+UxMcXPr4MN
 MAsFDRHbe3TAWt+iJNOQUC0+ARnkD7V9slwxUeguKZJ3m9K0hRdbhQiE7FJudE/vQOC7mTH8f
 nOr+rI1cvvsYg6hMKZ+BrDPkPcRP7f8KGm6VEHue2OFmwZ9o3GM9v+w0fBAxDGy6AgUQzVv3Y
 DcVyiYlj/+BgdY12rXKLbcvgLRLv3CGjsj4fv2iLOPlg7OC+u7Or6z5/n2pvsmIJTZHcR1eLp
 UoXdMaXcCus8oX5OXq4NEJgWsQbUqwH0S8hGNWC5KnYa24dfito41k0yOCKGWgG5lnhJIZLf3
 uTS74X1n+A4LUCIG4iRyys8htt54WSxyjmCSqEa3cP0XxDJxlsCie0V48Um87+JcF8XjgpoRW
 3Ai6BhSaDMvnX6TLUWK8fSAYGvMMMI0Gam5BSw/EmTX++xN9du4g9hjysnf6urMajEJqEaBin
 iFfxHNgLVATy79e6P43G8XC2GDRqVg4UIJGcXIZlXQ/TgdG1yQcGzORXsn2mVq8By3euaYiZK
 4zU0ozxR5vXdRY1vs4C9tDQKmIf9O7nkAp+Ex1ef3s77w5wrfZgRYglQ0RywsFrYvj26xOQsU
 IUnhN593FA5+H7GZa1HHdqaU5LX9iwE24/sm8j2CcPRnrphk8hfrKRrYgAc4t2/qEkQ7urm5t
 ES4z9VIU8gv4Ug=
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/15 15:14, Qu Wenruo wrote:
>
>
> On 2022/4/15 15:12, Christoph Hellwig wrote:
>> On Fri, Apr 15, 2022 at 03:02:41PM +0800, Qu Wenruo wrote:
>>> But this can not be said to btrfs_submit_compressed_read(), which has
>>> the same problem and can be triggered by EIO error easily.
>>>
>>> Do you want to give it a try? Or mind to me fix it?
>>
>> I don't really know the btrfs writeback and compression code very well,
>> so if you can tackle it that would be great.=C2=A0 I'll review it and w=
ill
>> ask lots of stupid question in exchange :)
>
> No stupid questions at all.
>
> Great we have some extra reviewing eyes!
>
> Thanks for your review in advance.
> Qu

OK, it turns out things are better than we thought.

For btrfs_submit_compressed_read() and btrfs_submit_compressed_write(),
we have a different (and correct) way handling the endio.

Let's look at btrfs_submit_compressed_read() as an example.

If functions like btrfs_lookup_bio_sums() failed, although we go
finish_cb: label, our @cur_disk_byte is already updated.

Then under finish_cb: label, we first finish the current @comp_bio,
which may:

1. Decrease cb::pending_bytes and it reached 0.
    Call finish_compressed_bio_read() as we're the last pending bytes.

2. Just decrease cb::pending_bytes
    There are still other pending ios.

For case 1, our @cur_disk_bytnr has already reached our range end, thus
we won't do anything but exit early, without manually calling
finish_compressed_bio_read().

For case 2, we continue to wait_var_event() first, to wait all bios
on-the-fly to finish.
As since the pending_sectors will never reach 0, no one is going to
finish the @cb.

Then we're safe to call finish_compressed_bio_read() then.


In fact, those are exact what I fixed in commit 6853c64a6e76 ("btrfs:
handle errors properly inside btrfs_submit_compressed_write()") and
86ccbb4d2a2a ("btrfs: handle errors properly inside
btrfs_submit_compressed_read()").

In fact, when I saw the overkilled usage of ASSERT()s, I should know
it's myself...

So in fact we're safe since v5.16.

Thanks,
Qu
