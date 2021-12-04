Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9983F468416
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344191AbhLDKeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 05:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbhLDKeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 05:34:11 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDD9C061751;
        Sat,  4 Dec 2021 02:30:45 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d24so11368386wra.0;
        Sat, 04 Dec 2021 02:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=X13VE/Fj6zRDrJGoTpK/w6yBjL0oISAqwSxbUBddfsw=;
        b=XVVQD+mmVTwrfFJ9yLL1OBwpJ02ihxxzS+bU2bwjoPEEnzWfRYG9DQzw2J++g0VxIK
         pr9RJLQDeDW76KXaG6tG5Ght2MzB4goiju+ejMgRLc4Sn+Udz3d4Y+TiUlT8rU+VK47+
         mXEvxVYXtyW7lVihyU3fE+pxXZhfTn+xCLx+hW3prhQh6tLHYIOp0v2qg340MRYCoQUf
         K1mqp4uGHC1vGGf8rDpm7N+yTDfautH5y2zWle0hsxN9OxkVdIAIGEu5zx0epqWIBmU4
         Fihd4BMVUWj5DAx4CuYCVSsDCDfzZeFBdX351Shc9jdwkjbQoCX4hvllyA0bkeCgQ1v0
         WOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=X13VE/Fj6zRDrJGoTpK/w6yBjL0oISAqwSxbUBddfsw=;
        b=FZiiBolk7ck3y1Ehu5SeUeqDBiEZ8GVBqvA3cALDiBaBYp8AB51/4mAlu2620rsjjj
         r2/JqQd9StOuM23fZ52FChDtgP17sae4NHmEPPwI8ToTN26WWHdslSk7meGRkujWQ/H6
         wi1G99iVfS5HePByn+B76jwNUFC0wvCtOL5zFvrMQebH41Mc0Qyiay0Ty3Ji5T8JTd5X
         5RbluJyCuOid4ong0UtfphelkeoROTRtqmI2LEPpQ8vQBJ+7Sxed6bqxm3jetq3yksnh
         BMk6IENk3FHL19kwoi4e5gdhnhwBvJGBxZNwEfE13VU8F1a0diO5EQvW4QxtkHrSIo3f
         h5gg==
X-Gm-Message-State: AOAM533WzH7XDiXzeJBTuxeT52QETPo2EREFeJWD4sLjnYKWQ9kA6q4I
        A6XpjyJA/pE+LfHDxsRR9qQ=
X-Google-Smtp-Source: ABdhPJyjoYln/8Qoq2zRkKTqcVjEoFQs8FM8/Gu+UXFk6/1+XqmzTSGYULoM5GzFAYoNlxfq4/hrNQ==
X-Received: by 2002:a05:6000:1a88:: with SMTP id f8mr28096654wry.54.1638613844526;
        Sat, 04 Dec 2021 02:30:44 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id t8sm5279066wrv.30.2021.12.04.02.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 02:30:44 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 4 Dec 2021 11:30:43 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <benh@debian.org>
Subject: Re: [PATCH 4.19 088/323] locking/lockdep: Avoid RCU-induced noinstr
 fail
Message-ID: <YatDUwWn7OznbcIP@eldamar.lan>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211124115721.937655496@linuxfoundation.org>
 <YaNP46ypf6xcTcJH@eldamar.lan>
 <YaNvGtWfuCRkmWwi@eldamar.lan>
 <YaNx31QvvjHy2IGh@eldamar.lan>
 <YaN+1gwQwt0aGKte@kroah.com>
 <YaN/ZQYSAUfzjq0d@kroah.com>
 <YaUcRuy050ZrtucJ@eldamar.lan>
 <YaXZevLfOkCTzQTV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaXZevLfOkCTzQTV@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Nov 30, 2021 at 08:57:46AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Nov 29, 2021 at 07:30:30PM +0100, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > (Adding Ben as well)
