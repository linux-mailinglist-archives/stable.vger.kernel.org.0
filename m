Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97083B2C75
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 12:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhFXKcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 06:32:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32991 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhFXKcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 06:32:05 -0400
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1lwMcC-0006wI-Uh
        for stable@vger.kernel.org; Thu, 24 Jun 2021 10:29:45 +0000
Received: by mail-pj1-f69.google.com with SMTP id h8-20020a17090ac388b029016f602f0758so5687844pjt.2
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 03:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fp8p7HZuUA7dLzTxrkrRGItFpn1kDPBrup/d3fPNHEw=;
        b=FRYNwC7v1diA3H+C6q7BZCnm7wahBHBgqd6IDk/E9lCeg90D5RzmrPPRFuKSB/cCQC
         /ZDiVfN6Ge2L/51rGy08g01OuoHrT/tVPc4jN3Rc3rSKRh7SGfof6RNP9lS2MJltWhCI
         X4cS4l08/BEiJNo+Xxo6qCIHWqnoD8QTeCA9L1qppwxO1NkagUE2bsKb29dzxZDia5Xr
         gdCPd/WcoVgaajvcEklHxnGjleIoC0vp5RxMaMuTnxqed8Jo5MJay9qHcvz1JOopcO04
         znt9NQrV70ZVAWIVF1PdgwARCtVxlazM63EpHh3ZxfT53TlG8KZcpvTblv6pTkcT5biU
         0ntg==
X-Gm-Message-State: AOAM532Nbngwuw8QIH4v4IFYIVWdMGcGP+ok3YWbq5sqIg7lVEXe0RrI
        EKNUlzZv+IE33+cpwxjQYut6uBmg+JBibRz+zY9g/Zww5qJ36dnzWkQiqQgoz8C6HpIZmH5Mh80
        26qkhrfq7IkzZr4k0Xbnn+Rru4Ltg9k/Afj740A7iBLiBiXmT
X-Received: by 2002:a65:6659:: with SMTP id z25mr4096752pgv.291.1624530583628;
        Thu, 24 Jun 2021 03:29:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyh/cf8E3LbmxFWhYziPJsbPcYAWsD13MA8K3m3YL5HGEeA5Swn7XRMlE4u/QR2fNpWrqPm8L1B4ZB3DSp0psU=
X-Received: by 2002:a65:6659:: with SMTP id z25mr4096713pgv.291.1624530583241;
 Thu, 24 Jun 2021 03:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <17fc60a3-cc50-7cff-eb46-904c2f0c416e@canonical.com>
 <20201118235015.GB6015@geo.homenetwork> <20201119003319.GA6805@geo.homenetwork>
 <CAKfTPtBYm8UtBBnbc7qddA2_OAa3vwH=KoHNgvsQJ9zO2KocYQ@mail.gmail.com>
 <7c9462c9-8908-8592-0727-9117d4173724@canonical.com> <CAKfTPtAfzxbm0qM+8r2i+3jWjpJ2OLbU4F1WE8GrzTZH6Ck7FA@mail.gmail.com>
In-Reply-To: <CAKfTPtAfzxbm0qM+8r2i+3jWjpJ2OLbU4F1WE8GrzTZH6Ck7FA@mail.gmail.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Thu, 24 Jun 2021 18:29:29 +0800
Message-ID: <CAMy_GT88PgfH9F4Mo95wPSCTpGYJfRFpruc1QYg77t=HPBDaLQ@mail.gmail.com>
Subject: Re: [PATCH v3] sched/fair: fix unthrottle_cfs_rq for leaf_cfs_rq list
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Tao Zhou <t1zhou@163.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        SeongJae Park <sjpark@amazon.com>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Tao Zhou <ouwen210@hotmail.com>, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavan Kondeti <pkondeti@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Gavin Guo <gavin.guo@canonical.com>, halves@canonical.com,
        nivedita.singhvi@canonical.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Vincent,

sorry to resurrect this thread again,
I was trying to backport this patch and corresponding fixes to our
Ubuntu 4.15 kernel [1] to fix an issue report by LTP cfs_bandwidth01
test[2], my colleague Guilherme told me there once a discussion about
backporting this on this thread.

