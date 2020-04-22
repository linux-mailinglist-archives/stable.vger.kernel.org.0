Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80201B38FF
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 09:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgDVHcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 03:32:47 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:45093 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgDVHcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 03:32:47 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 37916823;
        Wed, 22 Apr 2020 07:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=HtEBqmnfU1w2LdS6v9LHbppmOJ0=; b=XgO2yn
        LVXAM5e/KoTuTKiRiXzANPY+GuIkh1P8P/9li5KpgUrSXO8weDb+jHtiHjY6CI1v
        y0FDLJhiHv01Z5+ehnGdTeE/RkrFN/hb02Up781Z4839KcC+F/KR3aC4WJJ+gHIc
        034yiYyEwZ/7+aGFqBo8p6wmP7gTPL+rJaafmm/nPxNfJ467xYSs5afmE3n+y7bJ
        f8MFSjkzbe9jb4Zu1hlZrTafpvQauihAEn2eM4LIgwlE+irRldFk72JjgR34GNcP
        sazuknFarjO6jn+nXo1emK2UhcX52tx96aTUliqPcSYyOhJ6XwWYWcLCh3h7k5sE
        7K5BV5gX+UXOFcBQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fe767e4e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 22 Apr 2020 07:21:55 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id i19so1267969ioh.12;
        Wed, 22 Apr 2020 00:32:45 -0700 (PDT)
X-Gm-Message-State: AGi0PubIV8xiCRT5FeRXXp51ADZuoE/i+EgAqDoRz9LaUuSAbC7UDK7b
        bpZmhq0dHasEv0eFjeT3bDQC6Xp4zbehbQifwMk=
X-Google-Smtp-Source: APiQypKSHM1wFrVmucwCB0xnkocR4Y9qBsk20ipyD+/uvm3y3k7K4TRcTifVEIgKJhZZ/TiFbttLKE3sJmBUlMbvOts=
X-Received: by 2002:a5d:9c02:: with SMTP id 2mr24375333ioe.67.1587540764605;
 Wed, 22 Apr 2020 00:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200420075711.2385190-1-Jason@zx2c4.com> <20200422040415.GA2881@sol.localdomain>
In-Reply-To: <20200422040415.GA2881@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 22 Apr 2020 01:32:33 -0600
X-Gmail-Original-Message-ID: <CAHmME9q=hMRjBG=SBX8gCC3qx-t1wdEwMOYx952m9HkByjiofA@mail.gmail.com>
Message-ID: <CAHmME9q=hMRjBG=SBX8gCC3qx-t1wdEwMOYx952m9HkByjiofA@mail.gmail.com>
Subject: Re: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 10:04 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Seems this should just be a 'while' loop?
>
>         while (bytes) {
>                 unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
>
>                 kernel_neon_begin();
>                 chacha_doneon(state, dst, src, todo, nrounds);
>                 kernel_neon_end();
>
>                 bytes -= todo;
>                 src += todo;
>                 dst += todo;
>         }

The for(;;) is how it's done elsewhere in the kernel (that this patch
doesn't touch), because then we can break out of the loop before
having to increment src and dst unnecessarily. Likely a pointless
optimization as probably the compiler can figure out how to avoid
that. But maybe it can't. If you have a strong preference, I can
reactor everything to use `while (bytes)`, but if you don't care,
let's keep this as-is. Opinion?

Jason