> > 
> > On Sun, Nov 28, 2021 at 02:08:53PM +0100, Greg Kroah-Hartman wrote:
> > > On Sun, Nov 28, 2021 at 02:06:30PM +0100, Greg Kroah-Hartman wrote:
> > > > On Sun, Nov 28, 2021 at 01:11:11PM +0100, Salvatore Bonaccorso wrote:
> > > > > Hi,
> > > > > 
> > > > > On Sun, Nov 28, 2021 at 12:59:24PM +0100, Salvatore Bonaccorso wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > On Sun, Nov 28, 2021 at 10:46:13AM +0100, Salvatore Bonaccorso wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > On Wed, Nov 24, 2021 at 12:54:38PM +0100, Greg Kroah-Hartman wrote:
> > > > > > > > From: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > 
> > > > > > > > [ Upstream commit ce0b9c805dd66d5e49fd53ec5415ae398f4c56e6 ]
> > > > > > > > 
> > > > > > > > vmlinux.o: warning: objtool: look_up_lock_class()+0xc7: call to rcu_read_lock_any_held() leaves .noinstr.text section
> > > > > > > 
> > > > > > > For 4.19.218 at least this commit seems to cause a build failure for
> > > > > > > cpupower, if warnings are treated as errors, I have not seen the same
> > > > > > > for the 5.10.80 build:
> > > > > > > 
> > > > > > > gcc -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -DVERSION=\"4.19\" -DPACKAGE=\"cpupower\" -DPACKAGE_BUGREPORT=\"Debian\ \(reportbug\ linux-cpupower\)\" -D_GNU_SOURCE -pipe -DNLS -Wall -Wchar-subscripts -Wpointer-arith
> > > > > > >  -Wsign-compare -Wno-pointer-sign -Wdeclaration-after-statement -Wshadow -Os -fomit-frame-pointer -fPIC -o /home/build/linux-4.19.218/debian/build/build-tools/tools/power/cpupower/lib/cpupower.o -c lib/cpupower.c
> > > > > > > In file included from lockdep.c:28:
> > > > > > > ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> > > > > > > ../../../kernel/locking/lockdep.c:694:2: error: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Werror=implicit-function-declaration]
> > > > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > > > >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > > > >   hlist_for_each_entry_continue
> > > > > > > ../../../kernel/locking/lockdep.c:694:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
> > > > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > > > >                                                      ^~~~~~~~~~
> > > > > > >                                                      hash_ptr
> > > > > > > ../../../kernel/locking/lockdep.c:694:53: note: each undeclared identifier is reported only once for each function it appears in
> > > > > > > ../../../kernel/locking/lockdep.c:694:64: error: expected ‘;’ before ‘{’ token
> > > > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > > > >                                                                 ^~
> > > > > > >                                                                 ;
> > > > > > > ../../../kernel/locking/lockdep.c:706:1: warning: control reaches end of non-void function [-Wreturn-type]
> > > > > > >  }
> > > > > > >  ^
> > > > > > > cc1: some warnings being treated as errors
> > > > > > > make[5]: *** [/home/build/linux-4.19.218/tools/build/Makefile.build:97: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/lockdep.o] Error 1
> > > > > > > make[4]: *** [Makefile:121: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/liblockdep-in.o] Error 2
> > > > > > > make[4]: Leaving directory '/home/build/linux-4.19.218/tools/lib/lockdep'
> > > > > > > make[3]: *** [/home/build/linux-4.19.218/debian/rules.d/tools/lib/lockdep/Makefile:16: all] Error 2
> > > > > > > make[3]: Leaving directory '/home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep'
> > > > > > > make[2]: *** [debian/rules.real:795: build-liblockdep] Error 2
> > > > > > > make[2]: *** Waiting for unfinished jobs....
> > > > > > > 
> > > > > > > I was not yet able to look further on it.
> > > > > > 
> > > > > > Might actually be a distro specific issue, needs some further
> > > > > > investigation.
> > > > > 
> > > > > I'm really sorry about the doubled noice, so here is the stance. I can
> > > > > reproduce distro indpeendent, but the initial claim was wrong. It can
> > > > > be reproduced for 4.19.218:
> > > > > 
> > > > > $ LC_ALL=C.UTF-8 V=1 ARCH=x86 make -C tools liblockdep
> > > > > make: Entering directory '/home/build/linux-stable/tools'
> > > > > mkdir -p lib/lockdep && make  subdir=lib/lockdep  -C lib/lockdep 
> > > > > make[1]: Entering directory '/home/build/linux-stable/tools/lib/lockdep'
> > > > > make -f /home/build/linux-stable/tools/build/Makefile.build dir=. obj=fixdep
> > > > >   gcc -Wp,-MD,./.fixdep.o.d -Wp,-MT,fixdep.o  -D"BUILD_STR(s)=#s"   -c -o fixdep.o fixdep.c
> > > > >    ld -r -o fixdep-in.o  fixdep.o
> > > > > gcc  -o fixdep fixdep-in.o
> > > > >   gcc -Wp,-MD,./.common.o.d -Wp,-MT,common.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o common.o common.c
> > > > >   gcc -Wp,-MD,./.lockdep.o.d -Wp,-MT,lockdep.o -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"4.19.218"' -rdynamic -O0 -g -fPIC -Wall -I. -I./uinclude -I./include -I../../include -D"BUILD_STR(s)=#s" -c -o lockdep.o lockdep.c
> > > > > In file included from lockdep.c:28:
> > > > > ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> > > > > ../../../kernel/locking/lockdep.c:692:2: warning: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Wimplicit-function-declaration]
> > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > >   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > >   hlist_for_each_entry_continue
> > > > > ../../../kernel/locking/lockdep.c:692:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
> > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > >                                                      ^~~~~~~~~~
> > > > >                                                      hash_ptr
> > > > > ../../../kernel/locking/lockdep.c:692:53: note: each undeclared identifier is reported only once for each function it appears in
> > > > > ../../../kernel/locking/lockdep.c:692:64: error: expected ‘;’ before ‘{’ token
> > > > >   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
> > > > >                                                                 ^~
> > > > >                                                                 ;
> > > > > ../../../kernel/locking/lockdep.c:704:1: warning: control reaches end of non-void function [-Wreturn-type]
> > > > >  }
> > > > >  ^
> > > > > make[2]: *** [/home/build/linux-stable/tools/build/Makefile.build:97: lockdep.o] Error 1
> > > > > make[1]: *** [Makefile:121: liblockdep-in.o] Error 2
> > > > > make[1]: Leaving directory '/home/build/linux-stable/tools/lib/lockdep'
> > > > > make: *** [Makefile:66: liblockdep] Error 2
> > > > > make: Leaving directory '/home/build/linux-stable/tools'
> > > > > 
> > > > > Reverting upstream ce0b9c805dd6 ("locking/lockdep: Avoid RCU-induced
> > > > > noinstr fail") on top of 4.19.218 fixes the issue.
> > > > > 
> > > > > So back to square one, and again apologies for the intermediate noise!
> > > > 
> > > > What config/arch is causing this to break?  And if you add rchlist.h to
> > > > the include files for lockdep.c, does that resolve the issue?  I haven't
> > > > seen any other reports of this yet.
> > > 
> > > Ah, it's the tools being built here, sorry, that was confusing.
> > 
> > Ah yes, sorry this was not clear. It's all about the tools, which some
> > are built as well as packages in Debian accompaning, tools/lib/lockdep
> > is one of those built.
> 
> Ok, fair enough, I'll gladly take a patch that fixes this up for the
> 4.19.y releases.

We (speaking as for Debian) will probably drop the ball here as well,
and drop building the lockdep tool packages in the next upload. It was
probabably anyway not a good idea to have them built in the first
place.

Regards,
Salvatore
