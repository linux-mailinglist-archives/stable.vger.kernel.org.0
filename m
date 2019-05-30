Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB902FE0A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 16:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfE3Ok6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 10:40:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3Ok6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 10:40:58 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF0D5C04FFF6;
        Thu, 30 May 2019 14:40:51 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 655AE611A1;
        Thu, 30 May 2019 14:40:46 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 30 May 2019 16:40:51 +0200 (CEST)
Date:   Thu, 30 May 2019 16:40:45 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, dbueso@suse.de,
        Jens Axboe <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, e@80x24.org,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, omar.kilani@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error
 codes according to restore_user_sigmask())
Message-ID: <20190530144044.GG22536@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190529161157.GA27659@redhat.com>
 <CAK8P3a1fsrz6kAB1z-mqcaNvXL4Hf3XMiN=Q5rzAJ3rLGPK_Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1fsrz6kAB1z-mqcaNvXL4Hf3XMiN=Q5rzAJ3rLGPK_Yg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 30 May 2019 14:40:57 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/30, Arnd Bergmann wrote:
>
> I think this is a nice simplification, but it would help not to mix up the
> minimal regression fix with the rewrite of those functions.

Yes, yes, agreed.

Plus every file touched by this patch asks for more cleanups. Say, do_poll()
should return -ERESTARTNOHAND, not -EINTR, after that we can remove the ugly
EINTR->ERESTARTNOHAND in its callers. And more.

> For the stable
> kernels, I think we want just the addition of the 'bool interrupted' argument
> to restore_user_sigmask()

or simply revert this patch. I will check if this is possible today... At first
glance 854a6ed56839a40f6 fixed another bug by accident, do_pselect() did
"ret == -ERESTARTNOHAND" after "ret = poll_select_copy_remaining()" which can
turn ERESTARTNOHAND into EINTR, but this is simple. I'll check tomorrow.


> > -       ret = set_user_sigmask(ksig.sigmask, &ksigmask, &sigsaved, ksig.sigsetsize);
> > +       ret = set_xxx(ksig.sigmask, ksig.sigsetsize);
> >         if (ret)
> >                 return ret;
> >
> >         ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
> > -       restore_user_sigmask(ksig.sigmask, &sigsaved);
> > -       if (signal_pending(current) && !ret)
> > +
> > +       interrupted = signal_pending(current);
> > +       update_xxx(interrupted);
>
> Maybe name this
>
>            restore_saved_sigmask_if(!interrupted);

Yes, I thought about restore_if(), but to me

		restore_saved_sigmask_if(ret != -EINTR);

doesn't look readable... May be

		restore_saved_sigmask_unless(ret == -EINTR);

? but actually I agree with any naming.

> and make restore_saved_sigmask_if() an inline function
> next to restore_saved_sigmask()?

agreed,

> With some of the recent discussions about compat syscall handling,
> I now think that we want to just fold set_compat_user_sigmask()
> into set_user_sigmask()

agreed, and I thought about this too. But again, I'd prefer to do this
and other cleanups later, on top of this patch.

Oleg.

