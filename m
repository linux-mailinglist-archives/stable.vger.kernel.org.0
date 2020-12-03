Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC9E2CDD4E
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 19:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbgLCSXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 13:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgLCSXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 13:23:43 -0500
Date:   Thu, 3 Dec 2020 19:24:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607019783;
        bh=nRXtesF7itSWsJNL3nW9/JfPzZbpQfZ44W7acNczB0M=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qa40vJsECiADdzvc+lDaBEeTMw1R/jqeFEM51AHxmj44iGPX4tt+7aMXy8oGTMGGd
         xM1zJNaSohmdb5J2tTNpsgkorU2xOE2oGpdB3YC4R7NtpQ9RAhjl82YmVMyMOsx0p1
         C37kca9C4dGklVx5uSSPv1Yzct+qK041zQPJ0+Sc=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor.Ambarus@microchip.com
Cc:     michael@walle.cc, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, boris.brezillon@collabora.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
Message-ID: <X8ktStibpw1phn4G@kroah.com>
References: <20201202230040.14009-1-michael@walle.cc>
 <20201202230040.14009-2-michael@walle.cc>
 <44be8e3c-86ca-501e-e575-55f17747bda6@microchip.com>
 <bf31d41ca489b5d1b7976bfb8ede88e9@walle.cc>
 <2c66659b-ecff-c6bb-38c1-c1172780c710@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c66659b-ecff-c6bb-38c1-c1172780c710@microchip.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 03:08:49PM +0000, Tudor.Ambarus@microchip.com wrote:
> On 12/3/20 4:39 PM, Michael Walle wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > Am 2020-12-03 15:34, schrieb Tudor.Ambarus@microchip.com:
> >> On 12/3/20 1:00 AM, Michael Walle wrote:
> >>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
> >>> the content is safe
> >>>
> >>> This flash part actually has 4 block protection bits.
> >>>
> >>> Reported-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> >>> Cc: stable@vger.kernel.org # v5.7+
> >>
> >> While the patch is correct according to the datasheet, it was
> >> not tested, so it's not a candidate for stable. I would update
> >> the commit message to indicate that the the patch was made
> >> solely on datasheet info and not tested, I would add the fixes
> >> tag, and strip cc-ing to stable.
> > 
> > What is the difference? Any commit with a Fixes tag will also land
> > in the stable trees. Just that it will cause compile errors for
> > kernel older than 5.7.
> > 
> > So if you don't want to have it in stable then you must not add
> > a Fixes: tag either.
> > 
> 
> Documentation/process/stable-kernel-rules.rst doesn't say that the
> Fixes tag is a guarantee that a patch will hit the stable kernels.
> 
> Since this patch was not tested, it's not a candidate for stable as
> per the first rule. It's a theoretical fix, because it should indeed
> fix the locking as per the datasheet. Even for theoretical fixes, I
> would like to know what commit broke the functionality, and that's why
> I asked for the Fixes tag.
> 
> We don't want the patch in stable, so that's why I said that I would
> indicate in the commit message that it was not tested, and that I
> would strip the cc to stable.
> 
> Maybe it's just my understanding. Others may help.

Your understanding is correct.  But note that we might accidentally pick
it up with the Fixes: tag at a later date, so be aware that you might
want to make the text in the changelog really obvious that it should not
go into a stable kernel, and why not (hint, if you have a Fixes: tag,
that's usually a good reason _to_ include it...)

thanks,

greg k-h
