Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C0446065E
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 14:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbhK1NON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 08:14:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42024 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357395AbhK1NMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 08:12:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCA7460FE4;
        Sun, 28 Nov 2021 13:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB6EC004E1;
        Sun, 28 Nov 2021 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638104936;
        bh=dl2l8+X50Xzu8JdiY/48cXxuGVId4I8bEAKwJt0nmCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hXcSo+eAlaHYwRQ53QRiheDZCvgAsUG4a6S8uVhB6mxK0FdIZjGzV96+y7dUazP1M
         mGEuV0eMtJ5KrM8AyEqUjO7BGliIZl0+UC8EFJ6rlH0IfjYJcg42oKDqIjYUVOWCTU
         izhKTxz1OgvN0ZXHHpO5HHTKBLmJbP4FxsLlYVeg=
Date:   Sun, 28 Nov 2021 14:08:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 088/323] locking/lockdep: Avoid RCU-induced noinstr
 fail
Message-ID: <YaN/ZQYSAUfzjq0d@kroah.com>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211124115721.937655496@linuxfoundation.org>
 <YaNP46ypf6xcTcJH@eldamar.lan>
 <YaNvGtWfuCRkmWwi@eldamar.lan>
 <YaNx31QvvjHy2IGh@eldamar.lan>
 <YaN+1gwQwt0aGKte@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaN+1gwQwt0aGKte@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 02:06:30PM +0100, Greg Kroah-Hartman wrote:
