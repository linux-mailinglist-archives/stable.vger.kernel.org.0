Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10384929CD
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 16:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbiARPnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 10:43:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345966AbiARPnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 10:43:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642520626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d0YPpE+94B6yWE7TJv4rcwracfeu9W68cFUmQp0rBtk=;
        b=f2RaOJEYMyqX9+Rl5NQ3J4VUqIdDynYt/nl42grrUZDSUyxdhLJRoXa5ElPiiwc2xIGDg9
        xVwQrFSp14LnFbG0oqjjiyde84D38UghfVwIEYe5p+1wzjrgBIEdFGMSF705UkXgWpb/Mr
        EVbZGPbrP+pUeiqVmc++Cqa1l929XNI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-VoLCjjUeMIq3sqznmWcksw-1; Tue, 18 Jan 2022 10:43:44 -0500
X-MC-Unique: VoLCjjUeMIq3sqznmWcksw-1
Received: by mail-ed1-f70.google.com with SMTP id c11-20020a056402120b00b0040321cea9d4so4264375edw.23
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:43:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d0YPpE+94B6yWE7TJv4rcwracfeu9W68cFUmQp0rBtk=;
        b=hJXVjzbVsXcB/cfK5E6s8jGDIEuV2H+eYtzk+5ORk4HrALXFCahGSP+JHJ3NuToG5V
         mBEaaSfaqqX0vDRsOXVYurjYC0yayKK2NbYPZsDb6pLTLHinEXVGe1T+hk0ZtD62ogOW
         aF0IIOA9bqpPY44u02LP1jS2WTS65u0w8dCCO+W3jJP4jXvcbn8JZpcMqPS3n1RIDWce
         Nt7otbYmAL9dhgcnBR2pvG9ZnPCxpDkMVqV66bdJlNXMkIR+sOmF9o/lNHXlxK1tG+qF
         WICuF+k4xcWe6BdV+afJpbriF7p2V97vHF5Yv/NP+ZW/IXZsDWvG1Ybzs0qn43Fbx9JN
         XLJg==
X-Gm-Message-State: AOAM533N0fZREsPUEY/MNaz+v8ObCERCEHsYUpcAPZbpnpK5VEX96SKp
        or5ZGNDFdFGjtV7MfXNwELbx9Aa+R2elojrLXiKXOQWHKq+KVsoaDWDyZPxX1XDiSwJgOrlR8MX
        R7ffR/HQAA8x6GbFk
X-Received: by 2002:a05:6402:291b:: with SMTP id ee27mr18848549edb.363.1642520623264;
        Tue, 18 Jan 2022 07:43:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSf30u1Y8twrreQGvhRj70h4otcNrhlmXnPl8LDEz9y+o8KJ76N1+dABMmBkucVx6D4qd3/Q==
X-Received: by 2002:a05:6402:291b:: with SMTP id ee27mr18848524edb.363.1642520623022;
        Tue, 18 Jan 2022 07:43:43 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id hs32sm5459700ejc.180.2022.01.18.07.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 07:43:42 -0800 (PST)
Date:   Tue, 18 Jan 2022 10:43:38 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: acknowledge all features before access
Message-ID: <20220118104318-mutt-send-email-mst@kernel.org>
References: <20220114200744.150325-1-mst@redhat.com>
 <d6c4e521-1538-bbbf-30e6-f658a095b3ae@redhat.com>
 <20220117032429-mutt-send-email-mst@kernel.org>
 <87mtjuv8od.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mtjuv8od.fsf@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 01:38:42PM +0100, Cornelia Huck wrote:
> On Mon, Jan 17 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Mon, Jan 17, 2022 at 02:31:49PM +0800, Jason Wang wrote:
> >> 
> >> 在 2022/1/15 上午4:09, Michael S. Tsirkin 写道:
> >> > @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *dev)
> >> >   	/* We have a driver! */
> >> >   	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
> >> > +	ret = dev->config->finalize_features(dev);
> >> > +	if (ret)
> >> > +		goto err;
> >> 
> >> 
> >> Is this part of code related?
> >> 
> >> Thanks
> >> 
> >
> > Yes. virtio_finalize_features no longer calls dev->config->finalize_features.
> >
> > I think the dev->config->finalize_features callback is actually
> > a misnomer now, it just sends the features to device,
> > finalize is FEATURES_OK. Renaming that is a bigger
> > patch though, and I'd like this one to be cherry-pickable
> > to stable.
> 
> Do we want to add a comment before the calls to ->finalize_features()
> (/* write features to device */) and adapt the comment in virtio_ring.h?
> Should still be stable-friendly, and giving the callback a better name
> can be a follow-up patch.

Sorry which comment in virtio_ring.h?
Could not find anything.

> >
> >> > +
> >> >   	ret = virtio_finalize_features(dev);
> >> >   	if (ret)
> >> >   		goto err;

