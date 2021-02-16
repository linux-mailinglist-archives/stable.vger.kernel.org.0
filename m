Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE5831C758
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 09:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhBPI2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 03:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhBPI2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 03:28:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33A5164E04;
        Tue, 16 Feb 2021 08:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613464037;
        bh=Le2Eb2HspI0V1QIwLnnFJ5M4qLTd6wfC5sgfrFaVXdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZnibMyn0sFl9gyI6r4uUD6W0vOzg37DiSUcsVlJXH0BsQVHvEfOZSUSarU50nUhS3
         2NrSJiTdZjwRdBy+zm7WM9+HZrLpp8YBwsvtUWQHhpa9FVorCYIlYYoLkqY8LucLj3
         8Bi1AeZQ0C2wWSRl890DABaJCxTAsv94JcyM3ThpeU7gPl1Kz10nFsk/1YuF69zhTI
         YcOv3oL/zFDX7KVNDxhTW4LfsNC1+FTXxMY0iCl0gIH8uw0mJzLxYzVssu2DhmCi7B
         YOotpk4IMDoGtFuADgnWAlkUX1+JBIKXBVuFNvIDFpixXynDrcJbImrDIYdvA3Y2U0
         q9eWcjaMKGZQA==
Date:   Tue, 16 Feb 2021 10:27:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
Message-ID: <YCuB2UGll4aU2J0z@kernel.org>
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 01:31:00AM +0100, Lino Sanfilippo wrote:
> From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> The following sequence of operations results in a refcount warning:
> 
> 1. Open device /dev/tpmrm

Add '.' to end.

> 2. Remove module tpm_tis_spi

Add '.' to end.

> 3. Write a TPM command to the file descriptor opened at step 1.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
> refcount_t: addition on 0; use-after-free.
> Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
> sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
> brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
> raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
> snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
> CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
> Hardware name: BCM2711
> [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
> [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
> [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
> [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
> [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
> [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
> [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
> [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
> [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
> [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
> Exception stack(0xc226bfa8 to 0xc226bff0)
> bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
> bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
> bfe0: 0000006c beafe648 0001056c b6eb6944
> ---[ end trace d4b8409def9b8b1f ]---
> 
> The reason for this warning is the attempt to get the chip->dev reference
> in tpm_common_write() although the reference counter is already zero.
> 
> Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> extra reference used to prevent a premature zero counter is never taken,
> because the required TPM_CHIP_FLAG_TPM2 flag is never set.
> 
> Fix this by moving the TPM 2 character device handling from
> tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
> in time when the flag has been set in case of TPM2.
> 
> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> already introduced function tpm_devs_release() to release the extra
> reference but did not implement the required put on chip->devs that results
> in the call of this function.
> 
> Fix this by putting chip->devs in tpm_chip_unregister().
> 
> Finally move the new implemenation for the TPM 2 handling into a new
> function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
> good case and error cases.
> 
> Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> Cc: stable@vger.kernel.org

Put Cc first.

> ---
>  drivers/char/tpm/tpm-chip.c | 80 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 50 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index ddaeceb..44cac3a 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -344,7 +344,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->dev_num = rc;
>  
>  	device_initialize(&chip->dev);
> -	device_initialize(&chip->devs);
>  
>  	chip->dev.class = tpm_class;
>  	chip->dev.class->shutdown_pre = tpm_class_shutdown;
> @@ -352,39 +351,20 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->dev.parent = pdev;
>  	chip->dev.groups = chip->groups;
>  
> -	chip->devs.parent = pdev;
> -	chip->devs.class = tpmrm_class;
> -	chip->devs.release = tpm_devs_release;
> -	/* get extra reference on main device to hold on
> -	 * behalf of devs.  This holds the chip structure
> -	 * while cdevs is in use.  The corresponding put
> -	 * is in the tpm_devs_release (TPM2 only)
> -	 */
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		get_device(&chip->dev);
> -
>  	if (chip->dev_num == 0)
>  		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
>  	else
>  		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
>  
> -	chip->devs.devt =
> -		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> -
>  	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
>  	if (rc)
>  		goto out;
> -	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> -	if (rc)
> -		goto out;
>  
>  	if (!pdev)
>  		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
>  
>  	cdev_init(&chip->cdev, &tpm_fops);
> -	cdev_init(&chip->cdevs, &tpmrm_fops);
>  	chip->cdev.owner = THIS_MODULE;
> -	chip->cdevs.owner = THIS_MODULE;
>  
>  	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
>  	if (rc) {
> @@ -396,7 +376,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	return chip;
>  
>  out:
> -	put_device(&chip->devs);
>  	put_device(&chip->dev);
>  	return ERR_PTR(rc);
>  }
> @@ -431,6 +410,46 @@ struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
>  }
>  EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
>  
> +static int tpm_add_tpm2_char_device(struct tpm_chip *chip)
> +{
> +	int rc;
> +
> +	device_initialize(&chip->devs);
> +	chip->devs.parent = chip->dev.parent;
> +	chip->devs.class = tpmrm_class;
> +
> +	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> +	if (rc)
> +		goto out_put_devs;
> +	/*
> +	 * get extra reference on main device to hold on behalf of devs.
> +	 * This holds the chip structure while cdevs is in use. The
> +	 * corresponding put is in the tpm_devs_release.
> +	 */
> +	get_device(&chip->dev);
> +	chip->devs.release = tpm_devs_release;
> +	chip->devs.devt =
> +		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> +	cdev_init(&chip->cdevs, &tpmrm_fops);
> +	chip->cdevs.owner = THIS_MODULE;
> +
> +	rc = cdev_device_add(&chip->cdevs, &chip->devs);
> +	if (rc) {
> +		dev_err(&chip->devs,
> +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
> +			MINOR(chip->devs.devt), rc);
> +		goto out_put_devs;
> +	}
> +
> +	return 0;
> +
> +out_put_devs:
> +	put_device(&chip->devs);
> +
> +	return rc;
> +}
> +
>  static int tpm_add_char_device(struct tpm_chip *chip)
>  {
>  	int rc;
> @@ -445,14 +464,9 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  	}
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> -		rc = cdev_device_add(&chip->cdevs, &chip->devs);
> -		if (rc) {
> -			dev_err(&chip->devs,
> -				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> -				dev_name(&chip->devs), MAJOR(chip->devs.devt),
> -				MINOR(chip->devs.devt), rc);
> -			return rc;
> -		}
> +		rc = tpm_add_tpm2_char_device(chip);
> +		if (rc)
> +			goto del_cdev;
>  	}
>  
>  	/* Make the chip available. */
> @@ -460,6 +474,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
>  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
>  	mutex_unlock(&idr_lock);
>  
> +	return 0;
> +
> +del_cdev:
> +	cdev_device_del(&chip->cdev, &chip->dev);
>  	return rc;
>  }
>  
> @@ -640,8 +658,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>  	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
>  		hwrng_unregister(&chip->hwrng);
>  	tpm_bios_log_teardown(chip);
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		cdev_device_del(&chip->cdevs, &chip->devs);
> +		put_device(&chip->devs);
> +	}
>  	tpm_del_char_device(chip);
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_unregister);
> -- 
> 2.7.4
> 

Other than that, this looks good to me.

If this passes testing, I can fix those nit's.

I'll test this post 5.12 PR.

/Jarkko
