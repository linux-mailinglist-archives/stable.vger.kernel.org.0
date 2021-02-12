Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7572A319D00
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 12:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhBLLCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 06:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230227AbhBLLAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 06:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F335664E6B;
        Fri, 12 Feb 2021 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613127607;
        bh=4jkeFhImS8370/0LwmAq4dae3hRvBzc5EDZUtpIdZ44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YqTWaQ7ygwCLUvqYSSmFqgtaJtE8KacnCbfnor6sEkH+mcM6nt0z4DZRnEkXFgq6V
         EA9EGPAJt7ek/0ciYxl6Kl7QKnz8SGqCY5zwr2kJwMuZivhDw/LKzP/pKmdoky2E3H
         CNxUS1/RNEWrux2iOzdMQD1BFCfVtmTiibdJSJ8HPv6dwIlOjIC083jaNx4QHDXDyW
         U7hp9JOx4ze+WtF6BiHsl/BJ1CPLqlMQlox5PDu7XESeDOtfEqzawYwpBDgBVddrWf
         rRnDf+U2Feze6EWFljIGnTn2dJwXpqCnGoKGpzM1L4+3F3WoygB1nGN22HKNXlqWXC
         2nG4qVXNAZbGw==
Date:   Fri, 12 Feb 2021 12:59:58 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <l.sanfilippo@kunbus.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
Message-ID: <YCZfrjZGKVyWuglE@kernel.org>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <YByrCnswkIlz1w1t@kernel.org>
 <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
 <20210205172528.GP4718@ziepe.ca>
 <08ce58ab-3513-5d98-16a5-b197276f6bce@kunbus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08ce58ab-3513-5d98-16a5-b197276f6bce@kunbus.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 12:52:17PM +0100, Lino Sanfilippo wrote:
