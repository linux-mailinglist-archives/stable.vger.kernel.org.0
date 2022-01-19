Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F67493324
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 03:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350721AbiASCwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 21:52:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244048AbiASCwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 21:52:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642560768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gHpnsn2NkfuadkUJHw0pU0DVjGRpoEK47XlUcu+C1CQ=;
        b=IGkvmr5yPN2Rl3aqhW1Urk/XQMosCmOAD7vso67cDEZo+INSdENuNgEIhNDpdXP7HApOmm
        KBMA407t8RyUQ1PrZfPc2Bdh35BcGw16w7DTFBb3iYIEWQhRgUJfeYkG4Eh1jYvXyRRwtK
        QhGp515KZ1AxMItSS7Ioc0+e2C0d4FQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-__MTABNiORixEdKnko8b-w-1; Tue, 18 Jan 2022 21:52:47 -0500
X-MC-Unique: __MTABNiORixEdKnko8b-w-1
Received: by mail-lf1-f72.google.com with SMTP id v7-20020a056512048700b0042d99b3a962so522957lfq.23
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 18:52:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gHpnsn2NkfuadkUJHw0pU0DVjGRpoEK47XlUcu+C1CQ=;
        b=EJtPQut/BTMEWTpDKNvvAoAN2rh/Ww8s/zqJLDIZkx/nTlINvMGRTMzROi7touMz86
         aid6QP94IgBXwb2Q4Mv12Pb/nNVdB85Rem+xuLZpr6YDUaYwZ91e+MfAD+Sx9174zAif
         XpAQtE0+IyREpAyCCrM1+/2CCes6yupowrXPdalde8gKnHRD/19YFhI83sMaBceuFca6
         c28sRdlnOb/URNg1nNIFrfmjJ5RcINlVDxbDo6YSTHjX1IGl8qpLCFh0sU0zr9uY+1k8
         tKVOc7tUa3ZgDN8dPUcREJrJZFdv+dpc7NoRay4u7qhEhhCOwyI1xlm7Toj0VOzOooLl
         /Jqw==
X-Gm-Message-State: AOAM530Gi0mD+0MAhOA76tuhF9bgNt8y90dSA7YePTAlKv2IfcjH70xt
        lmlqsRA+sNPwxRVAbMrsVymQFSTjxgZhC/l2jVrGl0dq9wAL7EdtCGUaKx8+Kslzs4YJQAIDG4Q
        u5GguE3ClJ26tQk9bQZo595QcuZLmHH26
X-Received: by 2002:a05:6512:3b0a:: with SMTP id f10mr21391226lfv.629.1642560765781;
        Tue, 18 Jan 2022 18:52:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjlx7+UrF3gEdPjwx5nPlNnkZuqvs+mcSd1Q1R7MKLtS3Xz3+7MscCitPjBMwKq2CO18iBS+jjgO+0dejml+8=
X-Received: by 2002:a05:6512:3b0a:: with SMTP id f10mr21391207lfv.629.1642560765492;
 Tue, 18 Jan 2022 18:52:45 -0800 (PST)
