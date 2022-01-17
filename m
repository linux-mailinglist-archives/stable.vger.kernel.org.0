Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D680A491239
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 00:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiAQXOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 18:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229842AbiAQXN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 18:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642461239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=poL37lSy5yu+pXxIBkPJdf1QhhjhrG0y8WyJPB/Gac4=;
        b=cHoc6UPpucyNFfOPIEB/5koMaKlkBRvD7YHGYaBZ4CGfgaPdpjY6swRUkt0SAIWD+9OUzI
        Yz1vaOPfepoxcWTm1fvUOKdAVZFk4AvBszZ+oqy2LxBJpW8TyEym34r5RgHljcSs0lkPMz
        D821CiSRrU0vGVu4uhzJ6WSqrhxt4GI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-CdAjzcvAO6iM_9UDwriqdg-1; Mon, 17 Jan 2022 18:13:58 -0500
X-MC-Unique: CdAjzcvAO6iM_9UDwriqdg-1
Received: by mail-ed1-f69.google.com with SMTP id r14-20020aa7da0e000000b004021fa39843so4655197eds.15
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 15:13:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=poL37lSy5yu+pXxIBkPJdf1QhhjhrG0y8WyJPB/Gac4=;
        b=FwG8MssVSMNmCNpMOaONkRWyyGM4WVLLCJetDlhxVqgnQwgNUHT128Ir9FsYoL4co8
         BJRBg8rI7X73xPbsk9X3df1IXzEgq7ICQFgYtGl/81Dd9oz7TTXYN9b0O7cDdkms5N9v
         1OVsPjKUYwNpvRHdjrsOxuQb3P6IIYzsAWsgZ5vLDVmnz/r4eb5r2aJCs/D/Rn3rcqQ4
         eIjfNJBObf2ljtbdbwQLfKMT1CJO39NEK+jTYEiJKCFsVoJvPwxaizXCXyF8MizCeWYK
         ax7Vba2CcE5dCOrivYDP6OiUfUNGLAkz9TFbIx1VfE325lhs2lOoywBeTKWXIfR4cLHi
         Onyg==
X-Gm-Message-State: AOAM5310LJJfgLYSr4SpKSaEYDZRhh3ZA071AhyGC9JSmNhG3/FjrC0M
        Bztf/EzI+kjAjy3O3taPPqHQcI94Zi8GoyDbJxCuCnAyB5Wj/EgB5VuWoY/roGa2VwBJndhdEFm
        /kfHIZre4uXXJBvHJ
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr23540997edu.148.1642461236858;
        Mon, 17 Jan 2022 15:13:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLNJ+H3FJlkh2+Vfrf2XL670LwjFEEh5msW25BJKoOSxrD9zY3tXrjLznoSEqqi27F14Jz0A==
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr23540987edu.148.1642461236725;
        Mon, 17 Jan 2022 15:13:56 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id p25sm6417354edw.75.2022.01.17.15.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 15:13:54 -0800 (PST)
Date:   Mon, 17 Jan 2022 18:13:49 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: acknowledge all features before access
Message-ID: <20220117181318-mutt-send-email-mst@kernel.org>
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


Sounds like a good idea. I can also document that near
virtio_finalize_features.

> >
> >> > +
> >> >   	ret = virtio_finalize_features(dev);
> >> >   	if (ret)
> >> >   		goto err;

