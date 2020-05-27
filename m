Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2229B1E4C44
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403894AbgE0RpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 13:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403784AbgE0RpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 13:45:17 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2C1C08C5C2
        for <stable@vger.kernel.org>; Wed, 27 May 2020 10:45:17 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id d7so29100602eja.7
        for <stable@vger.kernel.org>; Wed, 27 May 2020 10:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8mFtPr70+M6apdHwECQwtE0zBIswHryRWPxkV/RNuy4=;
        b=dvDvQkJQFI8yWa2awybOsZrnFGgmcqFM7ZW4rJz0zjtlx9s5xgduk+OM2lc7nFfjCo
         c6Vz/iUvE0DfRgVV8SbSVoTXQXQ0YkZok9A0AcjzfZBwT7RKbjwXU4ELIKGZQStewJmz
         kknihChozQhZ/pQ1tJ0hEKMYQq7b7X7ggStktoC+sFL9O5rM300uiKvwtj8+HhR2zmvF
         Jt8Sa02KiuYawH9lV3OB5Lv0XI4o4N8/YWfD1IIinggWKQj3PAk/vq+0MWxl8fLsc4Hy
         KkfBO7OGsIxqdFboM3JUWjhvWxCNRHxD/Pm6nPrxZ79lem0gPlqNHUEYAtaF7FUfRBhN
         54Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8mFtPr70+M6apdHwECQwtE0zBIswHryRWPxkV/RNuy4=;
        b=ePxs2viJMHrYsZfSrKEYVdyeTzb4HdPNwoBO1uwsQ//ptz9PaAmIE0xkGgvAPk+u9Q
         W18+d+GId/UZGKazZk0kQxvfvBtk+2EcptDKxQ166bXQtEqEGbuUCb7QqGAAhia+C9Md
         /fqNQT2TRAYNpY+4Cg5msLfkZ2wYmOrTtHnVSYgJD76axUJjsoTqls+N+g88hIJVCjnu
         9OCRGOX7rSMcSR3wrHlHvlS+khXVorQkSiZQusFv/pKxP0pJMQCCOUgQlUFbZYNrisfV
         EFCvBxzPbMO3zV60HUN6Ykm5RaYgm70wyjqS2X3uKHHGy6WpHf3o/Mn//FDgGIdOKH/T
         BQZA==
X-Gm-Message-State: AOAM5302SKZyXyofCN7YZgU8z3eimBCB/70xuiXU9ROkCLEdOkQbK1/o
        Nx2h3otXy77XJ8396s8akOHXpUwqKbB2tcp9BXrlvA==
X-Google-Smtp-Source: ABdhPJyTjA/zTkYCTIHeH9PsmBKXEZoxnZzzLtoLEydIvlAGMECI+VKgrxr/M1xDJHkM9rV+v4IRpxyHFaY0PLCjndg=
X-Received: by 2002:a17:906:3597:: with SMTP id o23mr7022104ejb.174.1590601516095;
 Wed, 27 May 2020 10:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <159010126119.975921.6614194205409771984.stgit@dwillia2-desk3.amr.corp.intel.com>
 <159010126739.975921.6393757191247357952.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87mu5yg8n6.fsf@mpe.ellerman.id.au>
In-Reply-To: <87mu5yg8n6.fsf@mpe.ellerman.id.au>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 27 May 2020 10:45:05 -0700
Message-ID: <CAPcyv4h6moXY0fB=cyGuXOpT=+rFWupCy0kh87OT0X_1ZB2ROg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 23, 2020 at 5:04 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Hi Dan,
>
> Sorry one minor nit below.
>
> Dan Williams <dan.j.williams@intel.com> writes:
> > diff --git a/tools/testing/selftests/powerpc/copyloops/.gitignore b/tools/testing/selftests/powerpc/copyloops/.gitignore
> > index ddaf140b8255..1152bcc819fe 100644
> > --- a/tools/testing/selftests/powerpc/copyloops/.gitignore
> > +++ b/tools/testing/selftests/powerpc/copyloops/.gitignore
> > @@ -12,4 +12,4 @@ memcpy_p7_t1
> >  copyuser_64_exc_t0
> >  copyuser_64_exc_t1
> >  copyuser_64_exc_t2
> > -memcpy_mcsafe_64
> > +copy_mc_to_user
>
> Should be:
>
> +copy_mc_64
>
> Otherwise the powerpc bits look good to me.
>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

Will update, thanks!
