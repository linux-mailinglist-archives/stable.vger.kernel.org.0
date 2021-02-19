Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B57831F646
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 10:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBSJIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 04:08:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229953AbhBSJGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 04:06:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B86F64E5C;
        Fri, 19 Feb 2021 09:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613725569;
        bh=9gCM57rLof4KH7lXmy+UmvuKw9FROg+FI9WlxlntM6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HF6TCyaLMin7eWw4jcFe+dmeJli3eaPGNiRqFJOdifpw3v3jT+JZYAaUBeXZy74Go
         aeiwwSMCGDPuDcaeovq08+UTBhBykv6GzjbK79+AN4G3Z294+JgpaFB6c2ldOXfDGH
         KGoZJ2CBsqQSsqeQ3wVPGEav0wxTPIPxyuxdIew4rJ2erUfLcnJ2GE8PMM1ofzS5dy
         hqLP0Et4AKssHZqw1fH+RJNZDAe0vFzDiJ91PXDYRg2nSQ/1VkTFxka46a4mvxtP7F
         OjPhJ+HLcsd7zYl/fiwPqNZft4tb1qzXCfzpUGYAqjgCY16xVibPybPOMfK79UnnCy
         7B20K57epD1kw==
Date:   Fri, 19 Feb 2021 11:05:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@aculab.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH RESEND v5] tpm: fix reference counting for struct tpm_chip
Message-ID: <YC9/cr9Km/jWzmon@kernel.org>
References: <1613505191-4602-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613505191-4602-2-git-send-email-LinoSanfilippo@gmx.de>
 <YC2WRJfNbY22yIOn@kernel.org>
 <5d0f7222-a9ef-809b-cd9a-86bbacb03790@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d0f7222-a9ef-809b-cd9a-86bbacb03790@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 08:13:57PM +0100, Lino Sanfilippo wrote:
> 
> Hi,
> 
> On 17.02.21 at 23:18, Jarkko Sakkinen wrote:
> 
> >> +
> >
> > /*
> >  * Please describe what the heck the function does. No need for full on
> >  * kdoc.
> >  */
> 
> Ok.
> 
> >> +int tpm2_add_device(struct tpm_chip *chip)
> >
> > Please, rename as tpm_devs_add for coherency sake.
> >
> 
> Sorry I confused this and renamed it wrongly. I will fix it in the next
> patch version.
> 
> >> +{
> >> +	int rc;
> >> +
> >> +	device_initialize(&chip->devs);
> >> +	chip->devs.parent = chip->dev.parent;
> >> +	chip->devs.class = tpmrm_class;
> >
> > Empty line. Cannot recall, if I stated before.
> >> +	/* +	 * get extra reference on main device to hold on behalf of devs.
> >> +	 * This holds the chip structure while cdevs is in use. The
> >> +	 * corresponding put is in the tpm_devs_release.
> >> +	 */
> >> +	get_device(&chip->dev);
> >> +	chip->devs.release = tpm_devs_release;
> >> +	chip->devs.devt = MKDEV(MAJOR(tpm_devt),
> >> +					chip->dev_num + TPM_NUM_DEVICES);
> >
> > NAK, same comment as before.
> >
> 
> Thx for the review, I will fix these issues.

Yeah, I mean I'm going to collect this fix anyway after rc1 has been
released so there's a lot of time to polish small details. I.e. I'm
doing a PR for rc2 with the fix included.

> Regards,
> Lino

/Jarkko
