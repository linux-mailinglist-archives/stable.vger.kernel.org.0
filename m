Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD816BAA
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 21:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEGTte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 15:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEGTte (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 15:49:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8FE3D3082B4D;
        Tue,  7 May 2019 19:49:33 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E8741001DCC;
        Tue,  7 May 2019 19:49:27 +0000 (UTC)
Date:   Tue, 7 May 2019 14:49:25 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC][PATCH 2/3] x86_64: Allow breakpoints to emulate call
 functions
Message-ID: <20190507194925.qndvv67rinrmbefj@treble>
References: <20190507174227.673261270@goodmis.org>
 <20190507174400.219947724@goodmis.org>
 <20190507175342.fskdj2qidpao65qi@treble>
 <20190507150153.7a5d376d@gandalf.local.home>
 <20190507191412.n4uhoyfwagagyfwi@treble>
 <20190507152016.77f7a3af@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190507152016.77f7a3af@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 07 May 2019 19:49:34 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 03:20:16PM -0400, Steven Rostedt wrote:
> On Tue, 7 May 2019 14:14:12 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > On Tue, May 07, 2019 at 03:01:53PM -0400, Steven Rostedt wrote:
> > > How's this?
> > > 
> > > -- Steve
> > > 
> > > From d29dc2e9e0275c9857932b80cebc01551b669efb Mon Sep 17 00:00:00 2001
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > Date: Wed, 1 May 2019 15:11:17 +0200
> > > Subject: [PATCH] x86_64: Allow breakpoints to emulate call functions
> > > 
> > > In order to allow breakpoints to emulate call functions, they need to push
> > > the return address onto the stack. But because the breakpoint exception
> > > frame is added to the stack when the breakpoint is hit, there's no room to
> > > add the address onto the stack and return to the address of the emulated
> > > called funtion.  
> > 
> > The 2nd sentence can probably be removed since it's technically no
> > longer true, thanks to the previous patch.
> > 
> > > This helper functions are added:  
> > 
> > "These"
> 
> New version:
> 
>     x86_64: Allow breakpoints to emulate call functions
>     
>     In order to allow breakpoints to emulate call functions, they need to push

Sorry to keep nitpicking, but "call functions" -> "function calls" would
sound more accurate to me (in both subject and description).

Otherwise it looks good.

>     the return address onto the stack. The x86_64 int3 handler adds a small gap
>     to allow the stack to grow some. Use this gap to add the return address to
>     be able to emulate a call instruction at the breakpoint location.
>     
>     These helper functions are added:
>     
>       int3_emulate_jmp(): changes the location of the regs->ip to return there.
>     
>      (The next two are only for x86_64)
>       int3_emulate_push(): to push the address onto the gap in the stack
>       int3_emulate_call(): push the return address and change regs->ip

-- 
Josh
