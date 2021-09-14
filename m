Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A366A40A20B
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 02:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbhINAc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 20:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235668AbhINAc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 20:32:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 206FE60232;
        Tue, 14 Sep 2021 00:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631579501;
        bh=ROKfi1j6O6/b6NJU/GxZO7zzPnDnAEe2zixZ9LMELis=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i1861PIiMSnWhP5nnLDhXk+XB7414kaY17sDc6oHtnuLyuIQNQub8gKXQBR7TwGBP
         tvT/zVmawApBLxV6pCclJ2qiLKtPL4gQCrIVRRHDXBR7QvI3C2fb76v0mXFqP+EKq1
         MVLWzihVlKx8j/Es3yJjjWvqFPPtsFCRvmUyxpuOn/N95hNz/Ib3m/5BOfjbJClvFQ
         ENdGYJpzIyt36ZzDJbUMH7Rs4d2aF5QVav5ag4XVbHwM047+DKbyXPh+XW6m7dRbTj
         S+bTvL5SB7Z0G9HAxOAEM67R29rMXtYjlzIvgPLtFd5ORlLMMoJ6tW/ePE1aySAMmQ
         158WFcs52eFxA==
Message-ID: <c22d2878f9816000c33f5349e7256cadae22b400.camel@kernel.org>
Subject: Re: Aw: Re: [PATCH] tpm: fix potential NULL pointer access in
 tpm_del_char_device()
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 14 Sep 2021 03:31:39 +0300
In-Reply-To: <trinity-27f56ffd-504a-4c34-9cda-0953ccc459a3-1631566430623@3c-app-gmx-bs69>
References: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
         <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
         <trinity-27f56ffd-504a-4c34-9cda-0953ccc459a3-1631566430623@3c-app-gmx-bs69>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-09-13 at 22:53 +0200, Lino Sanfilippo wrote:
> Hi,
>=20
> > Gesendet: Montag, 13. September 2021 um 22:25 Uhr
> > Von: "Jarkko Sakkinen" <jarkko@kernel.org>
> > An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de, jgg@z=
iepe.ca
> > Cc: p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org, linux-ke=
rnel@vger.kernel.org, stable@vger.kernel.org
> > Betreff: Re: [PATCH] tpm: fix potential NULL pointer access in tpm_del_=
char_device()
> >=20
> > On Fri, 2021-09-10 at 20:04 +0200, Lino Sanfilippo wrote:
> > > In tpm_del_char_device() make sure that chip->ops is still valid.
> > > This check is needed since in case of a system shutdown
> > > tpm_class_shutdown() has already been called and set chip->ops to NUL=
L.
> > > This leads to a NULL pointer access as soon as tpm_del_char_device()
> > > tries to access chip->ops in case of TPM 2.
> > >=20
> > > Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > > ---
> >=20
> > Have you been able to reproduce this in some environment?
> >=20
> > /Jarkko
> >=20
> >=20
>=20
> Yes, this bug is reproducable on my system that is running a 5.10 raspber=
ry kernel.
> I use a SLB 9670 which is connected via SPI.

Can you confirm that the lates mainline kernel has also this
issue here? That is lacking in this fix.=20

It's obvious that the issue does not scale to every system,
so it would nice to know the difference that triggers the
issue, before applying this, and it also needs to be
documented to the commit message.


/Jarkko
