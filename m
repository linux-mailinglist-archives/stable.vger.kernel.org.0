Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863E731A87F
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 00:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBLX4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 18:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhBLX4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 18:56:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA3364E25;
        Fri, 12 Feb 2021 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613174137;
        bh=qB6dyxCgCs6hpdMfaqAM+5cZxOG0rVPh2DI+4rxPH7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BZyoiIUmJE83cjcXVkT2x2L9I+aJLnwkubehxYHjFxjKKutrqtjYlojrVKQgUoIDE
         jLdcQ/lLzERk+34spSAWv8NFJfj6RCNOf2pA+uGcGv8rPV50tfu4Ydn40skRHi3+Hw
         WkLc4apR0X0QTBMBeEZCyz/mlBIPWREr2VeahlftsEmfQB3ff94d+hGm5zOe4TQfNq
         /HOiBjCyf9qDLOijlpkf1k0jYRGKS8jlrQ8/w9Zk/rIRSCFFhm0Q74BOdFH0N5NRW9
         Np416mQ48jXj4nqFTR6etvjsT2u9WBwBFHKP8hJcRb5RFSBBs9iZnppw1UOy9R/hvT
         pSO4KaEM5dWbg==
Date:   Sat, 13 Feb 2021 01:55:28 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lukasz Majczak <lma@semihalf.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Tj <ml.linux@elloe.vision>, Dirk Gouders <dirk@gouders.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Radoslaw Biernacki <rad@semihalf.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Alex Levin <levinale@google.com>, upstream@semihalf.com
Subject: Re: [PATCH v5] tpm_tis: Add missing
 tpm_request/relinquish_locality() calls
Message-ID: <YCcVcA876iJesEW5@kernel.org>
References: <20210212110600.19216-1-lma@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212110600.19216-1-lma@semihalf.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 12:06:00PM +0100, Lukasz Majczak wrote:
> There are missing calls to tpm_request_locality() before the calls to
> the tpm_get_timeouts() and tpm_tis_probe_irq_single() - both functions
> internally send commands to the tpm using tpm_tis_send_data()
> which in turn, at the very beginning, calls the tpm_tis_status().
> This one tries to read TPM_STS register, what fails and propagates
> this error upward. The read fails due to lack of acquired locality,
> as it is described in
> TCG PC Client Platform TPM Profile (PTP) Specification,
> paragraph 6.1 FIFO Interface Locality Usage per Register,
> Table 39 Register Behavior Based on Locality Setting for FIFO
> - a read attempt to TPM_STS_x Registers returns 0xFF in case of lack
> of locality. The described situation manifests itself with
> the following warning trace:
> 
> [    4.324298] TPM returned invalid status
> [    4.324806] WARNING: CPU: 2 PID: 1 at drivers/char/tpm/tpm_tis_core.c:275 tpm_tis_status+0x86/0x8f

The commit message is has great description  of the background, but
it does not have description what the commit does. Please describe
this in imperative form, e.g. "Export tpm_request_locality() and ..."
and "Call tpm_request_locality() before ...". You get the idea.

It's also lacking expalanation of the implementation path, i.e.
why you are not using tpm_chip_start() and tpm_chip_stop().

> 
> Tested on Samsung Chromebook Pro (Caroline), TPM 1.2 (SLB 9670)

Empty line here.

Also, add:

Cc: stable@vger.kernel.org

> Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")

Remove empty line.

> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>


> ---
> 
> Hi
> 
> I have tried to clean all the pointed issues, but decided to stay with 
> tpm_request/relinquish_locality() calls instead of using tpm_chip_start/stop(),
> the rationale behind this is that, in this case only locality is requested, there
> is no need to enable/disable the clock, the similar case is present in
> the probe_itpm() function.

I would prefer to use the "same same" if it does not cause any extra harm
instead of new exports. That will also make the fix more compact. So don't
agree with this reasoning. Also the commit message lacks *any* reasoning.

> One more clarification is that, the TPM present on my test machine is the SLB 9670
> (not Cr50).
> 
> Best regards,
> Lukasz
> 
> Changes:
> v4->v5:
> * Fixed style, typos, clarified commit message
> 
>  drivers/char/tpm/tpm-chip.c      |  6 ++++--
>  drivers/char/tpm/tpm-interface.c | 13 ++++++++++---
>  drivers/char/tpm/tpm.h           |  2 ++
>  drivers/char/tpm/tpm_tis_core.c  | 14 +++++++++++---
>  4 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index ddaeceb7e109..ce9c2650fbe5 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -32,7 +32,7 @@ struct class *tpm_class;
>  struct class *tpmrm_class;
>  dev_t tpm_devt;
>  
> -static int tpm_request_locality(struct tpm_chip *chip)
> +int tpm_request_locality(struct tpm_chip *chip)
>  {
>  	int rc;
>  
> @@ -46,8 +46,9 @@ static int tpm_request_locality(struct tpm_chip *chip)
>  	chip->locality = rc;
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(tpm_request_locality);
>  
> -static void tpm_relinquish_locality(struct tpm_chip *chip)
> +void tpm_relinquish_locality(struct tpm_chip *chip)
>  {
>  	int rc;
>  
> @@ -60,6 +61,7 @@ static void tpm_relinquish_locality(struct tpm_chip *chip)
>  
>  	chip->locality = -1;
>  }
> +EXPORT_SYMBOL_GPL(tpm_relinquish_locality);
>  
>  static int tpm_cmd_ready(struct tpm_chip *chip)
>  {
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 1621ce818705..2a9001d329f2 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -241,10 +241,17 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
>  		return 0;
>  
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		return tpm2_get_timeouts(chip);
> -	else
> -		return tpm1_get_timeouts(chip);
> +	} else {
> +		ssize_t ret = tpm_request_locality(chip);
> +
> +		if (ret)
> +			return ret;
> +		ret = tpm1_get_timeouts(chip);
> +		tpm_relinquish_locality(chip);
> +		return ret;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
>  
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 947d1db0a5cc..8c13008437dd 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -193,6 +193,8 @@ static inline void tpm_msleep(unsigned int delay_msec)
>  
>  int tpm_chip_start(struct tpm_chip *chip);
>  void tpm_chip_stop(struct tpm_chip *chip);
> +int tpm_request_locality(struct tpm_chip *chip);
> +void tpm_relinquish_locality(struct tpm_chip *chip);
>  struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip);
>  __must_check int tpm_try_get_ops(struct tpm_chip *chip);
>  void tpm_put_ops(struct tpm_chip *chip);
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 431919d5f48a..d4f381d6356e 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -708,11 +708,19 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
>  	u32 cap2;
>  	cap_t cap;
>  
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
> -	else
> -		return tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
> +	} else {
> +		ssize_t ret = tpm_request_locality(chip);
> +
> +		if (ret)
> +			return ret;
> +		ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
>  				  0);
> +		tpm_relinquish_locality(chip);
> +		return ret;
> +	}
> +
>  }
>  
>  /* Register the IRQ and issue a command that will cause an interrupt. If an
> -- 
> 2.25.1
> 
> 
