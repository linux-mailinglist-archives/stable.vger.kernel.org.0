Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8554E31F66A
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 10:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhBSJRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 04:17:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhBSJQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 04:16:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A618764DED;
        Fri, 19 Feb 2021 09:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613726125;
        bh=aNg0vsuvUb0LtDI824VmYTwntH+mQFXOQD79zCUOv5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=en8Ek/Kw4uhKYikR8oywZYN1Eb2txnSYXmyQ6SUJe2U+6No8Q62E7AoHI0khHVs+i
         BtnY6itoNK+P2g34cb+KYHLJRYDSMMxivbgi+z2EgcYAAYoy59U0dfFbdCsSixdblX
         P2OSAraBSRH6K8ngf3p1IFG35WrhWA/ju1MT7Df/Uba67SOihQVp+f4rT4xhFivAcO
         PAb1sAGowXqY3bc8GT34DYHp1+N9jTV8UtrXHTOKc51GUwGy6T/0qFk2GOpUJn77nj
         BKjPgAP/ilTEfCSOaMxlJppK2b1OTR3e+RPLhCboaRQPvZ7YKOFFrnEXQ29HastR3u
         zZ2Eud4+11dzQ==
Date:   Fri, 19 Feb 2021 11:15:10 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@aculab.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v6] tpm: fix reference counting for struct tpm_chip
Message-ID: <YC+BnlFIfqKEcTh6@kernel.org>
References: <1613680181-31920-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613680181-31920-2-git-send-email-LinoSanfilippo@gmx.de>
 <YC+BRfvtA3n7yeaR@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YC+BRfvtA3n7yeaR@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 19, 2021 at 11:13:45AM +0200, Jarkko Sakkinen wrote:
