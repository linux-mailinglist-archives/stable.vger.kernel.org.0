Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCE2319D08
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 12:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBLLFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 06:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhBLLCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 06:02:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F001264E65;
        Fri, 12 Feb 2021 11:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613127732;
        bh=mqaVkrZNgite2xCHD2lroZ/46M4yAFMZdhRJGSoS5Yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CHWBNivK2sx1WQGie+cHGlaEvkRQRXUuv4rQb9e0tXy6I+cdqRuOLWU91qj4yHtpy
         NdUhxSYBu5g+DxqBHtEvDLcdkddjzw0fsNHcxtGvuOYzyvBICHc4HBPKO5SVSiw/xK
         VlBWjx16BpYX8xQ6wOb2JlPkoIWa1VVycuOjgEz4+zQCfL6Pliv/9fljuVY1RV1Rgf
         BkkARNRm5bBQU6BTOQEdsamHzAmPRBRgcc8sCmz8CL9xBAPtwKJV1rkKr5ky7qHoU2
         H3+nGg9r3im3BJV6bDhw3R3NIdGmCsfFLPihE2d5stYcBG4XPqWUlhGOD4a8vMZiTQ
         5nEvPzuNKHaig==
Date:   Fri, 12 Feb 2021 13:02:03 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
Message-ID: <YCZgK2uyzn/qPg6L@kernel.org>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <YByrCnswkIlz1w1t@kernel.org>
 <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
 <20210205172528.GP4718@ziepe.ca>
 <08ce58ab-3513-5d98-16a5-b197276f6bce@kunbus.com>
 <20210209133653.GC4718@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209133653.GC4718@ziepe.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 09:36:53AM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 09, 2021 at 12:52:17PM +0100, Lino Sanfilippo wrote:
> > > @@ -640,8 +643,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
> > >  	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
> > >  		hwrng_unregister(&chip->hwrng);
> > >  	tpm_bios_log_teardown(chip);
> > > -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > > +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > >  		cdev_device_del(&chip->cdevs, &chip->devs);
> > > +		put_device(&chip->devs);
> > > +	}
> > >  	tpm_del_char_device(chip);
> > >  }
> > >  EXPORT_SYMBOL_GPL(tpm_chip_unregister);
> > > 
> > 
> > I tested the solution you scetched and it fixes the issue for me. Will you send a (real) patch for this?
> 
> No, feel free to bundle this up with any fixes needed and send it with
> a Signed-off-by from both of us
> 
> I did it pretty fast so it will need a careful read that there isn't a
> typo
> 
> Thanks,
> Jason

Let's use CDB too as it exist and Sean kindly provided a better
documentation for it in some recent kernel release. It's great
exactly for this type of situation.

/Jarkko