You mentioned here this should not be backported to earlier stable
kernel, I am curious if there is any specific reason of it? Too risky
maybe?
Thanks!
PHLin

[1] https://lists.ubuntu.com/archives/kernel-team/2021-June/121571.html
[2] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/sched/cfs-scheduler/cfs_bandwidth01.c


On Thu, Nov 19, 2020 at 9:25 PM Vincent Guittot
<vincent.guittot@linaro.org> wrote:
>
> On Thu, 19 Nov 2020 at 12:36, Guilherme G. Piccoli
> <gpiccoli@canonical.com> wrote:
> >
> >
> >
> > On 19/11/2020 05:36, Vincent Guittot wrote:
> > > On Thu, 19 Nov 2020 at 01:36, Tao Zhou <t1zhou@163.com> wrote:
> > >>
> > >> On Thu, Nov 19, 2020 at 07:50:15AM +0800, Tao Zhou wrote:
> > >>> On Wed, Nov 18, 2020 at 07:56:38PM -0300, Guilherme G. Piccoli wrote:
> > >>>> Hi Vincent (and all CCed), I'm sorry to ping about such "old" patch, but
> > >>>> we experienced a similar condition to what this patch addresses; it's an
> > >>>> older kernel (4.15.x) but when suggesting the users to move to an
> > >>>> updated 5.4.x kernel, we noticed that this patch is not there, although
> > >>>> similar ones are (like [0] and [1]).
> > >>>>
> > >>>> So, I'd like to ask if there's any particular reason to not backport
> > >>>> this fix to stable kernels, specially the longterm 5.4. The main reason
> > >>>> behind the question is that the code is very complex for non-experienced
> > >>>> scheduler developers, and I'm afraid in suggesting such backport to 5.4
> > >>>> and introduce complex-to-debug issues.
> > >>>>
> > >>>> Let me know your thoughts Vincent (and all CCed), thanks in advance.
> > >>>> Cheers,
> > >>>>
> > >>>>
> > >>>> Guilherme
> > >>>>
> > >>>>
> > >>>> P.S. For those that deleted this thread from the email client, here's a
> > >>>> link:
> > >>>> https://lore.kernel.org/lkml/20200513135528.4742-1-vincent.guittot@linaro.org/
> > >>>>
> > >>>>
> > >>>> [0]
> > >>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe61468b2cb
> > >>>>
> > >>>> [1]
> > >>>> https://lore.kernel.org/lkml/20200506141821.GA9773@lorien.usersys.redhat.com/
> > >>>> <- great thread BTW!
> > >>>
> > >>> 'sched/fair: Fix unthrottle_cfs_rq() for leaf_cfs_rq list" failed to apply to
> > >>> 5.4-stable tree'
> > >>>
> > >>> You could check above. But I do not have the link about this. Can't search it
> > >>> on LKML web: https://lore.kernel.org/lkml/
> > >>>
> > >>> BTW: 'ouwen210@hotmail.com' and 'zohooouoto@zoho.com.cn' all is myself.
> > >>>
> > >>> Sorry for the confusing..
> > >>>
> > >>> Thanks.
> > >>
> > >> Sorry again. I forget something. It is in the stable.
> > >>
> > >> Here it is:
> > >>
> > >>   https://lore.kernel.org/stable/159041776924279@kroah.com/
> > >
> > > I think it has never been applied to stable.
> > > As you mentioned, the backport has been sent :
> > > https://lore.kernel.org/stable/20200525172709.GB7427@vingu-book/
> > >
> > > I received another emailed in September and pointed out to the
> > > backport : https://www.spinics.net/lists/stable/msg410445.html
> > >
> > >
> > >>
> >
> > Thanks a lot Tao and Vincent! Nice to know that you already worked the
> > backport, gives much more confidence when the author does that heheh
> >
> > So, this should go to stable 5.4.y, but not 4.19.y IIUC?
>
> Yeah. they should be backported up to v5.1 but not earlier
>
> Regards,
> Vincent
>
> > Cheers,
> >
> >
> > Guilherme
