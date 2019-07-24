Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1507574078
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGXUz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:55:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38950 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbfGXUz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:55:59 -0400
Received: by mail-io1-f67.google.com with SMTP id f4so92579094ioh.6
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 13:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uKJBy2iaUBCua8Sau5lsnnlge7l0Cz16fffzcwsA5cs=;
        b=v1fdWobTFZAmP2WoM31GjI+NFuvU3O+BPgFxE3fw8z8pQsD9+1tkE0+CpxhE/J10A6
         28yp+dIM/1fRnlYIzs2C3XP/KGUhcXYDV8rgL445AjvxSYq7tMtGs4ZyUFpB6oup2aCt
         oJh4M2T9NjdDtCXHBigCMF1YJMngAGz/6Erv97zTxjzmopH91PASt66xjGxRlwCqzKqv
         O5hsPLtvwD71rKMyHdC4hixA83PUlj7VAp/nnziSpyJQYsVgY0KxLEdAcrPbDlkEKaCg
         DNC9TGigoDYwq0u4fhUgPSZOHprHAmwPBxU5a3+nvtYbBoqtM2+KdG9QeFgql9y2+Jcy
         2sIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uKJBy2iaUBCua8Sau5lsnnlge7l0Cz16fffzcwsA5cs=;
        b=sVcqM/AotK9pTpPyQFn3/5/eTCPwEIaP0UD8t+Vp3yOA7/FrSSrsW6wZC63VvvYWMk
         A8PijxhkGJJWZQH5avJU1rMY/y1URsXNg09kuhO0aeDzbUP8nRyiCqWI/5jTGmukZhPf
         D/RPcICA8sGntlbnJoPEE2Ccz6eqem/1LiI+Y0+mD7GeQHZkfw/z41D/GtrV0vuN7ogc
         PGzdOdPNe3MtlGTX9JC+FSX96YZu1+kZjJCbpYGScqSeRnK+CswbvEy6ipBQDpVHqGmc
         bFVm0/QWrNBnVAVX+I0g9Gcgc7tEpLOs2qLsXRYOLLT30YjfQELDM2oMUZkNophnUGCX
         RwnA==
X-Gm-Message-State: APjAAAV6YfXaSDjAb8XfpV/0I/Lz0Ur36lilyGdVqBGXEux/SaY13UUR
        3Lupbs1fERonJZgzbzQ4O8WUC+BNLrJt2E6o/I+N/A==
X-Google-Smtp-Source: APXvYqzve52LHf2o7jPgYP//tdTSzSHvLil6UKvRYwnN3fvVdWkAv5jWj/kufB/dVFJ4NBLhutNrhg0E1wEwNxqpbwM=
X-Received: by 2002:a6b:ec06:: with SMTP id c6mr79740045ioh.198.1564001758141;
 Wed, 24 Jul 2019 13:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190723212418.36379-1-ndesaulniers@google.com> <alpine.DEB.2.21.1907241231480.1972@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1907241231480.1972@nanos.tec.linutronix.de>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Wed, 24 Jul 2019 13:55:47 -0700
Message-ID: <CAMVonLgwzj2vjKtgXJG2=U04-w+29TZhgykeNYRbWTT55wtNMg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] x86/purgatory: do not use __builtin_memcpy and __builtin_memset
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        yamada.masahiro@socionext.com, stable@vger.kernel.org,
        Manoj Gupta <manojgupta@google.com>,
        Alistair Delva <adelva@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Enrico Weigelt <info@metux.net>,
        Allison Randal <allison@lohutok.net>,
        Uros Bizjak <ubizjak@gmail.com>,
        Chao Fan <fanc.fnst@cn.fujitsu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 3:33 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Tue, 23 Jul 2019, Nick Desaulniers wrote:
> > Instead, reuse an implementation from arch/x86/boot/compressed/string.c
> > if we define warn as a symbol. Also, Clang may lower memcmp's that
> > compare against 0 to bcmp's, so add a small definition, too. See also:
> > commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
> > Link: https://bugs.chromium.org/p/chromium/issues/detail?id=984056
> > Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> > Debugged-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> > Debugged-by: Manoj Gupta <manojgupta@google.com>
> > Suggested-by: Alistair Delva <adelva@google.com>
> > Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>
> That SOB chain is weird. Is Vaibhav the author?
>
No, Nick Desaulniers is the author of v3.

> > +/*
> > + * Clang may lower `memcmp == 0` to `bcmp == 0`.
> > + */
> > +int bcmp(const void *s1, const void *s2, size_t len) {
> > +     return memcmp(s1, s2, len);
> > +}
>
> foo()
> {
> }
>
> please.
>
> Thanks,
>
>         tglx
Thanks,
Vaibhav
