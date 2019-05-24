Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4CB29A5E
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 16:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404162AbfEXOvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 10:51:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404154AbfEXOvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 10:51:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 604EB30B1B84;
        Fri, 24 May 2019 14:51:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 41FB02CFD6;
        Fri, 24 May 2019 14:51:07 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 24 May 2019 16:51:11 +0200 (CEST)
Date:   Fri, 24 May 2019 16:51:06 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
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
Message-ID: <20190524145105.GD2655@redhat.com>
References: <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141947.GC2655@redhat.com>
 <CABeXuvqx9fZGiGSAQEE=7wechoGE0E8YW7icBWoTtXPkWPROUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvqx9fZGiGSAQEE=7wechoGE0E8YW7icBWoTtXPkWPROUw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 24 May 2019 14:51:16 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/24, Deepa Dinamani wrote:
>
> I think you are misunderstanding what I said.

probably. Everything was very confusing to me from the very beginning.
And yes, I can hardly understand your emails, sorry. This one too :/

> You are taking things
> out of context. I was saying here what I did was inspired by why the
> syscall was designed to begin with.

which syscall?

> The syscall below refers to
> epoll_wait and not epoll_pwait.

So you tried to explain why epoll_pwait() was designed? Or what?

Either way, everything I said below still looks right to me. This probably
means that I still can't understand you.

But this is irrelevant. My main point is that the kernel was correct before
854a6ed568 ("signal: Add restore_user_sigmask()"), the (incomplete) patch I sent
tries to a) restore the correct behaviour and b) simplify/cleanup the code.

> On Fri, May 24, 2019 at 7:19 AM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > On 05/23, Deepa Dinamani wrote:
> > >
> > > 1. block the signals you don't care about.
> > > 2. syscall()
> > > 3. unblock the signals blocked in 1.
> >
> > and even this part of your email is very confusing. because in this case
> > we can never miss a signal. I'd say
> >
> >         1. block the signals you don't care about
> >         2. unblock the signals which should interrupt the syscall below
> >         3. syscall()
> >         4. block the signals unblocked in 2.
> >
> > Oleg.
> >

