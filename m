Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437FC13267
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfECQox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 12:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbfECQov (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 12:44:51 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F59217F5
        for <stable@vger.kernel.org>; Fri,  3 May 2019 16:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556901890;
        bh=8cw3huy9JgI135+NqQSe0fA379tB3gSlEfIQFk7nPPI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GN4tW4310AbL/mqvzyrO++mK6/0nJYMgriLgH/q3fTqUVlEYFgRBnwDRYwBAHOC5U
         SHgH4n3HB0aRrvENvxva9NuxFHVrOU6bdD4uObslpFeiCQi27bKzd7jnhT0ggW4+nl
         KWnKsSPtDikAHiIUxujOQeWbAleHYH56aw9on6gw=
Received: by mail-wr1-f54.google.com with SMTP id a9so8671176wrp.6
        for <stable@vger.kernel.org>; Fri, 03 May 2019 09:44:50 -0700 (PDT)
X-Gm-Message-State: APjAAAVIEUqUFEpNRa4IRJk6VyiUGk3Pdb/8Mt3KTKEsaL+L4QA6TllE
        PcQrfmMm9oyd296wjw4I/t8JIqtZjTJJ+O5QIAHLTw==
X-Google-Smtp-Source: APXvYqwdh0bncv2mEhNhDzUjkAso7jUC2TqrfVvEwRSxKalPbLqYKMBf8BsmaQA/bDkxZZthnfNip2uVK/Cx8DvGL2Q=
X-Received: by 2002:adf:ec42:: with SMTP id w2mr5212912wrn.77.1556901887167;
 Fri, 03 May 2019 09:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home> <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net> <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net> <20190503123126.3a2801be@gandalf.local.home>
 <20190503163527.GI2606@hirez.programming.kicks-ass.net>
In-Reply-To: <20190503163527.GI2606@hirez.programming.kicks-ass.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 3 May 2019 09:44:35 -0700
X-Gmail-Original-Message-ID: <CALCETrUcEH8kswYGNkoupVVP+3hEsTA4BWTfLk-RY_RfkDsHGw@mail.gmail.com>
Message-ID: <CALCETrUcEH8kswYGNkoupVVP+3hEsTA4BWTfLk-RY_RfkDsHGw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 3, 2019 at 9:35 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, May 03, 2019 at 12:31:26PM -0400, Steven Rostedt wrote:
> > I guess the real question is, what's the performance impact of doing
> > that?
>
> Is there anyone that considers i386 a performance platform?

Not me.  As far as I'm concerned, I will basically always gladly trade
several cycles for simplicity on 32-bit.

--Andy
