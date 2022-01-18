Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A3B49296C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 16:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbiARPLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 10:11:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238128AbiARPLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 10:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642518690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AwvMWEfnP+eoe9J52kdeva4MMtThgldbDLr+jG0anUw=;
        b=ILsp0n4QY4ZTTLpz9TicHivX7sd7Q1x5Z9in8vvqIMkznF6otNYys8y3qBf1b8SiwV11Ik
        hcRdPYjlangEeaBv+N+JIEvmN+ZCn+dJ9tyqBNe64OcJCYni6j2e962z+yPKE7ZuUduU+v
        96OaL2o27e1YG0xSLuceM0iiaNCi3Zs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-464-5lxuc2KaMTOjbNcPnnOOWQ-1; Tue, 18 Jan 2022 10:11:28 -0500
X-MC-Unique: 5lxuc2KaMTOjbNcPnnOOWQ-1
Received: by mail-ed1-f71.google.com with SMTP id ej6-20020a056402368600b00402b6f12c3fso5861301edb.8
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:11:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AwvMWEfnP+eoe9J52kdeva4MMtThgldbDLr+jG0anUw=;
        b=OrrtVp0DnZPbdFjEBUMpjI0v6NJGvhqMjsHogSfuIE5gn3hSFTj9aAclDg0z1q1NIv
         M0ELh+2CzV2ezfWE77b3E0Ml4ZIcOgbglJmJFuZy8bZ46dwDajjnbTbSe0hB9M1NgY2k
         nspsXEniKessA6FSl4N7uDvTEVkU9L0ek0cNzsE+vetwv+Fn5+WZ0awddfJN3s5eTtjf
         rhX18fmSx3AfO6sJxbqNUIGq3pqv1HtsQXnWO2ewxs2nYMguJ6P0Veg255xKr606jiEW
         8dEWlpIjdB2CxNX24tzKlot3tmCaieBJppeHm4j4/wlwETKjUmAt203qnS93z8gUFBY3
         246g==
X-Gm-Message-State: AOAM533jfNF4Ol626ylINZYFh8IKWZYserbLw8mA6G28/PtrnmeSHPX0
        LxNBsNWAQAI0PgcdQ06sg//2VbZO4TJ61AItjRxzCA0wGxq9FVIBWNjv0BjISYKE5mI+UeNi7O7
        Mcx52NPDjTWMpcvM7
X-Received: by 2002:a17:907:c26:: with SMTP id ga38mr8576208ejc.521.1642518687216;
        Tue, 18 Jan 2022 07:11:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxP6vMAJgIYQJ9LQ1cBLwMks8Dw0loNKFcydZ2FZsDsUmVAhjwn/XHQ47D6dQDr/t9ecgfTnA==
X-Received: by 2002:a17:907:c26:: with SMTP id ga38mr8576188ejc.521.1642518686993;
        Tue, 18 Jan 2022 07:11:26 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id 17sm5435824eju.65.2022.01.18.07.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 07:11:26 -0800 (PST)
Date:   Tue, 18 Jan 2022 10:11:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: acknowledge all features before access
Message-ID: <20220118101010-mutt-send-email-mst@kernel.org>
References: <20220114200744.150325-1-mst@redhat.com>
 <20220118134855.3e8cbce5.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118134855.3e8cbce5.pasic@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 01:48:55PM +0100, Halil Pasic wrote:
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
>  
> Hi Michael!
> 
> I was just about to have a look into this. But it does not apply
> cleanly to Linus master (fetched a couple of minutes ago). I also tride
> with d9679d0013a66849~1 but no luck. What is a suitable base for this
> patch?
> 
> Regards,
> Halil

It's on top of
	virtio: unexport virtio_finalize_features
You can also get
	commit cc1f7f0bb64302c1153aa9337db970e6360b379d (HEAD, kernel.org/vhost, kernel.org/linux-next)
from my tree.

> 
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
> > +	if (err)
> > +		goto err;
> > +
> >  	if (drv->validate) {
> > +		u64 features = dev->features;
> > +
> >  		err = drv->validate(dev);
> >  		if (err)
> >  			goto err;
> > +
> > +		if (features != dev->features) {
> > +			err = dev->config->finalize_features(dev);
> > +			if (err)
> > +				goto err;
> > +		}
> >  	}
> >  
> >  	err = virtio_finalize_features(dev);
> > @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *dev)
> >  	/* We have a driver! */
> >  	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
> >  
> > +	ret = dev->config->finalize_features(dev);
> > +	if (ret)
> > +		goto err;
> > +
> >  	ret = virtio_finalize_features(dev);
> >  	if (ret)
> >  		goto err;

