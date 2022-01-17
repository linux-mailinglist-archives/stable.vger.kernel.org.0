Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D124903BF
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 09:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbiAQI03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 03:26:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238118AbiAQI02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 03:26:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642407988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNQKbEtegSIWSosG5uGlKNCts0oURQOmirK/2YJ0xMQ=;
        b=iX1TAAZNjHMfP/vuRE5cWqb2e7Y2531l04a/QiaN04BYU7aeAjwuVa8T2SB588g8ftnvFU
        QMtXcRQZHc6I5864vE97a2LnV9Xekuzl5REkBieqlKwwoLnfCxT0McDBM9D+mfZnCbmuHY
        9/HQo4EKhqCDpg15sPmn+osJwhU+uks=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-4iTbeMQgOOK9UlsFAqqoeA-1; Mon, 17 Jan 2022 03:26:26 -0500
X-MC-Unique: 4iTbeMQgOOK9UlsFAqqoeA-1
Received: by mail-wm1-f69.google.com with SMTP id s190-20020a1ca9c7000000b00347c6c39d9aso10528186wme.5
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 00:26:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DNQKbEtegSIWSosG5uGlKNCts0oURQOmirK/2YJ0xMQ=;
        b=dgGeCo2AmshZ/orBfAjCkwt66ZN3aG+IFN8UCNWYkwblxUeJ9aAGNATXZ/Vn9NhuJu
         pbmNOZVrnBmdX/XvTuC1ykWo4xG0iYoFuG/kTV3ZIHqjF3jKLydXBd7bBeUYUphIhQMx
         Ot0kpkeEMpIoABAKo7HlIixgVF2hjSRkmggtx8aeQK6vojXp4JZ/V7xfJlzzUm3BdcJn
         uRvmBMKkyzYsTe56zOo7DX+HYC1w/FH3x88RGxBNPsSLrLOhnmN1hcKOI+shJt4J/Csh
         LYQfFZtVsq+f8IINYexK/H6F9b2LC8Ne+UIUTln0CzoNF4i53ys4No/lDhTiBDV8bdvQ
         9A0A==
X-Gm-Message-State: AOAM532aj9YT7AlC1vRc7iNliOYYk5rc1+jQoBD2qMqXsxVPK09Fvyjt
        8SgBYiTVZHy4iINWZvAocxD56h4GsiRVChN26TUb3Mh93h3uJcSeoEQEDluBtfo5kPfTM+O1LPc
        7Y6TBnCaLfmVTVgL4
X-Received: by 2002:a7b:c386:: with SMTP id s6mr26121322wmj.132.1642407985554;
        Mon, 17 Jan 2022 00:26:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyGOrrGupepsSg3nWADHPX7L3TERLID7WqvxnbS25Vx07PFaNvht3nsEkdR5w3oAVH1VcL8g==
X-Received: by 2002:a7b:c386:: with SMTP id s6mr26121303wmj.132.1642407985332;
        Mon, 17 Jan 2022 00:26:25 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id p10sm1776322wrr.10.2022.01.17.00.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:26:24 -0800 (PST)
Date:   Mon, 17 Jan 2022 03:26:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: acknowledge all features before access
Message-ID: <20220117032429-mutt-send-email-mst@kernel.org>
References: <20220114200744.150325-1-mst@redhat.com>
 <d6c4e521-1538-bbbf-30e6-f658a095b3ae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6c4e521-1538-bbbf-30e6-f658a095b3ae@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 02:31:49PM +0800, Jason Wang wrote:
> 
> 在 2022/1/15 上午4:09, Michael S. Tsirkin 写道:
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
> > 
> > As a side effect, this also reduces the amount of hypervisor accesses -
> > we now only acknowledge features once unless we are clearing any
> > features when validating.
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
> > 
> >   drivers/virtio/virtio.c | 31 +++++++++++++++++--------------
> >   1 file changed, 17 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index d891b0a354b0..2ed6e2451fd8 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -168,12 +168,10 @@ EXPORT_SYMBOL_GPL(virtio_add_status);
> >   static int virtio_finalize_features(struct virtio_device *dev)
> >   {
> > -	int ret = dev->config->finalize_features(dev);
> >   	unsigned status;
> > +	int ret;
> >   	might_sleep();
> > -	if (ret)
> > -		return ret;
> >   	ret = arch_has_restricted_virtio_memory_access();
> >   	if (ret) {
> > @@ -244,17 +242,6 @@ static int virtio_dev_probe(struct device *_d)
> >   		driver_features_legacy = driver_features;
> >   	}
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
> >   	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
> >   		dev->features = driver_features & device_features;
> >   	else
> > @@ -265,10 +252,22 @@ static int virtio_dev_probe(struct device *_d)
> >   		if (device_features & (1ULL << i))
> >   			__virtio_set_bit(dev, i);
> > +	err = dev->config->finalize_features(dev);
> > +	if (err)
> > +		goto err;
> > +
> >   	if (drv->validate) {
> > +		u64 features = dev->features;
> > +
> >   		err = drv->validate(dev);
> >   		if (err)
> >   			goto err;
> > +
> > +		if (features != dev->features) {
> > +			err = dev->config->finalize_features(dev);
> > +			if (err)
> > +				goto err;
> > +		}
> >   	}
> >   	err = virtio_finalize_features(dev);
> > @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *dev)
> >   	/* We have a driver! */
> >   	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
> > +	ret = dev->config->finalize_features(dev);
> > +	if (ret)
> > +		goto err;
> 
> 
> Is this part of code related?
> 
> Thanks
> 

Yes. virtio_finalize_features no longer calls dev->config->finalize_features.

I think the dev->config->finalize_features callback is actually
a misnomer now, it just sends the features to device,
finalize is FEATURES_OK. Renaming that is a bigger
patch though, and I'd like this one to be cherry-pickable
to stable.

> > +
> >   	ret = virtio_finalize_features(dev);
> >   	if (ret)
> >   		goto err;

