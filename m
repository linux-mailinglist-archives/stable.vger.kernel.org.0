Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253B029B64
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389908AbfEXPoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 11:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389206AbfEXPoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 11:44:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95F5DC09AD13;
        Fri, 24 May 2019 15:44:33 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4A11C63F62;
        Fri, 24 May 2019 15:44:26 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 24 May 2019 17:44:33 +0200 (CEST)
Date:   Fri, 24 May 2019 17:44:25 +0200
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
Message-ID: <20190524154425.GE2655@redhat.com>
References: <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <20190524132911.GA2655@redhat.com>
 <766510cbbec640b18fd99f3946b37475@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <766510cbbec640b18fd99f3946b37475@AcuMS.aculab.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 24 May 2019 15:44:38 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/24, David Laight wrote:
>
> From: Oleg Nesterov
> > Sent: 24 May 2019 14:29
> > It seems that we all are just trying to confuse each other. I got lost.
>
> I'm always lost :-)

same here ;)

> To my mind changing the signal mask should be enough to get a masked
> signal handler called - even if the mask is reset before the syscall exits.

well, the kernel doesn't do this, and on purpose.

> There shouldn't be any need for an interruptible wait to be interrupted.

can't parse ;)

> I suspect that if you send a signal to a process that is looping
> in userspace (on a different) the signal handler is called on the next
> exit to userspace regardless as to whether the kernel blocks.
>
> epoll and pselect shouldn't be any different.

They differ exactly because they manipulate the blocked mask,

> Having the signal unmasked at any time should be enough to get it called.

No. The sigmask passed to pselect() tells the kernel which signals should
interrupt the syscall if it blocks. The fact that pselect() actually unblocks
a signal is just the internal implementation detail.

> > > I suspect you need to defer the re-instatement of the original mask
> > > to the code that calls the signal handlers (which probably should
> > > be called with the programs signal mask).
> >
> > This is what the kernel does when the signal is delivered, the original mask
> > is restored after the signal handler runs.
>
> I'd have thought that the original signal mask (all blocked in the examples)
> should be restored before the signal handler is called.

No. And this means that if you have 2 pending signals, they both will be delivered.
Unless of course sigaction->sa_mask includes the 2nd one.

> After all the signal handler is allowed to modify the processes signal mask.

only untill the handler returns.

> I've had horrid thoughts about SIG_SUSPEND :-)

google knows nothing about SIG_SUSPEND, neither me ;)

Oleg.

