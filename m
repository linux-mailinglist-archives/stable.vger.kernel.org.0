Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B5627EEA6
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 18:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgI3QNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 12:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbgI3QNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 12:13:21 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0B8C0613D0
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:13:20 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so3633890ejo.9
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 09:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B68i/03gO6ZR0stPp/XuIiWcgy0nxB559p48BCd6ARw=;
        b=PX1/Et52kin9Rxfq1UxAKtvLAZw8XEYjLfAunQK4XuD4V0feOzB3QEYw7v7ThbU3Mt
         mAiv2K0rHxn933lpLwwCB0wtsyk/Vkj9iawLQ63G7s/YSV5r1kqfzoqoJBOpyjemnwbR
         jPkFIZ+aCNen9BaOql/Q6UkMrcE1yeclcDXqo4pRtnReCRRV2KjdXlMJ2qcMYBn88j4a
         hn54Pujx2xVaIZJ/7UDT4TJHflGOZyAVNefQWpY1GlZxlpT9OsE4bf8lH2/2XnHpOhIz
         +oIvhB3mmC5yUm2M66+DuI52zIT9WH0bnVRAKm3+NziWfY9j9ACgASesmoLq29qnztc+
         DZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B68i/03gO6ZR0stPp/XuIiWcgy0nxB559p48BCd6ARw=;
        b=Ge9cLhJ/CN6HOQRZNnHSc6MJHvhfd4IFGuEuiO1Kj/2f8S43T+COiEL9qQ4CvNcJu5
         dqYKGtCgtjp/Vylh+4DYrMu4DY2JVQrcUquQ+aXFJhgc4gitJa/b9rKEpLIR9ygxnH4W
         s9+ngE6EtXCO/gtA9C+w4O/Of2guuP3RAlp5rXwdpdWKhlOct1rLf32yi0vdDs5McBcC
         bgJ6AWa82uvKnYF5kAH6zLziYIJGwjpEhZOC93glRvfEv3zxieiJM148Rgm7kkXlxwLK
         t1+vz05eow1hAh2Dwv96xCP97TPzIOa9arIoaTStflp6l7ssFl5XkpyaYGKULwKVUS1r
         jbCg==
X-Gm-Message-State: AOAM531/JjzLz5/+9PWGo59YFQuPbTt4bkcLSgQGbVcZSYsjURHIZ/wD
        Vz+muUtKHo1QgZOyh4xRmda+IeVTGRatqeJvgLdPk0JI5vRP4w==
X-Google-Smtp-Source: ABdhPJxdHnKyHDYoMQeMMwxf000I8c4hJxQEZEzPq5LxM9cPBizoMqr58gmvU91MpkM9iwpTHzULwq9SHDscdiTmefI=
X-Received: by 2002:a17:906:8143:: with SMTP id z3mr3481181ejw.323.1601482399413;
 Wed, 30 Sep 2020 09:13:19 -0700 (PDT)
MIME-Version: 1.0
References: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
 <160087929294.3520.12013578778066801369.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200929102512.GB21110@zn.tnic>
In-Reply-To: <20200929102512.GB21110@zn.tnic>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 30 Sep 2020 09:13:07 -0700
Message-ID: <CAPcyv4jUYP3sWUUfL53Z6M7SpzXrrTTuzY8_EeN4O4bDVeL1EQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
To:     Borislav Petkov <bp@alien8.de>
Cc:     Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 3:25 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Sep 23, 2020 at 09:41:33AM -0700, Dan Williams wrote:
> > The rename replaces a single top-level memcpy_mcsafe() with either
> > copy_mc_to_user(), or copy_mc_to_kernel().
>
> What is "copy_mc" supposed to mean? Especially if it is called that on
> two arches...
>
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 7101ac64bb20..e876b3a087f9 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -75,7 +75,7 @@ config X86
> >       select ARCH_HAS_PTE_DEVMAP              if X86_64
> >       select ARCH_HAS_PTE_SPECIAL
> >       select ARCH_HAS_UACCESS_FLUSHCACHE      if X86_64
> > -     select ARCH_HAS_UACCESS_MCSAFE          if X86_64 && X86_MCE
> > +     select ARCH_HAS_COPY_MC                 if X86_64
>
> X86_MCE is dropped here. So if I have a build which has
>
> # CONFIG_X86_MCE is not set
>
> One of those quirks like:
>
>         /*
>          * CAPID0{7:6} indicate whether this is an advanced RAS SKU
>          * CAPID5{8:5} indicate that various NVDIMM usage modes are
>          * enabled, so memory machine check recovery is also enabled.
>          */
>         if ((capid0 & 0xc0) == 0xc0 || (capid5 & 0x1e0))
>                 enable_copy_mc_fragile();
>
> will still call enable_copy_mc_fragile() and none of those platforms
> need MCE functionality?
>
> But there's a hunk in here which sets it in the MCE code:
>
>         if (mca_cfg.recovery)
>                 enable_copy_mc_fragile();
>
> So which is it? They need it or they don't?
>
> The comment over copy_mc_to_kernel() says:
>
>  * Call into the 'fragile' version on systems that have trouble
>  * actually do machine check recovery
>
> If CONFIG_X86_MCE is not set, I'll say. :)

True, without CONFIG_X86_MCE there's no point in attempting the
fragile copy because the #MC will go unhandled. At the same time the
point of the new copy_mc_generic() is that it is suitable to use
without CONFIG_X86_MCE as it's just a typical fast string copy
instrumented for exception handling. So, I still think
CONFIG_ARCH_HAS_COPY_MC is independent of CONFIG_X86_MCE, but
enable_copy_mc_fragile() should be stubbed out by CONFIG_X86_MCE=n,
will re-spin.

>
> > +++ b/arch/x86/lib/copy_mc.c
> > @@ -0,0 +1,66 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
> > +
> > +#include <linux/jump_label.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/export.h>
> > +#include <linux/string.h>
> > +#include <linux/types.h>
> > +
> > +static DEFINE_STATIC_KEY_FALSE(copy_mc_fragile_key);
> > +
> > +void enable_copy_mc_fragile(void)
> > +{
> > +     static_branch_inc(&copy_mc_fragile_key);
> > +}
> > +
> > +/**
> > + * copy_mc_to_kernel - memory copy that that handles source exceptions
>
> One "that" is enough.

Yup.
