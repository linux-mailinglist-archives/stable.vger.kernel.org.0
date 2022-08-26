Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421325A2003
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 06:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244748AbiHZEsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 00:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiHZEsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 00:48:02 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4CBCE320
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 21:48:01 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3378303138bso8710777b3.9
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 21:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=baSv0Pn8NKV4CT1RoqMfXK68o2fQcY24x27HhvXMUKI=;
        b=b8WDemlJLBj3xJVS55uRQRlMy8umsRJbhI12sqSfOUsT5xTdCa1HUm4mqB0iqbIr0E
         zv/DDPBDFLkikkKkFsmxRWayUv0WIvQLVCd/yFWkHr01Sg9cnnspTdtZFbGN5fl4QAw3
         wqOtb+LMi6DoOCmdVAB0ZQv4QMZMuimTMJDgdRi8r4d56suCWXh/Pc0c3d3Jnyg5fqGF
         3XBfP608utZYOXm5DYkTwVqfL30d0HxuPjvxynt/WqjWbLXImnAIDS8klUgQGRAXe5Ci
         /kyFUvjCA03Snep08L14NN4YkqpeoVCxlqyGm226cbAb8vn6LifW5PdEXlTjlMIuiQ5j
         7H3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=baSv0Pn8NKV4CT1RoqMfXK68o2fQcY24x27HhvXMUKI=;
        b=VpDTTs4y2CpQ4Gkttwtirmy0PLFzKdNBu+HSLpkGa4lc+N256g/4W2g/vP0kM6MaHp
         lX9/Tr/5Bn/crYd1A9nhW739mjrFF5un8GAz+BGkvAdRxv/xiUxO4O+w7ZeT+0CBPjUD
         qpTeHCDd8fX4tQJ149/1cLVVXLF1Gn8aWCha5CHX3SmVPDO6hUs2IZE2ebdDpCm8ANMg
         m4/PqqDtC2P1pm8Y5dGRxRSKe7UvmqquR2b2WbkzmMnFIqaUZTvdkY6V5kNdE6r4O9kk
         DydBNPWCYKDz+vGLPy8OONnktX89N3enD4TmFDZdwq1AktbsRWxKN9GHWcti+bm660wA
         sU5A==
X-Gm-Message-State: ACgBeo0TxPzsxJz+0AY7p8jbO5O6vKaD8BtPHMwCyS76eSa0FYK4IQ1T
        C8JK465saLvsFfQrTpBsRt8zu9Zx7tXotp9oxlrsFg==
X-Google-Smtp-Source: AA6agR4McKR6po1Apga0nlBk1nr9dK1oPOWcrPMDqNvo03xzIJbG6rtBn+uTwlQxr2Ttr8yi9z0nmrOHrVlnhcLXWZc=
X-Received: by 2002:a0d:d0c1:0:b0:33d:77db:eadf with SMTP id
 s184-20020a0dd0c1000000b0033d77dbeadfmr6920136ywd.26.1661489280272; Thu, 25
 Aug 2022 21:48:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220808141538.102394-1-khuey@kylehuey.com> <87ilmpzunz.ffs@tglx>
 <CAP045Ao7hb4kXajkWnMxqawBzFGUZJtSuRRn1kbmjOF=mcTcoA@mail.gmail.com> <Yv6szXuKGv75wWmm@google.com>
In-Reply-To: <Yv6szXuKGv75wWmm@google.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Thu, 25 Aug 2022 21:47:49 -0700
Message-ID: <CAP045Aqspm6rRnM9ks_w6SS5CZ6R5TPqLras8aNjfG_2TUmWgg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] x86/fpu: Allow PKRU to be (once again) written by ptrace.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 2:19 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 18, 2022, Kyle Huey wrote:
> > On Thu, Aug 18, 2022 at 3:57 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Mon, Aug 08 2022 at 07:15, Kyle Huey wrote:
> > > > When management of the PKRU register was moved away from XSTATE, emulation
> > > > of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> > > > for APIs that write XSTATE. This can be seen by running gdb and executing
> > > > `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> > > > write to the PKRU register (which gdb performs through ptrace) is ignored.
> > > >
> > > > There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
> > > > sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
> > > > make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
> > > > down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
> > > > and sigreturn pass in pointers to the appropriate PKRU value.
> > > >
> > > > This also adds code to initialize the PKRU value to the hardware init value
> > > > (namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
> > > > This is a change to the current KVM_SET_XSAVE behavior.
> > >
> > > You are stating a fact here, but provide 0 justification why this is
> > > correct.
> >
> > Well, the justification is that this *is* the behavior we want for
> > ptrace/sigreturn, and it's very likely the existing KVM_SET_XSAVE
> > behavior in this edge case is an oversight rather than intentional,
> > and in the absence of confirmation that KVM wants the existing
> > behavior (the KVM mailing list and maintainer are CCd) one correct
> > code path is better than one correct code path and one buggy code
> > path.
>
> Sorry, I missed the KVM-relevant flags.
>
> Hrm, the current behavior has been KVM ABI for a very long time.
>
> It's definitely odd because all other components will be initialized due to their
> bits being cleared in the header during kvm_load_guest_fpu(), and it probably
> wouldn't cause problems in practice as most VMMs likely do "all or nothing" loads.
> But, in theory, userspace could save/restore a subset of guest XSTATE and rely on
> the kernel not overwriting guest PKRU when its bit is cleared in the header.

This seems extremely conservative, but ok. As you note, PKRU is the
only XSTATE component you could theoretically do this subset
save/restore with in the KVM ABI since all the others really do have
their hardware behavior.

> All that said, I don't see any reason to force KVM to change at this time, it's
> trivial enough to handle KVM's oddities while providing sane behavior for others.
> Nullify the pointer in the guest path and then update copy_uabi_to_xstate() to
> play nice with a NULL pointer, e.g.
>
>         /*
>          * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
>          * in the header.  KVM's odd ABI is to leave PKRU untouched in this
>          * case (all other components are eventually re-initialized).
>          */
>         if (!(kstate->regs.xsave.header.xfeatures & XFEATURE_MASK_PKRU))
>                 vpkru = NULL;

You meant ustate->... here (since this is before the copy now), but
yes, ok, I will do that.

>         return copy_uabi_from_kernel_to_xstate(kstate, ustate, vpkru);

- Kyle
