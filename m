Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D7D598CDF
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 21:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243080AbiHRTst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 15:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244062AbiHRTsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 15:48:46 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15155C952
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 12:48:39 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-333a4a5d495so69105057b3.10
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 12:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=pN7pqer4VDQBcNszwXCuWriKzSK5JQuQKVaTrQYaltM=;
        b=eJZZyDCvZFocEY1mnX4gNhf3oRrBiDSGvqtESvQlFghziy9F09FK0NXWYew7+Kje/t
         EYiUjzXF8F1SfwY5eTJn/SlOMC0eAYlX6vXlI6BBe3iss3srKpP32vCLpr1Tm1oKMUMN
         zg87bqYehNGX06yEK48vPXzcnNUkWK0MFSTmjqiX9GT4kQYkEBsKVx36aCMAt82aWbJe
         I3tpfUL3jqS3znRjqVz6Nais3mhbhgsyExZDigC6az9B/idmpcCqQsrbFUurVcbQ03qr
         VBPmy9U+vgbenggQVkmWLrNUBZx6y+nko5YSj1QAgdiIO6xqEJT7OVRswPbW8u68PuP3
         71lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=pN7pqer4VDQBcNszwXCuWriKzSK5JQuQKVaTrQYaltM=;
        b=2G+BJg9DGnUoZoHLzmNkwazKStLlXXpPj2G3XsQxHl5bBvmNP6e8rvVIohM8yzlXaQ
         K2yBJFxlmsMum2vtRIpQUQN2wekITGr0jCg+TNB/cRTEzaPKheYAofM/8yrTCaP9uabt
         z+HlOY6l3GLXz11jPykuYE4YbqwmGLwURbcnzfa8jn1EstCUeRWB7rZR7zbDCEfiXq4u
         qjs8FxUorQHiPhCy+CvpnP7qBloun4W8mGIIJCb10+798TtiJD1DcYM75NUN+utUo8zI
         8dfO4CIVDqjJWZux6+agMskoG7UX86jvMhA9bOSD2QAOEVLz8r2yqxDaZRJx1XhPlDD2
         dKMA==
X-Gm-Message-State: ACgBeo1RApnLDcnxoSJXbpEr6WFS00Qx0/ghZ1S3D4/yeEOsKem9KjIr
        t94sNkUwCoXJ+bA2bnxsVfyvBYYcFc3jthSBAMcCog==
X-Google-Smtp-Source: AA6agR4vFLdh+IPAYOERtSDAXoJ0znqtPFPClNRqMqibtcNloaQO1xQtmwFz06X3LDoLAF00jqv2MeLkBbP6KHyle2c=
X-Received: by 2002:a25:bd3:0:b0:691:d47a:be78 with SMTP id
 202-20020a250bd3000000b00691d47abe78mr4145138ybl.574.1660852118761; Thu, 18
 Aug 2022 12:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220808141538.102394-1-khuey@kylehuey.com> <87ilmpzunz.ffs@tglx>
In-Reply-To: <87ilmpzunz.ffs@tglx>
From:   Kyle Huey <me@kylehuey.com>
Date:   Thu, 18 Aug 2022 12:48:23 -0700
Message-ID: <CAP045Ao7hb4kXajkWnMxqawBzFGUZJtSuRRn1kbmjOF=mcTcoA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] x86/fpu: Allow PKRU to be (once again) written by ptrace.
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 3:57 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Kyle!

Hi.

> On Mon, Aug 08 2022 at 07:15, Kyle Huey wrote:
> > When management of the PKRU register was moved away from XSTATE, emulation
> > of PKRU's existence in XSTATE was added for APIs that read XSTATE, but not
> > for APIs that write XSTATE. This can be seen by running gdb and executing
> > `p $pkru`, `set $pkru = 42`, and `p $pkru`. On affected kernels (5.14+) the
> > write to the PKRU register (which gdb performs through ptrace) is ignored.
> >
> > There are three relevant APIs: PTRACE_SETREGSET with NT_X86_XSTATE,
> > sigreturn, and KVM_SET_XSAVE. KVM_SET_XSAVE has its own special handling to
> > make PKRU writes take effect (in fpu_copy_uabi_to_guest_fpstate). Push that
> > down into copy_uabi_to_xstate and have PTRACE_SETREGSET with NT_X86_XSTATE
> > and sigreturn pass in pointers to the appropriate PKRU value.
> >
> > This also adds code to initialize the PKRU value to the hardware init value
> > (namely 0) if the PKRU bit is not set in the XSTATE header to match XRSTOR.
> > This is a change to the current KVM_SET_XSAVE behavior.
>
> You are stating a fact here, but provide 0 justification why this is
> correct.

