Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2AE2422B6
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 01:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgHKXEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 19:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHKXEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 19:04:53 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512B4C06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 16:04:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o5so38604pgb.2
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 16:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jIVnC/ThBVmdAOVNCKzkgYvpkZs/3SaWOETF+/bDBw=;
        b=rLTy+RROVIXKYHzRZBfjIkWOti+ozBxFxi1Y8dQbExBZaxXRu+MHpQylvMEgpB9YZk
         8/Dxr4NCf7tnPzgiQd1HgYSPD4gTj+Wsm4gWGJzWRwEYiaMZuUyekuXE/Tx6gX7ctGC2
         +bbLBDKDcwiruY43RjcxqxAj+jnjQJQtgCY6jLXyngqEQ1JphgIj+MRK/9U/GC1B4TIX
         WpxLutHmu+HJcryDgWQzTr4ScFIpWrv7SilLHJm/NGRBsm3+QgZeAzr0o0T9suc/Zuwh
         WQdc3YsohEnPfTVoVyGG7EsWSptfc1Vi+f9xbYbg2B1IGZFeoBkAMUtWIJaz0p/MwI+9
         JX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jIVnC/ThBVmdAOVNCKzkgYvpkZs/3SaWOETF+/bDBw=;
        b=U7h9uCFDN4uV91qReAWb3Xtp9yIiojIdOVwxJkMBlsPVNvrSg3dJxZatZAxA62DNh5
         UeHf+fppdavI4fMnttmzcxKQQTfrmJgOdjHD8PvnhpAWGe6V1ehbqHwEUj4bDe4m+36d
         lpEBy2W7H09RXo90ezwAo9d8BjAv74MSLuHuPT07XA3EaN7td3BOdZDUMY6R3oab0uwd
         2RIQ4rFJQI/6vQ0pp4tV8WxERUiiqBcM9deFvDph1EYW1Cum+9JYOMNC1F8k9ckbnk/R
         8qXgDDicN1nMqOKFwxw14aPeQpVfTpbhRJ7PB5ts3VJEfWW8AZ1MvZ17GCih+jg6jYPR
         9XRQ==
X-Gm-Message-State: AOAM531S87zlijnpcj0vQi7E3Muq+KQ9UHn4DYesJ4f9UVjVrvUNNPJs
        onk8Bx22R9XhcmGzvpWdd2q8666fUOrpmjkn5POksw==
X-Google-Smtp-Source: ABdhPJygigo4EqPc+yqir+aRi30bS1mpvV1cF5plaBFBJoaeqBve89TpMGWKhtsUTAscu1yjyEjJDFo7iN0qttT88XU=
X-Received: by 2002:a62:8081:: with SMTP id j123mr8666722pfd.80.1597187092283;
 Tue, 11 Aug 2020 16:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
 <20200811173655.1162093-1-nivedita@alum.mit.edu> <CAKwvOdnjLfQ0fWsrFYDJ2O+qFAfEFnTEEnW-aHrPha8G3_WTrg@mail.gmail.com>
 <20200811224436.GA1302731@rani.riverdale.lan>
In-Reply-To: <20200811224436.GA1302731@rani.riverdale.lan>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 11 Aug 2020 16:04:40 -0700
Message-ID: <CAKwvOdnvyVapAJBchivu8SxoQriKEu1bAimm8688EH=uq5YMqA@mail.gmail.com>
Subject: Re: [PATCH] x86/boot/compressed: Disable relocation relaxation for
 non-pie link
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 3:44 PM Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> On Tue, Aug 11, 2020 at 10:58:40AM -0700, Nick Desaulniers wrote:
> > > Cc: stable@vger.kernel.org # 4.19.x
> >
> > Thanks Arvind, good write up.  Just curious about this stable tag, how
> > come you picked 4.19?  I can see boot failures in our CI for x86+LLD
> > back to 4.9.  Can we amend that tag to use `# 4.9`? I'd be happy to
> > help submit backports should they fail to apply cleanly.
> > https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/builds/179237488
> >
>
> 4.19 renamed LDFLAGS to KBUILD_LDFLAGS. For 4.4, 4.9 and 4.14 the patch
> needs to be modified, KBUILD_LDFLAGS -> LDFLAGS, so I figured we should
> submit backports separately. For 4.19 onwards, it should apply without
> changes I think.

Cool, sounds good.  I'll keep an eye out for when stable goes to pick this up.

tglx, Ingo, BP, can we pretty please get this in tip/urgent for
inclusion into 5.9?
-- 
Thanks,
~Nick Desaulniers
