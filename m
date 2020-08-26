Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A305D252B85
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 12:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgHZKk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbgHZKk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:40:26 -0400
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E832080C;
        Wed, 26 Aug 2020 10:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598438426;
        bh=txaSaNPnXRRk4ooQL2bKzX5EI3dP8CHaqLkAxMpUPeI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dC+5Olx5mdQHGtKK62E1yUdRwd3jMfhr/j1edBpYOjvI34xMS9P8Lj3QlOSjDdEh3
         Ads9nnaw2GUczX6HT23SDi4Ct5cjc4fH9rXJNOupxJpuSIdL6wJDS9jDPhMeVvSwRA
         6tfZnlV6W3577vNWCGv8pcnmnv7eZfTR/3J9JKa8=
Received: by mail-oo1-f54.google.com with SMTP id a6so326650oog.9;
        Wed, 26 Aug 2020 03:40:25 -0700 (PDT)
X-Gm-Message-State: AOAM533d4fGo58lzwKzoQrRPuWg60UoSKZ8airpEhEDVK1zdMBfBkyeq
        H+OeiQe8ZO7KPB6qJpTwYI9S7pZuydN4BcqlFhM=
X-Google-Smtp-Source: ABdhPJwV0tCVOBpDOYwyJ7WqID0zDWxC9DNsplWSfqvJpse4QTRdk5ZeqxB8wzlH4itZZkrEmzS/6TmCYNaNFKuQick=
X-Received: by 2002:a4a:9211:: with SMTP id f17mr4104637ooh.41.1598438425284;
 Wed, 26 Aug 2020 03:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200826055150.2753.90553@ml01.vlan13.01.org> <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
In-Reply-To: <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 Aug 2020 12:40:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
Message-ID: <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Caleb Jorden <caljorden@hotmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 08:18, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
>
> Dear Caleb,
>
>
> Thank you for the report. Linux has a no regression policy, so the
> correct forum to report this to is the Linux kernel folks. I am adding
> the crypto and stable folks to the receiver list.
>
> Am 26.08.20 um 07:51 schrieb caljorden@hotmail.com:
>
> > I wanted to note an issue that I have hit with iwd when I upgraded to
> > the Linux 5.8.3 stable kernel.  My office network uses WPA Enterprise
> > with EAP-PEAPv0 + MSCHAPv2.  When using this office network,
> > upgrading to Linux 5.8.3 caused my system to refuse to associate
> > successfully to the network.  I get the following in my dmesg logs:
> >
> > [   40.846535] wlan0: authenticate with <redacted>:60
> > [   40.850570] wlan0: send auth to <redacted>:60 (try 1/3)
> > [   40.854627] wlan0: authenticated
> > [   40.855992] wlan0: associate with <redacted>:60 (try 1/3)
> > [   40.860450] wlan0: RX AssocResp from <redacted>:60 (capab=3D0x411 st=
atus=3D0 aid=3D11)
> > [   40.861620] wlan0: associated
> > [   41.886503] wlan0: deauthenticating from <redacted>:60 by local choi=
ce (Reason: 23=3DIEEE8021X_FAILED)
> > [   42.360127] wlan0: authenticate with <redacted>:22
> > [   42.364584] wlan0: send auth to <redacted>:22 (try 1/3)
> > [   42.370821] wlan0: authenticated
> > [   42.372658] wlan0: associate with <redacted>:22 (try 1/3)
> > [   42.377426] wlan0: RX AssocResp from <redacted>:22 (capab=3D0x411 st=
atus=3D0 aid=3D15)
> > [   42.378607] wlan0: associated
> > [   43.402009] wlan0: deauthenticating from <redacted>:22 by local choi=
ce (Reason: 23=3DIEEE8021X_FAILED)
> > [   43.875921] wlan0: authenticate with <redacted>:60
> > [   43.879988] wlan0: send auth to <redacted>:60 (try 1/3)
> > [   43.886244] wlan0: authenticated
> > [   43.889273] wlan0: associate with <redacted>:60 (try 1/3)
> > [   43.894586] wlan0: RX AssocResp from <redacted>:60 (capab=3D0x411 st=
atus=3D0 aid=3D11)
> > [   43.896077] wlan0: associated
> > [   44.918504] wlan0: deauthenticating from <redacted>:60 by local choi=
ce (Reason: 23=3DIEEE8021X_FAILED)
> >
> > This continues as long as I let iwd run.
> >
> > I downgraded back to Linux 5.8.2, and verified that everything works
> > as expected.  I also tried using Linux 5.8.3 on a different system at
> > my home, which uses WPA2-PSK.  It worked fine (though it uses an
> > Atheros wireless card instead of an Intel card - but I assume that is
> > irrelevant).
> >
> > I decided to try to figure out what caused the issue in the changes
> > for Linux 5.8.3.  I assumed that it was something that changed in the
> > crypto interface, which limited my bisection to a very few commits.
> > Sure enough, I found that if I revert commit
> > e91d82703ad0bc68942a7d91c1c3d993e3ad87f0 (crypto: algif_aead - Only
> > wake up when ctx->more is zero), the problem goes away and I am able
> > to associate to my WPA Enterprise network successfully, and use it.
> > I found that in order to revert this commit, I also first had to
> > revert 465c03e999102bddac9b1e132266c232c5456440 (crypto: af_alg - Fix
> > regression on empty requests), because the two commits have coupled
> > changes.
> >
> > I normally would have assumed that this should be sent to the kernel
> > list, but I thought I would first mention it here because of what I
> > found in some email threads on the Linux-Crypto list about the crypto
> > interfaces to the kernel being sub-optimal and needing to be fixed.
> > The changes in these commits look like they are just trying to fix
> > what could be broken interfaces, so I thought that it would make
> > sense to see what the iwd team thinks about the situation first.
> >
> > The wireless card I was using during this testing is an Intel
> > Wireless 3165 (rev 81).  If there is any additional information I
> > could help provide, please let me know.
>
> It=E2=80=99d be great, if you verified, if the problem occurs with Linus=
=E2=80=99 master
> branch too.
>

It would be helpful if someone could explain for the non-mac80211
enlightened readers how iwd's EAP-PEAPv0 + MSCHAPv2 support relies on
the algif_aead socket interface, and which AEAD algorithms it uses. I
assume this is part of libell?
