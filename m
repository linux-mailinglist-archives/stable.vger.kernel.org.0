Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102A21D1093
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 13:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgEMLF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 07:05:57 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39496 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgEMLF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 07:05:57 -0400
Received: by mail-ot1-f67.google.com with SMTP id q11so1036167oti.6
        for <stable@vger.kernel.org>; Wed, 13 May 2020 04:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+VMy88baWfMC86WYGRMH0MUm6dhXM1+9Zx1s67RSpwo=;
        b=G9/UdgTBu2ypMLNoSAEGiR3YmBdogohfdgXabvIW5JY5ckxGbZXOQs1pi1s993Vl2T
         fpe6zLCq9j9eQeiCvE4PUv/aAHOB+fBLkltghs3PEigsUY5JlVU2oO74gs3EKJcASkli
         B0tuRKrDr44cwH/fkJXJo6Hp08hUzNF2VXxbC9Aa9zIBP4epwjQSkbtx1k7BR4g6Bkvb
         8bUwv4MAcqKTcSq9bzqo2Hf6iT82xI1ounmKNdPoxbJRNgGAgQtciXmL4PHK6jRVzXnZ
         EKeoneX55vdDZOVBEg5qI0Lto+HOzXPWCMH38d/GwlXpPfih/YOyduGzShwM9Bj0fAFc
         BZNw==
X-Gm-Message-State: AGi0Pub3wHHDopqX2w22ijWJrhhknO4TYI3jh1/xEgACg+SJVF1rY/52
        mHUJq+FCA5yXIGKrHWpyr+CmjRr8OmUarQYyZqtPRg==
X-Google-Smtp-Source: APiQypJ1PCtkEOVBt4jxSg6IC6s+X2pCXbo3uOAzDxVhf3brMs42IedTpBM6Ib/y9g4SD85u5F50Sw594ijhosdEYoc=
X-Received: by 2002:a9d:7990:: with SMTP id h16mr19691548otm.145.1589367956350;
 Wed, 13 May 2020 04:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200423204014.784944-1-lee.jones@linaro.org> <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com> <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
 <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
In-Reply-To: <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 13 May 2020 13:05:44 +0200
Message-ID: <CAMuHMdV+FAjBtp-yzp+57o19gcasq15-9rDM58NbJsOwBu=vUQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
To:     David Laight <David.Laight@aculab.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        stable <stable@vger.kernel.org>,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On Wed, May 13, 2020 at 12:10 PM David Laight <David.Laight@aculab.com> wrote:
> From: Geert Uytterhoeven
> > Sent: 13 May 2020 10:49
> ...
> > > I don't want to apply this to older kernels as it could cause extra
> > > memory usage for no good reason.  I have no idea why a non ARC system
> > > would want it :(
> >
> > I think the reference to ARC is a red herring.
> > The real issue is that buffers used for DMA may not have the required
> > alignment, which is not limited to ARC systems.
> >
> > Note that I'm also not super happy with the extra memory usage.
> > But devm_*() conveniences come with their penalties...
>
> Interesting thought.
> Could the devm 'header' be put right at the end of the kmalloc()
> buffer?
>
> Then the driver would be given aligned address.

Yes, if the header is extended to contain the real start address of the
allocated block.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
