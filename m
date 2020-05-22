Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD7D1DE846
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgEVNqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 09:46:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36161 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729406AbgEVNqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 09:46:53 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jc80g-0001Cc-Mb; Fri, 22 May 2020 13:46:50 +0000
Date:   Fri, 22 May 2020 15:46:49 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Matthew Blecker <matthewb@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Mike Frysinger <vapier@google.com>,
        Christian Brauner <christian@brauner.io>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        vineethrp@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC] sched/headers: Fix sched_setattr userspace
 compilation issues
Message-ID: <20200522134649.lcqgwbgbnqxebcng@wittgenstein>
References: <20200521155346.168413-1-joel@joelfernandes.org>
 <CAEXW_YTj83gO0STovrOuL9zgDwEYWRJusUZ3ebVw_jOG6yJxTg@mail.gmail.com>
 <20200522131355.f4bdc2f4h2zyqbku@wittgenstein>
 <20200522133816.GB210175@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200522133816.GB210175@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 09:38:16AM -0400, Joel Fernandes wrote:
> On Fri, May 22, 2020 at 03:13:55PM +0200, Christian Brauner wrote:
> > On Thu, May 21, 2020 at 11:55:21AM -0400, Joel Fernandes wrote:
> > > On Thu, May 21, 2020 at 11:53 AM Joel Fernandes (Google)
> > > <joel@joelfernandes.org> wrote:
> > > >
> > > > On a modern Linux distro, compiling the following program fails:
> > > >  #include<stdlib.h>
> > > >  #include<stdint.h>
> > > >  #include<pthread.h>
> > > >  #include<linux/sched/types.h>
> > > >
> > > >  void main() {
> > > >          struct sched_attr sa;
> > > >
> > > >          return;
> > > >  }
> > > >
> > > > with:
> > > > /usr/include/linux/sched/types.h:8:8: \
> > > >                         error: redefinition of ‘struct sched_param’
> > > >     8 | struct sched_param {
> > > >       |        ^~~~~~~~~~~
> > > > In file included from /usr/include/x86_64-linux-gnu/bits/sched.h:74,
> > > >                  from /usr/include/sched.h:43,
> > > >                  from /usr/include/pthread.h:23,
> > > >                  from /tmp/s.c:4:
> > > > /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23:8:
> > > > note: originally defined here
> > > >    23 | struct sched_param
> > > >       |        ^~~~~~~~~~~
> > > >
> > > > This is also causing a problem on using sched_attr Chrome. The issue is
> > > > sched_param is already provided by glibc.
> > > >
> > > > Guard the kernel's UAPI definition of sched_param with __KERNEL__ so
> > > > that userspace can compile.
> > > >
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > 
> > > If it is more preferable, another option is to move sched_param to
> > > include/linux/sched/types.h
> > 
> > Might it be worth Ccing libc-alpha here? Seems like one of those classic
> > header conflicts.
> 
> sched_param is defined by POSIX from my reading of the manpage. Is the kernel
> supposed to define it in the UAPI at all? I guarded it with __KERNEL__ as you
> can see.

Your patch is fine of course. :) It's just that conflicts like this
have happened before. Another conflict is e.g. in wait.h where the
kernel has #define P_* and libc has an enum for P_* and it's not at all
guaranteed that they are identical. Plus, sometimes the order of header
inclusion matters because of things like this (or something like this).
That's why having it seen on libc-alpha might help prevent accidentaly
causing bugs where you now include a header that gives you a different
definition than you expected.

> 
> Resent with libc-alpha CC'd per your suggestion.

Thanks!

Christian
