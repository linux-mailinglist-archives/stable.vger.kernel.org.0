Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B5314FC4
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfEFPOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfEFPOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 11:14:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C23E6307D942;
        Mon,  6 May 2019 15:14:38 +0000 (UTC)
Received: from treble (ovpn-122-172.rdu2.redhat.com [10.10.122.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 433C65F9D6;
        Mon,  6 May 2019 15:14:30 +0000 (UTC)
Date:   Mon, 6 May 2019 10:14:28 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190506151428.r6fhirmoz5nrmiu5@treble>
References: <20190501202830.347656894@goodmis.org>
 <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home>
 <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 06 May 2019 15:14:39 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 11:02:40AM -0700, Linus Torvalds wrote:
> On Thu, May 2, 2019 at 9:21 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > TL;DR, on x86_32 kernel->kernel IRET frames are only 3 entries and do
> > not include ESP/SS, so not only wasn't regs->sp setup, if you changed it
> > it wouldn't be effective and corrupt random stack state.
> 
> Indeed, the 32-bit case for same-RPL exceptions/iret is entirely
> different, and I'd forgotten about that.
> 
> And honestly, this makes the 32-bit case much worse. Now the entry
> stack modifications of int3 suddenly affect not just the entry, but
> every exit too.
> 
> This is _exactly_ the kind of subtle kernel entry/exit code I wanted
> us to avoid.

I actually love this patch (absent the bugs).  This is already something
that has been sorely needed for years.

The "struct pt_regs is incomplete on x86-32" thing is a monstrosity
which has long been a source of confusion and bugs.  Sure, this patch
adds some complexity to the entry code, but on the other hand it
actually makes it possible to use pt_regs sanely: regs->sp is no longer
uninitialized.  So a class of (very non-obvious) bugs is eliminated.

I don't think it would make sense to make this change for int3 only,
because the benefits are global.

-- 
Josh
