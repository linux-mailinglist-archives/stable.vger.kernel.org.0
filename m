Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B420252D38
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgHZMAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgHZMAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:00:10 -0400
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D386C2080C;
        Wed, 26 Aug 2020 12:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443205;
        bh=WdolUUSPQwrh8Aj5TJ8h5qeAtgIkR7u9c5nE+npwIIY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Qw1Rt0YmTj69jFWJ0biR73mZ980JOtuuj9zihJsBsJRTiPMfezuNNb2FQXeRTDFnN
         Dtb+xQ58UwcBov1EjWGpb4pfi3b90IRJ/qZq9Vk40+Ql6T9JI0EV56LZxxaAbVKwjG
         0fC9YtlfKviSR4UCsBKcf2OXdYrufDZ809xWnue0=
Received: by mail-ot1-f47.google.com with SMTP id i11so1255096otr.5;
        Wed, 26 Aug 2020 05:00:04 -0700 (PDT)
X-Gm-Message-State: AOAM531pxbnjxCDwMUPdm0fG6xKBsR0eMACV62U8KTGZ1Nu+WQwltFlL
        /vxFK/esfvY7MfqTO5iuErrfPIG9/K+axZH0eGA=
X-Google-Smtp-Source: ABdhPJyRHJMIRG+/FJI73y2W6ECDWrCfnnurge8nTGaW0Q7CAiSYqL3nLbuQh1xgC0wevH+7nsqEBia2B/6cXtCsGvo=
X-Received: by 2002:a9d:5189:: with SMTP id y9mr4290025otg.77.1598443204195;
 Wed, 26 Aug 2020 05:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200826055150.2753.90553@ml01.vlan13.01.org> <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com> <20200826114952.GA2375@gondor.apana.org.au>
In-Reply-To: <20200826114952.GA2375@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 Aug 2020 13:59:53 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
Message-ID: <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 13:50, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Aug 26, 2020 at 12:40:14PM +0200, Ard Biesheuvel wrote:
> >
> > It would be helpful if someone could explain for the non-mac80211
> > enlightened readers how iwd's EAP-PEAPv0 + MSCHAPv2 support relies on
> > the algif_aead socket interface, and which AEAD algorithms it uses. I
> > assume this is part of libell?
>
> I see the problem.  libell/ell/checksum.c doesn't clear the MSG_MORE
> flag before doing the recv(2).
>

But that code uses a hash not an aead, afaict.

> I was hoping nobody out there was doing this but obviously I've
> been proven wrong.
>
> So what I'm going to do is to specifically allow this case of
> a string of sendmsg(2)'s with MSG_MORE folloed by a recvmsg(2)
> in the same thread.  I'll add a WARN_ON_ONCE so user-space can
> eventually be fixed.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