MIME-Version: 1.0
References: <20220118170225.30620-1-mst@redhat.com> <20220118170225.30620-2-mst@redhat.com>
In-Reply-To: <20220118170225.30620-2-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 19 Jan 2022 10:52:34 +0800
Message-ID: <CACGkMEt-Q7baDDUM8aC_Lki1aeO36xi02AE7kEapi5NVqkGErg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio: acknowledge all features before access
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 1:04 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> The feature negotiation was designed in a way that
> makes it possible for devices to know which config
> fields will be accessed by drivers.
>
> This is broken since commit 404123c2db79 ("virtio: allow drivers to
> validate features") with fallout in at least block and net.  We have a
> partial work-around in commit 2f9a174f918e ("virtio: write back
> F_VERSION_1 before validate") which at least lets devices find out which
> format should config space have, but this is a partial fix: guests
> should not access config space without acknowledging features since
> otherwise we'll never be able to change the config space format.

So I guess this is for this part of the spec 3.1.1:

"""
4. Read device feature bits, and write the subset of feature bits
understood by the OS and driver to the device. During this step the
driver MAY read (but MUST NOT write) the device-specific configuration
fields to check that it can support the device before accepting it.
"""

If it is, is this better to quote in the change log?

Other than this,

Acked-by: Jason Wang <jasowang@redhat.com>

>
> To fix, split finalize_features from virtio_finalize_features and
> call finalize_features with all feature bits before validation,
> and then - if validation changed any bits - once again after.
>
> Since virtio_finalize_features no longer writes out features
> rename it to virtio_features_ok - since that is what it does:
> checks that features are ok with the device.
>
> As a side effect, this also reduces the amount of hypervisor accesses -
> we now only acknowledge features once unless we are clearing any
> features when validating (which is uncommon).
>
> Cc: stable@vger.kernel.org
> Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
> Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
> Cc: "Halil Pasic" <pasic@linux.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> fixup! virtio: acknowledge all features before access
> ---
>  drivers/virtio/virtio.c       | 39 ++++++++++++++++++++---------------
>  include/linux/virtio_config.h |  3 ++-
>  2 files changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index d891b0a354b0..d6396be0ea83 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -166,14 +166,13 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>  }
>  EXPORT_SYMBOL_GPL(virtio_add_status);
>
> -static int virtio_finalize_features(struct virtio_device *dev)
> +/* Do some validation, then set FEATURES_OK */
> +static int virtio_features_ok(struct virtio_device *dev)
>  {
> -       int ret = dev->config->finalize_features(dev);
>         unsigned status;
> +       int ret;
>
>         might_sleep();
> -       if (ret)
> -               return ret;
>
>         ret = arch_has_restricted_virtio_memory_access();
>         if (ret) {
> @@ -244,17 +243,6 @@ static int virtio_dev_probe(struct device *_d)
>                 driver_features_legacy = driver_features;
>         }
>
> -       /*
> -        * Some devices detect legacy solely via F_VERSION_1. Write
> -        * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
> -        * these when needed.
> -        */
> -       if (drv->validate && !virtio_legacy_is_little_endian()
> -                         && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
> -               dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
> -               dev->config->finalize_features(dev);
> -       }
> -
>         if (device_features & (1ULL << VIRTIO_F_VERSION_1))
>                 dev->features = driver_features & device_features;
>         else
> @@ -265,13 +253,26 @@ static int virtio_dev_probe(struct device *_d)
>                 if (device_features & (1ULL << i))
>                         __virtio_set_bit(dev, i);
>
> +       err = dev->config->finalize_features(dev);
> +       if (err)
> +               goto err;
> +
>         if (drv->validate) {
> +               u64 features = dev->features;
> +
>                 err = drv->validate(dev);
>                 if (err)
>                         goto err;
> +
> +               /* Did validation change any features? Then write them again. */
> +               if (features != dev->features) {
> +                       err = dev->config->finalize_features(dev);
> +                       if (err)
> +                               goto err;
> +               }
>         }
>
> -       err = virtio_finalize_features(dev);
> +       err = virtio_features_ok(dev);
>         if (err)
>                 goto err;
>
> @@ -495,7 +496,11 @@ int virtio_device_restore(struct virtio_device *dev)
>         /* We have a driver! */
>         virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
>
> -       ret = virtio_finalize_features(dev);
> +       ret = dev->config->finalize_features(dev);
> +       if (ret)
> +               goto err;
> +
> +       ret = virtio_features_ok(dev);
>         if (ret)
>                 goto err;
>
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 4d107ad31149..dafdc7f48c01 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -64,8 +64,9 @@ struct virtio_shm_region {
>   *     Returns the first 64 feature bits (all we currently need).
>   * @finalize_features: confirm what device features we'll be using.
>   *     vdev: the virtio_device
> - *     This gives the final feature bits for the device: it can change
> + *     This sends the driver feature bits to the device: it can change
>   *     the dev->feature bits if it wants.
> + * Note: despite the name this can be called any number of times.
>   *     Returns 0 on success or error status
>   * @bus_name: return the bus name associated with the device (optional)
>   *     vdev: the virtio_device
> --
> MST
>

