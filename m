Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490173118BD
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 03:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBFCot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 21:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhBFCkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:40:05 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAA5C033272;
        Fri,  5 Feb 2021 17:09:02 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C4E0B1280978;
        Fri,  5 Feb 2021 17:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612573701;
        bh=8buggqqJsrVnVBnD8cS/MsnjXH8kbSwhO0dtgWUSVT4=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=KPR8X6JVF1ai8MOI0Y6yVyuiPbwY3ElSnOgxl34aaTMtf0Tf0RVI9zqBm8XjJHN6r
         y3wU8lutpH3pqD7nU75Ng2qtGLEMayhY3FMgzao9j4TkbZANqWhYiOIRUNBGnb5ufz
         BeS8ZMgfMmGDGqyGhxGQ8RBZgD72vqN0TeRb2VcI=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 143TGuq5cmlv; Fri,  5 Feb 2021 17:08:21 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2B5AF1280976;
        Fri,  5 Feb 2021 17:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612573701;
        bh=8buggqqJsrVnVBnD8cS/MsnjXH8kbSwhO0dtgWUSVT4=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=KPR8X6JVF1ai8MOI0Y6yVyuiPbwY3ElSnOgxl34aaTMtf0Tf0RVI9zqBm8XjJHN6r
         y3wU8lutpH3pqD7nU75Ng2qtGLEMayhY3FMgzao9j4TkbZANqWhYiOIRUNBGnb5ufz
         BeS8ZMgfMmGDGqyGhxGQ8RBZgD72vqN0TeRb2VcI=
Message-ID: <525fe9047ffd66e0c8635c7d65e91943eb71cd6a.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Date:   Fri, 05 Feb 2021 17:08:20 -0800
In-Reply-To: <20210205172528.GP4718@ziepe.ca>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
         <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
         <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
         <YByrCnswkIlz1w1t@kernel.org>
         <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
         <20210205172528.GP4718@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-02-05 at 13:25 -0400, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 08:48:11AM -0800, James Bottomley wrote:
[...]
> > The practical consequence of this model is that if you allocate a
> > chip structure with tpm_chip_alloc() you have to release it again
> > by doing a put of *both* devices.
> 
> The final put of the devs should be directly after the
> cdev_device_del(), not in a devm. This became all confused because
> the devs was created during alloc, not register. Having a device that
> is initialized but will never be added is weird.
> 
> See sketch below.
> 
> > Stefan noticed the latter, so we got the bogus patch 8979b02aaf1d
> > ("tpm: Fix reference count to main device") applied which simply
> > breaks the master/slave model by not taking a reference on the
> > master for the slave.  I'm not sure why I didn't notice the problem
> > with this fix at the time, but attention must have been elsewhere.
> 
> Well, this is sort of OK because we never use the devs in TPM1, so we
> end up freeing the chip with a positive refcount on the devs, which
> is weird but not a functional bug.
> 
> Jason
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-
> chip.c
> index ddaeceb7e10910..e07193a0dd4438 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -344,7 +344,6 @@ struct tpm_chip *tpm_chip_alloc(struct device
> *pdev,
>  	chip->dev_num = rc;
>  
>  	device_initialize(&chip->dev);
> -	device_initialize(&chip->devs);
>  
>  	chip->dev.class = tpm_class;
>  	chip->dev.class->shutdown_pre = tpm_class_shutdown;
> @@ -352,29 +351,12 @@ struct tpm_chip *tpm_chip_alloc(struct device
> *pdev,
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
> -		MKDEV(MAJOR(tpm_devt), chip->dev_num +
> TPM_NUM_DEVICES);
> -
>  	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
> -	if (rc)
> -		goto out;
> -	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
>  	if (rc)
>  		goto out;
>  
> @@ -382,9 +364,7 @@ struct tpm_chip *tpm_chip_alloc(struct device
> *pdev,
>  		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
>  
>  	cdev_init(&chip->cdev, &tpm_fops);
> -	cdev_init(&chip->cdevs, &tpmrm_fops);
>  	chip->cdev.owner = THIS_MODULE;
> -	chip->cdevs.owner = THIS_MODULE;
>  
>  	rc = tpm2_init_space(&chip->work_space,
> TPM2_SPACE_BUFFER_SIZE);
>  	if (rc) {
> @@ -396,7 +376,6 @@ struct tpm_chip *tpm_chip_alloc(struct device
> *pdev,
>  	return chip;
>  
>  out:
> -	put_device(&chip->devs);
>  	put_device(&chip->dev);
>  	return ERR_PTR(rc);
>  }
> @@ -445,13 +424,33 @@ static int tpm_add_char_device(struct tpm_chip
> *chip)
>  	}
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +		device_initialize(&chip->devs);
> +		chip->devs.parent = pdev;
> +		chip->devs.class = tpmrm_class;
> +		rc = dev_set_name(&chip->devs, "tpmrm%d", chip-
> >dev_num);
> +		if (rc)
> +			goto out_put_devs;
> +
> +		/*
> +                 * get extra reference on main device to hold on
> behalf of devs.
> +                 * This holds the chip structure while cdevs is in
> use. The
> +		 * corresponding put is in the tpm_devs_release.
> +		 */
> +		get_device(&chip->dev);
> +		chip->devs.release = tpm_devs_release;
> +
> +		chip->devs.devt =
> +			MKDEV(MAJOR(tpm_devt), chip->dev_num +
> TPM_NUM_DEVICES);
> +		cdev_init(&chip->cdevs, &tpmrm_fops);
> +		chip->cdevs.owner = THIS_MODULE;
> +

Effectively all of this shuffles the tpmrm device allocation from
chip_alloc to chip_add ... I'm not averse to this but it does mean we
can suffer allocation failures now in the add routine and it makes
error handling a bit more complex.  On the other hand we can now check
the TPM2 flag correctly, so it's swings and roundabouts.

>  		rc = cdev_device_add(&chip->cdevs, &chip->devs);
>  		if (rc) {
>  			dev_err(&chip->devs,
>  				"unable to cdev_device_add() %s, major
> %d, minor %d, err=%d\n",
>  				dev_name(&chip->devs), MAJOR(chip-
> >devs.devt),
>  				MINOR(chip->devs.devt), rc);
> -			return rc;
> +			goto out_put_devs;
>  		}
>  	}
>  
> @@ -460,6 +459,10 @@ static int tpm_add_char_device(struct tpm_chip
> *chip)
>  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
>  	mutex_unlock(&idr_lock);
>  
> +out_put_devs:
> +	put_device(&chip->devs);

I think there should be a if (chip->flags & TPM_CHIP_FLAG_TPM2) here.

I realise you got everything semantically correct and you only ever go
to this label from somewhere that already has the check, but guess what
will happen when the bot rewriters get hold of this ...

> +out_del_dev:
> +	cdev_device_del(&chip->cdev);
>  	return rc;
>  }
>  
> @@ -640,8 +643,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>  	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
>  		hwrng_unregister(&chip->hwrng);
>  	tpm_bios_log_teardown(chip);
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		cdev_device_del(&chip->cdevs, &chip->devs);
> +		put_device(&chip->devs);
> +	}
>  	tpm_del_char_device(chip);

Actually, I think you want to go further here.  If there's a 

put_device(&chips->dev)

as the last statement (or moved into tpm_del_char_device) we should now
have no active reference on the devices from the kernel and we can
eliminate the 

	rc = devm_add_action_or_reset(pdev,
				      (void (*)(void *)) put_device,
				      &chip->dev);

In tpmm_chip_alloc().  That way both /dev/tpm and /dev/tpmrm have
identical lifetime properties.

James


