Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE43E3C8615
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 16:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhGNO3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 10:29:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhGNO3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 10:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6377611AD;
        Wed, 14 Jul 2021 14:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626272815;
        bh=3v5ilymBybdRvRvSEDJA+KRVQFXBDlKQaJO3h7AHNns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J5A//K4QYzuaoQXYksR17krj680x/1plUUKO9URyxTJNCbhfAr3F1EKWaCa3Hwn/1
         226rI+IMe6/JK/l3ieIXqFdP1sXvgEzwYelpuIFrj8Ch3z2XmWHwXyBBMYnx6aC759
         vGd3KqAVHCmcIE9OKDbGObHd+yeubuKOg6d5hI1Q=
Date:   Wed, 14 Jul 2021 16:26:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Holger Kiehl <Holger.Kiehl@dwd.de>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
Message-ID: <YO70LLnTE6LxcBnt@kroah.com>
References: <20210712060912.995381202@linuxfoundation.org>
 <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com>
 <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de>
 <YO7nHhW2t4wEiI9G@kroah.com>
 <CA+G9fYuhbE6sY3ykoiyqZqYSG=+V0r3z0TiaVL8LptbXWw=duQ@mail.gmail.com>
 <CA+G9fYtWkOLVVKB0xYfAXWS57G1C2xV-Zbtp5i4dAJDJqwLQhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtWkOLVVKB0xYfAXWS57G1C2xV-Zbtp5i4dAJDJqwLQhg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 07:29:26PM +0530, Naresh Kamboju wrote:
> On Wed, 14 Jul 2021 at 19:22, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Wed, 14 Jul 2021 at 19:01, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> 
> <trim>
> 
> > My two cents,
> > While running ssuite long running stress testing we have noticed deadlock.
> >
> > > So if you drop that, all works well?  I'll go drop that from the queues
> > > now.
> >
> > Let me drop that patch and test it again.
> >
> > Crash log,
> >
> > [ 1957.278399] ============================================
> > [ 1957.283717] WARNING: possible recursive locking detected
> > [ 1957.289031] 5.13.2-rc1 #1 Not tainted
> > [ 1957.292703] --------------------------------------------
> > [ 1957.298016] kworker/u8:7/236 is trying to acquire lock:
> > [ 1957.303241] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> > bfq_finish_requeue_request+0x55/0x500 [bfq]
> > [ 1957.312643]
> > [ 1957.312643] but task is already holding lock:
> > [ 1957.318467] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
> > bfq_insert_requests+0x81/0x1750 [bfq]
> > [ 1957.327334]
> > [ 1957.327334] other info that might help us debug this:
> > [ 1957.333852]  Possible unsafe locking scenario:
> > [ 1957.333852]
> > [ 1957.339762]        CPU0
> > [ 1957.342206]        ----
> > [ 1957.344651]   lock(&bfqd->lock);
> > [ 1957.347873]   lock(&bfqd->lock);
> > [ 1957.351097]
> > [ 1957.351097]  *** DEADLOCK ***
> > [ 1957.351097]
> 
> Also noticed on stable-rc 5.12.17-rc1.

I dropped the same patch from there as well already, thanks.

greg k-h
