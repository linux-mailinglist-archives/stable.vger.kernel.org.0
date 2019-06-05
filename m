Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76053593F
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 11:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfFEJFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 05:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfFEJFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 05:05:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42F9630832C9;
        Wed,  5 Jun 2019 09:04:59 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id F089B5D6A9;
        Wed,  5 Jun 2019 09:04:55 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  5 Jun 2019 11:04:58 +0200 (CEST)
Date:   Wed, 5 Jun 2019 11:04:54 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()
Message-ID: <20190605090453.GB32406@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <20190604134117.GA29963@redhat.com>
 <CAHk-=wjSOh5zmApq2qsNjmY-GMn4CWe9YwdcKPjT+nVoGiDKOQ@mail.gmail.com>
 <878sugewok.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sugewok.fsf@xmission.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 05 Jun 2019 09:05:04 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04, Eric W. Biederman wrote:
>
> >> -       restore_user_sigmask(ksig.sigmask, &sigsaved);
> >> -       if (signal_pending(current) && !ret)
> >> +
> >> +       interrupted = signal_pending(current);
> >> +       restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
> >> +       if (interrupted && !ret)
> >>                 ret = -ERESTARTNOHAND;
> >
> > are wrong to begin with, and we really should aim for an interface
> > which says "tell me whether you completed the system call, and I'll
> > give you an error return if not".
>
> The pattern you are pointing out is specific to io_pgetevents and it's
> variations.  It does look buggy to me but not for the reason you point
> out, but instead because it does not appear to let a pending signal
> cause io_pgetevents to return early.
>
> I suspect we should fix that and have do_io_getevents return
> -EINTR or -ERESTARTNOHAND like everyone else.

Exactly. It should not even check signal_pending(). It can rely on
wait_event_interruptible_hrtimeout().

> So can we please get this fix in and then look at cleaning up and
> simplifying this code.

Yes ;)

Oleg.

