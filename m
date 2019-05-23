Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906C2283E1
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 18:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbfEWQgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 12:36:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbfEWQgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 12:36:21 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1484A308624A;
        Thu, 23 May 2019 16:36:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0D76C60C9E;
        Thu, 23 May 2019 16:36:07 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 23 May 2019 18:36:08 +0200 (CEST)
Date:   Thu, 23 May 2019 18:36:04 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Deepa Dinamani' <deepa.kernel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190523163604.GE23070@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 23 May 2019 16:36:21 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/23, David Laight wrote:
>
> From: Oleg Nesterov
> > On 05/23, David Laight wrote:
> > >
> > > I'm confused...
> >
> > Me too. To clarify, the current code is obviously buggy, pselect/whatever
> > shouldn't return 0 (or anything else) if it was interrupted and we are going
> > to deliver the signal.
>
> If it was interrupted the return value has to be EINTR.

Yes, and this is what we need to fix.

> Whether any signal handlers are called is a separate matter.

Not really... because in this case we know that the signal will be delivered,

> > Not sure I understand... OK, suppose that you do
> >
> > 	block-all-signals;
> > 	ret = pselect(..., sigmask(SIG_URG));
> >
> > if it returns success/timeout then the handler for SIG_URG should not be called?
>
> Ugg...
> Posix probably allows the signal handler be called at the point the event
> happens rather than being deferred until the system call completes.
> Queueing up the signal handler to be run at a later time (syscall exit)
> certainly makes sense.
> Definitely safest to call the signal handler even if success/timeout
> is returned.

Why?

> pselect() exists to stop the entry race, not the exit one.

pselect() has to block SIG_URG again before it returns to user-mode, right?

Suppose pselect() finds a ready fd, and this races with SIG_URG.

Why do you think the handler should run?

What if SIG_URG comes right after pselect() blocks SIG_URG again? I mean,
how this differs the case when it comes before, but a ready fd was already
found?

Oleg.

