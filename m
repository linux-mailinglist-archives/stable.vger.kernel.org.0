Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4843A218B
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 02:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhFJAm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 20:42:58 -0400
Received: from relais.etsmtl.ca ([142.137.1.25]:55110 "EHLO relais.etsmtl.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFJAm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 20:42:58 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2021 20:42:58 EDT
Content-Type: text/plain; charset="UTF-8"
DKIM-Signature: v=1; a=rsa-sha256; d=etsmtl.ca; s=bbb; c=relaxed/relaxed;
        t=1623284761; h=from:subject:to:date:ad-hoc;
        bh=YrcDoTRJREfJvkaI1wsHtH/dI3ibV2/I8hsUsmQp/FE=;
        b=vcwVKLK2kLt9b/0T3TiDTOPrSPMAoXIxj9ozjpMm8UaRgC7FXsZFvwwTuUPSefrsWmOvcWRquS5
        0d482R/Ge2FGSY2JCU4j7XlCg4ASoo0zvA9CInBeigzwRDxHtXrPvzRDr58DM3605dPjEA3ur79Fp
        nL6hl9w9YGVUavm6vcg=
X-Gm-Message-State: AOAM531q5zH1R5DB3cSGAnZxWT5+HvoKlEmvZ1lBZnDl0HB8PuQYdIqP
        OTsi0OTIDJqixHvs/hs9DecqNIULlkm1N8MZlCY=
X-Google-Smtp-Source: ABdhPJyXcYRjnkzIL338agj5rjfpR8b4kGCNuXiITSIp3obKAC251x/UpkiLISJl64/fnC+COmBdw9gUVOLUWPJ+pJI=
X-Received: by 2002:a05:6122:614:: with SMTP id u20mr2918033vkp.20.1623284758318;
 Wed, 09 Jun 2021 17:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210604161023.1498582-1-pascal.giard@etsmtl.ca> <YLsdEtbAWJxLB+GF@kroah.com>
In-Reply-To: <YLsdEtbAWJxLB+GF@kroah.com>
From:   Pascal Giard <pascal.giard@etsmtl.ca>
Date:   Wed, 9 Jun 2021 20:25:47 -0400
X-Gmail-Original-Message-ID: <CAJNNDmk7z=aJtx00C+8kpBOk0j_XVOk2fDMG9Xf9Na_ChXM2OA@mail.gmail.com>
Message-ID: <CAJNNDmk7z=aJtx00C+8kpBOk0j_XVOk2fDMG9Xf9Na_ChXM2OA@mail.gmail.com>
Subject: Re: [PATCH] HID: sony: fix freeze when inserting ghlive ps3/wii dongles
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Daniel Nguyen <daniel.nguyen.1@ens.etsmtl.ca>
X-Originating-IP: [142.137.250.50]
X-ClientProxiedBy: FacteurB.ad.etsmtl.ca (10.162.28.15) To
 FacteurB.ad.etsmtl.ca (10.162.28.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 5, 2021 at 2:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 04, 2021 at 12:10:23PM -0400, Pascal Giard wrote:
> > This commit fixes a freeze on insertion of a Guitar Hero Live PS3/WiiU
> > USB dongle. Indeed, with the current implementation, inserting one of
> > those USB dongles will lead to a hard freeze. I apologize for not
> > catching this earlier, it didn't occur on my old laptop.
> >
> > While the issue was isolated to memory alloc/free, I could not figure
> > out why it causes a freeze. So this patch fixes this issue by
> > simplifying memory allocation and usage.
> >
> > We remind that for the dongle to work properly, a control URB needs to
> > be sent periodically. We used to alloc/free the URB each time this URB
> > needed to be sent.
> >
> > With this patch, the memory for the URB is allocated on the probe, reused
> > for as long as the dongle is plugged in, and freed once the dongle is
> > unplugged.
> >
> > Signed-off-by: Pascal Giard <pascal.giard@etsmtl.ca>
> > ---
> >  drivers/hid/hid-sony.c | 98 +++++++++++++++++++++---------------------
> >  1 file changed, 49 insertions(+), 49 deletions(-)
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

Dear Greg,

I apologize for failing to follow the procedure. I had already read
these guidelines, and I actually thought I was following Option 1 :-/

I thought that I had to get my patch merged into next first (patch
against dtor's git) and that by adding stable@ as CC, it would
automatically get considered for inclusion into stable once merged
into Linus' tree. Based on your email, I got that wrong...

So I sent my patch to the right place BUT my patch should be against
this [1] tree instead?

Thank you for your patience,

-Pascal
[1] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