> Hi Jason,
> 
> On 05.02.21 18:25, Jason Gunthorpe wrote:
> > On Fri, Feb 05, 2021 at 08:48:11AM -0800, James Bottomley wrote:
> >>> Thanks for pointing this out. I'd strongly support Jason's proposal:
> >>>
> >>> https://lore.kernel.org/linux-integrity/20201215175624.GG5487@ziepe.ca/
> >>>
> >>> It's the best long-term way to fix this.
> >>
> >> Really, no it's not.  It introduces extra mechanism we don't need.
> > 
> >> To recap the issue: character devices already have an automatic
> >> mechanism which holds a reference to the struct device while the
> >> character node is open so the default is to release resources on final
> >> put of the struct device.
> > 
> > The refcount on the struct device only keeps the memory alive, it
> > doesn't say anything about the ops. We still need to lock and check
> > the ops each and every time they are used.
> > 
> > The fact cdev goes all the way till fput means we don't need the extra
> > get/put I suggested to Lino at all.
> > 
> >> The practical consequence of this model is that if you allocate a chip
> >> structure with tpm_chip_alloc() you have to release it again by doing a
> >> put of *both* devices.
> > 
> > The final put of the devs should be directly after the
> > cdev_device_del(), not in a devm. This became all confused because the
> > devs was created during alloc, not register. Having a device that is
> > initialized but will never be added is weird.
> > 
> > See sketch below.
> > 
> >> Stefan noticed the latter, so we got the bogus patch 8979b02aaf1d
> >> ("tpm: Fix reference count to main device") applied which simply breaks
> >> the master/slave model by not taking a reference on the master for the
> >> slave.  I'm not sure why I didn't notice the problem with this fix at
> >> the time, but attention must have been elsewhere.
> > 
> > Well, this is sort of OK because we never use the devs in TPM1, so we
> > end up freeing the chip with a positive refcount on the devs, which is
> > weird but not a functional bug.
> > 
> > Jason
> > 
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index ddaeceb7e10910..e07193a0dd4438 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -344,7 +344,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> >  	chip->dev_num = rc;
> >  
> >  	device_initialize(&chip->dev);
> > -	device_initialize(&chip->devs);
> >  
> >  	chip->dev.class = tpm_class;
> >  	chip->dev.class->shutdown_pre = tpm_class_shutdown;
> > @@ -352,29 +351,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> >  	chip->dev.parent = pdev;
> >  	chip->dev.groups = chip->groups;
> >  
> > -	chip->devs.parent = pdev;
> > -	chip->devs.class = tpmrm_class;
> > -	chip->devs.release = tpm_devs_release;
> > -	/* get extra reference on main device to hold on
> > -	 * behalf of devs.  This holds the chip structure
> > -	 * while cdevs is in use.  The corresponding put
> > -	 * is in the tpm_devs_release (TPM2 only)
> > -	 */
> > -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > -		get_device(&chip->dev);
> > -
> >  	if (chip->dev_num == 0)
> >  		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
> >  	else
> >  		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
> >  
> > -	chip->devs.devt =
> > -		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> > -
> >  	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
> > -	if (rc)
> > -		goto out;
> > -	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> >  	if (rc)
> >  		goto out;
> >  
> > @@ -382,9 +364,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> >  		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
> >  
> >  	cdev_init(&chip->cdev, &tpm_fops);
> > -	cdev_init(&chip->cdevs, &tpmrm_fops);
> >  	chip->cdev.owner = THIS_MODULE;
> > -	chip->cdevs.owner = THIS_MODULE;
> >  
> >  	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
> >  	if (rc) {
> > @@ -396,7 +376,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> >  	return chip;
> >  
> >  out:
> > -	put_device(&chip->devs);
> >  	put_device(&chip->dev);
> >  	return ERR_PTR(rc);
> >  }
> > @@ -445,13 +424,33 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> >  	}
> >  
> >  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > +		device_initialize(&chip->devs);
> > +		chip->devs.parent = pdev;
> > +		chip->devs.class = tpmrm_class;
> > +		rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> > +		if (rc)
> > +			goto out_put_devs;
> > +
> > +		/*
> > +                 * get extra reference on main device to hold on behalf of devs.
> > +                 * This holds the chip structure while cdevs is in use. The
> > +		 * corresponding put is in the tpm_devs_release.
> > +		 */
> > +		get_device(&chip->dev);
> > +		chip->devs.release = tpm_devs_release;
> > +
> > +		chip->devs.devt =
> > +			MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> > +		cdev_init(&chip->cdevs, &tpmrm_fops);
> > +		chip->cdevs.owner = THIS_MODULE;
> > +
> >  		rc = cdev_device_add(&chip->cdevs, &chip->devs);
> >  		if (rc) {
> >  			dev_err(&chip->devs,
> >  				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> >  				dev_name(&chip->devs), MAJOR(chip->devs.devt),
> >  				MINOR(chip->devs.devt), rc);
> > -			return rc;
> > +			goto out_put_devs;
> >  		}
> >  	}
> >  
> > @@ -460,6 +459,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> >  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> >  	mutex_unlock(&idr_lock);
> >  
> > +out_put_devs:
> > +	put_device(&chip->devs);
> > +out_del_dev:
> > +	cdev_device_del(&chip->cdev);
> >  	return rc;
> >  }
> >  
> > @@ -640,8 +643,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
> >  	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
> >  		hwrng_unregister(&chip->hwrng);
> >  	tpm_bios_log_teardown(chip);
> > -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> >  		cdev_device_del(&chip->cdevs, &chip->devs);
> > +		put_device(&chip->devs);
> > +	}
> >  	tpm_del_char_device(chip);
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_chip_unregister);
> > 
> 
> I tested the solution you scetched and it fixes the issue for me. Will
> you send a (real) patch for this?

One *option*:

1. You take the Jason's patch.
2. https://www.kernel.org/doc/html/v5.10/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

Just mentioning this, and spreading the knowledge about co-developed-by.

> Best regards,
> Lino

/Jarkko
