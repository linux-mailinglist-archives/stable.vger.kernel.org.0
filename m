Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0E91362E
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 01:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfECXcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 19:32:18 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39732 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfECXcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 19:32:18 -0400
Received: by mail-pg1-f195.google.com with SMTP id w22so2122585pgi.6
        for <stable@vger.kernel.org>; Fri, 03 May 2019 16:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TtFvUcdRlwxjJeP9GJ9LZ/wpYtYluyY83Ajo3n2tLmk=;
        b=kqskyXzrfDnxR77Tks5uSUi+a2XhUZmNpDID3r72qxt/NRxfhrjv0CokHNdtd+a6cl
         m7alBdhtieul6RlJNw/MTLNWYFtHDYii/+BV2m5+g/sk4qcggR68NCRigyzZvZrhAFQ/
         MnZmbfiAPykM13Tz0riPz34Eir1qlJuTrfUVeKGGZ+zsYPouJsaaPHyrhL0hyqHTzKd7
         BUTkKCln6bRieJYk98qtx4OGov0CJzhFT/zakqd68j/M1z3BunVYca4gMFp7sx/JseJK
         WP3tnvFsi89qihVYRc7m8QPwHNDjiD/+ifQkuvMSRrySXIr/5M/4Xqv5sTSAj0uMkVZM
         Y/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TtFvUcdRlwxjJeP9GJ9LZ/wpYtYluyY83Ajo3n2tLmk=;
        b=YAB1MynHbFypuHXaAp01YVoK6m21it3sMd1bjn5Y4HL51Gv0FZ9zgGAx2nRng90etb
         MHgNHqDjdLqx6FbtHHA30I3rGVmtnNchfSIm1r/ZTa8DmTtQWsVQqOPF7urVJ66X1Dx9
         Kpk46V5PkcqVK77fgpZdWJjIcudZsOfDMVP32wUtKbwTMFEBAADPVMyjO8mhSAZBaW2j
         3DbQ2J77osEVTGA19BCBNDO5ATvJEne204BFvJCeOzJW8EZDHIWURiHJUIVERKNztX5q
         5+SJDQvNYYg/EyRcVbaZH6rqo89dq61xu6vzGPxTzF/F6LYFG6wKmF/ByBpR9HI3C11h
         x1Yw==
X-Gm-Message-State: APjAAAXvGr/XKBLrZEmla3jvKvRqEtapoaGbj9NdKpZR4yHW3oJlJa0v
        g0XZRP5rAGGtCiYtO/TDh5jYpQ==
X-Google-Smtp-Source: APXvYqyt9qFX7ekjL0W2h6vNZaNPpMFfvQPEWar+kAfFHxSiKk+BiVATEsFBTIEGtB7ggV2iwT09kw==
X-Received: by 2002:a63:ef04:: with SMTP id u4mr7647580pgh.96.1556926337031;
        Fri, 03 May 2019 16:32:17 -0700 (PDT)
Received: from [10.145.97.154] ([12.53.65.170])
        by smtp.gmail.com with ESMTPSA id q17sm5403159pfi.185.2019.05.03.16.32.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 16:32:16 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <CAHk-=wjZDhwStWvioV7totCnZfp74bqH0y1UJxkmFfdLg48wDA@mail.gmail.com>
Date:   Fri, 3 May 2019 16:32:15 -0700
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <93546F2D-0DF6-4E6A-98B0-BA49491C00CC@amacapital.net>
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org> <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net> <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com> <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com> <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com> <20190503152405.2d741af8@gandalf.local.home> <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com> <2962A4E4-3B9F-4195-9C6D-9932809D98F9@amacapital.net> <CAHk-=wjZDhwStWvioV7totCnZfp74bqH0y1UJxkmFfdLg48wDA@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 3, 2019, at 4:16 PM, Linus Torvalds <torvalds@linux-foundation.org>=
 wrote:
>=20
>> On Fri, May 3, 2019 at 3:55 PM Andy Lutomirski <luto@amacapital.net> wrot=
e:
>>=20
>> But I think this will end up worse than the version where the entry code f=
ixes it up.  This is because, if the C code moves pt_regs, then we need some=
 way to pass the new pointer back to the asm.
>=20
> What? I already posted that code. Let me quote it again:
>=20
> Message-ID: <CAHk-=3Dwh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gm=
ail.com>
>=20
>        # args: pt_regs pointer (no error code for int3)
>        movl %esp,%eax
>        # allocate a bit of extra room on the stack, so that
>        # 'kernel_int3' can move the pt_regs
>        subl $8,%esp
>        call kernel_int3
>        movl %eax,%esp
>=20
> It's that easy (this is with the assumption that we've already applied
> the "standalone simple int3" case, but I think the above might work
> even with the current code model, just the "call do_int3" needs to
> have the kernel/not-kernel distinction and do the above for the kernel
> case)
>=20
> That's *MUCH* easier than your code to move entries around on the
> stack just as you return, and has the advantage of not changing any
> C-visible layout.
>=20
> The C interface looks like this
>=20
>    /* Note: on x86-32, we can move 'regs' around for push/pop emulation */=

>    struct pt_regs *kernel_int3(struct pt_regs *regs)
>    {
>        ..
>        .. need to pass regs to emulation functions
>        .. and call emulation needs to return it
>        ..
>        return regs;
>    }
>=20
> and I just posted as a response to Stephen the *trivial* do_int3()
> wrapper (so that x86-64 doesn't need to care), and the *trivial* code
> to actually emulate a call instruction.
>=20
> And when I say "trivial", I obviously mean "totally untested and
> probably buggy", but it sure seems *simple*.,
>=20
> Notice? Simple and minimal changes to entry code that only affect
> int3, and nothing else.
>=20
> =20

I can get on board with this.=
