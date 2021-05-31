Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC073954F3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 07:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhEaFQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 01:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhEaFQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 01:16:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8AA560FEB;
        Mon, 31 May 2021 05:14:24 +0000 (UTC)
Date:   Mon, 31 May 2021 07:14:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] tpm: Replace WARN_ONCE() with dev_err_once() in
 tpm_tis_status()
Message-ID: <YLRwrezeI7oW2Evz@kroah.com>
References: <20210531045131.110616-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531045131.110616-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 07:51:31AM +0300, Jarkko Sakkinen wrote:
> Do not torn down the system when getting invalid status from a TPM chip.
> This can happen when panic-on-warn is used.
> 
> In addition, print out the value of TPM_STS.x instead of "invalid
> status". In order to get the earlier benefits for forensics, also call
> dump_stack().
> 
> Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
> Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
> Cc: stable@vger.kernel.org
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  drivers/char/tpm/tpm_tis_core.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 55b9d3965ae1..514a481829c9 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -202,7 +202,16 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
>  		 * acquired.  Usually because tpm_try_get_ops() hasn't
>  		 * been called before doing a TPM operation.
>  		 */
> -		WARN_ONCE(1, "TPM returned invalid status\n");
> +		dev_err_once(&chip->dev, "invalid TPM_STS.x 0x%02x, dumping stack for forensics\n",
> +			     status);
> +
> +		/*
> +		 * Dump stack for forensics, as invalid TPM_STS.x could be
> +		 * potentially triggered by impaired tpm_try_get_ops() or
> +		 * tpm_find_get_ops().
> +		 */
> +		dump_stack();
> +
>  		return 0;
>  	}

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
