Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFAC31E1DE
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 23:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhBQWPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 17:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233233AbhBQWPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 17:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 439F964E2E;
        Wed, 17 Feb 2021 22:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613600063;
        bh=ho1u7e2w9JqRpncq9x3PVMnODQbvW5QEt8tn93vzJDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PPrvYo5RJObFV0zjf5rzkzzapHf0JGpLxtwvpJjTuWUd9J8luci8STuUrqMme1RV2
         xXFLd8ToKs4xg2hW0BOXPx8a/RNbIf9e2NsTwvbuvJOAYmpOaIP6zsiTdbPBC6akRo
         owhyPWHr8OuMIVPnoAG/kXdymfk1UHCN/KsFDIG2Qb8+zHFu4y//geHjEQGJ3c1uGQ
         vEt2PBFi35Z/5PH8E9HF0sR92BWgpdaZpNzMAQtzcgUj2FOtue6kslFiER90iq4peO
         vclFYizMkxMaeV6068IjeoHyjjZJohhe9uTHzl81u7f/44bDiE+Vfj0KQ3HjGJwo7Y
         7XuzVq2/yCdIA==
Date:   Thu, 18 Feb 2021 00:14:11 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        "peterhuewe@gmx.de" <peterhuewe@gmx.de>,
        "stefanb@linux.vnet.ibm.com" <stefanb@linux.vnet.ibm.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@hansenpartnership.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
Message-ID: <YC2VM1JI0tECPs7g@kernel.org>
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210216125342.GU4718@ziepe.ca>
 <YCvtF4qfG35tHM5e@kernel.org>
 <74bbc76260594a8a8f7993ab66cca104@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74bbc76260594a8a8f7993ab66cca104@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 04:31:26PM +0000, David Laight wrote:
> ...
> > > > +	get_device(&chip->dev);
> > > > +	chip->devs.release = tpm_devs_release;
> > > > +	chip->devs.devt =
> > > > +		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> > 
> > Isn't this less than 100 chars?
> 
> Still best kept under 80 if 'reasonable'?
> 
> Really it is just split in the wrong place:
> 	chip->devs.devt = MKDEV(MAJOR(tpm_devt),
> 					chip->dev_num + TPM_NUM_DEVICES);


Well it looks crap IMHO. Would be more reasonable to have it in a single 
like. And it is legit too, since it is accepted by checkpatch.

You might break the lines within 80 chars if it is somehow "logically"
consistent.

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 

/Jarkko
