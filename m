Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC233D1A5
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 11:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhCPKSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 06:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236273AbhCPKRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 06:17:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D912465024;
        Tue, 16 Mar 2021 10:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615889862;
        bh=mPZpYndorhq/hGagJa302dLkTdn2UIDGB0v5ZTd6Isk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H4UblTBphr2g0960ZHn0FDAhozaK3VEq7NAdn/y2dqS5bZVglkPR5u7Gougu0yCTF
         ySVrtSvIEv/jot3SzexIUA3hIjc2hpx0Tu7khsZcgTxVFlvS3xa0/nTa8f/B68syfr
         +0EQMCCMhzjLA05tZA8TXE0T8SfGGsXctxFxDtoNGbuFIDHU7E/ZtXNl5RJ27hnbGF
         PmAgxlRTa2Or8hKQJMoyq/6ASegHTmX/MsIxR+qB+jJlfBhoowmL345SEzp2EVkzER
         dKXrHckWFVXCHzVbQcw/lzkG76SjRFC3jL1YSd5fsipEtR/gYlfFL8wHVV2pYnJbGM
         /1wqIEus/PF1g==
Received: by mail-ot1-f51.google.com with SMTP id 75so8337765otn.4;
        Tue, 16 Mar 2021 03:17:41 -0700 (PDT)
X-Gm-Message-State: AOAM533QSo1mLTls8JRiyi8qHMiJiPMTDmVugn5N1zysrhyZbXrGn4pK
        LNwUXEDpWiyJ1UOPRTePbaVo7gXCVO1VBuNQn3U=
X-Google-Smtp-Source: ABdhPJyEqCvePx8enAes+FWMrFnWnd9A3TcRrE0wT9hXhaug7cQAl/j5o2iXIFEOUCoRayEqtBLmY+pd8uNsk6N4bME=
X-Received: by 2002:a9d:7512:: with SMTP id r18mr3169537otk.90.1615889861146;
 Tue, 16 Mar 2021 03:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu>
In-Reply-To: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 16 Mar 2021 11:17:30 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
Message-ID: <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
Subject: Re: stable request
To:     Thomas Backlund <tmb@tmb.nu>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
>
> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
> > Please consider backporting commit
> >
> > 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
> > crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
> >
> > to stable. It addresses a rather substantial retpoline-related
> > performance regression in the AES-NI XTS code, which is a widely used
> > disk encryption algorithm on x86.
> >
>
> To get all the nice bits, we added the following in Mageia 5.10 / 5.11
> series kerenels (the 2 first is needed to get the third to apply/build
> nicely):
>

I will leave it up to the -stable maintainers to decide, but I will
point out that none of the additional patches fix any bugs, so this
may violate the stable kernel rules. In fact, I deliberately split the
XTS changes into two  patches so that the first one could be
backported individually.

-- 
Ard.


> applied in this order:
>
>  From 032d049ea0f45b45c21f3f02b542aa18bc6b6428 Mon Sep 17 00:00:00 2001
> From: Uros Bizjak <ubizjak@gmail.com>
> Date: Fri, 27 Nov 2020 10:44:52 +0100
> Subject: [PATCH] crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg
>
>  From ddf169a98f01d6fd46295ec0dd4c1d6385be65d4 Mon Sep 17 00:00:00 2001
> From: Ard Biesheuvel <ardb@kernel.org>
> Date: Tue, 8 Dec 2020 00:34:02 +0100
> Subject: [PATCH] crypto: aesni - implement support for cts(cbc(aes))
>
>  From 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1 Mon Sep 17 00:00:00 2001
> From: Ard Biesheuvel <ardb@kernel.org>
> Date: Thu, 31 Dec 2020 17:41:54 +0100
> Subject: [PATCH] crypto: x86/aes-ni-xts - use direct calls to and 4-way
> stride
>
>  From 2481104fe98d5b016fdd95d649b1235f21e491ba Mon Sep 17 00:00:00 2001
> From: Ard Biesheuvel <ardb@kernel.org>
> Date: Thu, 31 Dec 2020 17:41:55 +0100
> Subject: [PATCH] crypto: x86/aes-ni-xts - rewrite and drop indirections
> via glue helper
>
> --
> Thomas
>
