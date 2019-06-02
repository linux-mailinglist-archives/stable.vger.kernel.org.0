Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04E5322C6
	for <lists+stable@lfdr.de>; Sun,  2 Jun 2019 11:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFBJHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Jun 2019 05:07:23 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41776 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfFBJHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Jun 2019 05:07:22 -0400
Received: by mail-lf1-f68.google.com with SMTP id 136so11216724lfa.8;
        Sun, 02 Jun 2019 02:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E3LHC70VmPjWfUEwWCZUhxJK2v23LsUvMVDDFT+88Do=;
        b=t/aKIikr1PdapJ+uG190SGfU4tj20xb0xPHhBXXAzpgFJb0VYYTzveZPV/gYGo2wO8
         qPQc7jpvQpPVLHks/IHQG56mVc0yg9uhdfC+gXbiCMkZwdCnMhU2WQ6RaGyFACf0JPAM
         iifaNwbqFFfpTDnmlO6PRSinP9D2zoMCOnzEbrEyBpf0N6gypVDmpnGjlMctEI7qhHMV
         EeRGB2cqHaPM5jtGEQp87kT+K0jntWhrtGkRtwLhLiajZFkkQ7iJhVTcRVkHMFYyRvSO
         kllx3y7W7G6c1FMx+bfYFe64/DjBE+/1QdIDEEU1TO+8zOzJBECYHkPbi4xM5lRaOIFj
         yBbw==
X-Gm-Message-State: APjAAAWbdEMJHdElzCRtPGlDmqm8l1JBvJFUbdmjXItIBr4spLKWSxaP
        KmKon1IUc8j3mInUhvMpMzNKcnaUgmmBVwAr2Hg=
X-Google-Smtp-Source: APXvYqxy+O5HGBSEBmOF5307Hd8hoJqYsjZ7BrzfpQ4TI22wSOyyeZT1DmT14vb/Ghbydjv9tdcFTg4D6zmRRpE5WWI=
X-Received: by 2002:a19:218b:: with SMTP id h133mr10380233lfh.151.1559466440253;
 Sun, 02 Jun 2019 02:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559438652.git.fthain@telegraphics.com.au> <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au>
In-Reply-To: <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 2 Jun 2019 11:07:08 +0200
Message-ID: <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com>
Subject: Re: [PATCH 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take 2
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Finn,

On Sun, Jun 2, 2019 at 3:29 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> A system bus error during a PDMA transfer can mess up the calculation of
> the transfer residual (the PDMA handshaking hardware lacks a byte
> counter). This results in data corruption.
>
> The algorithm in this patch anticipates a bus error by starting each
> transfer with a MOVE.B instruction. If a bus error is caught the transfer
> will be retried. If a bus error is caught later in the transfer (for a
> MOVE.W instruction) the transfer gets failed and subsequent requests for
> that target will use PIO instead of PDMA.
>
> This avoids the "!REQ and !ACK" error so the severity level of that
> message is reduced to KERN_DEBUG.
>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@vger.kernel.org # v4.14+
> Fixes: 3a0f64bfa907 ("mac_scsi: Fix pseudo DMA implementation")
> Reported-by: Chris Jones <chris@martin-jones.com>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Thanks for your patch!

> ---
>  arch/m68k/include/asm/mac_pdma.h | 179 +++++++++++++++++++++++++++
>  drivers/scsi/mac_scsi.c          | 201 ++++++++-----------------------

Why have you moved the PDMA implementation to a header file under
arch/m68k/? Do you intend to reuse it by other drivers?

If not, please keep it in the driver, so (a) you don't need an ack from
me ;-), and (b) your change may be easier to review.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
