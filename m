Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6EC253625
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 19:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgHZRrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 13:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgHZRrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 13:47:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C840C061574;
        Wed, 26 Aug 2020 10:47:42 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598464059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HX2HLBhi0wlAtyTIUgiN/1RIi5SlncWFJOMrq7y7hFY=;
        b=GnYw3mSIxtBphZBY5CJDgXoe4DxWv+jiAw2ZDTjRA6EFla8Z7Le2rllgfyJIwRFSVFC4Fi
        FuGUbb7E06pDhq8XeZBrRJDJWoz8jFqjhp8rvczAAU0V+N6MRcfK2DtLdZkD2H36RACoEq
        2wtvL0P04c9Ha/Goxa96lPeHicM7oBK39M3UNGTLTQ+tlY6iscqgOpG6h5S5H9m8IVdPPa
        x/GOnu+in3B7de/4k2evOehYHhHgXewwG6bwCTjhHwyKI3NkYxmRZl0Z9UyTFb/ANM7lVl
        ci/Hn3VKGs7vx/3ddd4MZQL6d0dbJy7dh5So90cet8+ZR4uPcBgIqRcYTvJisg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598464059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HX2HLBhi0wlAtyTIUgiN/1RIi5SlncWFJOMrq7y7hFY=;
        b=IHc4jvprLTkzDK/iU1NAfc6TbfzG/pxd13owSiweS5f0L6e35whtCpEq4USngkoD265M8l
        bTnoDIr/gRAXXfCQ==
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexander Graf <graf@amazon.com>, X86 ML <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Avi Kivity <avi@scylladb.com>,
        "Herrenschmidt\, Benjamin" <benh@amazon.com>, robketr@amazon.de,
        Amos Kong <amos@scylladb.com>, Brian Gerst <brgerst@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
In-Reply-To: <CALCETrX-8a61k03+XJop=k11-TkE+7JOiGTH=81sHXPmXsA+Tw@mail.gmail.com>
References: <20200826115357.3049-1-graf@amazon.com> <87k0xlv5w5.fsf@nanos.tec.linutronix.de> <CALCETrX-8a61k03+XJop=k11-TkE+7JOiGTH=81sHXPmXsA+Tw@mail.gmail.com>
Date:   Wed, 26 Aug 2020 19:47:39 +0200
Message-ID: <87eentuwn8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andy,

On Wed, Aug 26 2020 at 09:13, Andy Lutomirski wrote:
> On Wed, Aug 26, 2020 at 7:27 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> The below nasty hack cures it, but I hate it with a passion. I'll look
>> deeper for a sane variant.
>>
> Fundamentally, the way we overload orig_ax is problematic.  I have a
> half-written series to improve it, but my series is broken.  I think
> it's fixable, though.
>
> First is this patch to use some __csh bits to indicate the entry type.
> As far as I know, this patch is correct:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=dfff54208072a27909ae97ebce644c251a233ff2

Yes, that looks about right.

> Then I wrote this incorrect patch:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=3a5087acb8a2cc1e88b1a55fa36c2f8bef370572
>
> That one is wrong because the orig_ax wreckage seems to have leaked
> into user ABI -- user programs think that orig_ax has certain
> semantics on user-visible entries.

Yes, orig_ax is pretty much user ABI for a very long time.

> But I think that the problem in this thread could be fixed quite
> nicely by the first patch, plus a new CS_ENTRY_IRQ and allocating
> eight bits of __csh to store the vector.  Then we could read out the
> vector.

That works. Alternatively I can just store the vector in the irq
descriptor itself. That's trivial enough and can be done completely in C
independent of the stuff above.

Thanks,

        tglx
