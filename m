Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996C524C7DE
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 00:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgHTWnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 18:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728489AbgHTWnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 18:43:21 -0400
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4087622BED
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597963400;
        bh=5xHB7attkpmdUNvdTySFDMgYf8GNV6BlGCYBOuLcHEc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=COYHVBXO3lN06Rb02cRiYn5f/fqzDSmlDtxTdw1OZp0e9jpSARPBBrCgxDlqxBLz8
         3zUefbTY6RZimHz3I2/okoRrPpv88Ovypw14zYVVXm/XzNuCCy22hRi0qNBQST53YK
         /tCG9XElPADBs8w74fIZAZbk6itbOWNkyAxd3fps=
Received: by mail-ed1-f54.google.com with SMTP id k25so1504676edj.13
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 15:43:20 -0700 (PDT)
X-Gm-Message-State: AOAM532fam7UIaSlXI8pZtiP95IBSoMUg4Kwzgb7ON40OoFgUTRtbyI0
        4/j16+QpbKoh7+fhA8zZpqGsQBXUe1VXbLSzoMXLAg==
X-Google-Smtp-Source: ABdhPJyIgAqsMA8JsQyikj/7ZlGQn610nb8EEcUeoTdpgwBdv87N4yg0Jjwegi5kVutkq43iZp2VoPR538rleGH4AVg=
X-Received: by 2002:adf:cc88:: with SMTP id p8mr7829wrj.70.1597963398679; Thu,
 20 Aug 2020 15:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <8b9bd05f187231df008d48cf818a6a311cbd5c98.1597882384.git.luto@kernel.org>
 <20200820084427.GO2674@hirez.programming.kicks-ass.net>
In-Reply-To: <20200820084427.GO2674@hirez.programming.kicks-ass.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 20 Aug 2020 15:43:07 -0700
X-Gmail-Original-Message-ID: <CALCETrXkZdR4Vvk1UXeWapHrBug+d6Nr-=VcbFHzw8PKzvLJCw@mail.gmail.com>
Message-ID: <CALCETrXkZdR4Vvk1UXeWapHrBug+d6Nr-=VcbFHzw8PKzvLJCw@mail.gmail.com>
Subject: Re: [PATCH] x86/debug: Allow a single level of #DB recursion
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Kyle Huey <me@kylehuey.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        "Robert O'Callahan" <rocallahan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Brian Gerst <brgerst@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 1:44 AM <peterz@infradead.org> wrote:
>
> On Wed, Aug 19, 2020 at 05:15:43PM -0700, Andy Lutomirski wrote:
> > +static __always_inline void debug_enter(unsigned long *dr6, unsigned long *dr7)
> > +{
> > +     *dr6 = debug_read_clear_dr6();
> >  }
> >
> >  static __always_inline void debug_exit(unsigned long dr7)
> >  {
> > -     local_db_restore(dr7);
> >  }
>
> That's all unused after this patch, might as well remove it.

Whoops.
