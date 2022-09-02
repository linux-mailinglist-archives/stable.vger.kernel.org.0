Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFF25AB4F8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 17:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiIBPXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 11:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiIBPWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 11:22:50 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A53105B40
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 07:56:06 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-344fc86d87cso4786357b3.3
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 07:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5puXSXyNPgfcUFe4Jn/d6QN/HZApr6oHFwTb8VmTKrQ=;
        b=EbhB96vaJrIXiSpbfhJQW1pMsRKRpMrQXkU2bUK86oMObNxFJCfUYPDW4HWXgsgD2C
         rN4uQJiT23YX9Gzh4baN9GBIt9Pza8RVfgvHzauMvhZGalpH1ognoJ/lCYZmVgnehjuh
         0fxJT3w01yO7/VqrDXfehzbN9sq3xU80EsKDqFIndwq4ai0JqfaY/yHxDHcMZc2BukqH
         VaqEERfgEa4oHAWOuZIaWZaOF57M3iZ9Z43JtzdII5yR3wWka11BGSUzHvmrZAD3aa/e
         c0n/bP/mE1LLkD9DAY6X99BaJFWgJJ5CBhOWKvZ1aqm1kWptB1k7VYZ/rNNm9tC6DtWF
         oFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5puXSXyNPgfcUFe4Jn/d6QN/HZApr6oHFwTb8VmTKrQ=;
        b=spP/7Gv6wGg6LAxr63snFOTeJGmIo5pzjY4XC2gJ47Dlw6NE3TFaip3KPOvC+Nkxxo
         Nrjzw2q/US7bV7Lk+NbLagBHcj9XEa8dIBTu/UOidOsfcsPbihAFu5wQCtf9TvJDPv4b
         k2XcN49bUiWfpW1ZrLxFCUfTNjRGyNulRQ8jgIY6/JH4HNx4N4BME+UeGQwWjsaQu7rH
         dvNiuliaQD+Txg65zhAOLoRJw+YYXrZ4NwwfWvuSeJTKa0LfvAWRAPExUmwwkZFg1W3h
         dZSgOuyiZU6FptL4sUIuvgKKtyEbuZ2X1mQipWQ00SZYwhEBdEV+6UDLObAiHXlDwiOI
         9o5Q==
X-Gm-Message-State: ACgBeo133P1qfioYh4TZsDk8YlIUqPwyrc/rbTc/ln1Cs0TnCT5/43qx
        VuFOgGmle2rtcxPOCZ2bZEFzf2qTZJIVMhb6Gpi8Zg==
X-Google-Smtp-Source: AA6agR7fOH5Hb21ZbPQEF1JrLyxAT8BpwnpyXkscqlvOhS0EBSwiDPA0q3CexQ4xX2zSzVdgSUAh6Z8aFDQPx2zG5Go=
X-Received: by 2002:a81:1492:0:b0:33d:a446:808f with SMTP id
 140-20020a811492000000b0033da446808fmr29480466ywu.159.1662130565590; Fri, 02
 Sep 2022 07:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220829194905.81713-1-khuey@kylehuey.com> <YxDP6jie4cwzZIHp@google.com>
In-Reply-To: <YxDP6jie4cwzZIHp@google.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Fri, 2 Sep 2022 07:55:51 -0700
Message-ID: <CAP045Aqc7T8in-MQz0hj4dOZ7TU6oAKuBNFtH57KttZ8Ueng-g@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again) written by ptrace.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
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

On Thu, Sep 1, 2022 at 8:29 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Aug 29, 2022, Kyle Huey wrote:
> > @@ -1246,6 +1246,21 @@ static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
> >               }
> >       }
> >
> > +     /*
> > +      * Update the user protection key storage. Allow KVM to
> > +      * pass in a NULL pkru pointer if the mask bit is unset
> > +      * for its legacy ABI behavior.
> > +      */
> > +     if (pkru)
> > +             *pkru = 0;
> > +
> > +     if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> > +             struct pkru_state *xpkru;
> > +
> > +             xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
> > +             *pkru = xpkru->pkru;
> > +     }
>
> What about writing this as:
>
>         if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
>                 ...
>
>                 *pkru = xpkru->pkru;
>         } else if (pkru) {
>                 *pkru = 0;
>         }
>
> to make it slightly more obvious that @pkru must be non-NULL if the feature flag
> is enabled?

tglx didn't seem to like the branchiness before but maybe he'll change
his mind since we have to have the `if (pkru)` now anyways.

> Or we could be paranoid, though I'm not sure this is worthwhile.
>
>         if ((hdr.xfeatures & XFEATURE_MASK_PKRU) &&
>             !WARN_ON_ONCE(!pkru)) {
>                 ...
>
>                 *pkru = xpkru->pkru;
>         } else if (pkru) {
>                 *pkru = 0;
>         }

I don't feel strongly about this.

> Otherwise, looks good from a KVM perspective.  Thanks!

Great.

- Kyle