Well, the justification is that this *is* the behavior we want for
ptrace/sigreturn, and it's very likely the existing KVM_SET_XSAVE
behavior in this edge case is an oversight rather than intentional,
and in the absence of confirmation that KVM wants the existing
behavior (the KVM mailing list and maintainer are CCd) one correct
code path is better than one correct code path and one buggy code
path.

> >
> > Changelog since v4:
>
> Can you please put the change log past the --- seperator line, so it
> gets stripped off when the patch is applied? That spares manual fixups.

Ok.

> >
> > Signed-off-by: Kyle Huey <me@kylehuey.com>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: kvm@vger.kernel.org # For edge case behavior of KVM_SET_XSAVE
> > Cc: stable@vger.kernel.org # 5.14+
> > Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
>
> Can you please use the documented tag ordering?
>
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#patch-submission-notes

Ok.

> > @@ -1235,6 +1235,24 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> >       for (i = 0; i < XFEATURE_MAX; i++) {
> >               mask = BIT_ULL(i);
> >
> > +             if (i == XFEATURE_PKRU) {
> > +                     /*
> > +                      * Retrieve PKRU if not in init state, otherwise
> > +                      * initialize it.
> > +                      */
> > +                     if (hdr.xfeatures & mask) {
> > +                             struct pkru_state xpkru = {0};
> > +
> > +                             if (copy_from_buffer(&xpkru, xstate_offsets[i],
> > +                                                  sizeof(xpkru), kbuf, ubuf))
> > +                                     return -EFAULT;
> > +
> > +                             *pkru = xpkru.pkru;
> > +                     } else {
> > +                             *pkru = 0;
> > +                     }
> > +             }
>
> That's really horrible and there is no point in copying the stuff from
> the buffer twice:
>
> @@ -1246,6 +1246,15 @@ static int copy_uabi_to_xstate(struct fp
>                 }
>         }
>
> +       /* Update the user protection key storage */
> +       *pkru = 0;
> +       if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> +               struct pkru_state *xpkru;
> +
> +               xpkru = get_xsave_addr(xsave, XFEATURE_PKRU);
> +               *pkru = xpkru->pkru;
> +       }
> +
>
> Hmm?

It took me a bit to figure out what this is actually trying to do. To
work, it would need to come at the very end of copy_uabi_to_xstate
after xsave->header.xfeatures is updated. If you just want to avoid
two copies I would counter-propose this though:

@@ -1235,7 +1235,19 @@ static int copy_uabi_to_xstate(struct fpstate
*fpstate, const void *kbuf,
        for (i = 0; i < XFEATURE_MAX; i++) {
                mask = BIT_ULL(i);

-               if (hdr.xfeatures & mask) {
+               if (i == XFEATURE_PKRU) {
+                       /* Update the user protection key storage */
+                       *pkru = 0;
+                       if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
+                               struct pkru_state xpkru = {0};
+
+                               if (copy_from_buffer(&xpkru, xstate_offsets[i],
+                                                    sizeof(xpkru), kbuf, ubuf))
+                                       return -EFAULT;
+
+                               *pkru = xpkru.pkru;
+                       }
+               } else if (hdr.xfeatures & mask) {
                        void *dst = __raw_xsave_addr(xsave, i);

                        offset = xstate_offsets[i];

Thoughts? This avoids a second copy and avoids having to calculate the
offset into the (now potentially compressed) XSTATE.

- Kyle

>
> Thanks,
>
>         tglx
