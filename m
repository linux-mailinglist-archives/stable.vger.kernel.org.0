Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8844A135
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 14:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfFRM4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 08:56:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40057 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRM4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 08:56:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so15085108qtn.7;
        Tue, 18 Jun 2019 05:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCf5iHrLfN/sCDfBuv4fsEiVMo3wKaNoIwbeEHLt/rc=;
        b=PT6Pa5D4n6l9kyKzExM2NFZe3+YbP5u3ymXhF58YTPTEVzVyC/cQUq3I5UyRs9e9KK
         IIU4AFvTFcxwSibJk2iTDRd1rq7aVptJFfBkTesyFFl4gAREmkyBm8qnrAjhdEK7Rc9X
         nJe0+HsA92fEOapnYSxVu/JyGrtucL0KzpFMclthtIdLG6JSqx4st/wdGSVaPU+mZwhy
         oqvbaIDKDWpRZwIIVLeWcgK6aZ6fts0ScOgi3JLe/PN4vF7YvtbDCar/X/TWK64IL5Eg
         jX+FYdK9XHSHYh5Dm7zb3kB64Y/kBv3ZooIEq+bIsQYA2B8lsuMa1UG+sviCNBX2BGs0
         ymxg==
X-Gm-Message-State: APjAAAXU3TDFruLNvyVp2nCCVH8eUshP8qtra7ZmSC1iI9f4SEtLahCQ
        dS1gmURlintfCcrRSjjpfifbYmE2EG2lq/Sg9eshoyPkBUY=
X-Google-Smtp-Source: APXvYqwCVpXxqSfg0MzgdN3t4njvASb5EphGuU2IedZxTHyAW5Lc4aDC1ZXBq7xmQcAheuz7YuaPjxEgHvyJiCiNl9E=
X-Received: by 2002:a0c:b758:: with SMTP id q24mr27130440qve.45.1560862584288;
 Tue, 18 Jun 2019 05:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190617123109.667090-1-arnd@arndb.de> <20190617140210.GB3436@hirez.programming.kicks-ass.net>
In-Reply-To: <20190617140210.GB3436@hirez.programming.kicks-ass.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 14:56:07 +0200
Message-ID: <CAK8P3a3iwWOkMBL-H3h5aSaHKjKWFce22rvydvVE=3uMfeOhVg@mail.gmail.com>
Subject: Re: [PATCH] ubsan: mark ubsan_type_mismatch_common inline
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 4:02 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Jun 17, 2019 at 02:31:09PM +0200, Arnd Bergmann wrote:
> > objtool points out a condition that it does not like:
> >
> > lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> > lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> >
> > I guess this is related to the call ubsan_type_mismatch_common()
> > not being inline before it calls user_access_restore(), though
> > I don't fully understand why that is a problem.
>
> The rules are that when AC is set, one is not allowed to CALL schedule,
> because scheduling does not save/restore AC.  Preemption, through the
> exceptions is fine, because the exceptions do save/restore AC.
>
> And while most functions do not appear to call into schedule, function
> trace ensures that every single call does in fact call into schedule.
> Therefore any CALL (with AC set) is invalid.

I see that stackleak_track_stack is already marked 'notrace',
since we must ensure we don't recurse when calling into it from
any of the function trace logic.

Does that mean we could just mark it as another safe call?

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -486,6 +486,7 @@ static const char *uaccess_safe_builtin[] = {
        "__ubsan_handle_type_mismatch",
        "__ubsan_handle_type_mismatch_v1",
        /* misc */
+       "stackleak_track_stack",
        "csum_partial_copy_generic",
        "__memcpy_mcsafe",
        "ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */


> Maybe we should disable stackleak when building ubsan instead? We
> already disable stack-protector when building ubsan.

I couldn't find out how that is done.

> > Fixes: 42440c1f9911 ("lib/ubsan: add type mismatch handler for new GCC/Clang")
>
> I don't think this is quite right, because back then there wasn't any
> uaccess validation.

Right.

       Arnd
