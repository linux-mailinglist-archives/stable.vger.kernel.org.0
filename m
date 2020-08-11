Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81C824168F
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 08:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgHKG5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 02:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728116AbgHKG5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 02:57:13 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A767C06174A;
        Mon, 10 Aug 2020 23:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OWWNJvWPIndEqb6wl9zSkQcJ0zXQ6TPJf2KSMd6xWU0=; b=DQKzNRk54WlNTp7eB5I1xdARRa
        S105AzzEl0oOn8wrr0Qq4sdtfdnj5XB2BDQr17SrPVwV6A437/7LC+aNfcwMr0y7zNDGQ7+Gh6MRJ
        qgYeuH1ghYGOIDxkLv41q4Vq45odG3kSKgJ25sxIsPwO7/1HTHDAG02+0LmIvnZf1fCURcgBEBLSw
        06sjsFWQ2mTo9xvef+4xuSuJ+naKBAnDB+G+lIWPgCSxpafpY1anti9RgB1kJW83RHBS1dIYt/9GO
        S1+AganBfn+Ho+T6gG9+osTCjYbCqAfV2s+8Y7be5E0nOsa9es2HfdPBECeWlVdsEueyOmPB+q9O2
        4EW3PsJQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5ODY-0008Sq-0a; Tue, 11 Aug 2020 06:57:04 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5BA5D980CA0; Tue, 11 Aug 2020 08:56:59 +0200 (CEST)
Date:   Tue, 11 Aug 2020 08:56:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
References: <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811064516.GA21797@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 08:45:16AM +0200, Oleg Nesterov wrote:
> On 08/11, Jann Horn wrote:
> >
> > > --- a/kernel/task_work.c
> > > +++ b/kernel/task_work.c
> > > @@ -42,7 +42,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
> > >                 set_notify_resume(task);
> > >                 break;
> > >         case TWA_SIGNAL:
> > > -               if (lock_task_sighand(task, &flags)) {
> > > +               if (!(task->jobctl & JOBCTL_TASK_WORK) &&
> > > +                   lock_task_sighand(task, &flags)) {
> > >                         task->jobctl |= JOBCTL_TASK_WORK;
> > >                         signal_wake_up(task, 0);
> > >                         unlock_task_sighand(task, &flags);
> > 
> > I think that should work in theory, but if you want to be able to do a
> > proper unlocked read of task->jobctl here, then I think you'd have to
> > use READ_ONCE() here
> 
> Agreed,
> 
> > and make all existing writes to ->jobctl use
> > WRITE_ONCE().
> 
> ->jobctl is always modified with ->siglock held, do we really need
> WRITE_ONCE() ?

In theory, yes. The compiler doesn't know about locks, it can tear
writes whenever it feels like it. In practise it doesn't happen much,
but...
