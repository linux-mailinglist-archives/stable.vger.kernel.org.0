Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D549837B2AB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 01:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhEKXh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 19:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKXh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 19:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39C796162B;
        Tue, 11 May 2021 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620776181;
        bh=0kddMno8L9vTWGOafdeTWibFtrcMKYCj9uXKnKrzec8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uMgaCy0tzlycndd4vmEWxzT+gQb2yfTZi/i7jdJ9EXEIe3h10vTneAA/I92P+XkSX
         yU0IUkIjhwOs89AC/yuOiOCxLyDQwohpiXQwtViceLNSZJErrlq4x2lU3Z8r8vPQO0
         UBPX4GpBABPdtBrFp6W3Wsw/Uay2a2+TnGP3HCT4ooGREHaerTZGGgGcRucqvjwx8S
         DFNAD9lfaG9B3Eu9eSwrmM7H6/5QLv4YZk7VcVT3yJCyoRMARpxMrL04gPO6ppoNGw
         uF9Xjh89Td9AVawxzN8h5MIsRmdkdixcWTSYJCj5FQtf49r1qSGjsG97x+98kkue+A
         SK38YyxcSxADw==
Date:   Wed, 12 May 2021 02:36:18 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     linux-integrity@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [PATCH 1/2] tpm, tpm_tis: Extend locality handling to TPM2 in
 tpm_tis_gen_interrupt()
Message-ID: <YJsU8m0WddX/9+H9@kernel.org>
References: <20210510122831.409608-1-jarkko@kernel.org>
 <daf823b3-522c-6c9a-984b-0ca849512a54@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daf823b3-522c-6c9a-984b-0ca849512a54@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 01:09:35AM +0200, Lino Sanfilippo wrote:
> Hi,
> 
> On 10.05.21 at 14:28, Jarkko Sakkinen wrote:
> > The earlier fix (linked) only partially fixed the locality handling bug
> > in tpm_tis_gen_interrupt(), i.e. only for TPM 1.x.
> >
> > Extend the locality handling to cover TPM2.
> >
> > Cc: Hans de Goede <hdegoede@redhat.com>
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/linux-integrity/20210220125534.20707-1-jarkko@kernel.org/
> > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
> > Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >
> > v1:
> > * Testing done with Intel NUC5i5MYHE with SLB9665 TPM2 chip.
> >
> >  drivers/char/tpm/tpm_tis_core.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index a2e0395cbe61..6fa150a3b75e 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -709,16 +709,14 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
> >  	cap_t cap;
> >  	int ret;
> >
> > -	/* TPM 2.0 */
> > -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > -		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
> > -
> > -	/* TPM 1.2 */
> >  	ret = request_locality(chip, 0);
> >  	if (ret < 0)
> >  		return ret;
> >
> > -	ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		ret = tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
> > +	else
> > +		ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
> >
> >  	release_locality(chip, 0);
> >
> >
> 
> This fix works for me. Tested on a SLB9670vq2.0 and the warning message is gone.
> 
> Tested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> 
> Regards,
> Lino

Thanks a lot, I'll add your tag.

/Jarkko
