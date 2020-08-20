Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A8E24ABE3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgHTAOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgHTAOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 20:14:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D535AC061757
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 17:13:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so213321plr.0
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 17:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSEYrX5ACCj62ngKp36MmVum7AWiPuR/R+X34o+7xuE=;
        b=GZgsINVjA/iPVwpqT/wdawM2LvRnSYS0j70GlPgoxgV9M4sanwWBFOsmDMGbuAVIRa
         fInE81nFqMhoKq8aeK2wXF23ckv+8mvNAsIAMNsaEXyznMXVLd+MFeyWTryUYHfbHhoL
         kS9sYMtCAKiqoxBbxYxGEpzZdonBKqbwUdIwbuasbQS/1Reg518ZvopiGNEAOnVxezPZ
         0fc1L1znuoVPGemAh7QXesW7icu7VBfCaj9yWLu28K5Ix0mIvzQPh6O3AT9pCabC9Qlt
         bd32bNMb1gX+jDIWkWEa7SXABnbuMe2PsEgAvpvtqbTRKy6kOBIF4TCyzYtrGbZrqAki
         rq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSEYrX5ACCj62ngKp36MmVum7AWiPuR/R+X34o+7xuE=;
        b=Ngj2y5k+LJXzr51L5R0c6oJXBsGOutiPZnZ1A3t255kf8AvelLdpLkUCnXLJ9HZ0RG
         9uo8YDj5xEAZQ00NJLoSViRYP8PH46I4pVhd09MljOLgixb7eF1RBvX5IBnjkmILCL+V
         U5CKlVFYUy7t+zrtMVtxieURfpXLBGWELdWlIK3X2+H/N5DNS+aDC22xcGWASYTeB8n6
         gPwhvrH8ugZIN+CVVA3ast140X6m83PiMBEPVFPQhXY0FNNkG+2aR4+USjysefKdtCfI
         AtwA51dIqAS/eaIgNGPMm/hbKEeBf2hVSWjZ5tiH+gB7PfciYANJRZeL/t4XxkK3h7c8
         +1Uw==
X-Gm-Message-State: AOAM530j7L8n8lmDjQNA4btPZMbenf4UwzUUe5J/qxDGSNbLWh012nbe
        +KAcA/sOkriWs21pGMUh51lbAQ57sg0HgjprMKaRbA==
X-Google-Smtp-Source: ABdhPJzl6F5E2iWMKn+8J0GL89vR8SvenD67R1x0TWLjRLW3Uw/3w3cewKL6RgzutABpZ4MtNfBH5ztYpmF9l9LEG8A=
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr340778pjp.32.1597882439098;
 Wed, 19 Aug 2020 17:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205112.2099429-1-ndesaulniers@google.com>
 <20200730205112.2099429-3-ndesaulniers@google.com> <CAN=-Rxty=Ux5rj-VQSZH-ryj1RiNJvy7mRE7uyx_YAndGtcq7Q@mail.gmail.com>
 <CAKwvOdkNLK2cRfY+DA0u3KuY5PuEss5Qox6X3zzpL053pARfrA@mail.gmail.com>
In-Reply-To: <CAKwvOdkNLK2cRfY+DA0u3KuY5PuEss5Qox6X3zzpL053pARfrA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 19 Aug 2020 17:13:47 -0700
Message-ID: <CAKwvOdnDyUw7TZ-ZsWQ=d7ZNPM_ziFnimmbYoVAexWmg2DL36A@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: backtrace-clang: add fixup for lr dereference
To:     Nathan Huckleberry <nhuck15@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Lvqiang Huang <lvqiang.huang@unisoc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Miles Chen <miles.chen@mediatek.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 3:33 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, Aug 6, 2020 at 3:39 PM Nathan Huckleberry <nhuck15@gmail.com> wrote:
> >
> > Mostly looks good to me. Just a minor nit.
> >
> > On Thu, Jul 30, 2020 at 3:51 PM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > > +/*
> > > + * Accessing the address pointed to by the link register triggered an
> > > + * exception, don't try to unwind through it.
> > > + */
> > > +bad_lr:                mov     sv_fp, #0
> >
> > It might be nice to emit a warning here since we'll
> > only hit this case if something fishy is going on
> > with the saved lr.
>
> Yeah, something fishy is going on if that ever happens.  Let me create
> a V2 with an additional print.

FWIW, I ran into another bug on -next when trying to update this.

Report:
https://lore.kernel.org/lkml/20200811204729.1116341-1-ndesaulniers@google.com/
Fix:
https://lore.kernel.org/lkml/20200814212525.6118-1-john.ogness@linutronix.de/T/#t

Then I got bogged down in planning for plumbers and other fires. I
hope to revisit the series after plumbers.
-- 
Thanks,
~Nick Desaulniers
