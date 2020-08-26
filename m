Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC7253639
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 20:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHZSAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 14:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgHZSAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 14:00:41 -0400
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E1E20737
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598464840;
        bh=WId3BTrlpx4dFQDQ6F8bBoE8Z80/dTcpERIP1b6Ga9k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FhFRwOKXHFzlRt+ouyHtm1yMMXPJt6At0/ogHY0K2+d4hX8hDeBOI3VAtNkclibVV
         K7sYiUvCmLvoBnN7tXS0y8jeB/QyeeDVfm82txnZiaVcxy8V45uyXemePW4jlhCC8J
         piZOxd/sLwiXMuT9l11Jcnv5ugcdexrduCwUf1hs=
Received: by mail-ed1-f43.google.com with SMTP id c8so2522460edn.8
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 11:00:39 -0700 (PDT)
X-Gm-Message-State: AOAM5303yunOyNefe1ITvOexPqaDOTzFosfEkZFvZgSoV0BVJLFMKJuV
        PeIq5Laa06Ze2XL/+GaSJ4GszrktdUW0YvblL1OOtQ==
X-Google-Smtp-Source: ABdhPJx+8ruOOWOEt9g6LP17Jqc4u8yMfiB8jgl3qmPXylIwXxEaVMQkkFlxfJ5W/ZHpeKHB79EY3NJ71151MgqzJLM=
X-Received: by 2002:adf:f442:: with SMTP id f2mr6093709wrp.184.1598464835295;
 Wed, 26 Aug 2020 11:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200826115357.3049-1-graf@amazon.com> <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
 <CALCETrX-8a61k03+XJop=k11-TkE+7JOiGTH=81sHXPmXsA+Tw@mail.gmail.com> <87eentuwn8.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87eentuwn8.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 26 Aug 2020 11:00:23 -0700
X-Gmail-Original-Message-ID: <CALCETrWG9UZUuygcTtYi51UFnaENW8Cv8xhuMXSZprP+_dQrFA@mail.gmail.com>
Message-ID: <CALCETrWG9UZUuygcTtYi51UFnaENW8Cv8xhuMXSZprP+_dQrFA@mail.gmail.com>
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexander Graf <graf@amazon.com>, X86 ML <x86@kernel.org>,
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
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Avi Kivity <avi@scylladb.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>, robketr@amazon.de,
        Amos Kong <amos@scylladb.com>, Brian Gerst <brgerst@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 10:47 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Andy,
>
> On Wed, Aug 26 2020 at 09:13, Andy Lutomirski wrote:
> > On Wed, Aug 26, 2020 at 7:27 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> The below nasty hack cures it, but I hate it with a passion. I'll look
> >> deeper for a sane variant.
> >>
> > Fundamentally, the way we overload orig_ax is problematic.  I have a
> > half-written series to improve it, but my series is broken.  I think
> > it's fixable, though.
> >
> > First is this patch to use some __csh bits to indicate the entry type.
> > As far as I know, this patch is correct:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=dfff54208072a27909ae97ebce644c251a233ff2
>
> Yes, that looks about right.
>
> > Then I wrote this incorrect patch:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=3a5087acb8a2cc1e88b1a55fa36c2f8bef370572
> >
> > That one is wrong because the orig_ax wreckage seems to have leaked
> > into user ABI -- user programs think that orig_ax has certain
> > semantics on user-visible entries.
>
> Yes, orig_ax is pretty much user ABI for a very long time.
>
> > But I think that the problem in this thread could be fixed quite
> > nicely by the first patch, plus a new CS_ENTRY_IRQ and allocating
> > eight bits of __csh to store the vector.  Then we could read out the
> > vector.
>
> That works. Alternatively I can just store the vector in the irq
> descriptor itself. That's trivial enough and can be done completely in C
> independent of the stuff above.

The latter sounds quite sensible to me.  It does seem vaguely
ridiculous to be trying to fish the vector out of pt_regs in the APIC
code.

--Andy
