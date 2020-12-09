Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE332D3D55
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 09:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgLIIaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 03:30:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbgLIIaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 03:30:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607502520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TY8/pWIgcIz+C6jRI22Ls6KSQPYFbL8dVJN418r6j6I=;
        b=MjpHsnYT85AizTEtTNlMCKnXGEbd3guX0uKx8J2b55ngGIThD5sp33pTAbtzkXzTrz9nNM
        gxJusA9LtWAX+QLbSM7PzXiCq6tWrl6Rqm57skVawSs4D1oG8zZbkVJt0wds1/DK7mCZfN
        ytvdDyxXtWAQ1nrPidLx+QAeXlORtRA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-u2yPRzpsMNmPahxKxeiaNw-1; Wed, 09 Dec 2020 03:28:38 -0500
X-MC-Unique: u2yPRzpsMNmPahxKxeiaNw-1
Received: by mail-wr1-f69.google.com with SMTP id q18so353866wrc.20
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 00:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TY8/pWIgcIz+C6jRI22Ls6KSQPYFbL8dVJN418r6j6I=;
        b=SP5ycjuVKIVT6hq+duRQqNVhc0xvgRoH2l1rwSbuUE8HA0aituyBsiV7PSvAvzUoH0
         UirLLDAF3jNkIO80yhN1bnDTtiwIFoHMRduDnAN6VzD3Cfe8rUgBBxlQut4IA42/yMyL
         aupITKOQKQuqH4iEAd1RhtkfJuu64bJHJUxyZvmMkhJ2tBMap0i7l6nG7XU3qOV68Uho
         Hc4gBGV/iXC35XFlROBCmFPtLdQu2zJZ3OTiFT0nDqKaOCOX4vl1D1qS6T4hV8f5l5u+
         FiibK27zt90H9BYQIpijlPLLLwv7GZQxQLhtD7dGiQ8l3+YdPzGYoP5NTu2x7LGkUgdX
         CUxA==
X-Gm-Message-State: AOAM533675VL5ovMm0EkcFxPOHeRtZy80MmYmHbH2TVP0PAuB97oUlLy
        9flePj+Qmn+5V2FpE76a358KqsUixgFQy+1J6JkZxmGfacoE7BdeETsk3so/sMOE2cvF5vcRHcI
        Z5EQZ92nu4kx59Gat
X-Received: by 2002:adf:ecd0:: with SMTP id s16mr1258059wro.415.1607502517428;
        Wed, 09 Dec 2020 00:28:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxH6Do+31Svbm6gZcmCgYjugWGzqIMTR6tBXYz8WhylY3W/V+37vUvxCwZh+NfQ/MkOY6D7Mg==
X-Received: by 2002:adf:ecd0:: with SMTP id s16mr1258052wro.415.1607502517272;
        Wed, 09 Dec 2020 00:28:37 -0800 (PST)
Received: from redhat.com (bzq-79-176-44-197.red.bezeqint.net. [79.176.44.197])
        by smtp.gmail.com with ESMTPSA id u6sm2188084wrm.90.2020.12.09.00.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 00:28:36 -0800 (PST)
Date:   Wed, 9 Dec 2020 03:28:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Mathias Crombez <mathias.crombez@faurecia.com>
Subject: Re: [PATCH RESEND v2] virtio-input: add multi-touch support
Message-ID: <20201209030635-mutt-send-email-mst@kernel.org>
References: <20201208210150.20001-1-vasyl.vavrychuk@opensynergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208210150.20001-1-vasyl.vavrychuk@opensynergy.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 08, 2020 at 11:01:50PM +0200, Vasyl Vavrychuk wrote:
> From: Mathias Crombez <mathias.crombez@faurecia.com>
> Cc: stable@vger.kernel.org

I don't believe this is appropriate for stable, looks like
a new feature to me.


> 
> Without multi-touch slots allocated, ABS_MT_SLOT events will be lost by
> input_handle_abs_event.
> 
> Signed-off-by: Mathias Crombez <mathias.crombez@faurecia.com>
> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> Tested-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> ---
> v2: fix patch corrupted by corporate email server
> 
>  drivers/virtio/Kconfig        | 11 +++++++++++
>  drivers/virtio/virtio_input.c |  8 ++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 7b41130d3f35..2cfd5b01d96d 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -111,6 +111,17 @@ config VIRTIO_INPUT
>  
>  	 If unsure, say M.
>  
> +config VIRTIO_INPUT_MULTITOUCH_SLOTS
> +	depends on VIRTIO_INPUT
> +	int "Number of multitouch slots"
> +	range 0 64
> +	default 10
> +	help
> +	 Define the number of multitouch slots used. Default to 10.
> +	 This parameter is unused if there is no multitouch capability.
> +
> +	 0 will disable the feature.
> +

Most people won't be using this config so the defaults matter. So why 10? 10 fingers?

And where does 64 come from?


>  config VIRTIO_MMIO
>  	tristate "Platform bus driver for memory mapped virtio devices"
>  	depends on HAS_IOMEM && HAS_DMA
> diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
> index f1f6208edcf5..13f3d90e6c30 100644
> --- a/drivers/virtio/virtio_input.c
> +++ b/drivers/virtio/virtio_input.c
> @@ -7,6 +7,7 @@
>  
>  #include <uapi/linux/virtio_ids.h>
>  #include <uapi/linux/virtio_input.h>
> +#include <linux/input/mt.h>
>  
>  struct virtio_input {
>  	struct virtio_device       *vdev;
> @@ -205,6 +206,7 @@ static int virtinput_probe(struct virtio_device *vdev)
>  	unsigned long flags;
>  	size_t size;
>  	int abs, err;
> +	bool is_mt = false;
>  
>  	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>  		return -ENODEV;
> @@ -287,9 +289,15 @@ static int virtinput_probe(struct virtio_device *vdev)
>  		for (abs = 0; abs < ABS_CNT; abs++) {
>  			if (!test_bit(abs, vi->idev->absbit))
>  				continue;
> +			if (input_is_mt_value(abs))
> +				is_mt = true;
>  			virtinput_cfg_abs(vi, abs);
>  		}
>  	}
> +	if (is_mt)
> +		input_mt_init_slots(vi->idev,
> +				    CONFIG_VIRTIO_INPUT_MULTITOUCH_SLOTS,
> +				    INPUT_MT_DIRECT);


Do we need the number in config space maybe? And maybe with a feature
bit so host can find out whether guest supports MT?

>  
>  	virtio_device_ready(vdev);
>  	vi->ready = true;
> -- 
> 2.23.0

