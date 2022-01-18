Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC149298E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 16:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345401AbiARPUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 10:20:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231476AbiARPUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 10:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642519210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gY6Hax963rHOpjf62HVLLjpmM0CdjtqRy7qF6ZHQCGc=;
        b=Wb8z/PKyQZXRtWITK+XL6W9w4a/D7xmidVHKXq+uWjC2pFZHHM8sN7ZAD7Q/4tIyfDEUPv
        Fk3eu6oFJOhkTmjlApRCruMtMOh6cr/Kc6EhShmnfC1zpBXe8MwAtm0q6/Cxx+illeoc6q
        GUMHp2Nkhl4QPNFFI/pIGROHDdUg+1A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-rOexeXLdOJqep0-E3CRdEg-1; Tue, 18 Jan 2022 10:20:08 -0500
X-MC-Unique: rOexeXLdOJqep0-E3CRdEg-1
Received: by mail-ed1-f69.google.com with SMTP id k10-20020a50cb8a000000b00403c8326f2aso1136189edi.6
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:20:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gY6Hax963rHOpjf62HVLLjpmM0CdjtqRy7qF6ZHQCGc=;
        b=nBMbLVBgIk+FakzlLt8mJVQ2giOdx/I2JNdxctWukG63fadGtpC2XUmVA+qztiGNfn
         dzKzWfhRPQScqF2KXn3g5zPhU6pDAX8MdvDYmFZu3y7O10MY/37Pjv4YAllDZCwCXagV
         Lhqs7ytkdbkrE+ylscs122Jh4wArGmu7bPDvPztEZqL3rsc7uiCLn1DWdoo+VIbPTY7/
         mUehEbC0WrZjf5HlGClNZi21bgwrloFwcC/+IWpzM9P8wD8r5bnoA5KZgEdV5Tkd/+GC
         10we2797ax74LB6uC0rkrT1GSb7XlThg3kSMAuLSJjmNF2/ji/BMZg2BjINKEXuFmbo6
         zn5Q==
X-Gm-Message-State: AOAM533+6WarNCmfWz7GvqtW6K1FzLP9eMnW441gOhLmflFGAwNf8+7h
        UJQg4V0hpkvYu0zULV1Plyo/7IpDBdI/khBDLGaeyfC/9XV1LphN8Sn4F+nB8d7kSGoudv8Yvze
        XdbTSXiRLnzkVfDUH
X-Received: by 2002:a05:6402:350f:: with SMTP id b15mr25709382edd.77.1642519206826;
        Tue, 18 Jan 2022 07:20:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrPUpMZrXZZ6hhQLm6jDDIK+KWCDI7IJhGLGk4DhdtM+pN0tvJUeMqVeEWPPbTOnCCPxX2CA==
X-Received: by 2002:a05:6402:350f:: with SMTP id b15mr25709360edd.77.1642519206567;
        Tue, 18 Jan 2022 07:20:06 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id 26sm5457537ejk.166.2022.01.18.07.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 07:20:05 -0800 (PST)
Date:   Tue, 18 Jan 2022 10:20:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: acknowledge all features before access
Message-ID: <20220118101233-mutt-send-email-mst@kernel.org>
References: <20220114200744.150325-1-mst@redhat.com>
 <20220118154350.1ff3fa3f.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118154350.1ff3fa3f.pasic@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 03:43:50PM +0100, Halil Pasic wrote:
> On Fri, 14 Jan 2022 15:09:14 -0500
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > The feature negotiation was designed in a way that
> > makes it possible for devices to know which config
> > fields will be accessed by drivers.
> > 
> > This is broken since commit 404123c2db79 ("virtio: allow drivers to
> > validate features") with fallout in at least block and net.
> > We have a partial work-around in commit 2f9a174f918e ("virtio: write
> > back F_VERSION_1 before validate") which at least lets devices
> > find out which format should config space have, but this
> > is a partial fix: guests should not access config space
> > without acknowledging features since otherwise we'll never
> > be able to change the config space format.
> 
> I agree with that. The crux is what does "acknowledge features" exactly
> mean. Is it "write features" or "complete the feature negotiation,
> including setting FEATURES_OK".

Right. I think originally it was "write features". We then added
the FEATURES_OK in order to give devices a chance to reject
a set of features, and while doing this we failed to
notice that at this point "acknowledge" became confusing.

There's a spec proposal to make things more explicit, and
I think I will tweak it to actually use the term
"acknowledge".

On top of that, it makes sense to go back, scan all of the spec
and see whether any places that we changed from set not negotiated
for clarify actually should read "set in the written".

> My understanding is, that we should not rely on that the device is
> going to act according to the negotiated feature set unless FEATURES_OK
> was set successfully.


not for writes, but for reads there's little choice.

> That would mean, that this change ain't guaranteed to help with the
> stated problem. We simply don't know if the fact that features
> were written is going to have a side-effect or not. Also see below.

right. at the moment it's just the MTU field. In the future it
can be more, but by that future time we can fix the spec ;)

> > 
> > As a side effect, this also reduces the amount of hypervisor accesses -
> > we now only acknowledge features once unless we are clearing any
> > features when validating.
> 
> My understanding is that this patch basically does for all the features,
> what commit 2f9a174f918e ("virtio: write back F_VERSION_1 before
> validate") did only for F_VERSION_1 and under certain conditions to
> be minimally invasive.
> 
> I don't like when s390 is the oddball, so I'm very happy to see us
> moving away from that.
> 
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
> > Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
> > Cc: "Halil Pasic" <pasic@linux.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Halil, I thought hard about our situation with transitional and
> > today I finally thought of something I am happy with.
> > Pls let me know what you think. Testing on big endian would
> > also be much appreciated!
> 
> Thanks! I will first provide some comments, and I intend to come back
> with the test results later.
> 
> > 
> >  drivers/virtio/virtio.c | 31 +++++++++++++++++--------------
> >  1 file changed, 17 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index d891b0a354b0..2ed6e2451fd8 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -168,12 +168,10 @@ EXPORT_SYMBOL_GPL(virtio_add_status);
> >  
> >  static int virtio_finalize_features(struct virtio_device *dev)
> >  {
> > -	int ret = dev->config->finalize_features(dev);
> >  	unsigned status;
> > +	int ret;
> >  
> >  	might_sleep();
> > -	if (ret)
> > -		return ret;
> >  
> >  	ret = arch_has_restricted_virtio_memory_access();
> >  	if (ret) {
> > @@ -244,17 +242,6 @@ static int virtio_dev_probe(struct device *_d)
> >  		driver_features_legacy = driver_features;
> >  	}
> >  
> > -	/*
> > -	 * Some devices detect legacy solely via F_VERSION_1. Write
> > -	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
> > -	 * these when needed.
> > -	 */
> > -	if (drv->validate && !virtio_legacy_is_little_endian()
> > -			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
> > -		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
> > -		dev->config->finalize_features(dev);
> > -	}
> > -
> >  	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
> >  		dev->features = driver_features & device_features;
> >  	else
> > @@ -265,10 +252,22 @@ static int virtio_dev_probe(struct device *_d)
> >  		if (device_features & (1ULL << i))
> >  			__virtio_set_bit(dev, i);
> >  
> > +	err = dev->config->finalize_features(dev);
> 
> A side note: config->finalize_features() ain't the best name for what the
> thing does. After config->finalize_features() the features are not final.
> Unlike after virtio_finalize_features(). IMHO filter_and_write_features()
> would be a more accurate, although longer name.

I agree.
But I think I will start with figuring out the best name in the spec.
Maybe write back or acknowledge. Let's see what gets accepted by
the tc. Then I'll change code to match.

> After this point, the features aren't final yet, and one can not say
> that a some feature X has been negotiated. But with regards to features,
> the spec does not really consider this limbo state.
> 
> Should this change? Do we want to say: the device SHOULD pick up, and
> act upon the new features *before* FEATURES_OK is set?

Yes but only for handling config reads. See my spec proposal.

> ...
> 
> > +	if (err)
> > +		goto err;
> > +
> >  	if (drv->validate) {
> > +		u64 features = dev->features;
> > +
> >  		err = drv->validate(dev);
> 
> ... Consider the "we would like to introduce a new config space format"
> example. Here, I guess we would like to use the new format. But let's say
> _F_CFG_FMT_V2 aint negotiated yet. So to be sure about the format, we
> would need to specify, that the behavior of the device needs to change
> after the feature has been written, but before FEATURES_OK is set, at
> least for _F_CFG_FMT_V2.

for config space reads. yes.

> Please also consider the QEMU implementation of the vhost-user stuff. We
> push the features to the back-end only when FEATURES_OK status is
> written.

that has to change, anyway - it's needed to fix endian-ness.

> 
> >  		if (err)
> >  			goto err;
> > +
> > +		if (features != dev->features) {
> > +			err = dev->config->finalize_features(dev);
> 
> It is fine to call it again, because the features aren't finalized yet.
> And re-doing any transport-level filtering and validation is fine as
> well.

Will add a comment.

> > +			if (err)
> > +				goto err;
> > +		}
> >  	}
> >  
> >  	err = virtio_finalize_features(dev);
> 
> Here the features are finally negotiated and final.
> 
> > @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *dev)
> >  	/* We have a driver! */
> >  	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
> >  
> > +	ret = dev->config->finalize_features(dev);
> > +	if (ret)
> > +		goto err;
> > +
> >  	ret = virtio_finalize_features(dev);
> 
> Looks a little weird, because virtio_finalize_features() used to include
> filter + write + set FEATURES_OK. But it ain't too bad.
> 
> Better names would benefit readability though, if we can come up with
> some.
> 
> Regards,
> Halil

right. I think that can be a patch on top though.

> >  	if (ret)
> >  		goto err;