> On Sun, Nov 28, 2021 at 01:11:11PM +0100, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Sun, Nov 28, 2021 at 12:59:24PM +0100, Salvatore Bonaccorso wrote:
> > > Hi,
> > > 
> > > On Sun, Nov 28, 2021 at 10:46:13AM +0100, Salvatore Bonaccorso wrote:
> > > > Hi,
> > > > 
> > > > On Wed, Nov 24, 2021 at 12:54:38PM +0100, Greg Kroah-Hartman wrote:
> > > > > From: Peter Zijlstra <peterz@infradead.org>
> > > > > 
> > > > > [ Upstream commit ce0b9c805dd66d5e49fd53ec5415ae398f4c56e6 ]
> > > > > 
> > > > > vmlinux.o: warning: objtool: look_up_lock_class()+0xc7: call to rcu_read_lock_any_held() leaves .noinstr.text section
> > > > 
> > > > For 4.19.218 at least this commit seems to cause a build failure for
> > > > cpupower, if warnings are treated as errors, I have not seen the same
> > > > for the 5.10.80 build:
> > > > 
> > > > gcc -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -DVERSION=\"4.19\" -DPACKAGE=\"cpupower\" -DPACKAGE_BUGREPORT=\"Debian\ \(reportbug\ linux-cpupower\)\" -D_GNU_SOURCE -pipe -DNLS -Wall -Wchar-subscripts -Wpointer-arith
> > > >  -Wsign-compare -Wno-pointer-sign -Wdeclaration-after-statement -Wshadow -Os -fomit-frame-pointer -fPIC -o /home/build/linux-4.19.218/debian/build/build-tools/tools/power/cpupower/lib/cpupower.o -c lib/cpupower.c
> > > > In file included from lockdep.c:28:
> > > > ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> > > > ../../../kernel/locking/lockdep.c:694:2: error: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Werror=implicit-function-declaration]
> > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >   hlist_for_each_entry_continue
> > > > ../../../kernel/locking/lockdep.c:694:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
> > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > >                                                      ^~~~~~~~~~
> > > >                                                      hash_ptr
> > > > ../../../kernel/locking/lockdep.c:694:53: note: each undeclared identifier is reported only once for each function it appears in
> > > > ../../../kernel/locking/lockdep.c:694:64: error: expected ‘;’ before ‘{’ token
> > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > >                                                                 ^~
> > > >                                                                 ;
> > > > ../../../kernel/locking/lockdep.c:706:1: warning: control reaches end of non-void function [-Wreturn-type]
> > > >  }
> > > >  ^
> > > > cc1: some warnings being treated as errors
> > > > make[5]: *** [/home/build/linux-4.19.218/tools/build/Makefile.build:97: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/lockdep.o] Error 1
> > > > make[4]: *** [Makefile:121: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/liblockdep-in.o] Error 2
> > > > make[4]: Leaving directory '/home/build/linux-4.19.218/tools/lib/lockdep'
> > > > make[3]: *** [/home/build/linux-4.19.218/debian/rules.d/tools/lib/lockdep/Makefile:16: all] Error 2
> > > > make[3]: Leaving directory '/home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep'
> > > > make[2]: *** [debian/rules.real:795: build-liblockdep] Error 2
> > > > make[2]: *** Waiting for unfinished jobs....
> > > > 
> > > > I was not yet able to look further on it.
> > > 
> > > Might actually be a distro specific issue, needs some further
> > > investigation.
> > 
> > I'm really sorry about the doubled noice, so here is the stance. I can
> > reproduce distro indpeendent, but the initial claim was wrong. It can
> > be reproduced for 4.19.218:
> > 
> > $ LC_ALL=C.UTF-8 V=1 ARCH=x86 make -C tools liblockdep
> > make: Entering directory '/home/build/linux-stable/tools'
> > mkdir -p lib/lockdep && make  subdir=lib/lockdep  -C lib/lockdep 
> > make[1]: Entering directory '/home/build/linux-stable/tools/lib/lockdep'
> > make -f /home/build/linux-stable/tools/build/Makefile.build dir=. obj=fixdep
> >   gcc -Wp,-MD,./.fixdep.o.d -Wp,-MT,fixdep.o  -D"BUILD_STR(s)=#s"   -c -o fixdep.o fixdep.c
> >    ld -r -o fixdep-in.o  fixdep.o
> > gcc  -o fixdep fixdep-in.o
> >   gcc -Wp,-MD,./.common.o.d -Wp,-MT,common.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o common.o common.c
> >   gcc -Wp,-MD,./.lockdep.o.d -Wp,-MT,lockdep.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o lockdep.o lockdep.c
> > In file included from lockdep.c:28:
> > ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> > ../../../kernel/locking/lockdep.c:692:2: warning: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Wimplicit-function-declaration]
> >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   hlist_for_each_entry_continue
> > ../../../kernel/locking/lockdep.c:692:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
> >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> >                                                      ^~~~~~~~~~
> >                                                      hash_ptr
> > ../../../kernel/locking/lockdep.c:692:53: note: each undeclared identifier is reported only once for each function it appears in
> > ../../../kernel/locking/lockdep.c:692:64: error: expected ‘;’ before ‘{’ token
> >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> >                                                                 ^~
> >                                                                 ;
> > ../../../kernel/locking/lockdep.c:704:1: warning: control reaches end of non-void function [-Wreturn-type]
> >  }
> >  ^
> > make[2]: *** [/home/build/linux-stable/tools/build/Makefile.build:97: lockdep.o] Error 1
> > make[1]: *** [Makefile:121: liblockdep-in.o] Error 2
> > make[1]: Leaving directory '/home/build/linux-stable/tools/lib/lockdep'
> > make: *** [Makefile:66: liblockdep] Error 2
> > make: Leaving directory '/home/build/linux-stable/tools'
> > 
> > Reverting upstream ce0b9c805dd6 ("locking/lockdep: Avoid RCU-induced
> > noinstr fail") on top of 4.19.218 fixes the issue.
> > 
> > So back to square one, and again apologies for the intermediate noise!
> 
> What config/arch is causing this to break?  And if you add rchlist.h to
> the include files for lockdep.c, does that resolve the issue?  I haven't
> seen any other reports of this yet.

Ah, it's the tools being built here, sorry, that was confusing.

Yes, I can duplicate this, when building liblockdep.  As that code just
got ripped out of upstream, perhaps just use the out-of-tree code
instead now?

thanks,

greg k-h
