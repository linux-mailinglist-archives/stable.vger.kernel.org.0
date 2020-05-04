Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C131C4834
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 22:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgEDU0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 16:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgEDU0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 16:26:19 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A3A2192A
        for <stable@vger.kernel.org>; Mon,  4 May 2020 20:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588623979;
        bh=DUmpNCt7sNyutHVhULaA6d0vAPjjPhpTraWgkmnZdyY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KvXXiqry87Szd40oW7qmvq0ntbT1pBo6DfjXJmzmENbGlpPUlXmPL3CW9nfNNtMpo
         w39UxUKjl8KtH8DTHYzaAVJOjxQVuQjfxX77yYW4FDf2jLkIHoXysk+ifogXw0STHo
         r7P3YE3FswvzHQa/7qoQa1zzjk+a3mjOx22UyNxs=
Received: by mail-wr1-f41.google.com with SMTP id g13so48223wrb.8
        for <stable@vger.kernel.org>; Mon, 04 May 2020 13:26:18 -0700 (PDT)
X-Gm-Message-State: AGi0Pub90EL8W9Jvn66FXw4UQX48ddF+uLX3wxkMsc2/7pAxhAmi0Gmc
        WCmPe3S8uB+TsPHgurz6quyMD0HLdTwerybGGP1r3w==
X-Google-Smtp-Source: APiQypJgIr3SLa4yyIaFXtdy872yoxtbq48e5nGbKjFHKp58KwjtLIyJDkPPDArLP6fzN/fnACAi9buLhS2L24Hcp80=
X-Received: by 2002:a5d:42c8:: with SMTP id t8mr1151633wrr.70.1588623976949;
 Mon, 04 May 2020 13:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
 <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net> <3908561D78D1C84285E8C5FCA982C28F7F60EBB6@ORSMSX115.amr.corp.intel.com>
 <CALCETrW5zNLOrhOS69xeb3ANa0HVAW5+xaHvG2CA8iFy1ByHKQ@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F7F612DF4@ORSMSX115.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7F612DF4@ORSMSX115.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 4 May 2020 13:26:05 -0700
X-Gmail-Original-Message-ID: <CALCETrVAsppM5kRz0HicAQ8o_x06=7Nd0q64sEre3MEShWPaLw@mail.gmail.com>
Message-ID: <CALCETrVAsppM5kRz0HicAQ8o_x06=7Nd0q64sEre3MEShWPaLw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Tsaur, Erwin" <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 4, 2020 at 1:05 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> > When a copy function hits a bad page and the page is not yet known to
> > be bad, what does it do?  (I.e. the page was believed to be fine but
> > the copy function gets #MC.)  Does it unmap it right away?  What does
> > it return?
>
> I suspect that we will only ever find a handful of situations where the
> kernel can recover from memory that has gone bad that are worth fixing
> (got to be some code path that touches a meaningful fraction of memory,
> otherwise we get code complexity without any meaningful payoff).
>
> I don't think we'd want different actions for the cases of "we just found out
> now that this page is bad" and "we got a notification an hour ago that this
> page had gone bad". Currently we treat those the same for application
> errors ... SIGBUS either way[1].

Oh, I agree that the end result should be the same.  I'm thinking more
about the mechanism and the internal API.  As a somewhat silly example
of why there's a difference, the first time we try to read from bad
memory, we can expect #MC (I assume, on a sensibly functioning
platform).  But, once we get the #MC, I imagine that the #MC handler
will want to unmap the page to prevent a storm of additional #MC
events on the same page -- given the awful x86 #MC design, too many
all at once is fatal.  So the next time we copy_mc_to_user() or
whatever from the memory, we'll get #PF instead.  Or maybe that #MC
will defer the unmap?

So the point of my questions is that the overall design should be at
least somewhat settled before anyone tries to review just the copy
functions.
