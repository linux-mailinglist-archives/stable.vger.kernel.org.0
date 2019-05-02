Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AA12214
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 20:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfEBSoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 14:44:01 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40309 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfEBSoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 14:44:01 -0400
Received: by mail-lf1-f65.google.com with SMTP id o16so2638724lfl.7
        for <stable@vger.kernel.org>; Thu, 02 May 2019 11:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRZt+D8O8akEME1deiXcwDybfKiwpthrXzyaDQKQw+o=;
        b=DOe1Odxc1gK8brv9R5zvAAh8GUyJ0YnhuXPXnXKLY6rlveLN+SrMsrIhlmdzjwzc3A
         +gpmg7E+x+gFu/OGE9tnfORqGbP7/EJEKg5bLaODW4PNZqGswJ1xp/er7T39ChKACNGs
         gUroHv8DdOMTYzXZZhWIDTz6VqI7ZdBhWPnGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRZt+D8O8akEME1deiXcwDybfKiwpthrXzyaDQKQw+o=;
        b=THmjZIiqCUFnoHdxRez2UYKEWe22YFJJIUMntcaQTdD7X0y/8V95pr/ZAXSH9EwGUU
         oj7VpO0Up1MMSC6mhdBdnzDrmf/EEfPSkPBLiXWVrag8w/cPdFbu+0trQA/Zrsdbu9pJ
         EOOP3acnUJRTqgX02cPxcJCHDPqoWrUlTs0ZfZJwTIfzzWPAwaqJKhtBaiMkPsY0tjNa
         7CDRvljT+Hl0Zkhd3Pg339cMbx1fZT0U5Y4ZZS6zRzET0Iin4WCkrk+lFDtBWMR/ioJP
         MRiFLBjUIVsyNdpgQs5Rj/9o3qh7OZHLC9GOWJcRv6ZvBv9H5mcPp+Wym9BGujF8M1jg
         XjFA==
X-Gm-Message-State: APjAAAXzcIxHgaGmWAd5EWItZrmvlCtt/yAf9ufXPHXtRXQ9i17wOdV+
        mPHeWqsls0kudm28kzabUnWENWA1OMU=
X-Google-Smtp-Source: APXvYqxKmLotUcQ+M2Wa599W+v0k3WHQ+BHz37sgz6yPnv0ItobY+9Qd2hU37hz2z9KKYIT19K8OlQ==
X-Received: by 2002:a19:f50e:: with SMTP id j14mr2779275lfb.11.1556822638398;
        Thu, 02 May 2019 11:43:58 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id o7sm4107668ljh.57.2019.05.02.11.43.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 11:43:57 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id d15so3134540ljc.7
        for <stable@vger.kernel.org>; Thu, 02 May 2019 11:43:55 -0700 (PDT)
X-Received: by 2002:a2e:9a84:: with SMTP id p4mr2295002lji.22.1556822633649;
 Thu, 02 May 2019 11:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com> <20190502181811.GY2623@hirez.programming.kicks-ass.net>
In-Reply-To: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 May 2019 11:43:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
Message-ID: <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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

On Thu, May 2, 2019 at 11:18 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> We could fix this by not using the common exit path on int3; not sure we
> want to go there, but that is an option.

I don't think it's an option in general, because *some* int3
invocations will need all the usual error return.

But I guess we could make "int3 from kernel space" special.

I'm not sure how much that would help, but it might be worth looking into.

> ARGH; I knew it was too pretty :/ Yes, something like what you suggest
> will be needed, I'll go look at that once my brain recovers a bit from
> staring at entry code all day.

Looks like it works based on your other email.

What would it look like with the "int3-from-kernel is special" modification?

Because *if* we can make the "kernel int3" entirely special, that
would make the "Eww factor" much less of this whole thing.

I forget: is #BP _only_ for the "int3" instruction? I know we have
really nasty cases with #DB (int1) because of "pending exceptions
happen on the first instruction in kernel space", and that makes it
really really nasty to handle with all the stack switch and %cr3
handling etc.

But if "int3 from kernel space" _only_ happens on actual "int3"
instructions, then we really could just special-case that case. We'd
know that %cr3 has been switched, we'd know that we don't need to do
fsgs switching, we'd know we already have a good stack and percpu data
etc set up.

So then special casing #BP would actually allow us to have a simple
and straightforward kernel-int3-only sequence?

And then having that odd stack setup special case would be *much* more
palatable to me.

               Linus
