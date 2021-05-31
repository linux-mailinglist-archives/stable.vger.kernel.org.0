Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5268C395512
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 07:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhEaFf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 01:35:27 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:52277 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229730AbhEaFf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 01:35:26 -0400
Received: from [192.168.0.7] (ip5f5ae8a3.dynamic.kabel-deutschland.de [95.90.232.163])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6337261E5FE02;
        Mon, 31 May 2021 07:33:45 +0200 (CEST)
Subject: Re: [PATCH] tpm: Replace WARN_ONCE() with dev_err_once() in
 tpm_tis_status()
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Greg KH <greg@kroah.com>, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-integrity@vger.kernel.org
References: <20210531045131.110616-1-jarkko@kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <bbd2c61c-edd7-f830-aafe-2881ba7d2614@molgen.mpg.de>
Date:   Mon, 31 May 2021 07:33:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531045131.110616-1-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Jarkko,


Am 31.05.21 um 06:51 schrieb Jarkko Sakkinen:
> Do not torn down the system when getting invalid status from a TPM chip.

Nit: Do not *tear* down …?

> This can happen when panic-on-warn is used.

Hmm, I’d say it works as expected then? Shouldn’t an invalid status of 
an important device like TPM considered a warning?

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
>   drivers/char/tpm/tpm_tis_core.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 55b9d3965ae1..514a481829c9 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -202,7 +202,16 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
>   		 * acquired.  Usually because tpm_try_get_ops() hasn't
>   		 * been called before doing a TPM operation.
>   		 */
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
>   		return 0;
>   	}


Kind regards,

Paul
