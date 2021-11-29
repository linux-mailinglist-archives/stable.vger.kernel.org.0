Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC464625F3
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhK2Wph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbhK2Wor (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:44:47 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82A2C1404D8;
        Mon, 29 Nov 2021 10:30:33 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id a9so38860830wrr.8;
        Mon, 29 Nov 2021 10:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1/CwQ12ShLmacvJ1YWb4vFM7M7bJgoNSB+8djXb70J8=;
        b=JIZ3TcK/4QVWjkktk1XNt3FaGg3NPql/JVcH3scPqsZSC5Eax+EbKByaMv1MCmzOpk
         xX+gkv4AP7xVDLlSxsnOVwh6WyFMCKtOwRtd4jHy0JN4TrIjbL0c37JBRBJYzsIZtMcK
         Rj0JOTRJmBAkH/O8Z7ondD4Ng2WXXSVGCNDSqwdZQsHJTd75plFAC7uvpAEM2WD5Uxx7
         cZ0PRT/q8JUYGSbYCSHy07H3yb3ltpR2lT0Ei/CL7Y1LIUzVzQcx9KlOgvwiYyYT5Rv0
         rn3BXZovIji0cfJRzWELSXVupzOVHXlLXs/es1oEHtpwcIhxx/oImd4Txfd/8yEuQmRt
         7boQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=1/CwQ12ShLmacvJ1YWb4vFM7M7bJgoNSB+8djXb70J8=;
        b=CVCHilDn219yPd5tsM3IqS+cdCMYvaamr82yonzGqlZvNpHvtpFXAwR5HJvMGqOUaE
         WFo0+PQNHvzXLgeSfLh9ZcxNqthsWls/OGiIg1Dx8+x/EL8hpMP3N3LyAli7TAQWnsC+
         KrzsJIVkQOnJFXM2uXuVoB1owPRP00MywszJKT4f9c88TDjrMxUTfRyrxvbYDFyxSi3W
         T/TRdX6KyuoJjZz+0sttWB2cHmZR3c7eA3OWjC7K8R3inxust9edLduaGynt7MiceHAJ
         Og4NxTKdh1Clk9pnN8CTD1hRsEmkAcNXaPZTkZ2IlmMJyTwf0Piqjo4F4b76Ka8xmnYT
         YQbQ==
X-Gm-Message-State: AOAM5320kJiQnRRcqN7S5lZED0Hpt6en/leIo7Ln59sTfnh/HtPK8o9Y
        6OX2umrLlhO+Fnmw6IJgZVTC3nxaZ388CQ==
X-Google-Smtp-Source: ABdhPJyAm+oTAjAgnH9K0Qb6WIc1qU8yq6dloiZVp4/ZRDicxlIFKJMm2SWeqBY39j3KXN26RkTo2g==
X-Received: by 2002:adf:9e01:: with SMTP id u1mr35778156wre.561.1638210632098;
        Mon, 29 Nov 2021 10:30:32 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id z6sm104695wmp.9.2021.11.29.10.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 10:30:31 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Mon, 29 Nov 2021 19:30:30 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <benh@debian.org>
Subject: Re: [PATCH 4.19 088/323] locking/lockdep: Avoid RCU-induced noinstr
 fail
Message-ID: <YaUcRuy050ZrtucJ@eldamar.lan>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211124115721.937655496@linuxfoundation.org>
 <YaNP46ypf6xcTcJH@eldamar.lan>
 <YaNvGtWfuCRkmWwi@eldamar.lan>
 <YaNx31QvvjHy2IGh@eldamar.lan>
 <YaN+1gwQwt0aGKte@kroah.com>
 <YaN/ZQYSAUfzjq0d@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaN/ZQYSAUfzjq0d@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

(Adding Ben as well)

On Sun, Nov 28, 2021 at 02:08:53PM +0100, Greg Kroah-Hartman wrote:
> On Sun, Nov 28, 2021 at 02:06:30PM +0100, Greg Kroah-Hartman wrote:
> > On Sun, Nov 28, 2021 at 01:11:11PM +0100, Salvatore Bonaccorso wrote:
> > > Hi,
> > > 
> > > On Sun, Nov 28, 2021 at 12:59:24PM +0100, Salvatore Bonaccorso wrote:
> > > > Hi,
> > > > 
> > > > On Sun, Nov 28, 2021 at 10:46:13AM +0100, Salvatore Bonaccorso wrote:
> > > > > Hi,
> > > > > 
> > > > > On Wed, Nov 24, 2021 at 12:54:38PM +0100, Greg Kroah-Hartman wrote:
> > > > > > From: Peter Zijlstra <peterz@infradead.org>
> > > > > > 
> > > > > > [ Upstream commit ce0b9c805dd66d5e49fd53ec5415ae398f4c56e6 ]
> > > > > > 
> > > > > > vmlinux.o: warning: objtool: look_up_lock_class()+0xc7: call to rcu_read_lock_any_held() leaves .noinstr.text section
> > > > > 
> > > > > For 4.19.218 at least this commit seems to cause a build failure for
> > > > > cpupower, if warnings are treated as errors, I have not seen the same
> > > > > for the 5.10.80 build:
> > > > > 
> > > > > gcc -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -DVERSION=\"4.19\" -DPACKAGE=\"cpupower\" -DPACKAGE_BUGREPORT=\"Debian\ \(reportbug\ linux-cpupower\)\" -D_GNU_SOURCE -pipe -DNLS -Wall -Wchar-subscripts -Wpointer-arith
> > > > >  -Wsign-compare -Wno-pointer-sign -Wdeclaration-after-statement -Wshadow -Os -fomit-frame-pointer -fPIC -o /home/build/linux-4.19.218/debian/build/build-tools/tools/power/cpupower/lib/cpupower.o -c lib/cpupower.c
> > > > > In file included from lockdep.c:28:
> > > > > ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> > > > > ../../../kernel/locking/lockdep.c:694:2: error: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Werror=implicit-function-declaration]
> > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > >   hlist_for_each_entry_continue
> > > > > ../../../kernel/locking/lockdep.c:694:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
> > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > >                                                      ^~~~~~~~~~
> > > > >                                                      hash_ptr
> > > > > ../../../kernel/locking/lockdep.c:694:53: note: each undeclared identifier is reported only once for each function it appears in
> > > > > ../../../kernel/locking/lockdep.c:694:64: error: expected ‘;’ before ‘{’ token
> > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > >                                                                 ^~
> > > > >                                                                 ;
> > > > > ../../../kernel/locking/lockdep.c:706:1: warning: control reaches end of non-void function [-Wreturn-type]
> > > > >  }
> > > > >  ^
> > > > > cc1: some warnings being treated as errors
> > > > > make[5]: *** [/home/build/linux-4.19.218/tools/build/Makefile.build:97: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/lockdep.o] Error 1
> > > > > make[4]: *** [Makefile:121: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/liblockdep-in.o] Error 2
> > > > > make[4]: Leaving directory '/home/build/linux-4.19.218/tools/lib/lockdep'
> > > > > make[3]: *** [/home/build/linux-4.19.218/debian/rules.d/tools/lib/lockdep/Makefile:16: all] Error 2
> > > > > make[3]: Leaving directory '/home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep'
> > > > > make[2]: *** [debian/rules.real:795: build-liblockdep] Error 2
> > > > > make[2]: *** Waiting for unfinished jobs....
> > > > > 
> > > > > I was not yet able to look further on it.
> > > > 
> > > > Might actually be a distro specific issue, needs some further
> > > > investigation.
> > > 
> > > I'm really sorry about the doubled noice, so here is the stance. I can
> > > reproduce distro indpeendent, but the initial claim was wrong. It can
> > > be reproduced for 4.19.218:
> > > 
> > > $ LC_ALL=C.UTF-8 V=1 ARCH=x86 make -C tools liblockdep
> > > make: Entering directory '/home/build/linux-stable/tools'
> > > mkdir -p lib/lockdep && make  subdir=lib/lockdep  -C lib/lockdep 
> > > make[1]: Entering directory '/home/build/linux-stable/tools/lib/lockdep'
> > > make -f /home/build/linux-stable/tools/build/Makefile.build dir=. obj=fixdep
> > >   gcc -Wp,-MD,./.fixdep.o.d -Wp,-MT,fixdep.o  -D"BUILD_STR(s)=#s"   -c -o fixdep.o fixdep.c
> > >    ld -r -o fixdep-in.o  fixdep.o
> > > gcc  -o fixdep fixdep-in.o
> > >   gcc -Wp,-MD,./.common.o.d -Wp,-MT,common.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o common.o common.c
> > >   gcc -Wp,-MD,./.lockdep.o.d -Wp,-MT,lockdep.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o lockdep.o lockdep.c
> > > In file included from lockdep.c:28:
> > > ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> > > ../../../kernel/locking/lockdep.c:692:2: warning: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Wimplicit-function-declaration]
> > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   hlist_for_each_entry_continue
> > > ../../../kernel/locking/lockdep.c:692:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
> > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > >                                                      ^~~~~~~~~~
> > >                                                      hash_ptr
> > > ../../../kernel/locking/lockdep.c:692:53: note: each undeclared identifier is reported only once for each function it appears in
> > > ../../../kernel/locking/lockdep.c:692:64: error: expected ‘;’ before ‘{’ token
> > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > >                                                                 ^~
> > >                                                                 ;
> > > ../../../kernel/locking/lockdep.c:704:1: warning: control reaches end of non-void function [-Wreturn-type]
> > >  }
> > >  ^
> > > make[2]: *** [/home/build/linux-stable/tools/build/Makefile.build:97: lockdep.o] Error 1
> > > make[1]: *** [Makefile:121: liblockdep-in.o] Error 2
> > > make[1]: Leaving directory '/home/build/linux-stable/tools/lib/lockdep'
> > > make: *** [Makefile:66: liblockdep] Error 2
> > > make: Leaving directory '/home/build/linux-stable/tools'
> > > 
> > > Reverting upstream ce0b9c805dd6 ("locking/lockdep: Avoid RCU-induced
> > > noinstr fail") on top of 4.19.218 fixes the issue.
> > > 
> > > So back to square one, and again apologies for the intermediate noise!
> > 
> > What config/arch is causing this to break?  And if you add rchlist.h to
> > the include files for lockdep.c, does that resolve the issue?  I haven't
> > seen any other reports of this yet.
> 
> Ah, it's the tools being built here, sorry, that was confusing.

Ah yes, sorry this was not clear. It's all about the tools, which some
are built as well as packages in Debian accompaning, tools/lib/lockdep
is one of those built.

> Yes, I can duplicate this, when building liblockdep.  As that code just
> got ripped out of upstream, perhaps just use the out-of-tree code
> instead now?

That's tricky. Even though lockep is probably only usefull for Kernel
developers, we usually cannot drop a package built in a stable
release. If it's not fixable in upstream and the respective stable
series, then we might need to find a suitable fix downstream to make
it build.

Speaking of Debian: Last resort would probably be still to drop the
package in the stable release.

I know lockdep was ripped in v5.16-rc1, but AFAIK lockdep has not
found a new home yet out of tree.

Regards,
Salvatore
