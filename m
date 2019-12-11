Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7819B11A1A6
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 03:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLKCvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 21:51:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbfLKCvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 21:51:13 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4BFB20836
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 02:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576032673;
        bh=v5s7xAB1ZKTwliMLIUXoJpyhVphhX3gSE8MDBuTMA78=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vQx+Hkh833J9WaiPR09qwOuGhSOuakMBRcAsI9O6IjjU6it8P5jmns742yQWsRLxS
         u7lMySWNFp0tE0zfFMuH+rxYKjxAovLbBEL/x8BhDF/vMyPzIFTr2ZkvUZw6k9ILyC
         J0dx7x0xLADIaC3VodnRWm83R9w6Lh0lSkzPV7H8=
Received: by mail-wm1-f49.google.com with SMTP id p9so5376505wmc.2
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 18:51:12 -0800 (PST)
X-Gm-Message-State: APjAAAUXDLD3ptb9fjc8WlCoqYsElwZK8zMLGL4a5zzd/IH1dtN1ooqy
        NnSPFXKWX0J5BPTgbI+xyb9Vvm858//ZQSFzoPY=
X-Google-Smtp-Source: APXvYqzyeno9avB5eyNLaWnBKy0vxS3qWvZ71vI00GdLWAzo6k4Ns3PJVNcu8Bi31eE4I5cdt7B+RbKLUaLAkm8NUBg=
X-Received: by 2002:a1c:9e0d:: with SMTP id h13mr600718wme.110.1576032671360;
 Tue, 10 Dec 2019 18:51:11 -0800 (PST)
MIME-Version: 1.0
References: <20191210225743.GA4443@roeck-us.net> <20191211002102.mr3re4rks2nmdkyf@toshiba.co.jp>
In-Reply-To: <20191211002102.mr3re4rks2nmdkyf@toshiba.co.jp>
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Wed, 11 Dec 2019 10:51:00 +0800
X-Gmail-Original-Message-ID: <CAGb2v66cAr63ikiBhO6h0c5cZufwcceY+52d9w71RbNScxyORg@mail.gmail.com>
Message-ID: <CAGb2v66cAr63ikiBhO6h0c5cZufwcceY+52d9w71RbNScxyORg@mail.gmail.com>
Subject: Re: stable RC build breakages (4.14.y, 4.19.y)
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 8:21 AM Nobuhiro Iwamatsu
<nobuhiro1.iwamatsu@toshiba.co.jp> wrote:
>
> Hi,
>
> On Tue, Dec 10, 2019 at 02:57:43PM -0800, Guenter Roeck wrote:
> > v4.14.y:
> >
> > arm64:defconfig:
> >
> > arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts:5:10: fatal error:
> >       dt-bindings/input/gpio-keys.h: No such file or directory
> >
>
> The include/dt-bindings/input/gpio-keys.h is not provided.
> We need to revert commit 9b7f85596a7c799d3715729188ea8f0f0f4b3c54(arm64:
> tegra: Fix power key interrupt type on Jetson TX2).
>
>
> > i386:allyesconfig:
> >
> > drivers/crypto/geode-aes.c:174:2: error:
> >       implicit declaration of function 'crypto_sync_skcipher_clear_flags
> >
> > and several similar errors.
>
>
> crypto_sync_skcipher_clear_flags() was provided from 4.19. So we need to
> fix the patch.
>
> >
> >
> > ---
> > v4.19.y:
> >
> > arm64:defconfig:
> >
> > arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:82.1-7 Label or path codec not found
> > arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:86.1-14 Label or path codec_analog not found
> > arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:91.1-5 Label or path dai not found
> > arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:297.1-7 Label or path sound not found
>
> I think we need to pick commit ec4a95409d5c28962e0097e8291aa7048f8b262a.
> But I have not examined it in detail.

Yes that looks like the right patch.

Alternatively, you could just ask for

  ea03518a3123 arm64: dts: allwinner: a64: enable sound on Pinebook

to be dropped, since the related driver changes aren't in stable either,
there's no way this works.


ChenYu

> >
> > i386:allyesconfig:
> >
> > Same as v4.14.y.
> >
> > Guenter
> >
>
> Best regards,
>   Nobuhiro
