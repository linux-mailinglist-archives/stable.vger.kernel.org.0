Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DB41C0501
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 20:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgD3Smf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 14:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgD3Smf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 14:42:35 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F98A24957
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 18:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588272154;
        bh=R81KA1exG6QyWEvvM1/QecUU8WMGFHG/k/cxKcdkfnc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SKIj3ofhpyqALEnbxq/Qwt9I+q8xqgFA+l6wnFR3a2eTeE5nVt5QfYHFAwjC/y+Ja
         s8uytIm5fXDttDTtpNCgxSD0+3yT34ulwtIpiC/VwDctbm4BV5uOySFOyHPHNganWE
         ftAE+TPkYBb4X9BD4lyjCgOpqW23VPFKogllHC+c=
Received: by mail-wr1-f42.google.com with SMTP id o27so3008652wra.12
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 11:42:34 -0700 (PDT)
X-Gm-Message-State: AGi0PuZGv0fT/EVGcXeQXCUUUq2vJO+bE8ZTBcqIC/Pgu79lYJPXe07H
        pxIPSomdwexBBsfX2k7+BbgF16JfIQE0W/kyxETU/Q==
X-Google-Smtp-Source: APiQypJgn2E33Ju/7FojR2A+zMnprCF7LbVkAmb0PlfhPmDEYEV5k/ga1+sfxFBZugZk5p4MRnQtkD5+A+c7WwtOQ+E=
X-Received: by 2002:a5d:42c8:: with SMTP id t8mr3902056wrr.70.1588272152368;
 Thu, 30 Apr 2020 11:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
 <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com> <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
In-Reply-To: <CAHk-=widQfxhWMUN3bGxM_zg3az0fRKYvFoP8bEhqsCtaEDVAA@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 30 Apr 2020 11:42:20 -0700
X-Gmail-Original-Message-ID: <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
Message-ID: <CALCETrVq11YVqGZH7J6A=tkHB1AZUWXnKwAfPUQ-m9qXjWfZtg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 10:17 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Apr 30, 2020 at 9:52 AM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > If I'm going to copy from memory that might be bad but is at least a
> > valid pointer, I want a function to do this.  If I'm going to copy
> > from memory that might be entirely bogus, that's a different
> > operation.  In other words, if I'm writing e.g. filesystem that is
> > touching get_user_pages()'d persistent memory, I don't want to panic
> > if the memory fails, but I do want at least a very loud warning if I
> > follow a wild pointer.
> >
> > So I think that probe_kernel_copy() is not a valid replacement for
> > memcpy_mcsafe().
>
> Fair enough.
>
> That said, the part I do like about probe_kernel_read/write() is that
> it does indicate which part we think is possibly the one that needs
> more care.
>
> Sure, it _might_ be both sides, but honestly, that's likely the much
> less common case. Kind of like "copy_{to,from}_user()" vs
> "copy_in_user()".
>
> Yes, the "copy_in_user()" case exists, but it's the odd and unusual case.

I suppose there could be a consistent naming like this:

copy_from_user()
copy_to_user()

copy_from_unchecked_kernel_address() [what probe_kernel_read() is]
copy_to_unchecked_kernel_address() [what probe_kernel_write() is]

copy_from_fallible() [from a kernel address that can fail to a kernel
address that can't fail]
copy_to_fallible() [the opposite, but hopefully identical to memcpy() on x86]

copy_from_fallible_to_user()
copy_from_user_to_fallible()

These names are fairly verbose and could probably be improved.