> On Thu, Feb 18, 2021 at 09:29:41PM +0100, Lino Sanfilippo wrote:
> > From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> > 
> > The following sequence of operations results in a refcount warning:
> > 
> > 1. Open device /dev/tpmrm.
> > 2. Remove module tpm_tis_spi.
> > 3. Write a TPM command to the file descriptor opened at step 1.
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 3 PID: 1161 at lib/refcount.c:25 kobject_get+0xa0/0xa4
> > refcount_t: addition on 0; use-after-free.
> > Modules linked in: tpm_tis_spi tpm_tis_core tpm mdio_bcm_unimac brcmfmac
> > sha256_generic libsha256 sha256_arm hci_uart btbcm bluetooth cfg80211 vc4
> > brcmutil ecdh_generic ecc snd_soc_core crc32_arm_ce libaes
> > raspberrypi_hwmon ac97_bus snd_pcm_dmaengine bcm2711_thermal snd_pcm
> > snd_timer genet snd phy_generic soundcore [last unloaded: spi_bcm2835]
> > CPU: 3 PID: 1161 Comm: hold_open Not tainted 5.10.0ls-main-dirty #2
> > Hardware name: BCM2711
> > [<c0410c3c>] (unwind_backtrace) from [<c040b580>] (show_stack+0x10/0x14)
> > [<c040b580>] (show_stack) from [<c1092174>] (dump_stack+0xc4/0xd8)
> > [<c1092174>] (dump_stack) from [<c0445a30>] (__warn+0x104/0x108)
> > [<c0445a30>] (__warn) from [<c0445aa8>] (warn_slowpath_fmt+0x74/0xb8)
> > [<c0445aa8>] (warn_slowpath_fmt) from [<c08435d0>] (kobject_get+0xa0/0xa4)
> > [<c08435d0>] (kobject_get) from [<bf0a715c>] (tpm_try_get_ops+0x14/0x54 [tpm])
> > [<bf0a715c>] (tpm_try_get_ops [tpm]) from [<bf0a7d6c>] (tpm_common_write+0x38/0x60 [tpm])
> > [<bf0a7d6c>] (tpm_common_write [tpm]) from [<c05a7ac0>] (vfs_write+0xc4/0x3c0)
> > [<c05a7ac0>] (vfs_write) from [<c05a7ee4>] (ksys_write+0x58/0xcc)
> > [<c05a7ee4>] (ksys_write) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
> > Exception stack(0xc226bfa8 to 0xc226bff0)
> > bfa0:                   00000000 000105b4 00000003 beafe664 00000014 00000000
> > bfc0: 00000000 000105b4 000103f8 00000004 00000000 00000000 b6f9c000 beafe684
> > bfe0: 0000006c beafe648 0001056c b6eb6944
> > ---[ end trace d4b8409def9b8b1f ]---
> > 
> > The reason for this warning is the attempt to get the chip->dev reference
> > in tpm_common_write() although the reference counter is already zero.
> > 
> > Since commit 8979b02aaf1d ("tpm: Fix reference count to main device") the
> > extra reference used to prevent a premature zero counter is never taken,
> > because the required TPM_CHIP_FLAG_TPM2 flag is never set.
> > 
> > Fix this by moving the TPM 2 character device handling from
> > tpm_chip_alloc() to tpm_add_char_device() which is called at a later point
> > in time when the flag has been set in case of TPM2.
> > 
> > Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> > already introduced function tpm_devs_release() to release the extra
> > reference but did not implement the required put on chip->devs that results
> > in the call of this function.
> > 
> > Fix this by putting chip->devs in tpm_chip_unregister().
> > 
> > Finally move the new implementation for the TPM 2 handling into a new
> > function to avoid multiple checks for the TPM_CHIP_FLAG_TPM2 flag in the
> > good case and error cases.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
> > Fixes: 8979b02aaf1d ("tpm: Fix reference count to main device")
> > Co-developed-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> > ---
> >  drivers/char/tpm/tpm-chip.c   | 48 ++++++++-----------------------------
> >  drivers/char/tpm/tpm.h        |  1 +
> >  drivers/char/tpm/tpm2-space.c | 55 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 66 insertions(+), 38 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index ddaeceb..ae6e414 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -274,14 +274,6 @@ static void tpm_dev_release(struct device *dev)
> >  	kfree(chip);
> >  }
> >  
> > -static void tpm_devs_release(struct device *dev)
> > -{
> > -	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
> > -
> > -	/* release the master device reference */
> > -	put_device(&chip->dev);
> > -}
> > -
> >  /**
> >   * tpm_class_shutdown() - prepare the TPM device for loss of power.
> >   * @dev: device to which the chip is associated.
> > @@ -344,7 +336,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> >  	chip->dev_num = rc;
> >  
> >  	device_initialize(&chip->dev);
> > -	device_initialize(&chip->devs);
> >  
> >  	chip->dev.class = tpm_class;
> >  	chip->dev.class->shutdown_pre = tpm_class_shutdown;
> > @@ -352,39 +343,20 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
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
> >  	if (rc)
> >  		goto out;
> > -	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> > -	if (rc)
> > -		goto out;
> >  
> >  	if (!pdev)
> >  		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
> >  
> >  	cdev_init(&chip->cdev, &tpm_fops);
> > -	cdev_init(&chip->cdevs, &tpmrm_fops);
> >  	chip->cdev.owner = THIS_MODULE;
> > -	chip->cdevs.owner = THIS_MODULE;
> >  
> >  	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
> >  	if (rc) {
> > @@ -396,7 +368,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
> >  	return chip;
> >  
> >  out:
> > -	put_device(&chip->devs);
> >  	put_device(&chip->dev);
> >  	return ERR_PTR(rc);
> >  }
> > @@ -445,14 +416,9 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> >  	}
> >  
> >  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > -		rc = cdev_device_add(&chip->cdevs, &chip->devs);
> > -		if (rc) {
> > -			dev_err(&chip->devs,
> > -				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> > -				dev_name(&chip->devs), MAJOR(chip->devs.devt),
> > -				MINOR(chip->devs.devt), rc);
> > -			return rc;
> > -		}
> > +		rc = tpm_devs_add(chip);
> > +		if (rc)
> > +			goto del_cdev;
> >  	}
> >  
> >  	/* Make the chip available. */
> > @@ -460,6 +426,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> >  	idr_replace(&dev_nums_idr, chip, chip->dev_num);
> >  	mutex_unlock(&idr_lock);
> >  
> > +	return 0;
> > +
> > +del_cdev:
> > +	cdev_device_del(&chip->cdev, &chip->dev);
> >  	return rc;
> >  }
> >  
> > @@ -640,8 +610,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
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
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index 947d1db..ac4b2dc 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -238,6 +238,7 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
> >  		       size_t cmdsiz);
> >  int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space, void *buf,
> >  		      size_t *bufsiz);
> > +int tpm_devs_add(struct tpm_chip *chip);
> >  
> >  void tpm_bios_log_setup(struct tpm_chip *chip);
> >  void tpm_bios_log_teardown(struct tpm_chip *chip);
> > diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> > index 784b8b3..6d17f77 100644
> > --- a/drivers/char/tpm/tpm2-space.c
> > +++ b/drivers/char/tpm/tpm2-space.c
> > @@ -571,3 +571,58 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
> >  	dev_err(&chip->dev, "%s: error %d\n", __func__, rc);
> >  	return rc;
> >  }
> > +
> > +/*
> > + * Put the reference to the main device.
> > + */
> > +static void tpm_devs_release(struct device *dev)
> > +{
> > +	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
> > +
> > +	/* release the master device reference */
> > +	put_device(&chip->dev);
> > +}
> > +
> > +/*
> > + * Add a device file to expose TPM spaces. Also take a reference to the
> > + * main device.
> > + */
> > +int tpm_devs_add(struct tpm_chip *chip)
> > +{
> > +	int rc;
> > +
> > +	device_initialize(&chip->devs);
> > +	chip->devs.parent = chip->dev.parent;
> > +	chip->devs.class = tpmrm_class;
> > +
> > +	/*
> > +	 * Get extra reference on main device to hold on behalf of devs.
> > +	 * This holds the chip structure while cdevs is in use. The
> > +	 * corresponding put is in the tpm_devs_release.
> > +	 */
> > +	get_device(&chip->dev);
> > +	chip->devs.release = tpm_devs_release;
> > +	chip->devs.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> > +	cdev_init(&chip->cdevs, &tpmrm_fops);
> > +	chip->cdevs.owner = THIS_MODULE;
> > +
> > +	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> > +	if (rc)
> > +		goto out_put_devs;
> > +
> > +	rc = cdev_device_add(&chip->cdevs, &chip->devs);
> > +	if (rc) {
> > +		dev_err(&chip->devs,
> > +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> > +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
> > +			MINOR(chip->devs.devt), rc);
> > +		goto out_put_devs;
> > +	}
> > +
> > +	return 0;
> > +
> > +out_put_devs:
> 
> A nit:
> 
> 1. You have already del_cdev:
> 2. Here you use a differing convention with out prefix.
> 
> I'd suggest that you put err_ to both:
> 
> 1. err_del_cdev
> 2. err_put_devs
> 
> It's quite coherent what we have already:
> 
> linux-tpmdd on  next took 8s 
> ❯ git grep "^err_.*" drivers/char/tpm/ |  wc -l
> 17

I guess there's some ambiguity with this, but IMHO makes a lot of
sense for code blocks *only* executed as an exception handler.

/Jarkko
