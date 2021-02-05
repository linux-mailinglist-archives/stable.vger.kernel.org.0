Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FF431120F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhBEScz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhBEPLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:11:04 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6BC06178B;
        Fri,  5 Feb 2021 08:48:13 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6B8A4128054D;
        Fri,  5 Feb 2021 08:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612543692;
        bh=Qk86HJsAGCaa5VEyh7ydTPuNgosuMGRMD3HFh6dLzss=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Hxz21Tao/GbJoa/uOmu/9DH68/NGSLP2NwsU2Y49tdfoL1mfzQazA44sPgDjAe6kZ
         vtX72RHRZHPaf603yKX8ODOWHTIulSgIKAphGt1ho+yoU3Up3nwCer8qMmLGA270rX
         174B/CE8xdehPct3Ta64JFxIiKxmnqFBy2W7Toko=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RqzctNyNHdIN; Fri,  5 Feb 2021 08:48:12 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id D1B091280542;
        Fri,  5 Feb 2021 08:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612543692;
        bh=Qk86HJsAGCaa5VEyh7ydTPuNgosuMGRMD3HFh6dLzss=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Hxz21Tao/GbJoa/uOmu/9DH68/NGSLP2NwsU2Y49tdfoL1mfzQazA44sPgDjAe6kZ
         vtX72RHRZHPaf603yKX8ODOWHTIulSgIKAphGt1ho+yoU3Up3nwCer8qMmLGA270rX
         174B/CE8xdehPct3Ta64JFxIiKxmnqFBy2W7Toko=
Message-ID: <ee4adfbb99273e1bdceca210bc1fa5f16a50c415.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Date:   Fri, 05 Feb 2021 08:48:11 -0800
In-Reply-To: <YByrCnswkIlz1w1t@kernel.org>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
         <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
         <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
         <YByrCnswkIlz1w1t@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-02-05 at 04:18 +0200, Jarkko Sakkinen wrote:
> On Thu, Feb 04, 2021 at 04:34:11PM -0800, James Bottomley wrote:
> > On Fri, 2021-02-05 at 00:50 +0100, Lino Sanfilippo wrote:
> > > From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> > > 
> > > In tpm2_del_space() chip->ops is used for flushing the sessions.
> > > However
> > > this function may be called after tpm_chip_unregister() which
> > > sets
> > > the chip->ops pointer to NULL.
> > > Avoid a possible NULL pointer dereference by checking if chip-
> > > >ops is
> > > still
> > > valid before accessing it.
> > > 
> > > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of
> > > tpm_transmit()")
> > > Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> > > ---
> > >  drivers/char/tpm/tpm2-space.c | 15 ++++++++++-----
> > >  1 file changed, 10 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm2-space.c
> > > b/drivers/char/tpm/tpm2-
> > > space.c
> > > index 784b8b3..9a29a40 100644
> > > --- a/drivers/char/tpm/tpm2-space.c
> > > +++ b/drivers/char/tpm/tpm2-space.c
> > > @@ -58,12 +58,17 @@ int tpm2_init_space(struct tpm_space *space,
> > > unsigned int buf_size)
> > >  
> > >  void tpm2_del_space(struct tpm_chip *chip, struct tpm_space
> > > *space)
> > >  {
> > > -	mutex_lock(&chip->tpm_mutex);
> > > -	if (!tpm_chip_start(chip)) {
> > > -		tpm2_flush_sessions(chip, space);
> > > -		tpm_chip_stop(chip);
> > > +	down_read(&chip->ops_sem);
> > > +	if (chip->ops) {
> > > +		mutex_lock(&chip->tpm_mutex);
> > > +		if (!tpm_chip_start(chip)) {
> > > +			tpm2_flush_sessions(chip, space);
> > > +			tpm_chip_stop(chip);
> > > +		}
> > > +		mutex_unlock(&chip->tpm_mutex);
> > >  	}
> > > -	mutex_unlock(&chip->tpm_mutex);
> > > +	up_read(&chip->ops_sem);
> > > +
> > >  	kfree(space->context_buf);
> > >  	kfree(space->session_buf);
> > >  }
> > 
> > Actually, this still isn't right.  As I said to the last person who
> > reported this, we should be doing a get/put on the ops, not rolling
> > our
> > own here:
> > 
> > https://lore.kernel.org/linux-integrity/e7566e1e48f5be9dca034b4bfb67683b5d3cb88f.camel@HansenPartnership.com/
> > 
> > The reporter went silent before we could get this tested, but could
> > you
> > try, please, because your patch is still hand rolling the ops
> > get/put,
> > just slightly better than it had been done previously.
> > 
> > James
> 
> Thanks for pointing this out. I'd strongly support Jason's proposal:
> 
> https://lore.kernel.org/linux-integrity/20201215175624.GG5487@ziepe.ca/
> 
> It's the best long-term way to fix this.

Really, no it's not.  It introduces extra mechanism we don't need.

To recap the issue: character devices already have an automatic
mechanism which holds a reference to the struct device while the
character node is open so the default is to release resources on final
put of the struct device.

tpm 2 is special because we have two character device nodes: /dev/tpm0
and /dev/tpmrm0.  The way we make this work is that tpm0 is the master
and tpmrm0 the slave, so the slave holds an extra reference on the
master which is put when the slave final put happens.  This means that
our resources aren't freed until the final puts of both devices, which
is the model we're using.

The practical consequence of this model is that if you allocate a chip
structure with tpm_chip_alloc() you have to release it again by doing a
put of *both* devices.

However, patch fdc915f7f719 ("tpm: expose spaces via a device link
/dev/tpmrm<n>") contains two bugs: firstly it didn't add a devm action
release for devs and secondly it didn't update the only non-devm user
ibm vtpm to do the double put.

Stefan noticed the latter, so we got the bogus patch 8979b02aaf1d
("tpm: Fix reference count to main device") applied which simply breaks
the master/slave model by not taking a reference on the master for the
slave.  I'm not sure why I didn't notice the problem with this fix at
the time, but attention must have been elsewhere.

Subsequently we got ftpm added which copied the ibm vtpm put bug.

So I think 1/2 is the correct fix for all three bugs.  I just need to
find a way to verify it.

James


