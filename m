Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789FA12292
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 21:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEBT3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 15:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfEBT3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 15:29:01 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A2F205F4;
        Thu,  2 May 2019 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556825340;
        bh=4+7iWLyZHdlkEaJ9YIk2Zw2gBNmiSwpxVpWt2kUQHoA=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=T3meCuhymsjbqBV1PJ4E8RF0HMtRR78xo9UtI/BzIqosyAJrJej4ouBZOQXFy38v9
         Xqqac2c12ESnORGAB5k92HVdaVhMRyZdR4m6ewn1XoG1Vcdy9TxLdpkYy6/fs+4emz
         yrffJxf6fyRF0eI6jBQBaqBaNH9/JMsz7X8WC4x4=
Date:   Thu, 2 May 2019 21:28:53 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     Peter Zijlstra <peterz@infradead.org>,
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
        Josh Poimboeuf <jpoimboe@redhat.com>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
In-Reply-To: <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.1905022101060.10635@cbobk.fhfr.pm>
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org> <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net> <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 May 2019, Linus Torvalds wrote:

> I forget: is #BP _only_ for the "int3" instruction? 

Hmm, according to 17.3.2 in vol 3 of SDM (and table 6-1 there), that 
indeed seems to be the case, so we should be fine.

> But if "int3 from kernel space" _only_ happens on actual "int3"
> instructions, then we really could just special-case that case. We'd
> know that %cr3 has been switched, we'd know that we don't need to do
> fsgs switching, we'd know we already have a good stack and percpu data
> etc set up.

That should indeed be doable, under the asumption that noone is doing any 
int3 games before we've switched away from entry trampoline.

I've briefly looked, and seems like we have proper notrace anotations for 
stackleak_erase(), which seems to be the only C (ftrace-able) code that's 
running on a trampoline (off-topic: where does PTI code make sure that we 
actually map this symbol into user pagetables in case we're not doing 
global mapping?).

-- 
Jiri Kosina
SUSE Labs

