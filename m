Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DD0598F7D
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 23:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347125AbiHRV1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 17:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347047AbiHRV1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 17:27:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092CEEA89A
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 14:19:14 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f21so2864484pjt.2
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 14:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tTJTjqw4MggpWtxGKCzfbFeqFxFbwJEwUmHLuAFNlC4=;
        b=KLY0b+bh0hfzUpqKcJhe/wX0zYM3DwWqLn+1EFPX/z/mvu9FX8S6481IG9EwIwKlr0
         sksbXHJQ4Kh7CSdeJ54/AGd442l6xfwUSwbgjuIY7cPkTmb/P8QcpBZsFw1/AEgW7BxO
         Z7vFc1cM6wHyTLrXmXs4BpPTKJqKJm4CDzUsmuDRJO5YqQ2oTdhgmDQfcISIZdvLXi+a
         iIdIuaNiTdK6EZBOyO8Sqr7BsD7W8hLLdMZHw8f/Q35ywyTfALa1cNGq5gHNhppDaPfZ
         O+kBBnOCDICeLF6quWO+kUt7vyDNo8jD0dQqib2ZIPNPKJ57Uq0YHy8r7Fi2W5SNMe/A
         HD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tTJTjqw4MggpWtxGKCzfbFeqFxFbwJEwUmHLuAFNlC4=;
        b=GrxyoowCYXgsWN0tloNfyqbi643aafL0X8shsyEZtr2OAX3Y4xM8HgnupiLNwxGIai
         8fzyo5tSB8bWfrEzUox2b7P7Rx4nBKLM14WgNcpphj1JsSMlo1jfx1BEGyqWHdvp4p81
         3J5FkRM/zXZNvHEV8w3jCX9RRMVoN9furvVY49fvwQh9rAFs8eEQu5WX2rKzIyjGIMiN
         jI8SXk9D9r8c5I3HyEtsz5DUypSJ20GmCwOBxuhdRIJkTa8kfK1NnPkZXhfCPQtngZSa
         G1H0f2XUQ1tLcQPmj3X9DlwQV0OpgZ1mfHgT6PUrDJQUhnfguc7Fqi80uA2KZ56inlxN
         YZMA==
X-Gm-Message-State: ACgBeo0si6A7XIrAVNsRlRAnCRXkq5M4laLkd7gCtD2kwpicDM2VVApt
        vqRHrK1lw+ypmF87JPiDl7adqQ==
X-Google-Smtp-Source: AA6agR6y0AhMETJyQ+vXl0SNQkEBxWGMTcxU9uSEZQLV6JUuiIN57zfeFgll2QLSPF2S39iiIToTNg==
X-Received: by 2002:a17:90b:4c4b:b0:1f4:d176:aa5a with SMTP id np11-20020a17090b4c4b00b001f4d176aa5amr4899401pjb.233.1660857553755;
        Thu, 18 Aug 2022 14:19:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902f54800b0016ee328fd61sm1819751plf.198.2022.08.18.14.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 14:19:13 -0700 (PDT)
Date:   Thu, 18 Aug 2022 21:19:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kyle Huey <me@kylehuey.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] x86/fpu: Allow PKRU to be (once again) written by
 ptrace.
Message-ID: <Yv6szXuKGv75wWmm@google.com>
References: <20220808141538.102394-1-khuey@kylehuey.com>
 <87ilmpzunz.ffs@tglx>
 <CAP045Ao7hb4kXajkWnMxqawBzFGUZJtSuRRn1kbmjOF=mcTcoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP045Ao7hb4kXajkWnMxqawBzFGUZJtSuRRn1kbmjOF=mcTcoA@mail.gmail.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022, Kyle Huey wrote:
> On Thu, Aug 18, 2022 at 3:57 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, Aug 08 2022 at 07:15, Kyle Huey wrote:
> > > When management of the PKRU register was moved away from XSTATE, emulation
> > > of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> > > for APIs that write XSTATE. This can be seen by running gdb and executing
> > > `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> > > write to the PKRU register (which gdb performs through ptrace) is ignored.
> > >
> > > There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
> > > sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
> > > make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
> > > down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
> > > and sigreturn pass in pointers to the appropriate PKRU value.
> > >
> > > This also adds code to initialize the PKRU value to the hardware init value
> > > (namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
> > > This is a change to the current KVM_SET_XSAVE behavior.
> >
> > You are stating a fact here, but provide 0 justification why this is
> > correct.
> 
> Well, the justification is that this *is* the behavior we want for
> ptrace/sigreturn, and it's very likely the existing KVM_SET_XSAVE
> behavior in this edge case is an oversight rather than intentional,
> and in the absence of confirmation that KVM wants the existing
> behavior (the KVM mailing list and maintainer are CCd) one correct
> code path is better than one correct code path and one buggy code
> path.

Sorry, I missed the KVM-relevant flags.

Hrm, the current behavior has been KVM ABI for a very long time.

It's definitely odd because all other components will be initialized due to their
bits being cleared in the header during kvm_load_guest_fpu(), and it probably
wouldn't cause problems in practice as most VMMs likely do "all or nothing" loads.
But, in theory, userspace could save/restore a subset of guest XSTATE and rely on
the kernel not overwriting guest PKRU when its bit is cleared in the header.

All that said, I don't see any reason to force KVM to change at this time, it's
trivial enough to handle KVM's oddities while providing sane behavior for others.
Nullify the pointer in the guest path and then update copy_uabi_to_xstate() to
play nice with a NULL pointer, e.g. 

	/*
	 * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
	 * in the header.  KVM's odd ABI is to leave PKRU untouched in this
	 * case (all other components are eventually re-initialized).
	 */
	if (!(kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU))
		vpkru = NULL;

	return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);
