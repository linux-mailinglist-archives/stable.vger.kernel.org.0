Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A9042756
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 15:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437483AbfFLNTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 09:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437469AbfFLNTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 09:19:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95794821D8;
        Wed, 12 Jun 2019 13:19:26 +0000 (UTC)
Received: from localhost (ovpn-12-46.pek2.redhat.com [10.72.12.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E946F5D961;
        Wed, 12 Jun 2019 13:19:25 +0000 (UTC)
Date:   Wed, 12 Jun 2019 21:19:22 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [v5] x86/mm/KASLR: Fix the size of vmemmap section
Message-ID: <20190612131922.GO26148@MiWiFi-R3L-srv>
References: <CA+icZUXaXhvm46tA2aHO=85Lv16Y4=DOnz7OBRyfztp=i0_a5Q@mail.gmail.com>
 <20190612101519.GM26148@MiWiFi-R3L-srv>
 <CA+icZUV78MPyLRie4MWa0PZ-UObpG33gmZhFfHD1rFsTqV7vnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUV78MPyLRie4MWa0PZ-UObpG33gmZhFfHD1rFsTqV7vnw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 12 Jun 2019 13:19:31 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/12/19 at 02:48pm, Sedat Dilek wrote:
> On Wed, Jun 12, 2019 at 12:15 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 06/04/19 at 01:46pm, Sedat Dilek wrote:
> > > [ CC me I am not subscribed to linux-stable ML ]
> > > [ CC Greg and Sasha ]
> > >
> > > Hi Baoquan,
> > >
> > > that should be s/Fiexes/Fixes for the "Fixes tag".
> > >
> > > OLD: Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
> > > for CONFIG_X86_5LEVEL=y")
> > > NEW: Fixes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic
> > > for CONFIG_X86_5LEVEL=y")
> > >
> > > Also, you can add...
> > >
> > > Cc: stable@vger.kernel.org # v4.19+
> > >
> > > ...to catch the below.
> > >
> > > [ QUOTE ]
> > > You can see that it was added in kernel 4.17-rc1, as above. Can we just
> > > apply this patch to stable trees after 4.17?
> >
> > Oops, I just noticed this mail today, sorry.
> >
> > Boris has picked it into tip/x86/urgent. It should be in linus's tree
> > very soon. Appreciate your help anyway.
> >
> 
> I have applied the patch set from [0] and booted into the new kernel.
> 
> But I have set...
> 
> CONFIG_PGTABLE_LEVELS=4
> # CONFIG_X86_5LEVEL is not set
> 
> To test this I need CONFIG_X86_5LEVEL=y?
> Best two kernels with and without your patch.

Yeah, with CONFIG_X86_5LEVEL=y.

In fact I didn't have chance to trigger the issue to reproduce, then
apply this patch to fix. As you know, the machine with large memory is
too few. This is a code bug, so I just run the level 4 kernel and level
5 kernel to test the basic functionality.

If you have machine owning RAM 64 TB, and it supports 5-level, you can
build two kernels w and w/o this patch, it's easy to reproduce.

> 
> - Sedat -
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/x86/x86_64/5level-paging.rst
> 
> > Thanks
> > Baoquan
> >
> > >
> > > >
> > > > v5.1.4: Build OK!
> > > > v5.0.18: Build OK!
> > > > v4.19.45: Build OK!
> > > [ /QUOTE ]
> > >
> > > I had an early patchset of you tested (which included this one IIRC),
> > > so feel free to add my...
> > >
> > >    Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > >
> > > Hope this lands in tip or linux-stable Git.
> > >
> > > Thanks.
> > >
> > > Regards,
> > > - Sedat -
> > >
> > > [1] https://lore.kernel.org/patchwork/patch/1077557/
