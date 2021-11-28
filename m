Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900FB46060E
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 13:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357261AbhK1MQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 07:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhK1MOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 07:14:31 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E34C061574;
        Sun, 28 Nov 2021 04:11:15 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d24so30220797wra.0;
        Sun, 28 Nov 2021 04:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=b+qlKKuEsHts24i+/7eZuleQ70aiJH5vp8R5fKl9lyU=;
        b=e/qh+FehCQyTfJrFyHnKg0rHCAftIUuCpGwRYUdETlTJ6/rIRCx3QeSJaPdH09hTPC
         yG0k6JVzM+HvFxYTgcutCFvM/3bMs/uKjyjG7iyd4g9wVjsSrEZcLqZhGzT7/2xRXuFB
         iUyWWIgCJ5apcEqYrqCx7FhkiyBOBsYAcGlMyx4wD9QdhacxBNuw9WDdysapH9DVhSvZ
         +UeMO1GYMPgxUgLt53QIZh20Kn0l22242kO+SFvjPdCDWtI1QhipzXK1obPx/LCPc+sD
         TEf8nmBAlmFhtJhiXf4GzPcn5rWa7h10qC2k0PBQUI+Hnx7Xf5APsjvsH7FnjjSPxIZL
         bSRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=b+qlKKuEsHts24i+/7eZuleQ70aiJH5vp8R5fKl9lyU=;
        b=xsz658a50ASP61SUxIcIHTDMRxE6BQ+1QrCKCMl4FmJhqvzp3lvzVX8J2Iwl60qE4m
         HVXx5N0Rd+5TAzJsW57AP7PaiH6/VWIy4Rayt4Ol/RT8EWCQgfI4oCzSY6l6+9/SAgHG
         MPRZA8Mjk55WNeuVtkaTdgK9rFpOz4/xetvsKPuW8R1QWk7duYMZFMeSGEFcq8uP9rHs
         cL0ZvRIrZDSn7JAz+M3Cfk9WmkGupNQV+sRIRw9KlyyuciWC8YbSo+t4SWJ6Gf98dQJy
         2SuxuAVWrP1O70lr8z0mebsw8kG87m+6AZzZDAVSzg1zPm3LC+2/ff5oZUzAD9/pymZb
         UFAw==
X-Gm-Message-State: AOAM532HCymG19SdGT67nhEcM9r/Fme6a/hi3knwVQ8vJmwnbCScqpni
        I7f7R3BeJmhnDn5t+7hHXCw=
X-Google-Smtp-Source: ABdhPJwCXPyNeLXj0THnZ0DQFmO84BSfkwsyG4JZNZSZupMD76OEHHqtcQxI370gEl/eD63IQNLuwg==
X-Received: by 2002:adf:f80f:: with SMTP id s15mr26587988wrp.542.1638101473066;
        Sun, 28 Nov 2021 04:11:13 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id b11sm16381248wmj.35.2021.11.28.04.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:11:12 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 28 Nov 2021 13:11:11 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 088/323] locking/lockdep: Avoid RCU-induced noinstr
 fail
