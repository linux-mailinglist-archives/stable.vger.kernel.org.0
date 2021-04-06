Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E392E35507E
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 12:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240979AbhDFKHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 06:07:55 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:57185 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236660AbhDFKHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 06:07:55 -0400
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud9.xs4all.net with ESMTPA
        id TicYl4EOH43ycTicclNVCp; Tue, 06 Apr 2021 12:07:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1617703666; bh=Smp4MRVLLNFUnOv70Z5XSGoIqeMHHh6mJ4G83RG34ns=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=Yybzm13G/vqFcbp43DlPIrp8Gd0s+gHw3xJnpMbQbR7LFEM6Wu6TfqjqeeDfjGuNU
         ib+QD0pN54obSN9VI/IYqAWaFXM93TvPbVFR26aXWdo5WmwS+AdxlZOfAT5Ws68/ks
         MRkv6bohwIEewPtYutcroMCD/RFqNECEgYyuHMrfQmsoSWzksH3HrK6HxTKQukh9hV
         guPjwY5jDuDABkYedfot35NEtZsSS6/Wja/c3CRRxD5A6iJFwU6AEaAM44GtBxFfQ4
         unWbMgoM7o/lluxr4vOrfyh7EUUkVGn/c/m2a8ZB/i9thjajwwSPeWQmA/0XOCvwFL
         sqmEchwwyw7QA==
Subject: Re: [PATCH] media: em28xx: fix memory leak
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>,
        dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        skhan@linuxfoundation.org
Cc:     syzkaller-bugs@googlegroups.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:EM28XX VIDEO4LINUX DRIVER" <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
References: <20210324180753.GA410359@LEGION>
 <675efa79414d2d8cb3696d3ca3a0c3be99bd92fa.camel@gmail.com>
 <57f041d036a6a472c1463ab5d5274df5bb646920.camel@gmail.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <3cd9808b-a684-f0f2-8ea0-81b404943239@xs4all.nl>
Date:   Tue, 6 Apr 2021 12:07:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <57f041d036a6a472c1463ab5d5274df5bb646920.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfOjeiWIl6LzpQHXWGkDVKfhjL1RGlWcrFhZob03hVnI4BYGItPjLfQaKzqmZAtgM3FcS7pcebfi4XPDvDiDqFT1PUwVz2eKjpve5w11RTTm28M8POnNa
 XR9nsO40iWnzf2raJRr7xpyqB5v5MhYodAPm3rHM5xzY9w6KrpmM/mB618g117/OABXUNeyqz0BsI0V2p4wdtc1NzocpM+a1D5JwEzjEBp9fp2W8IPcyEIoy
 jLlYJAn06RROv+724oajy9RH65M7LUbMLYNsCbo+icRtxSU3lv1gC98l+1s6Kauq3H2tNJWurRRW58zGJ71YF0EpvYKw4Snh6xsRELyi6qsgyIbUJArrv/x+
 ZXXNTlZBeLVbBGvfAG0BguIlTBUWLBCy0OL5mLNadwI4+lybKCjPXUXzpvym7bSepNoLnQ9UjzuIuOHTpVuc9zAyV6ZrYXb8TwXDlKjH6bpQWnkixUmohl6C
 L4WE/wAlNFTdoarAZvgd2tOJkZ0di5a1EH+thh62A8PABIfas/wEhdaVULY0n5woEEGL1d1/xFv/gjBr
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/2021 11:44, Muhammad Usama Anjum wrote:
> On Wed, 2021-03-31 at 13:22 +0500, Muhammad Usama Anjum wrote:
>> On Wed, 2021-03-24 at 23:07 +0500, Muhammad Usama Anjum wrote:
>>> If some error occurs, URB buffers should also be freed. If they aren't
>>> freed with the dvb here, the em28xx_dvb_fini call doesn't frees the URB
>>> buffers as dvb is set to NULL. The function in which error occurs should
>>> do all the cleanup for the allocations it had done.
>>>
>>> Tested the patch with the reproducer provided by syzbot. This patch
>>> fixes the memleak.
>>>
>>> Reported-by: syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com
>>> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
>>> ---
>>> Resending the same path as some email addresses were missing from the
>>> earlier email.
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    1a4431a5 Merge tag 'afs-fixes-20210315' of git://git.kerne..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=11013a7cd00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ff6b8b2e9d5a1227
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=889397c820fa56adf25d
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1559ae3ad00000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176985c6d00000
>>>
>>>  drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
>>> index 526424279637..471bd74667e3 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>>> @@ -2010,6 +2010,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>>>  	return result;
>>>  
>>>  out_free:
>>> +	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
>>>  	kfree(dvb);
>>>  	dev->dvb = NULL;
>>>  	goto ret;
>>
>> I'd received the following notice and waiting for the review:
>> On Thu, 2021-03-25 at 09:06 +0000, Patchwork wrote:
>>> Hello,
>>>
>>> The following patch (submitted by you) has been updated in Patchwork:
>>>
>>>  * linux-media: media: em28xx: fix memory leak
>>>      - http://patchwork.linuxtv.org/project/linux-media/patch/20210324180753.GA410359@LEGION/
>>>      - for: Linux Media kernel patches
>>>
> This patch has been accepted. This bug was introduced by 27ba0dac.
> Will it be backported and submitted for inclusion in stable release by
> maintainer automatically?

That might not happen since there was no 'Fixes:' tag. Without that it
will depend on the stable tree maintainers whether they'll pick it up or not.

Regards,

	Hans
