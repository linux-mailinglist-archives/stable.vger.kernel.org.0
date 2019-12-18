Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE242124730
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 13:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLRMqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 07:46:15 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33988 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLRMqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 07:46:14 -0500
Received: by mail-pf1-f195.google.com with SMTP id l127so1168705pfl.1
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 04:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yluChybCoEtCO6LswLntX+4auTP4ivgdcSe24D3NLf0=;
        b=IgKYAiNKTGUEIuh3ZBy1pxqBWb8WrUSdt5oJ4eV/8ICtTRsKT899NMQE+gVJfQ8A5L
         JCRC79cO0mpCgr7dnRnI8RhkbwodS2TPRpZh0Ajhh7rRG7d6YowIDs1DzxIdl1LjEC73
         2+GAqsjfRkISNglNa0dgKCofJSunyEEuf3sY4AoCdwQn2BY7zFG7YhBwC92xHnWHNbvL
         qhNeXi3/C1RLuf2oqE5+4mKWaeXNhg9lKXFbNptS7eFpmyYWeRnenQWCcrBn6cQUkT2g
         i+i+yuNosiSD8am6g976jYNQ37XbBzja9SKyDYoZmrgewtTU4cmwRowsV7zqTeIRU/uG
         oMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yluChybCoEtCO6LswLntX+4auTP4ivgdcSe24D3NLf0=;
        b=aMcUVWreTSEsceDoD2zVp4Elo2fAiLGbSVhSx+J8qmf9DH+eQIcnQMerN74vivR41z
         SsntDJ+1ChivWNlZlAY2A+HdVnvRP7oMjSoTlYEvToWJuryWSRU7cSJhxV8/x0eCEMhC
         myr9YQwKNFJKgiJWu1Dy1ACYzF5rBRsMoxKMd8N5VVuX41BqFobMduNnwcZfitE7J6BQ
         glTu1zI1ILouwlo3CdFXE1FBKJRtdUCykOXtYEJydeTZXeXAH3xYeKdef/Y4vs/U9XVt
         vZC8XXEsnFleOIvC7g4L/Fofcy43cDP7oz+7+wMU661t83IY1uFiDMUdBKQPpE7tJxh9
         plDw==
X-Gm-Message-State: APjAAAVnkkYu6q8709KEaAze4V7wJ4TZahSlmtMqKroIOphN2sFrR0vC
        HFuxqZghW/aSLkHNfaOddtLGejGlUAQMRll2S8/dfA==
X-Google-Smtp-Source: APXvYqxkhNJRqzXYC42cGmDXz7PIECqCbtXde3JI6sc7pAAm62yrqdnrGPZDmc7/dNRQGKy/SxMONAF/P8dJwp/qrSc=
X-Received: by 2002:a65:678f:: with SMTP id e15mr2900742pgr.130.1576673173313;
 Wed, 18 Dec 2019 04:46:13 -0800 (PST)
MIME-Version: 1.0
References: <20191108154838.21487-1-will@kernel.org> <20191108155503.GB15731@pendragon.ideasonboard.com>
 <20191216121651.GA12947@willie-the-truck> <CAAeHK+xdVmEFtK78bWd2Odn0uBynqnt5UT9jZJFvqGL=_9NU2w@mail.gmail.com>
 <20191218114137.GA15505@willie-the-truck> <20191218122324.GB17086@kroah.com>
In-Reply-To: <20191218122324.GB17086@kroah.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 18 Dec 2019 13:46:00 +0100
Message-ID: <CAAeHK+xyv-x6ejwcqNAn=5eKoBYPkJsN=SgJLHJ1ey=6v+YyyA@mail.gmail.com>
Subject: Re: [PATCH RESEND RESEND] media: uvc: Avoid cyclic entity chains due
 to malformed USB descriptors
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 1:23 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 18, 2019 at 11:41:38AM +0000, Will Deacon wrote:
> > On Mon, Dec 16, 2019 at 02:17:52PM +0100, Andrey Konovalov wrote:
> > > On Mon, Dec 16, 2019 at 1:16 PM Will Deacon <will@kernel.org> wrote:
> > > > On Fri, Nov 08, 2019 at 05:55:03PM +0200, Laurent Pinchart wrote:
> > > > > Thank you for the patch.
> > > > >
> > > > > I'm sorry for the delay, and will have to ask you to be a bit more
> > > > > patient I'm afraid. I will leave tomorrow for a week without computer
> > > > > access and will only be able to go through my backlog when I will be
> > > > > back on the 17th.
> > > >
> > > > Gentle reminder on this, now you've been back a month ;)
> > >
> > > I think we now have a reproducer for this issue that syzbot just reported:
> > >
> > > https://syzkaller.appspot.com/bug?extid=0a5c96772a9b26f2a876
> > >
> > > You can try you patch on it :)
> >
> > Oh wow, I *really* like the raw USB gadget thingy you have to reproduce
> > these! I also really like that this patch fixes the issue. Logs below.

Thanks! An easier way to test the patch would be to issue a syz test
command, but I'm glad you managed to set up raw gadget manually and it
worked for you.

>
> Ok, that's a good poke for me to go review that raw gadget code to see
> if it can be merged upstream :)

Looking forward to it! =)

>
> > Laurent -- can we please merge this now?
>
> Yes, that would be good to have, as this obviously fixes a problem, and
> I can take it off of my "patches to track" list....
>
> thanks,
>
> greg k-h
