Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53E25A4B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 00:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbfEUW1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 18:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfEUW1u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 18:27:50 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A5C217D7;
        Tue, 21 May 2019 22:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558477669;
        bh=f5uEoHUN4BmcdB5I8paRLRa+KIbFOaIzyTepmZ7yDes=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aYlPqqP861Eho4x2nqqJFvRWWd/odtIQcz9aqclko8lAceqQYjeJ/t5tGi1KP0wiJ
         038YM5HOU3qLCLPDaAKxkytnBl/M5vZrjsK5K7vMh2XNjz4DcB73WwBR2Yl2AJi/Sm
         bOws1O/C+vDEjEsToQuVRz5LZMZVnS7PF8zdTE5Q=
Date:   Tue, 21 May 2019 15:27:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Eric Wong <e@80x24.org>
Cc:     Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        arnd@arndb.de, dbueso@suse.de, axboe@kernel.dk, dave@stgolabs.net,
        jbaron@akamai.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, omar.kilani@gmail.com, tglx@linutronix.de,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1] signal: Adjust error codes according to
 restore_user_sigmask()
Message-Id: <20190521152748.6b4cd70cf83a1183caa6aae7@linux-foundation.org>
In-Reply-To: <20190521092551.fwtb6recko3tahwj@dcvr>
References: <20190507043954.9020-1-deepa.kernel@gmail.com>
        <20190521092551.fwtb6recko3tahwj@dcvr>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 May 2019 09:25:51 +0000 Eric Wong <e@80x24.org> wrote:

> Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> > For all the syscalls that receive a sigmask from the userland,
> > the user sigmask is to be in effect through the syscall execution.
> > At the end of syscall, sigmask of the current process is restored
> > to what it was before the switch over to user sigmask.
> > But, for this to be true in practice, the sigmask should be restored
> > only at the the point we change the saved_sigmask. Anything before
> > that loses signals. And, anything after is just pointless as the
> > signal is already lost by restoring the sigmask.
> > 
> > The inherent issue was detected because of a regression caused by
> > 854a6ed56839a.
> > The patch moved the signal_pending() check closer to restoring of the
> > user sigmask. But, it failed to update the error code accordingly.
> > 
> > Detailed issue discussion permalink:
> > https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/
> > 
> > Note that the patch returns interrupted errors (EINTR, ERESTARTNOHAND,
> > etc) only when there is no other error. If there is a signal and an error
> > like EINVAL, the syscalls return -EINVAL rather than the interrupted
> > error codes.
> > 
> > The sys_io_uring_enter() seems to be returning success when there is
> > a signal and the queue is not empty. This seems to be a bug. I will
> > follow up with a separate patch for that.
> > 
> > Reported-by: Eric Wong <e@80x24.org>
> > Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
> > Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> > Reviewed-by: Davidlohr Bueso <dbueso@suse.de>

(top-posting fixed).

> It's been 2 weeks and this fix hasn't appeared in mmots / mmotm.
> I also noticed it's missing Cc: for stable@ (below)

Why is a -stable backport needed?  I see some talk above about lost
signals but it is unclear whether these are being observed after fixing
the regression caused by 854a6ed56839a.

IOW, can we please have a changelog which has a clear and complete
description of the user-visible effects of the change.

And please Cc Oleg.
