Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F1C12F247
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgACAkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:40:07 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41045 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 19:40:06 -0500
Received: by mail-pf1-f193.google.com with SMTP id w62so22789569pfw.8;
        Thu, 02 Jan 2020 16:40:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3XbpzRISsRnAWo64hPWxTD8VrNV6vVLizRH94il6B8k=;
        b=Iwerr1DZ1TVJmzzy7+Mcn37Ss9n7XF5c/1Yf7A+uGaM58TUM+79fqfWGlelMwd9X/U
         m3X1mexxrA+l4dHeoAu+a4nJc2VjgYafOjbyDU+bv6o0MM17fhCvKbv4mKrYuiE8cF/9
         EGYIxkpTZ6yzjLUTZzMqx7bPG/GxK73MAr2EOXW0MPBKVp+HPA29N56oc4gZOyamE6Aw
         MIKv0EGJGnUeuLjxRBdqBK5QAOPvNWhZLuT89hckJtlOo5PBnM6ILVzMIG623+e5MYa/
         jnVV0EZmwfkhAQSQ15jgwB1DLCzBb5r6gRmkAoSZqWIOrZF6J/RzI2MpfAe18v9yhPN3
         uAEg==
X-Gm-Message-State: APjAAAX5MMcq0yATiLMCSSDtB+DA1EYG18g9FmMJs1Uzk4+LKblbfyfa
        kjswGLsJQZaKlVm8l0P1c/figlFFf+kXSg==
X-Google-Smtp-Source: APXvYqxOJlFAIsECPVgAenHPkXPibhyFtyFPPpux79kjO3NLhnr/S5rUcdmPtNvFUj9QJjX2MmQ2aw==
X-Received: by 2002:a63:597:: with SMTP id 145mr89378717pgf.384.1578012005481;
        Thu, 02 Jan 2020 16:40:05 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810::55])
        by smtp.gmail.com with ESMTPSA id k1sm12225897pjl.21.2020.01.02.16.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 16:40:04 -0800 (PST)
Date:   Thu, 2 Jan 2020 16:42:29 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@canonical.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Avoid VDSO ABI breakage due to global register
 variable
Message-ID: <20200103004229.lpbhocebuny6vxmf@lantea.localdomain>
References: <20200102005343.GA495913@rani.riverdale.lan>
 <20200102045038.102772-1-paulburton@kernel.org>
 <754c5d05-4455-5ce1-475d-55c2191a06cf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <754c5d05-4455-5ce1-475d-55c2191a06cf@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vincenzo,

On Thu, Jan 02, 2020 at 04:56:00PM +0000, Vincenzo Frascino wrote:
> Hi Paul,
> 
> Happy new year.

Thanks; happy new year to you too!

> On 02/01/2020 04:50, Paul Burton wrote:
> > Declaring __current_thread_info as a global register variable has the
> > effect of preventing GCC from saving & restoring its value in cases
> > where the ABI would typically do so.
> > 
> > To quote GCC documentation:
> > 
> >> If the register is a call-saved register, call ABI is affected: the
> >> register will not be restored in function epilogue sequences after the
> >> variable has been assigned. Therefore, functions cannot safely return
> >> to callers that assume standard ABI.
> > 
> > When our position independent VDSO is built for the n32 or n64 ABIs all
> > functions it exposes should be preserving the value of $gp/$28 for their
> > caller, but in the presence of the __current_thread_info global register
> > variable GCC stops doing so & simply clobbers $gp/$28 when calculating
> > the address of the GOT.
> > 
> > In cases where the VDSO returns success this problem will typically be
> > masked by the caller in libc returning & restoring $gp/$28 itself, but
> > that is by no means guaranteed. In cases where the VDSO returns an error
> > libc will typically contain a fallback path which will now fail
> > (typically with a bad memory access) if it attempts anything which
> > relies upon the value of $gp/$28 - eg. accessing anything via the GOT.
> > 
> 
> First of all good catch. I just came back from holidays and seems that you guys
> had fun without me :)

The fun never stops ;)

