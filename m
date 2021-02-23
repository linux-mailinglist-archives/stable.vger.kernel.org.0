Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBB3322DA4
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 16:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhBWPgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 10:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhBWPgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 10:36:31 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D7AC06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 07:35:49 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d2so2167697pjs.4
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 07:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=BnLhbV4q8sdnFkZjnko1LKGxrL0kXwy4HCD3zJOfD4k=;
        b=e1aOH4lowSAqlV7nJxM5AJOOrXdop1pnqlXYB6/tmt2DOmu9BDsYecM5EQi8qOHgD+
         G1ZGGTakAqN8i4Zq4zsfB0xoh3Sj7o2GCaqOsnj9rHhrXE8ztr2Z5lMK/YZIluQWJuo1
         aqJhSjEM8IcSgnX6iF8Hq1qIUetFL+So604VONxxvHi7tOMeywsh9jIUifeGI1HBIWb4
         bXfqK/b4+cHyGlROe5xlRNlud8+B8enGZaBlckVQte2t9Vh8EKjNTbNf6/MIa5weonC7
         d/WHaHEfyJpuE6uZ1XP+AT/yae7AyLCASwamMLTaE27Pio0ZnwLlxDmTIPKSSi9CoOz8
         Dwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=BnLhbV4q8sdnFkZjnko1LKGxrL0kXwy4HCD3zJOfD4k=;
        b=T2vB7dyDb/7x98ka3TrCk62pS+zNxx4B6EAW6m6r1fIQ+sic8Hr3N/vXNTS2DkKHuQ
         x+6ZDBQgKw+BJvuFKYPKlvpwgJHJr7m+VL4rKN8wowopx6aHZaGh8M50qUljV/IymRlg
         RCdq5ljU05tTkJKW0ywCTa0dEIuVbJApEIK4GeQMgm+vZdEhgQTsLCQrJLHurNKKyemE
         CgBpyRXcSEVYJjn/xgFLIgKZAh3IWJKjG0YIT+S9wMpv692SBl3p9sNqQG5qNaxwITf0
         IQieC8Fv2wIkgYnURpmF5/vLH5o7Mj8qYUr1OiYiEJvvZHsAt1PECRFVvZxZrrQyOjIU
         QbtQ==
X-Gm-Message-State: AOAM531/mqaQ6sYMqnb9a/YTABU3TO3ULKuQNa0qv6NIODnu84Rg6Ie0
        EX7yMllQj8I83K0TgIVIRrQ1tg==
X-Google-Smtp-Source: ABdhPJyOjf5KjBka3sjuuTJblzjYJPNhq3qQWCL4Ka/HLlJMZ5H6zRe97rFfZcGYUueSudAaVChZlA==
X-Received: by 2002:a17:90a:1a16:: with SMTP id 22mr30322559pjk.34.1614094549345;
        Tue, 23 Feb 2021 07:35:49 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:2488:1c5a:27b:935? ([2601:646:c200:1ef2:2488:1c5a:27b:935])
        by smtp.gmail.com with ESMTPSA id t18sm683718pjs.6.2021.02.23.07.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 07:35:48 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/3] x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls
Date:   Tue, 23 Feb 2021 07:35:47 -0800
Message-Id: <AA835AD1-31C1-4C8A-AEFF-F0D1DD2C834C@amacapital.net>
References: <YDTm8Q/cvBcfzhPn@hirez.programming.kicks-ass.net>
Cc:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
In-Reply-To: <YDTm8Q/cvBcfzhPn@hirez.programming.kicks-ass.net>
To:     Peter Zijlstra <peterz@infradead.org>
X-Mailer: iPhone Mail (18D52)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Feb 23, 2021, at 3:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> =EF=BB=BFOn Mon, Feb 22, 2021 at 09:50:28PM -0800, Andy Lutomirski wrote:
>> On a 32-bit fast syscall that fails to read its arguments from user
>> memory, the kernel currently does syscall exit work but not
>> syscall exit work.  This would confuse audit and ptrace.
>>=20
>> This is a minimal fix intended for ease of backporting.  A more
>> complete cleanup is coming.
>>=20
>> Cc: stable@vger.kernel.org
>> Fixes: 0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>> ---
>> arch/x86/entry/common.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
>> index 0904f5676e4d..cf4dcf346ca8 100644
>> --- a/arch/x86/entry/common.c
>> +++ b/arch/x86/entry/common.c
>> @@ -128,7 +128,8 @@ static noinstr bool __do_fast_syscall_32(struct pt_re=
gs *regs)
>>        regs->ax =3D -EFAULT;
>>=20
>>        instrumentation_end();
>> -        syscall_exit_to_user_mode(regs);
>> +        local_irq_disable();
>> +        exit_to_user_mode();
>>        return false;
>>    }
>=20
> I'm confused, twice. Once by your Changelog, and second by the actual
> patch. Shouldn't every return to userspace pass through
> exit_to_user_mode_prepare() ? We shouldn't ignore NEED_RESCHED or
> NOTIFY_RESUME, both of which can be set I think, even if the SYSCALL
> didn't actually do anything.


Aaaaahhhhhh!  There are too many of these functions. I=E2=80=99ll poke aroun=
d. I=E2=80=99ll also try to figure out why I didn=E2=80=99t catch this in te=
sting.=
