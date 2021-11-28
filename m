Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACAB460605
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 13:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357295AbhK1MGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 07:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357409AbhK1MEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 07:04:06 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2F8C0613F2;
        Sun, 28 Nov 2021 03:59:25 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso9596157wmh.0;
        Sun, 28 Nov 2021 03:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jSRe68zCmLJFEKWuQop4ZXT5Q3aCGxd7+ZWrFhjTSEs=;
        b=WLt7e/oirf0p5qBv5wjnLNLm1hHuHs6tyELo44EP4q5CbHk7OuDJKT4SJhwPXBE0+z
         roksEPaSgaF0fLpFEKEVNEIkspQ2NdLs5+NR/bz5tZvF/xbuvevOb+Br7qdSIpRb/t5U
         NSsQ9UtHGkdcXZeH2a4zKDA4ng+CCzzYsvchPUudjxN5pkWGjRvpr/nCPRU9nMcXgjdn
         2mQ6FJAz8H1RYKtnAkl304xDL1uwrTbDWYY9cZaiWTeCH1iaVDqjdJ2O7qcq0HzBg+DH
         e5uZUrLlK0vDLw5mgZ59ko4llHre+u1WtAmiuKaXhKeHRGLqGs177W/8nZmokhnowNEO
         k4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=jSRe68zCmLJFEKWuQop4ZXT5Q3aCGxd7+ZWrFhjTSEs=;
        b=d2FtcM62Oz5Db8b2U+16/Tpss0820GPbt650puSV3U8DaY5LVIgPu+V8c0YLM6zKbU
         0fFT/vWev9mE2uFOY3YyfmST+qsEtUAc3Q9gVrp3QHHg2lFCnPjaqjbCwRKG3gRdwjMK
         BOL7c7KeG64fX67f0JgHlo4MHjcy8bMxY1vRgHKMhhIMjZTC+uhK3quuBMSNrQhaChBC
         3vtmXwbB3HM7T6AfoyXMkEVT0gTDzNVmJCvx0NwKa2pccwt6DNo2cGT6QqUygushvvWP
         GFuHImxRJuTJ0hvN3J+XDvMYCMImPv58lrIiEQ1HoQPe8CWH3A2o4MzHO6XSqVwdb4Jq
         7ZzA==
X-Gm-Message-State: AOAM530FKt6+RSJlSpNhCmdcNOB3GPlxA63pjwLghH3Mxb4ZYI2p4YAi
        qA8B8pkbwtNJnp3YEERPQgI=
X-Google-Smtp-Source: ABdhPJwKhqiNTTlcYj9nXVK0fCYywehODfMO7zP82hxSVQQ3gKEcXjD0EpiWUvQnXwDyc1t1Jg/0vQ==
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr28858014wml.23.1638100764238;
        Sun, 28 Nov 2021 03:59:24 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id h18sm11938521wre.46.2021.11.28.03.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 03:59:23 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sun, 28 Nov 2021 12:59:22 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 088/323] locking/lockdep: Avoid RCU-induced noinstr
 fail
Message-ID: <YaNvGtWfuCRkmWwi@eldamar.lan>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211124115721.937655496@linuxfoundation.org>
 <YaNP46ypf6xcTcJH@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaNP46ypf6xcTcJH@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Nov 28, 2021 at 10:46:13AM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Wed, Nov 24, 2021 at 12:54:38PM +0100, Greg Kroah-Hartman wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > [ Upstream commit ce0b9c805dd66d5e49fd53ec5415ae398f4c56e6 ]
> > 
> > vmlinux.o: warning: objtool: look_up_lock_class()+0xc7: call to rcu_read_lock_any_held() leaves .noinstr.text section
> 
> For 4.19.218 at least this commit seems to cause a build failure for
> cpupower, if warnings are treated as errors, I have not seen the same
> for the 5.10.80 build:
> 
> gcc -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -DVERSION=\"4.19\" -DPACKAGE=\"cpupower\" -DPACKAGE_BUGREPORT=\"Debian\ \(reportbug\ linux-cpupower\)\" -D_GNU_SOURCE -pipe -DNLS -Wall -Wchar-subscripts -Wpointer-arith
>  -Wsign-compare -Wno-pointer-sign -Wdeclaration-after-statement -Wshadow -Os -fomit-frame-pointer -fPIC -o /home/build/linux-4.19.218/debian/build/build-tools/tools/power/cpupower/lib/cpupower.o -c lib/cpupower.c
> In file included from lockdep.c:28:
> ../../../kernel/locking/lockdep.c: In function ‘look_up_lock_class’:
> ../../../kernel/locking/lockdep.c:694:2: error: implicit declaration of function ‘hlist_for_each_entry_rcu_notrace’; did you mean ‘hlist_for_each_entry_continue’? [-Werror=implicit-function-declaration]
>   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   hlist_for_each_entry_continue
> ../../../kernel/locking/lockdep.c:694:53: error: ‘hash_entry’ undeclared (first use in this function); did you mean ‘hash_ptr’?
>   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
>                                                      ^~~~~~~~~~
>                                                      hash_ptr
> ../../../kernel/locking/lockdep.c:694:53: note: each undeclared identifier is reported only once for each function it appears in
> ../../../kernel/locking/lockdep.c:694:64: error: expected ‘;’ before ‘{’ token
>   hlist_for_each_entry_rcu_notrace(class, hash_head, hash_entry) {
>                                                                 ^~
>                                                                 ;
> ../../../kernel/locking/lockdep.c:706:1: warning: control reaches end of non-void function [-Wreturn-type]
>  }
>  ^
> cc1: some warnings being treated as errors
> make[5]: *** [/home/build/linux-4.19.218/tools/build/Makefile.build:97: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/lockdep.o] Error 1
> make[4]: *** [Makefile:121: /home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep/liblockdep-in.o] Error 2
> make[4]: Leaving directory '/home/build/linux-4.19.218/tools/lib/lockdep'
> make[3]: *** [/home/build/linux-4.19.218/debian/rules.d/tools/lib/lockdep/Makefile:16: all] Error 2
> make[3]: Leaving directory '/home/build/linux-4.19.218/debian/build/build-tools/tools/lib/lockdep'
> make[2]: *** [debian/rules.real:795: build-liblockdep] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> I was not yet able to look further on it.

Might actually be a distro specific issue, needs some further
investigation.

Regards,
Salvatore
