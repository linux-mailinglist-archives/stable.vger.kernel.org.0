Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE84535913
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 10:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfFEI4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 04:56:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfFEI4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 04:56:20 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C53788307;
        Wed,  5 Jun 2019 08:56:14 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 76A465D705;
        Wed,  5 Jun 2019 08:56:06 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  5 Jun 2019 10:56:12 +0200 (CEST)
Date:   Wed, 5 Jun 2019 10:56:04 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Davidlohr Bueso <dbueso@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Message-ID: <20190605085604.GA32406@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 05 Jun 2019 08:56:19 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04, Linus Torvalds wrote:
>
> On Tue, Jun 4, 2019 at 6:41 AM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > This is the minimal fix for stable, I'll send cleanups later.
>
> Ugh. I htink this is correct, but I wish we had a better and more
> intuitive interface.

Yes,

> In particular, since restore_user_sigmask() basically wants to check
> for "signal_pending()" anyway

No, the caller should check signal_pending() anyway and this is enough.

> > -       restore_user_sigmask(ksig.sigmask, &sigsaved);
> > -       if (signal_pending(current) && !ret)
> > +
> > +       interrupted = signal_pending(current);
> > +       restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
> > +       if (interrupted && !ret)
> >                 ret = -ERESTARTNOHAND;
>
> are wrong to begin with,

This is fs/aio.c and I have already mentioned that this code doesn't look
right anyway.

> IOW, I think the above could become
>
>         ret = restore_user_sigmask(ksig.sigmask, &sigsaved, ret, -ERESTARTHAND);
>
> instead if we just made the right interface decision.

I think this particular code should simply do

		ret = do_io_getevents(...);

		if (ret == -ERESTARTSYS)
			ret = -EINTR;

		restore_user_sigmask(ret == -EINTR);

However I agree that another helper(s) which takes/returns the error code makes
sense and I was going to do this. Lets do this step by step, I think we should
kill sigmask/sigsaved first.

Oleg.

