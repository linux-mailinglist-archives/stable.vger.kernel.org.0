Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8150446750A
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 11:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380005AbhLCKeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 05:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379987AbhLCKeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 05:34:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01604C06174A;
        Fri,  3 Dec 2021 02:30:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 684F26294D;
        Fri,  3 Dec 2021 10:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D71C58319;
        Fri,  3 Dec 2021 10:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638527449;
        bh=RcP5xgutHpVuMEDTVWRPy+67aJdjE6dJ1nDSLasNx/c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W+iH1k3C1COL2C6s3ufbZmCN/rV3mlz920873ga9RQ+nDaYynAq7fboLEKoE0F/SR
         ncxc+cRqnH29+S57+x37i1XfgjPWsBICHcXG1fpOAMft104hfDn9JHTSJkAu3aDooB
         bEbUkphQq2+FT60lgSkDVzcJrbbAhMCGjmEz4QbeiAOvMHYR61USrTNvoU/DqFrlxI
         2cpBaQCLMGPLv0g9afv5A/oCfhu28fC0OujMyjK2GTborVwz5kshRopRj2G+qWImlX
         q010pMTrK5XPFe8uhTc2w85w0lbWf/oUKIdp3omioGH4WpTnGtWyhmGqTLYdx7zkzz
         Sd5VasHqO2ARA==
Received: by mail-oi1-f178.google.com with SMTP id bk14so4944674oib.7;
        Fri, 03 Dec 2021 02:30:49 -0800 (PST)
X-Gm-Message-State: AOAM531PC8gxLJWE6rbilgoQ+qZDxXsbwkfVv68TkCJAih3Yw+RdlHnS
        nswvvVZx5KaZoujDUrbdA4O6dWhKPjtSp/ZlbOA=
X-Google-Smtp-Source: ABdhPJytzC+ann1KB6ekO12wj9Cbt3QWXfD0JkS+I2NnDbz/4AI+D2NUXfy/tm83h/6XocNBZUBH3AXB9BXLZqFrb18=
X-Received: by 2002:a05:6808:12:: with SMTP id u18mr9337072oic.174.1638527449029;
 Fri, 03 Dec 2021 02:30:49 -0800 (PST)
MIME-Version: 1.0
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com> <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
 <YXmEo8iMNIn1esYC@zn.tnic> <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
 <f939e968-149f-1caf-c1fb-5939eafae31c@amd.com> <15ceb556-0b56-2833-206e-0cf9b9d2cb45@amd.com>
In-Reply-To: <15ceb556-0b56-2833-206e-0cf9b9d2cb45@amd.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 3 Dec 2021 11:30:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHKxObuebZJMWQQwg014rYzvoBgWPZxfCYakuf+GSoqhg@mail.gmail.com>
Message-ID: <CAMj1kXHKxObuebZJMWQQwg014rYzvoBgWPZxfCYakuf+GSoqhg@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as encrypted
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 1 Dec 2021 at 15:06, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/27/21 12:04 PM, Tom Lendacky wrote:
> >
> >
> > On 10/27/21 11:59 AM, Ard Biesheuvel wrote:
> >> On Wed, 27 Oct 2021 at 18:56, Borislav Petkov <bp@alien8.de> wrote:
> >>>
> >>> On Wed, Oct 27, 2021 at 05:14:35PM +0200, Ard Biesheuvel wrote:
> >>>> I could take it, but since it will ultimately go through -tip anyway,
> >>>> perhaps better if they just take it directly? (This will change after
> >>>> the next -rc1 though)
> >>>>
> >>>> Boris?
> >>>
> >>> Yeah, I'm being told this is not urgent enough to rush in now so you
> >>> could queue it into your fixes branch for 5.16 once -rc1 is out and send
> >>> it to Linus then. The stable tag is just so it gets backported to the
> >>> respective trees.
> >>>
> >>> But if you prefer I should take it, then I can queue it after -rc1.
> >>> It'll boil down to the same thing though.
> >>>
> >>
> >> No, in that case, I can take it myself.
> >>
> >> Tom, does that work for you?
> >
> > Yup, that works for me. Thanks guys!
>
> I don't see this in any tree yet, so just a gentle reminder in case it
> dropped off the radar.
>

Apologies for the delay, I've pushed this out to -next now.

Before I send it to Linus, can you please confirm (for my peace of
mind) how this only affects systems that have memory encryption
available and enabled in the first place?
