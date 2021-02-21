Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B9320A8F
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 14:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhBUN0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 08:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229914AbhBUN0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 08:26:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE70B60230;
        Sun, 21 Feb 2021 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613913921;
        bh=nQ8cbL5l2J/S9smkvuInScvbHXN8c/orZm+jlM6mP3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=acDINoQ266bJ13ikO19j5jDyVbGCpz46Rz8f0dBJM7oFleorAGihjlShLhHVFD5sj
         T4jGaumic3CeGl7/o2MfFlFDYcRJO9fJZrMO9aE/FrPsCkq61njHd5ZbTk3xluxDsa
         3WnGfzyrYMYy34xZJwWKAceYpwOBK6nqNqel9cjGgcC2XRgeg9/f2nBzrVvU4ifqOl
         ypXpDvhFezQEsnotd/Kkn1fgUgKevHG2kBcz+XHT1XYv+hR3pkbR6ve5DXYmN1hLzb
         AKZjrTvKVEpLuKD+JT63UTdTsDN2S276gNvrkNDqyoORV4VVvrgVEqZQ4HDkmrKEQ3
         t4CVbOZnAta1g==
Date:   Sun, 21 Feb 2021 15:25:06 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, David.Laight@aculab.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v6] tpm: fix reference counting for struct tpm_chip
Message-ID: <YDJfMll1rwA2idDC@kernel.org>
References: <1613680181-31920-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613680181-31920-2-git-send-email-LinoSanfilippo@gmx.de>
 <YC+BRfvtA3n7yeaR@kernel.org>
 <aa2ec878-f8ea-d28b-c7c2-ecdc3d19f71e@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa2ec878-f8ea-d28b-c7c2-ecdc3d19f71e@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 21, 2021 at 11:19:28AM +0100, Lino Sanfilippo wrote:
> 
> Hi,
> 
> On 19.02.21 at 10:13, Jarkko Sakkinen wrote:
> 
> >> +	rc = cdev_device_add(&chip->cdevs, &chip->devs);
> >> +	if (rc) {
> >> +		dev_err(&chip->devs,
> >> +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> >> +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
> >> +			MINOR(chip->devs.devt), rc);
> >> +		goto out_put_devs;
> >> +	}
> >> +
> >> +	return 0;
> >> +
> >> +out_put_devs:
> >
> > A nit:
> >
> > 1. You have already del_cdev:
> > 2. Here you use a differing convention with out prefix.
> >
> > I'd suggest that you put err_ to both:
> >
> > 1. err_del_cdev
> > 2. err_put_devs
> >
> > It's quite coherent what we have already:
> >
> > linux-tpmdd on  next took 8s
> > ❯ git grep "^err_.*" drivers/char/tpm/ |  wc -l
> > 17
> >
> 
> 
> The label del_cdev is indeed a bit inconsistent with the rest of the code.
> But AFAICS out_put_devs is not:
> 1. all labels in tpm2-space.c start with out_
> 2. there are more hits for out_ across the whole TPM code (i.e. with the same command
> you used above I get 31 hits for _out) than for err_.
> 
> I suggest to rename del_cdev to something like out_del_cdev or maybe out_cdev which
> seems to be even closer to the existing naming scheme for labels.

OK, that makes sense, thanks!

> Regards,
> Lino

/Jarkko
