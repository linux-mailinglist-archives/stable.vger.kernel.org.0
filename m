Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B076310EA9
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhBEPqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbhBEPns (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:43:48 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F6C061574
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 09:25:30 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id x81so7682036qkb.0
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 09:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gYCWCHzWNYrqUIFpcjQGBigsKmu/xjSezoVKxDf9cQk=;
        b=C41uh8xblqnUmPuFfn67XLXLGiG2mslENYIXY5IHLMyCqRdBLbD4VPhCgbTBc6TmZv
         B9cOEfATWuFB4qniCijFLw3ibeOXtSzXA4s7zh9kh4fpUXVTmPF8RccGzlxr14rh1QGG
         JZnUiWWxbLDfxX6nG2bcyndf7l3FjeS3hEJNSXlY8iHPqYSh8xnIT3pVfn3LSAWXLP7p
         T1p/e9oLAFRyj+BB8UAjf2v8FFx243OgSxCfXVX2NCUj9L0UPBzb77wV+IFVdFAaHkF9
         JDXlvyoLdNM6Bq9lMbVdwASTqoy8YQh3oDuNsHbHG9EeteplgoSuBdL0SRClWJTC2FeT
         uawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gYCWCHzWNYrqUIFpcjQGBigsKmu/xjSezoVKxDf9cQk=;
        b=aYatnQ7e+zdD9SmxZQi2DYqWzRajflAtinQVe07pNGstjQVw3NS3V8oT3FCHv0PzOD
         5lwMv+N2276TnvuLwli5fYIR9rnHQUG1G8o2i/WW9mrN+hibP+OgrNRWFQ7iv76+TBdN
         Xh9cbN784lTLn9r4w0rA53VQuHDYC02u93bf7Qqx3sJ6fi/p1oZcDSV4J71YWn5UBs2n
         ejExcp632iyVCjhlv1rNUtPBaZ16pve5vyo5jHKjjD+jPRafBtx5x91V3ks2q2CPBCPz
         fcEGtsx7wDwkmPoFffXALpGPEgXC90COPqQOn/DDJVDbNIDYzLN/Mh2BwxcR7PzWAYIQ
         /Zug==
X-Gm-Message-State: AOAM531LUNCHUmOiaXeA6fHUvz+zsQh/F84R9/mzU+h2Lj+3haZFlcEN
        Ow54A8S06bylx19vAK4xzUjkag==
X-Google-Smtp-Source: ABdhPJxuZFNNv1vLvpgwgRTBZO7AkqN44W+Ag7bzdmAO0tlBCs6gcbIitnVY2IcssYpUSaBMhbi46A==
X-Received: by 2002:a37:8884:: with SMTP id k126mr5164153qkd.104.1612545929201;
        Fri, 05 Feb 2021 09:25:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id 18sm10015024qkl.20.2021.02.05.09.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:25:28 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l84rI-003yPG-5R; Fri, 05 Feb 2021 13:25:28 -0400
Date:   Fri, 5 Feb 2021 13:25:28 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
Message-ID: <20210205172528.GP4718@ziepe.ca>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <YByrCnswkIlz1w1t@kernel.org>
 <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 08:48:11AM -0800, James Bottomley wrote:
> > Thanks for pointing this out. I'd strongly support Jason's proposal:
> > 
> > https://lore.kernel.org/linux-integrity/20201215175624.GG5487@ziepe.ca/
> > 
> > It's the best long-term way to fix this.
> 
> Really, no it's not.  It introduces extra mechanism we don't need.

> To recap the issue: character devices already have an automatic
> mechanism which holds a reference to the struct device while the
> character node is open so the default is to release resources on final
> put of the struct device.

The refcount on the struct device only keeps the memory alive, it
doesn't say anything about the ops. We still need to lock and check
the ops each and every time they are used.

The fact cdev goes all the way till fput means we don't need the extra
get/put I suggested to Lino at all.

> The practical consequence of this model is that if you allocate a chip
> structure with tpm_chip_alloc() you have to release it again by doing a
> put of *both* devices.

The final put of the devs should be directly after the
cdev_device_del(), not in a devm. This became all confused because the
devs was created during alloc, not register. Having a device that is
initialized but will never be added is weird.

See sketch below.

> Stefan noticed the latter, so we got the bogus patch 8979b02aaf1d
> ("tpm: Fix reference count to main device") applied which simply breaks
> the master/slave model by not taking a reference on the master for the
> slave.  I'm not sure why I didn't notice the problem with this fix at
> the time, but attention must have been elsewhere.

Well, this is sort of OK because we never use the devs in TPM1, so we
end up freeing the chip with a positive refcount on the devs, which is
weird but not a functional bug.

Jason

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index ddaeceb7e10910..e07193a0dd4438 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -344,7 +344,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->dev_num = rc;
 
 	device_initialize(&chip->dev);
-	device_initialize(&chip->devs);
 
 	chip->dev.class = tpm_class;
 	chip->dev.class->shutdown_pre = tpm_class_shutdown;
@@ -352,29 +351,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
 
-	chip->devs.parent = pdev;
-	chip->devs.class = tpmrm_class;
-	chip->devs.release = tpm_devs_release;
-	/* get extra reference on main device to hold on
-	 * behalf of devs.  This holds the chip structure
-	 * while cdevs is in use.  The corresponding put
-	 * is in the tpm_devs_release (TPM2 only)
-	 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		get_device(&chip->dev);
-
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	chip->devs.devt =
-		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
-
 	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
-	if (rc)
-		goto out;
-	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
 	if (rc)
 		goto out;
 
@@ -382,9 +364,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
 
 	cdev_init(&chip->cdev, &tpm_fops);
-	cdev_init(&chip->cdevs, &tpmrm_fops);
 	chip->cdev.owner = THIS_MODULE;
-	chip->cdevs.owner = THIS_MODULE;
 
 	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
@@ -396,7 +376,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	return chip;
 
 out:
-	put_device(&chip->devs);
 	put_device(&chip->dev);
 	return ERR_PTR(rc);
 }
@@ -445,13 +424,33 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 	}
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		device_initialize(&chip->devs);
+		chip->devs.parent = pdev;
+		chip->devs.class = tpmrm_class;
+		rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
+		if (rc)
+			goto out_put_devs;
+
+		/*
+                 * get extra reference on main device to hold on behalf of devs.
+                 * This holds the chip structure while cdevs is in use. The
+		 * corresponding put is in the tpm_devs_release.
+		 */
+		get_device(&chip->dev);
+		chip->devs.release = tpm_devs_release;
+
+		chip->devs.devt =
+			MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
+		cdev_init(&chip->cdevs, &tpmrm_fops);
+		chip->cdevs.owner = THIS_MODULE;
+
 		rc = cdev_device_add(&chip->cdevs, &chip->devs);
 		if (rc) {
 			dev_err(&chip->devs,
 				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
 				dev_name(&chip->devs), MAJOR(chip->devs.devt),
 				MINOR(chip->devs.devt), rc);
-			return rc;
+			goto out_put_devs;
 		}
 	}
 
@@ -460,6 +459,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 	idr_replace(&dev_nums_idr, chip, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
+out_put_devs:
+	put_device(&chip->devs);
+out_del_dev:
+	cdev_device_del(&chip->cdev);
 	return rc;
 }
 
@@ -640,8 +643,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
 		hwrng_unregister(&chip->hwrng);
 	tpm_bios_log_teardown(chip);
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		cdev_device_del(&chip->cdevs, &chip->devs);
+		put_device(&chip->devs);
+	}
 	tpm_del_char_device(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
