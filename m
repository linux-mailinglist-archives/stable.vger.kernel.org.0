Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259483B1B3A
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 15:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhFWNgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 09:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhFWNgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 09:36:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F0EE61075;
        Wed, 23 Jun 2021 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624455262;
        bh=Ub/TeUhtbPOhJNeYUKp0O0qQF4nnkFy8gy1hyv/hJaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pKQ+MQAvO81uOvzBNPKBu9URkI0cbs9KOqEsG5pVEBeoRTOehlg7GL9ScNLVi3Lc1
         LWry5eLQ5A+cslz0Fk2b0wNala1GOpi0hW2FLGydYj+C+FcTjaqmlOUUJm2bcQ/sI3
         w1GZbztqrIpWa5h2yBqBdyghzI+U2VKrmD6UMAe6TUKYWSPA7RNWWUC2oTk98r2cUk
         cZ5tO+/823tWRdZhlh14IhxcRcjaAd9Dzep2fvBqFNmr/cwnDzTpsRAXc4bkzaRgYo
         wKZEPtW0vvFShXPhDhtWq2tMJ3gVSP24hs12IME7iJr7nFXO/VR0qG5hvpWAJ8NS5p
         EtIW0YrsCRUHQ==
Date:   Wed, 23 Jun 2021 16:34:20 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, linus.walleij@linaro.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] tpm, tpm_tis_spi: Allow to sleep in the interrupt
 handler
Message-ID: <20210623133420.gw2lziue5nkvjtps@kernel.org>
References: <20210620023444.14684-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210620023444.14684-1-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 20, 2021 at 04:34:44AM +0200, Lino Sanfilippo wrote:
> Interrupt handling at least includes reading and writing the interrupt
> status register within the interrupt routine. For accesses over SPI a mutex
> is used in the concerning functions. Since this requires a sleepable
> context request a threaded interrupt handler for this case.
> 
> Cc: stable@vger.kernel.org
> Fixes: 1a339b658d9d ("tpm_tis_spi: Pass the SPI IRQ down to the driver")
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

I'll test this after rc1 PR (I have one NUC which uses tpm_tis_spi).

/Jarkko

