Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BACE13A0BC
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 06:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgANFkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 00:40:00 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:44658 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANFkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 00:40:00 -0500
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23990431AbgANFj45Upcz (ORCPT
        <rfc822;stable@vger.kernel.org> + 2 others);
        Tue, 14 Jan 2020 06:39:56 +0100
Date:   Tue, 14 Jan 2020 05:39:56 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Paul Burton <paulburton@kernel.org>
cc:     David Laight <David.Laight@aculab.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] MIPS: Use __copy_{to,from}_user() for emulated FP
 loads/stores
In-Reply-To: <20191229190123.ju24cz7thuvybejs@lantea.localdomain>
Message-ID: <alpine.LFD.2.21.2001140508250.1162854@eddie.linux-mips.org>
References: <20191203204933.1642259-1-paulburton@kernel.org> <f5e09155580d417e9dcd07b1c20786ed@AcuMS.aculab.com> <20191204154048.eotzglp4rdlx4yzl@lantea.localdomain> <e220ba9a19da41abba599b5873afa494@AcuMS.aculab.com> <alpine.LFD.2.21.1912260251520.3762799@eddie.linux-mips.org>
 <20191229190123.ju24cz7thuvybejs@lantea.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

 Sorry to take so long; it took me a while to track down the discussion I 
had in mind, and I was quite busy too.  Also greetings from linux.conf.au!

> >  As I recall we only emulate unaligned accesses with a subset of integer 
> > load/store instructions (and then only if TIF_FIXADE is set, which is the 
> > default), and never with FP load/store instructions.  Consequently I see 
> > no point in doing this in the FP emulator either and I think these ought 
> > to just send SIGBUS instead.  Otherwise you'll end up with user code that 
> > works differently depending on whether the FP hardware is real or 
> > emulated, which is really bad.
> 
> That might simplify things here, but it's incorrect. I'm fairly certain
> the intent is that emulate_load_store_insn() handles all non-FP loads &
> stores (though looking at it we're missing some instructions added in
> r6). More importantly though we've been emulating FP loads & stores
> since v3.10 which introduced the change alongside microMIPS support in
> commit 102cedc32a6e ("MIPS: microMIPS: Floating point support."). The
> commit contains no description of why, and I'm not aware of any reason
> microMIPS specifically would need this so I suspect that commit bundled
> this change for no good reason...

 See the thread of discussion starting from this submission:

<https://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=20120615234641.6938B58FE7C%40mail.viric.name>

and in particular Ralf's response (not referred directly due to the 
monthly archive rollover):

<https://www.linux-mips.org/cgi-bin/mesg.cgi?a=linux-mips&i=20120731134001.GA14151%40linux-mips.org>

I think Ralf's argument still stands and I find it regrettable that an 
unwanted feature was sneaked in with a trick along with a submission 
supposed to only add a different, unrelated feature.

 I can't even track down a public submission/review of the change you 
refer, which is not how things are supposed to work with Linux!  And 
neither the `Signed-off-by' tags help figuring out what the route of the 
change was to get there upstream.  At that time there was supposed to be 
Ralf's tag there, as it was him who was the sole port maintainer.

> It's also worth noting that some hardware will handle unaligned FP
> loads/stores, which means having the emulator reject them will result in
> more of a visible difference to userland. ie. on some hardware they'll
> work just fine, but on some you'd get SIGBUS. So I do think emulating
> them makes some sense - just as for non-FP loads & stores it lets
> userland not care whether the hardware will handle them, so long as it's
> not performance critical code. If we knew that had never been used then
> perhaps we could enforce the alignment requirement (and maybe that's
> what you recall doing), but since we've been emulating them for the past
> 6 years it's too late for that now.

 I don't think it's ever too late to remove a broken feature that everyone 
knows is not a part of the architecture and the emulation of which has 
never been advertised as a part of the Linux ABI either.  You just don't 
make it a part of the ABI when you sneak in a feature without a proper 
review, we do not accept the fait accompli method in Linux development.

 The presence of unaligned FP data is a sign of user code breakage and 
whoever caused that breakage will best know that ASAP by seeing their 
program trap (they can emulate the trap in their software by installing a 
suitable signal handler if they are so desperate to have unaligned FP data 
handled).

 So I think that not only the new submission should be rejected, but also 
parts of commit 102cedc32a6e ("MIPS: microMIPS: Floating point support.") 
reverted that are not a part of actual microMIPS support.  If someone 
relied on it by accident or ignorance, they'll simply have to adjust.

  Maciej