Message-ID: <YaNx31QvvjHy2IGh@eldamar.lan>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211124115721.937655496@linuxfoundation.org>
 <YaNP46ypf6xcTcJH@eldamar.lan>
 <YaNvGtWfuCRkmWwi@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaNvGtWfuCRkmWwi@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Nov 28, 2021 at 12:59:24PM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Sun, Nov 28, 2021 at 10:46:13AM +0100, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Wed, Nov 24, 2021 at 12:54:38PM +0100, Greg Kroah-Hartman wrote:
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > [ Upstream commit ce0b9c805dd66d5e49fd53ec5415ae398f4c56e6 ]
> > > 
> > > vmlinux.o: warning: objtool: look_up_lock_class()+0xc7: call to rcu_read_lock_any_held() leaves .noinstr.text section
> > 
> > For 4.19.218 at least this commit seems to cause a build failure for
> > cpupower, if warnings are treated as errors, I have not seen the same
> > for the 5.10.80 build:
> > 
> > gcc -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -DVERSION=\"4.19\" -DPACKAGE=\"cpupower\" -DPACKAGE_BUGREPORT=\"Debian\ \(reportbug\ linux-cpupower\)\" -D_GNU_SOURCE -pipe -DNLS -Wall -Wchar-subscripts -Wpointer-arith
> >  -Wsign-compare -Wno-pointer-sign -Wdeclaration-after-statement -Wshadow -Os -fomit-frame-pointer -fPIC -o /home/build/linux-4.19.218/debian/build/build-tools/tools/power/cpupower/lib/cpupower.o -c lib/cpupower.c
> > In file included from lockdep.c:28:
> > ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> > ../../../kernel/locking/lockdep.c:694:2: error: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Werror=implicit-function-declaration]
> >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   hlist_for_each_entry_continue
> > ../../../kernel/locking/lockdep.c:694:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
> >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> >                                                      ^~~~~~~~~~
> >                                                      hash_ptr
> > ../../../kernel/locking/lockdep.c:694:53: note: each undeclared identifier is reported only once for each function it appears in
> > ../../../kernel/locking/lockdep.c:694:64: error: expected ‘;’ before ‘{’ token
> >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> >                                                                 ^~
> >                                                                 ;
> > ../../../kernel/locking/lockdep.c:706:1: warning: control reaches end of non-void function [-Wreturn-type]
> >  }
> >  ^
> > cc1: some warnings being treated as errors
> > make[5]: *** [/home/build/linux-4.19.218/tools/build/Makefile.build:97: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/lockdep.o] Error 1
> > make[4]: *** [Makefile:121: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/liblockdep-in.o] Error 2
> > make[4]: Leaving directory '/home/build/linux-4.19.218/tools/lib/lockdep'
> > make[3]: *** [/home/build/linux-4.19.218/debian/rules.d/tools/lib/lockdep/Makefile:16: all] Error 2
> > make[3]: Leaving directory '/home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep'
> > make[2]: *** [debian/rules.real:795: build-liblockdep] Error 2
> > make[2]: *** Waiting for unfinished jobs....
> > 
> > I was not yet able to look further on it.
> 
> Might actually be a distro specific issue, needs some further
> investigation.

I'm really sorry about the doubled noice, so here is the stance. I can
reproduce distro indpeendent, but the initial claim was wrong. It can
be reproduced for 4.19.218:

$ LC_ALL=C.UTF-8 V=1 ARCH=x86 make -C tools liblockdep
make: Entering directory '/home/build/linux-stable/tools'
mkdir -p lib/lockdep && make  subdir=lib/lockdep  -C lib/lockdep 
make[1]: Entering directory '/home/build/linux-stable/tools/lib/lockdep'
make -f /home/build/linux-stable/tools/build/Makefile.build dir=. obj=fixdep
  gcc -Wp,-MD,./.fixdep.o.d -Wp,-MT,fixdep.o  -D"BUILD_STR(s)=#s"   -c -o fixdep.o fixdep.c
   ld -r -o fixdep-in.o  fixdep.o
gcc  -o fixdep fixdep-in.o
  gcc -Wp,-MD,./.common.o.d -Wp,-MT,common.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o common.o common.c
  gcc -Wp,-MD,./.lockdep.o.d -Wp,-MT,lockdep.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o lockdep.o lockdep.c
In file included from lockdep.c:28:
../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
../../../kernel/locking/lockdep.c:692:2: warning: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Wimplicit-function-declaration]
  hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  hlist_for_each_entry_continue
../../../kernel/locking/lockdep.c:692:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
  hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
                                                     ^~~~~~~~~~
                                                     hash_ptr
../../../kernel/locking/lockdep.c:692:53: note: each undeclared identifier is reported only once for each function it appears in
../../../kernel/locking/lockdep.c:692:64: error: expected ‘;’ before ‘{’ token
  hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
                                                                ^~
                                                                ;
../../../kernel/locking/lockdep.c:704:1: warning: control reaches end of non-void function [-Wreturn-type]
 }
 ^
make[2]: *** [/home/build/linux-stable/tools/build/Makefile.build:97: lockdep.o] Error 1
make[1]: *** [Makefile:121: liblockdep-in.o] Error 2
make[1]: Leaving directory '/home/build/linux-stable/tools/lib/lockdep'
make: *** [Makefile:66: liblockdep] Error 2
make: Leaving directory '/home/build/linux-stable/tools'

Reverting upstream ce0b9c805dd6 ("locking/lockdep: Avoid RCU-induced
noinstr fail") on top of 4.19.218 fixes the issue.

So back to square one, and again apologies for the intermediate noise!

Regards,
Salvatore