> ---
> This patch has been tested on a SLB9670vq2.0.
> The first version of this patch was part of patch series (see
> https://marc.info/?l=linux-integrity&m=162016888020044&w=2)
> 
> v2:
> - request threaded irq handler only in case of SPI as requested by Jarkko
>   Sakkinen
> - add "Fixes" tag
> - add stable
> - correct short summary
> 
>  drivers/char/tpm/tpm_tis.c           |  2 +-
>  drivers/char/tpm/tpm_tis_core.c      | 32 ++++++++++++++++++++--------
>  drivers/char/tpm/tpm_tis_core.h      |  2 +-
>  drivers/char/tpm/tpm_tis_spi_main.c  |  3 ++-
>  drivers/char/tpm/tpm_tis_synquacer.c |  2 +-
>  5 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 4ed6e660273a..d27009b989fe 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -236,7 +236,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info)
>  		phy->priv.flags |= TPM_TIS_ITPM_WORKAROUND;
>  
>  	return tpm_tis_core_init(dev, &phy->priv, irq, &tpm_tcg,
> -				 ACPI_HANDLE(dev));
> +				 ACPI_HANDLE(dev), false);
>  }
>  
>  static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 55b9d3965ae1..21abc2168d07 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -728,19 +728,31 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
>   * everything and leave in polling mode. Returns 0 on success.
>   */
>  static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
> -				    int flags, int irq)
> +				    int flags, int irq, bool threaded_irq)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>  	u8 original_int_vec;
>  	int rc;
>  	u32 int_status;
>  
> -	if (devm_request_irq(chip->dev.parent, irq, tis_int_handler, flags,
> -			     dev_name(&chip->dev), chip) != 0) {
> +
> +	if (threaded_irq) {
> +		rc = devm_request_threaded_irq(chip->dev.parent, irq, NULL,
> +					       tis_int_handler,
> +					       IRQF_ONESHOT | flags,
> +					       dev_name(&chip->dev),
> +					       chip);
> +	} else {
> +		rc = devm_request_irq(chip->dev.parent, irq, tis_int_handler,
> +				      flags, dev_name(&chip->dev), chip);
> +	}
> +
> +	if (rc) {
>  		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
>  			 irq);
>  		return -1;
>  	}
> +
>  	priv->irq = irq;
>  
>  	rc = tpm_tis_read8(priv, TPM_INT_VECTOR(priv->locality),
> @@ -795,7 +807,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>   * do not have ACPI/etc. We typically expect the interrupt to be declared if
>   * present.
>   */
> -static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
> +static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask,
> +			      bool threaded_irq)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>  	u8 original_int_vec;
> @@ -810,10 +823,11 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
>  		if (IS_ENABLED(CONFIG_X86))
>  			for (i = 3; i <= 15; i++)
>  				if (!tpm_tis_probe_irq_single(chip, intmask, 0,
> -							      i))
> +							      i, threaded_irq))
>  					return;
>  	} else if (!tpm_tis_probe_irq_single(chip, intmask, 0,
> -					     original_int_vec))
> +					     original_int_vec,
> +					     threaded_irq))
>  		return;
>  }
>  
> @@ -909,7 +923,7 @@ static const struct tpm_class_ops tpm_tis = {
>  
>  int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  		      const struct tpm_tis_phy_ops *phy_ops,
> -		      acpi_handle acpi_dev_handle)
> +		      acpi_handle acpi_dev_handle, bool threaded_irq)
>  {
>  	u32 vendor;
>  	u32 intfcaps;
> @@ -1049,7 +1063,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  
>  		if (irq) {
>  			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
> -						 irq);
> +						 irq, threaded_irq);
>  			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
>  				dev_err(&chip->dev, FW_BUG
>  					"TPM interrupt not working, polling instead\n");
> @@ -1057,7 +1071,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  				disable_interrupts(chip);
>  			}
>  		} else {
> -			tpm_tis_probe_irq(chip, intmask);
> +			tpm_tis_probe_irq(chip, intmask, threaded_irq);
>  		}
>  	}
>  
> diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
> index 9b2d32a59f67..32d36e538208 100644
> --- a/drivers/char/tpm/tpm_tis_core.h
> +++ b/drivers/char/tpm/tpm_tis_core.h
> @@ -161,7 +161,7 @@ static inline bool is_bsw(void)
>  void tpm_tis_remove(struct tpm_chip *chip);
>  int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>  		      const struct tpm_tis_phy_ops *phy_ops,
> -		      acpi_handle acpi_dev_handle);
> +		      acpi_handle acpi_dev_handle, bool use_threaded_irq);
>  
>  #ifdef CONFIG_PM_SLEEP
>  int tpm_tis_resume(struct device *dev);
> diff --git a/drivers/char/tpm/tpm_tis_spi_main.c b/drivers/char/tpm/tpm_tis_spi_main.c
> index 3856f6ebcb34..2eb57c1cf9ba 100644
> --- a/drivers/char/tpm/tpm_tis_spi_main.c
> +++ b/drivers/char/tpm/tpm_tis_spi_main.c
> @@ -199,7 +199,8 @@ int tpm_tis_spi_init(struct spi_device *spi, struct tpm_tis_spi_phy *phy,
>  
>  	phy->spi_device = spi;
>  
> -	return tpm_tis_core_init(&spi->dev, &phy->priv, irq, phy_ops, NULL);
> +	return tpm_tis_core_init(&spi->dev, &phy->priv, irq, phy_ops, NULL,
> +				 true);
>  }
>  
>  static const struct tpm_tis_phy_ops tpm_spi_phy_ops = {
> diff --git a/drivers/char/tpm/tpm_tis_synquacer.c b/drivers/char/tpm/tpm_tis_synquacer.c
> index e47bdd272704..6ee59a1fdf08 100644
> --- a/drivers/char/tpm/tpm_tis_synquacer.c
> +++ b/drivers/char/tpm/tpm_tis_synquacer.c
> @@ -127,7 +127,7 @@ static int tpm_tis_synquacer_init(struct device *dev,
>  		return PTR_ERR(phy->iobase);
>  
>  	return tpm_tis_core_init(dev, &phy->priv, tpm_info->irq, &tpm_tcg_bw,
> -				 ACPI_HANDLE(dev));
> +				 ACPI_HANDLE(dev), false);
>  }
>  
>  static SIMPLE_DEV_PM_OPS(tpm_tis_synquacer_pm, tpm_pm_suspend, tpm_tis_resume);
> 
> base-commit: 913ec3c22ef425d63dd0bc81fb008ce7f9bcb07b
> -- 
> 2.31.1
> 
