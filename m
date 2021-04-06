Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA9F35504B
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 11:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhDFJoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 05:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhDFJoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 05:44:54 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FB3C06174A;
        Tue,  6 Apr 2021 02:44:47 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j18so13470223wra.2;
        Tue, 06 Apr 2021 02:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=c3VPXku/wlc/72yWuPj7c0yUNXSw4O8ty+i4pDGv8po=;
        b=Bg3WXLoPzwow4EQCefMMqupQlhAeZOvcKR1ZK7qVyaUc47QXGcYnUGIFpVT7AFUAoL
         l8UAQJXLPHTrR3JI/x8INb1q0l07F+5hOCNKeCMKYkb5xav1vYrJv5N6zWw5AO+ZJb/U
         8tnuHjJ2leFJfZxHubva6H3cOe1q+RidbmQJ4kDL19eTbiuuLZ9B4/EfjBwpUmQfdBNX
         DZ7MBHon9B/vdfRC9GRdvq8aX6/3VlX9KeBoAXtLL4CcxrbnJ6bC87SwJdIGZxRHvZX8
         j7a1aBFZq/63dBMjAQxThVcUzgbQinCFdom3K3hlrxYRwv4E+6lO0jhMvTLZX9Oxhdzu
         /DSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=c3VPXku/wlc/72yWuPj7c0yUNXSw4O8ty+i4pDGv8po=;
        b=kh0uvutgPBrDNf7Y2EEqMOIr/zhvKzj9lxnuYkpRxUVSmqcrhRX74p640kjOk/sOoy
         Um4VHHd4wjQl6c0C4W8mYa6rQJ+ig2w7qRcKroG+zJM1bx5HX2NTo/daj/cOAWDdVkoC
         X2sSfmtvGKZTtvg0Y1FQJjRkjIhIMVak5bamVJALtHA2NX2OGA0t3T1641VlKwwqtfln
         Ye9+UMzpp9OwMYbzEz9+DL25NngwiJY6GulaLrhrrZIbythmorKluv+W5mODOZFtkE8t
         b3Mx+vLKdDllSDIC5j6kdlEUOjptraxfmiesD3w0XC0Qz5O6iz+N/dHAb6B3jOORFrBS
         Psyw==
X-Gm-Message-State: AOAM533ineAHW/WQhNo/efYyH/k30o4HJ4SIgjzuWlrmTQoE42oO81s0
        /4+Tq6cbnlk01mPVj5bUCrg=
X-Google-Smtp-Source: ABdhPJzeKfCK/GOfVRmrOtbm6wzzALVV+vBBcFh0oV6GaRnyEyH8bUJFrtR8DZzsGKuDgBal6w3xmQ==
X-Received: by 2002:adf:cc8d:: with SMTP id p13mr9364902wrj.50.1617702286154;
        Tue, 06 Apr 2021 02:44:46 -0700 (PDT)
Received: from 192.168.10.5 ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id r206sm2071738wma.46.2021.04.06.02.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 02:44:45 -0700 (PDT)
Message-ID: <57f041d036a6a472c1463ab5d5274df5bb646920.camel@gmail.com>
Subject: Re: [PATCH] media: em28xx: fix memory leak
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     hverkuil-cisco@xs4all.nl, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, skhan@linuxfoundation.org
Cc:     musamaanjum@gmail.com, syzkaller-bugs@googlegroups.com,
        dvyukov@google.com, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:EM28XX VIDEO4LINUX DRIVER" <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Date:   Tue, 06 Apr 2021 14:44:40 +0500
In-Reply-To: <675efa79414d2d8cb3696d3ca3a0c3be99bd92fa.camel@gmail.com>
References: <20210324180753.GA410359@LEGION>
         <675efa79414d2d8cb3696d3ca3a0c3be99bd92fa.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-03-31 at 13:22 +0500, Muhammad Usama Anjum wrote:
> On Wed, 2021-03-24 at 23:07 +0500, Muhammad Usama Anjum wrote:
> > If some error occurs, URB buffers should also be freed. If they aren't
> > freed with the dvb here, the em28xx_dvb_fini call doesn't frees the URB
> > buffers as dvb is set to NULL. The function in which error occurs should
> > do all the cleanup for the allocations it had done.
> > 
> > Tested the patch with the reproducer provided by syzbot. This patch
> > fixes the memleak.
> > 
> > Reported-by: syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com
> > Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
> > ---
> > Resending the same path as some email addresses were missing from the
> > earlier email.
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    1a4431a5 Merge tag 'afs-fixes-20210315' of git://git.kerne..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11013a7cd00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ff6b8b2e9d5a1227
> > dashboard link: https://syzkaller.appspot.com/bug?extid=889397c820fa56adf25d
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1559ae3ad00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176985c6d00000
> > 
> >  drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> > index 526424279637..471bd74667e3 100644
> > --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> > @@ -2010,6 +2010,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
> >  	return result;
> >  
> >  out_free:
> > +	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
> >  	kfree(dvb);
> >  	dev->dvb = NULL;
> >  	goto ret;
> 
> I'd received the following notice and waiting for the review:
> On Thu, 2021-03-25 at 09:06 +0000, Patchwork wrote:
> > Hello,
> > 
> > The following patch (submitted by you) has been updated in Patchwork:
> > 
> >  * linux-media: media: em28xx: fix memory leak
> >      - http://patchwork.linuxtv.org/project/linux-media/patch/20210324180753.GA410359@LEGION/
> >      - for: Linux Media kernel patches
> > 
This patch has been accepted. This bug was introduced by 27ba0dac.
Will it be backported and submitted for inclusion in stable release by
maintainer automatically?
> > 
> 
> Thanks,
> Usama
> 
> 

