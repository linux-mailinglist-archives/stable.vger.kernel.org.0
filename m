Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1C231CDA4
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 17:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhBPQKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 11:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhBPQKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 11:10:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F33464DE0;
        Tue, 16 Feb 2021 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613491799;
        bh=T8z4FJ8TFARXixQ5KCdrCvlpeBamrvRhdKdPYXzvLf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QxCPMsdiP1kSav4wMJzVNPCLGSNTuI0geryHe+g8JYhS/hn8fu3EPwx8V9KH6FHGP
         K8YO3v4ArJszGPImvrUUMGrX08Ifqr4Luw34L+utjp4ZvvQ1FPQqm4L0/vGFq+c12n
         aDSpR9Zhzm1/7dDzpEKeEPhvVT0t3QAYTvcOT4lPDJfo4Znu4dv4O756Be6khtwERL
         qgjiAmfX+7lc0kqaOYp/uLePcb9y29ve7hTBgy3AnL4mS7LxPWqfwH1a4A6WJVjHeM
         Adjo0wby5B54ooOgaJEa9Tzzu5hReWX+cqoifFL9L0GlJEpo8dgcJr3Std5Hvacg9M
         O55wy2f48uchA==
Date:   Tue, 16 Feb 2021 18:09:47 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        stefanb@linux.vnet.ibm.com, James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
Message-ID: <YCvuS9cIT7umOjhy@kernel.org>
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210216125342.GU4718@ziepe.ca>
 <YCvtF4qfG35tHM5e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCvtF4qfG35tHM5e@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 06:04:42PM +0200, Jarkko Sakkinen wrote:
> On Tue, Feb 16, 2021 at 08:53:42AM -0400, Jason Gunthorpe wrote:
> > On Tue, Feb 16, 2021 at 01:31:00AM +0100, Lino Sanfilippo wrote:
> > >  
> > > +static int tpm_add_tpm2_char_device(struct tpm_chip *chip)
> 
> BTW, this naming is crap.
> 
> - 2x tpm
> - char is useless
> 
> -> tpm2_add_device

Actually, tpm2s_add_device() add put it to tpm2-space.c.

> > > +{
> > > +	int rc;
> > > +
> > > +	device_initialize(&chip->devs);
> > > +	chip->devs.parent = chip->dev.parent;
> > > +	chip->devs.class = tpmrm_class;
> > > +
> > > +	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> > > +	if (rc)
> > > +		goto out_put_devs;
> 
> Right, and empty line missing here.
> 
> > > +	/*
> > > +	 * get extra reference on main device to hold on behalf of devs.
> > > +	 * This holds the chip structure while cdevs is in use. The
> > > +	 * corresponding put is in the tpm_devs_release.
> > > +	 */
> > > +	get_device(&chip->dev);
> > > +	chip->devs.release = tpm_devs_release;
> > > +	chip->devs.devt =
> > > +		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> 
> Isn't this less than 100 chars?
> 
> > > +	cdev_init(&chip->cdevs, &tpmrm_fops);
> > > +	chip->cdevs.owner = THIS_MODULE;
> > > +
> > > +	rc = cdev_device_add(&chip->cdevs, &chip->devs);
> > > +	if (rc) {
> > > +		dev_err(&chip->devs,
> > > +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> > > +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
> > > +			MINOR(chip->devs.devt), rc);
> > > +		goto out_put_devs;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +out_put_devs:
> > > +	put_device(&chip->devs);
> > 
> > I'd rather you organize this so chip->devs.release and the get_device
> > is always sent instead of having the possiblity for a put_device that
> > doesn't call release
> 
> /Jarkko
