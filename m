Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125A558918A
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 19:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbiHCRgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 13:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiHCRfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 13:35:55 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E233858B7B
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 10:35:48 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3246910dac3so126640067b3.12
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 10:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Vw/moZJ/DE4Y4fjRyATUTV6Tvv5V7feioLAQ0kH+vK4=;
        b=WfEzhn1NroNkWXhUm+yWWRbDkalIFdJCAvVk5wBrtjTpwz9vuISAprUXn9rYDLEzlR
         f/fV46oP+mDo8wlsFZBt32UgEbr+Zr7HkL+dxOCgHEYTcmX2osg+EX4zV6WLx48lRCs7
         qQDvoFMGb2aKrq8BwPpsEQrBObnznG4/QBi3tHhBSphFi2NUommqu+T+MlWGHf7Rvzqw
         F70NprAGhQXtrPA9ziQC29Xs7YTqitIDhoR+1a/qldk4MOdHINDAlrF5qGJ+lxYdfRZN
         ZgzTTrufMTMGV2UXN7TlWqhjOzeMTRGKgPdOXJy13cqFwGJYoG/Ifg6nYTOJ/VKgNlWf
         syZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Vw/moZJ/DE4Y4fjRyATUTV6Tvv5V7feioLAQ0kH+vK4=;
        b=kcngIBPwnyiG+i4sxIjnoXcm0oOwei58UuE8jMwu11Ti7ceqomjRNy2k9fqu+6oKYL
         uk99H1TlVOhpvkoaxtkAWHQ+O+rBPef1pYus4sNkABKMMeThVkvZodLgdd72y9AHB/FL
         VurVT6+hPW/XZ046o3DBcojSCFBJk7r8uy9nUvMUHjhzF4bVU7oSt0DPB0Ia6w4UQiDp
         A2avoDWraPeBkBTmDVDHPLDA9/P/eHJmdRZjHvHgkuhedc52wPasxheIRcVPnYZHrsP5
         rokpO8tgKiy7dodjNq+poNxRmLrG5OFTgXlJIjKzorInMGH2/meW5h+WqMTGBdv/etpj
         thug==
X-Gm-Message-State: ACgBeo0/C2urQ5SCmj4vzXGY5BxwbFzw7nHudf+CmQMwRV1fDNksFX5v
        pw9jlFKGYZcS5P8CHxWle0cygClHIjsVaxCiMgPUgg==
X-Google-Smtp-Source: AA6agR7tfN2OQQF7AAQoTVTGEtkhnBr59+zuxMq/OnXw5taSmIWsWXbRTTTP6xQNb5FZtQjLcIB24ATaX88VfGYw2Wo=
X-Received: by 2002:a81:9b47:0:b0:325:2240:ce5 with SMTP id
 s68-20020a819b47000000b0032522400ce5mr12252070ywg.210.1659548147968; Wed, 03
 Aug 2022 10:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220731050342.56513-1-khuey@kylehuey.com> <Yuo59tV071/i6yhf@gmail.com>
 <CAP045ArF0SX84tDr=iZoK=EnXK2LsXYut3-KMkCxQO2OOhn=0A@mail.gmail.com> <Yuqvkufu7Hu4drL6@gmail.com>
In-Reply-To: <Yuqvkufu7Hu4drL6@gmail.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Wed, 3 Aug 2022 10:35:36 -0700
Message-ID: <CAP045AoBZvcacHM=rEKC+Lc8XeQQVzCvnNvsU-o=-ZHi=pE=mA@mail.gmail.com>
Subject: Re: [PATCH] x86/fpu: Allow PKRU to be (once again) written by ptrace.
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        kvm@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 3, 2022 at 10:25 AM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Kyle Huey <me@kylehuey.com> wrote:
>
> > > Also, what's the security model for this register, do we trust all
> > > input values user-space provides for the PKRU field in the XSTATE? I
> > > realize that WRPKRU already gives user-space write access to the
> > > register - but does the CPU write it all into the XSTATE, with no
> > > restrictions on content whatsoever?
> >
> > There is no security model for this register. The CPU does write whatever
> > is given to WRPKRU (or XRSTOR) into the PKRU register. The pkeys(7) man
> > page notes:
> >
> > Protection keys have the potential to add a layer of security and
> > reliability to applications. But they have not been primarily designed as
> > a security feature. For instance, WRPKRU is a completely unprivileged
> > instruction, so pkeys are useless in any case that an attacker controls
> > the PKRU register or can execute arbitrary instructions.
>
> Ok - allowing ptrace to set the full 32 bits of the PKRU register seems OK
> then, and is 100% equivalent to using WRPKRU, right? So there's no implicit
> masking/clearing of bits depending on how many keys are available, or other
> details where WRPKRU might differ from a pure 32-bit per thread write,
> correct?

Right. The hardware doesn't have any concept of what keys are
available or not, that exists entirely in the kernel.

- Kyle

> Thanks,
>
>         Ingo
