Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9775B307A18
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 16:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhA1Px6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 10:53:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229885AbhA1Pxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 10:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611849148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dB3JIX9113VONKdVfV6NlxQN80Cb3wMNjDS3PJIHsUU=;
        b=h/yLiErlrqWXMf98NDJ9X76xMNiRycVKcgOlKijbkOMcjIxbEUzYV3z+hrqAyVZcAPy3Ly
        yXSFFO8gU/zmeB2tOuddxI9h4ykmSfmSP/4s51YZfGuWg3Q282j1BuLEQIQqf37NhWkUI2
        sUXKDeXlmOc7BhdJdvBEjKu2YV3QTLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-XcJUl8L6PCadxoA9h56X8A-1; Thu, 28 Jan 2021 10:52:26 -0500
X-MC-Unique: XcJUl8L6PCadxoA9h56X8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FA0D1015C84;
        Thu, 28 Jan 2021 15:52:25 +0000 (UTC)
Received: from treble (ovpn-120-118.rdu2.redhat.com [10.10.120.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E1185D720;
        Thu, 28 Jan 2021 15:52:24 +0000 (UTC)
Date:   Thu, 28 Jan 2021 09:52:22 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Thomas Backlund <tmb@tmb.nu>
Cc:     Chris Clayton <chris2553@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: linux-5.10.11 build failure
Message-ID: <20210128155222.eu35xflfqlcinu7g@treble>
References: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8b3e9d93-1381-b415-9ece-a10fb098b896@tmb.nu>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 11:24:47AM +0000, Thomas Backlund wrote:
> Den 28.1.2021 kl. 12:05, skrev Chris Clayton:
> > 
> > On 28/01/2021 09:34, Greg Kroah-Hartman wrote:
> >> On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
> >>> Hi,
> >>>
> >>> Building 5.10.11 fails on my (x86-64) laptop thusly:
> >>>
> >>> ..
> >>>
> >>>   AS      arch/x86/entry/thunk_64.o
> >>>    CC      arch/x86/entry/vsyscall/vsyscall_64.o
> >>>    AS      arch/x86/realmode/rm/header.o
> >>>    CC      arch/x86/mm/pat/set_memory.o
> >>>    CC      arch/x86/events/amd/core.o
> >>>    CC      arch/x86/kernel/fpu/init.o
> >>>    CC      arch/x86/entry/vdso/vma.o
> >>>    CC      kernel/sched/core.o
> >>> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e
> >>>
> >>>    AS      arch/x86/realmode/rm/trampoline_64.o
> >>> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
> >>> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
> >>> make[2]: *** Waiting for unfinished jobs....
> >>>
> >>> ..
> >>>
> >>> Compiler is latest snapshot of gcc-10.
> >>>
> >>> Happy to test the fix but please cc me as I'm not subscribed
> >>
> >> Can you do 'git bisect' to track down the offending commit?
> >>
> > 
> > Sure, but I'll hold that request for a while. I updated to binutils-2.36 on Monday and I'm pretty sure that is a feature
> > of this build fail. I've reverted binutils to 2.35.1, and the build succeeds. Updated to 2.36 again and, surprise,
> > surprise, the kernel build fails again.
> > 
> > I've had a glance at the binutils ML and there are all sorts of issues being reported, but it's beyond my knowledge to
> > assess if this build error is related to any of them.
> > 
> > I'll stick with binutils-2.35.1 for the time being.
> > 
> >> And what exact gcc version are you using?
> >>
> > 
> >   It's built from the 10-20210123 snapshot tarball.
> > 
> > I can report this to the binutils folks, but might it be better if the objtool maintainer looks at it first? The
> > binutils change might just have opened the gate to a bug in objtool.
> > 
> >> thanks,
> >>
> >> greg k-h
> >>
> > 
> 
> 
> AFAIK you need this in stable trees:
> 
>  From 1d489151e9f9d1647110277ff77282fe4d96d09b Mon Sep 17 00:00:00 2001
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> Date: Thu, 14 Jan 2021 16:14:01 -0600
> Subject: [PATCH] objtool: Don't fail on missing symbol table

Actually I think you need:

  5e6dca82bcaa ("x86/entry: Emit a symbol for register restoring thunk")

I submitted a patch to stable list a few days ago.

(Though it's possible you need both commits, I'm not sure if binutils
 2.36 has the symbol stripping stuff)

-- 
Josh

