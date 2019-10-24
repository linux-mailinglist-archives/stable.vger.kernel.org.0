Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595B8E344E
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393621AbfJXNed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:34:33 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38566 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393611AbfJXNec (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 09:34:32 -0400
Received: by mail-qt1-f195.google.com with SMTP id o25so24472579qtr.5
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 06:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRktfDKCEPWgmnY5Y7BD1nJ5OP47eE9gxExYGjtUFwY=;
        b=GDzCk5B/Z2g/VeVPfsI2R7C6lIrSHkxHYonPo5xCwj6ubV206IMo+sXliD2ICuq6Sd
         cxn9nrWlY1CmAwO8Yeb1bDhCDn24rCd0iSb3WqbMYJhq2CRmV3rSASRNp8YcODXneEYN
         pCr8sZh5gaQt56ixBDbGwiog9QN/b1C1E6tiMhlyXlE0fsUEQKjxEY5kg8dZlahSKnu8
         iAIM8n2qm3tCJW/nrN2jL1q73L1b9+SOx7VbSMkUQeXlg2pUdDdQbT7F0EOhMSgug3gQ
         FvnLR171MiT/6WsoUB9dz4pMdceXp5TvNmSnm4HXaoHyULjuM4WKXt9iqN0IZ532Pg3o
         81mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRktfDKCEPWgmnY5Y7BD1nJ5OP47eE9gxExYGjtUFwY=;
        b=WbijLCnTtwdigD6szmOa0Q7hWkG1ivTjrsrIOlQxRtmkdScG/axCI45j5vvjs7HSSg
         Syt2Ru0KMWz35U0EQ2izJzMU9f4SVBDSzSwhH37W0Ri2qagrMIZ+7fqXG8uO2iCtq8CR
         46p1W+TFzDnP2IcpmcycyvSgMN/hJbwMXNDGk4nsBmiczAxS6cex0si1oDZxcaqJWTle
         l6AC8iI6GwL1bYIcv03LZgqnJVayhgMd/Q9cwx7xVFVQxTUBz6okDpvFb6oBB2LUmxVa
         tNzRLoQqz+Wk3hYs5JgzURMV8yINpmJeFacm64xQahwgLm0mLUC+XFRM7GEVpNcfcmb2
         waIw==
X-Gm-Message-State: APjAAAXNCAkV8ef6t//S0pieS3M1FSm6DxLcxAHAmIN2Rqioq54eRYwc
        5LXUllFCHWMm02JEYDbnxg7xsd7SiEZ2tN3JengsCw==
X-Google-Smtp-Source: APXvYqxs+0q2P/sVEy9+xQMl/vvTH3Kbau5FJ0qrnR2H/o9cTI+kGFL3Vt+OjMpcMxXqivw1bOA8fjTubRYpp8pvuYg=
X-Received: by 2002:ac8:c89:: with SMTP id n9mr4162049qti.380.1571924071165;
 Thu, 24 Oct 2019 06:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com> <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com> <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
 <20191024130502.GA11335@andrea.guest.corp.microsoft.com> <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
 <20191024132136.jknzt7rgjssgv5b6@wittgenstein>
In-Reply-To: <20191024132136.jknzt7rgjssgv5b6@wittgenstein>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 24 Oct 2019 15:34:19 +0200
Message-ID: <CACT4Y+bgs3P9v_MqG4BpDM2ZC06kdUJbqKobH=rAXxwv6cBeRA@mail.gmail.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 3:21 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Thu, Oct 24, 2019 at 03:13:48PM +0200, Dmitry Vyukov wrote:
> > On Thu, Oct 24, 2019 at 3:05 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > >
> > > On Thu, Oct 24, 2019 at 01:51:20PM +0200, Dmitry Vyukov wrote:
> > > > On Thu, Oct 24, 2019 at 1:32 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > > > >
> > > > > > How these later loads can be completely independent of the pointer
> > > > > > value? They need to obtain the pointer value from somewhere. And this
> > > > > > can only be done by loaded it. And if a thread loads a pointer and
> > > > > > then dereferences that pointer, that's a data/address dependency and
> > > > > > we assume this is now covered by READ_ONCE.
> > > > >
> > > > > The "dependency" I was considering here is a dependency _between the
> > > > > load of sig->stats in taskstats_tgid_alloc() and the (program-order)
> > > > > later loads of *(sig->stats) in taskstats_exit().  Roughly speaking,
> > > > > such a dependency should correspond to a dependency chain at the asm
> > > > > or registers level from the first load to the later loads; e.g., in:
> > > > >
> > > > >   Thread [register r0 contains the address of sig->stats]
> > > > >
> > > > >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> > > > >      ...
> > > > >   B: LOAD r2,[r0]       // LOAD *(sig->stats)
> > > > >   C: LOAD r3,[r2]
> > > > >
> > > > > there would be no such dependency from A to C.  Compare, e.g., with:
> > > > >
> > > > >   Thread [register r0 contains the address of sig->stats]
> > > > >
> > > > >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> > > > >      ...
> > > > >   C: LOAD r3,[r1]       // LOAD *(sig->stats)
> > > > >
> > > > > AFAICT, there's no guarantee that the compilers will generate such a
> > > > > dependency from the code under discussion.
> > > >
> > > > Fixing this by making A ACQUIRE looks like somewhat weird code pattern
> > > > to me (though correct). B is what loads the address used to read
> > > > indirect data, so B ought to be ACQUIRE (or LOAD-DEPENDS which we get
> > > > from READ_ONCE).
> > > >
> > > > What you are suggesting is:
> > > >
> > > > addr = ptr.load(memory_order_acquire);
> > > > if (addr) {
> > > >   addr = ptr.load(memory_order_relaxed);
> > > >   data = *addr;
> > > > }
> > > >
> > > > whereas the canonical/non-convoluted form of this pattern is:
> > > >
> > > > addr = ptr.load(memory_order_consume);
> > > > if (addr)
> > > >   data = *addr;
> > >
> > > No, I'd rather be suggesting:
> > >
> > >   addr = ptr.load(memory_order_acquire);
> > >   if (addr)
> > >     data = *addr;
> > >
> > > since I'd not expect any form of encouragement to rely on "consume" or
> > > on "READ_ONCE() + true-address-dependency" from myself.  ;-)
> >
> > But why? I think kernel contains lots of such cases and it seems to be
> > officially documented by the LKMM:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt
> > address dependencies and ppo
>
> You mean this section:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt#n955
> and specifically:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt#n982
> ?

Yes, and also this:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt#n450
