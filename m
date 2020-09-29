Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CBB27C256
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 12:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI2KZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 06:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2KZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 06:25:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76740C061755;
        Tue, 29 Sep 2020 03:25:24 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ead0084926be0aaf8b723.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:ad00:8492:6be0:aaf8:b723])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 753C21EC034B;
        Tue, 29 Sep 2020 12:25:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1601375121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vD3s6odY/cyE9Bx1q0oRZfhly7bcVfpKxNIBv+AD3wk=;
        b=ShLtAJ1+ONETkeLGQIFpUr5YpYO4Y8avI/Jwm/uh7pk67leh6pvbESMFqfa71vUJRYBzXL
        Utw8bgAfPDECvMhnh48UTxadK4tT9xzoHIe9xly+7QEHld/P6HTUArNTnmwb8000XJnLXZ
        noscDle3MKpVzFNcmkIiIUTBqk1oOjk=
Date:   Tue, 29 Sep 2020 12:25:12 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     mingo@redhat.com, x86@kernel.org, stable@vger.kernel.org,
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
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        jack@suse.cz
Subject: Re: [PATCH v9 1/2] x86, powerpc: Rename memcpy_mcsafe() to
 copy_mc_to_{user, kernel}()
Message-ID: <20200929102512.GB21110@zn.tnic>
References: <160087928642.3520.17063139768910633998.stgit@dwillia2-desk3.amr.corp.intel.com>
 <160087929294.3520.12013578778066801369.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <160087929294.3520.12013578778066801369.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 09:41:33AM -0700, Dan Williams wrote:
> The rename replaces a single top-level memcpy_mcsafe() with either
> copy_mc_to_user(), or copy_mc_to_kernel().

What is "copy_mc" supposed to mean? Especially if it is called that on
two arches...

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 7101ac64bb20..e876b3a087f9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -75,7 +75,7 @@ config X86
>  	select ARCH_HAS_PTE_DEVMAP		if X86_64
>  	select ARCH_HAS_PTE_SPECIAL
>  	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
> -	select ARCH_HAS_UACCESS_MCSAFE		if X86_64 && X86_MCE
> +	select ARCH_HAS_COPY_MC			if X86_64

X86_MCE is dropped here. So if I have a build which has

# CONFIG_X86_MCE is not set

One of those quirks like:

        /*
         * CAPID0{7:6} indicate whether this is an advanced RAS SKU
         * CAPID5{8:5} indicate that various NVDIMM usage modes are
         * enabled, so memory machine check recovery is also enabled.
         */
        if ((capid0 & 0xc0) == 0xc0 || (capid5 & 0x1e0))
                enable_copy_mc_fragile();

will still call enable_copy_mc_fragile() and none of those platforms
need MCE functionality?

But there's a hunk in here which sets it in the MCE code:

        if (mca_cfg.recovery)
                enable_copy_mc_fragile();

So which is it? They need it or they don't?

The comment over copy_mc_to_kernel() says:

 * Call into the 'fragile' version on systems that have trouble
 * actually do machine check recovery

If CONFIG_X86_MCE is not set, I'll say. :)

> +++ b/arch/x86/lib/copy_mc.c
> @@ -0,0 +1,66 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
> +
> +#include <linux/jump_label.h>
> +#include <linux/uaccess.h>
> +#include <linux/export.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +static DEFINE_STATIC_KEY_FALSE(copy_mc_fragile_key);
> +
> +void enable_copy_mc_fragile(void)
> +{
> +	static_branch_inc(&copy_mc_fragile_key);
> +}
> +
> +/**
> + * copy_mc_to_kernel - memory copy that that handles source exceptions

One "that" is enough.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
