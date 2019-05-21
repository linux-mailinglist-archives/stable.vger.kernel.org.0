Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2423E25AE1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 01:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfEUXdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 19:33:20 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:59806 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfEUXdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 19:33:20 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 7D2A61F462;
        Tue, 21 May 2019 23:33:19 +0000 (UTC)
Date:   Tue, 21 May 2019 23:33:19 +0000
From:   Eric Wong <e@80x24.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190521233319.GA17957@dcvr>
References: <20190507043954.9020-1-deepa.kernel@gmail.com>
 <20190521092551.fwtb6recko3tahwj@dcvr>
 <20190521152748.6b4cd70cf83a1183caa6aae7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521152748.6b4cd70cf83a1183caa6aae7@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 21 May 2019 09:25:51 +0000 Eric Wong <e@80x24.org> wrote:
> 
> > Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> > > For all the syscalls that receive a sigmask from the userland,
> > > the user sigmask is to be in effect through the syscall execution.
> > > At the end of syscall, sigmask of the current process is restored
> > > to what it was before the switch over to user sigmask.
> > > But, for this to be true in practice, the sigmask should be restored
> > > only at the the point we change the saved_sigmask. Anything before
> > > that loses signals. And, anything after is just pointless as the
> > > signal is already lost by restoring the sigmask.
> > > 
> > > The inherent issue was detected because of a regression caused by
> > > 854a6ed56839a.
> > > The patch moved the signal_pending() check closer to restoring of the
> > > user sigmask. But, it failed to update the error code accordingly.
> > > 
> > > Detailed issue discussion permalink:
> > > https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/
> > > 
> > > Note that the patch returns interrupted errors (EINTR, ERESTARTNOHAND,
> > > etc) only when there is no other error. If there is a signal and an error
> > > like EINVAL, the syscalls return -EINVAL rather than the interrupted
> > > error codes.
> > > 
> > > The sys_io_uring_enter() seems to be returning success when there is
> > > a signal and the queue is not empty. This seems to be a bug. I will
> > > follow up with a separate patch for that.
> > > 
> > > Reported-by: Eric Wong <e@80x24.org>
> > > Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
> > > Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> > > Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
> 
> (top-posting fixed).
> 
> > It's been 2 weeks and this fix hasn't appeared in mmots / mmotm.
> > I also noticed it's missing Cc: for stable@ (below)
> 
> Why is a -stable backport needed?  I see some talk above about lost
> signals but it is unclear whether these are being observed after fixing
> the regression caused by 854a6ed56839a.

I guess Deepa's commit messages wasn't clear...
I suggest prepending this as the first paragraph to Deepa's
original message:

  This fixes a bug introduced with 854a6ed56839a which caused
  EINTR to not be reported to userspace on epoll_pwait.  Failure
  to report EINTR to userspace caused problems with user code
  which relies on EINTR to run signal handlers.

> IOW, can we please have a changelog which has a clear and complete
> description of the user-visible effects of the change.
> 
> And please Cc Oleg.