> Did you consider the option to use "-ffixed-gp -ffixed-28" as a compilation
> flags for the vDSO library (Arvind was mentioning it as well in his reply)?
> According to the GCC manual "treats the register as a fixed register; generated
> code should never refer to it"
> (https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html#Code-Gen-Options)
> 
> I did some experiments this morning an seems that on MIPS the convention is not
> honored at least on GCC-9. Do you know who to contact to get it enabled/fixed in
> the compiler?
> 
> With this:
> 
> Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

Using -ffixed-gp wouldn't be correct for the VDSO - the VDSO itself is
position independent code, and will need to use $gp to access the GOT
which is part of how position-independence is achieved (technically you
could access the GOT using another register of course but you'd need
some way to persuade the compiler to break with convention & you'd gain
nothing meaningful since you'd need to use some other register anyway).
If we use -ffixed-gp then we're telling GCC not to use $gp, and that
doesn't make sense. If we consider -ffixed-gp as telling GCC not to use
$gp as a general purpose register then it's meaningless because $gp
already has a specific use & isn't used as a general purpose register.
If we consider -ffixed-gp as telling GCC not to use $gp at all then it
doesn't make sense because it needs to in order to access the GOT.

In terms of GCC's flags we'd want to use -fcall-saved-gp, but that would
just be telling GCC information it already knows about the n32 & n64
ABIs & indeed it seems to have no effect at all on the way GCC handles
the global register variable - it doesn't cause gcc to save & restore
$gp with the global register variable present, so you gain nothing.

We could use -ffixed-gp for the kernel proper (& not the VDSO), but:

1) The kernel builds as non-PIC code with no $gp-based optimizations
   enabled, and since this has been fine forever it seems safe to expect
   the compiler not to start using $gp in new ways.

2) It would be a separate issue to fixing the VDSO anyway.

So I'll go ahead with the v2 patch without changing compiler flags for
now.

Thanks,
    Paul

> > One fix for this would be to move the declaration of
> > __current_thread_info inside the current_thread_info() function,
> > demoting it from global register variable to local register variable &
> > avoiding inadvertently creating a non-standard calling ABI for the VDSO.
> > Unfortunately this causes issues for clang, which doesn't support local
> > register variables as pointed out by commit fe92da0f355e ("MIPS: Changed
> > current_thread_info() to an equivalent supported by both clang and GCC")
> > which introduced the global register variable before we had a VDSO to
> > worry about.
> > 
> > Instead, fix this by continuing to use the global register variable for
> > the kernel proper but declare __current_thread_info as a simple extern
> > variable when building the VDSO. It should never be referenced, and will
> > cause a link error if it is. This resolves the calling convention issue
> > for the VDSO without having any impact upon the build of the kernel
> > itself for either clang or gcc.
> > 
> > Signed-off-by: Paul Burton <paulburton@kernel.org>
> > Reported-by: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Christian Brauner <christian.brauner@canonical.com>
> > Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > Cc: <stable@vger.kernel.org> # v4.4+
> > ---
> > Changes in v2:
> > - Switch to the #ifdef __VDSO__ approach rather than using a local
> >   register variable which clang doesn't support.
> > ---
> >  arch/mips/include/asm/thread_info.h | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
> > index 4993db40482c..ee26f9a4575d 100644
> > --- a/arch/mips/include/asm/thread_info.h
> > +++ b/arch/mips/include/asm/thread_info.h
> > @@ -49,8 +49,26 @@ struct thread_info {
> >  	.addr_limit	= KERNEL_DS,		\
> >  }
> >  
> > -/* How to get the thread information struct from C.  */
> > +/*
> > + * A pointer to the struct thread_info for the currently executing thread is
> > + * held in register $28/$gp.
> > + *
> > + * We declare __current_thread_info as a global register variable rather than a
> > + * local register variable within current_thread_info() because clang doesn't
> > + * support explicit local register variables.
> > + *
> > + * When building the VDSO we take care not to declare the global register
> > + * variable because this causes GCC to not preserve the value of $28/$gp in
> > + * functions that change its value (which is common in the PIC VDSO when
> > + * accessing the GOT). Since the VDSO shouldn't be accessing
> > + * __current_thread_info anyway we declare it extern in order to cause a link
> > + * failure if it's referenced.
> > + */
> > +#ifdef __VDSO__
> > +extern struct thread_info *__current_thread_info;
> > +#else
> >  register struct thread_info *__current_thread_info __asm__("$28");
> > +#endif
> >  
> >  static inline struct thread_info *current_thread_info(void)
> >  {
> > 
> 
> -- 
> Regards,
> Vincenzo


