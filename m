Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC856144E1B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 09:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgAVI6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 03:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgAVI6M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 03:58:12 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C78BA2253D;
        Wed, 22 Jan 2020 08:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579683491;
        bh=L5+TjZZJ8+VeycRrVHojzkOrux+l43ihduPe3QgHk4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qzre03S/wypM/ojjE4jxh/az4YA+uF3N3B0tXUW1xMhb/EAJwvqdbCZ1dGM0tuD5E
         5PJWxjJED3ew6MQGmXNLCYLb2e8IUxWsbz1tvqeapgNHuaZjFtPgkhFXKvCmx0RajU
         b3hrQsdu4bvqu65ESrJAFwm5wbjUe6qu+tfgOSrY=
Date:   Wed, 22 Jan 2020 08:58:06 +0000
From:   Will Deacon <will@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND RESEND] media: uvc: Avoid cyclic entity chains due
 to malformed USB descriptors
Message-ID: <20200122085805.GA15537@willie-the-truck>
References: <20191108154838.21487-1-will@kernel.org>
 <20191108155503.GB15731@pendragon.ideasonboard.com>
 <20191216121651.GA12947@willie-the-truck>
 <CAAeHK+xdVmEFtK78bWd2Odn0uBynqnt5UT9jZJFvqGL=_9NU2w@mail.gmail.com>
 <20191218114137.GA15505@willie-the-truck>
 <20191218122324.GB17086@kroah.com>
 <CAAeHK+xyv-x6ejwcqNAn=5eKoBYPkJsN=SgJLHJ1ey=6v+YyyA@mail.gmail.com>
 <20191218165153.GC17876@pendragon.ideasonboard.com>
 <20200121190142.GB13592@willie-the-truck>
 <20200121225305.GL5003@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121225305.GL5003@pendragon.ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 12:53:05AM +0200, Laurent Pinchart wrote:
> On Tue, Jan 21, 2020 at 07:01:42PM +0000, Will Deacon wrote:
> > On Wed, Dec 18, 2019 at 06:51:53PM +0200, Laurent Pinchart wrote:
> > > On Wed, Dec 18, 2019 at 01:46:00PM +0100, Andrey Konovalov wrote:
> > > > On Wed, Dec 18, 2019 at 1:23 PM Greg Kroah-Hartman wrote:
> > > > > On Wed, Dec 18, 2019 at 11:41:38AM +0000, Will Deacon wrote:
> > > > >> On Mon, Dec 16, 2019 at 02:17:52PM +0100, Andrey Konovalov wrote:
> > > > >>> On Mon, Dec 16, 2019 at 1:16 PM Will Deacon <will@kernel.org> wrote:
> > > > >>>> On Fri, Nov 08, 2019 at 05:55:03PM +0200, Laurent Pinchart wrote:
> > > > >>>>> Thank you for the patch.
> > > > >>>>>
> > > > >>>>> I'm sorry for the delay, and will have to ask you to be a bit more
> > > > >>>>> patient I'm afraid. I will leave tomorrow for a week without computer
> > > > >>>>> access and will only be able to go through my backlog when I will be
> > > > >>>>> back on the 17th.
> > > > >>>>
> > > > >>>> Gentle reminder on this, now you've been back a month ;)
> > > > >>>
> > > > >>> I think we now have a reproducer for this issue that syzbot just reported:
> > > > >>>
> > > > >>> https://syzkaller.appspot.com/bug?extid=0a5c96772a9b26f2a876
> > > > >>>
> > > > >>> You can try you patch on it :)
> > > > >>
> > > > >> Oh wow, I *really* like the raw USB gadget thingy you have to reproduce
> > > > >> these! I also really like that this patch fixes the issue. Logs below.
> > > > 
> > > > Thanks! An easier way to test the patch would be to issue a syz test
> > > > command, but I'm glad you managed to set up raw gadget manually and it
> > > > worked for you.
> > > > 
> > > > >
> > > > > Ok, that's a good poke for me to go review that raw gadget code to see
> > > > > if it can be merged upstream :)
> > > > 
> > > > Looking forward to it! =)
> > > 
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > and merged in my tree. I'm so sorry for the way too long delay.
> > 
> > Please can you send this upstream and/or put it in linux-next? I can't see
> > it anywhere at the moment :(
> 
> I've now sent the pull request.

Thanks, Laurent.

> Seems I failed the schedule from A to Z with this patch. I'm extremely
> sorry :-(

Well, at least you were consistent ;)

Will
