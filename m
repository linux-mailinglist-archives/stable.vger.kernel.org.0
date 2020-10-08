Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC0287CC0
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 22:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgJHUBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 16:01:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbgJHUBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 16:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602187261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N7ZjK4P1j2h8bXH0yXST1ACz87+diWlu/RJO8+yMMIg=;
        b=bxK79r1vP7LDirK5E9MB05lV91LHOJuqYy2a97gWoNqsqk+zBziRcXZaoxHubSNgdcmALg
        aEX/v6tY7luSzdEPBgJcsgYmAIMm+k+7Jb29h7SCf+Zu93n6Iz31nnt6nUuaUqOM385DPA
        OFTr/1EQRPOzgNPAxA+Rhw8GFSTIkPc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-a0aNslg0NESbEKhH3u4Pew-1; Thu, 08 Oct 2020 16:00:58 -0400
X-MC-Unique: a0aNslg0NESbEKhH3u4Pew-1
Received: by mail-wr1-f72.google.com with SMTP id 47so4281212wrc.19
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 13:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N7ZjK4P1j2h8bXH0yXST1ACz87+diWlu/RJO8+yMMIg=;
        b=nhYDnKrFmxWM5NMdQvi/USFBMsb70jGxq1X3gWHOET3xB/nnuEbAXRjBH9ArN9i57h
         pVu689BChDxm+bvakivxDF89jEzZj525y+rs9WnHL4nZI8RXIpZT8nsMswcSNXEajITm
         5BsTn9Xobgs1NIv3/LgvwXh3czI9iC+YRd+BaDgGHl+qJ3CIdxC4MxwFLYRjqHf6nvyB
         5gRgbCMo26/S+BAwF3g+KSyRahmj3g4DhBxVQJC4cESlMLu81FiAFPtGPoLYsSUD3mM5
         b7mGJeP724IXl/fa+5ZfNw/KywanyPL3BsanBaH0SIo878sgwwk7W2CPUnym7K3Dnzym
         pe1A==
X-Gm-Message-State: AOAM532U8z0r6cjysU9Fz/tD2Z++T36oHmfQqa3nwo6fwt+5mWsYVPd1
        PMskCluUPn15c2aFKVr67nbTdCXVEbHW1jTn9h7ldcPGhygwLpwVw5vRgL6ZlmumapHraXGK/E/
        HKP2edh4crqZa2mOy
X-Received: by 2002:adf:8562:: with SMTP id 89mr10925397wrh.214.1602187256875;
        Thu, 08 Oct 2020 13:00:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWrfSGm9ixOxCPW8QdF5CAdI6tKiof9TUB2EwQFmEeCUUsDhhAjPVtVpxFRSxH/O9OPV7uVw==
X-Received: by 2002:adf:8562:: with SMTP id 89mr10925375wrh.214.1602187256545;
        Thu, 08 Oct 2020 13:00:56 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id w11sm8493631wrs.26.2020.10.08.13.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:00:55 -0700 (PDT)
Date:   Thu, 8 Oct 2020 16:00:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] vringh: fix __vringh_iov() when riov and wiov are
 different
Message-ID: <20201008160035-mutt-send-email-mst@kernel.org>
References: <20201008161311.114398-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008161311.114398-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 06:13:11PM +0200, Stefano Garzarella wrote:
> If riov and wiov are both defined and they point to different
> objects, only riov is initialized. If the wiov is not initialized
> by the caller, the function fails returning -EINVAL and printing
> "Readable desc 0x... after writable" error message.
> 
> Let's replace the 'else if' clause with 'if' to initialize both
> riov and wiov if they are not NULL.
> 
> As checkpatch pointed out, we also avoid crashing the kernel
> when riov and wiov are both NULL, replacing BUG() with WARN_ON()
> and returning -EINVAL.
> 
> Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Can you add more detail please? when does this trigger?

> ---
>  drivers/vhost/vringh.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index e059a9a47cdf..8bd8b403f087 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -284,13 +284,14 @@ __vringh_iov(struct vringh *vrh, u16 i,
>  	desc_max = vrh->vring.num;
>  	up_next = -1;
>  
> +	/* You must want something! */
> +	if (WARN_ON(!riov && !wiov))
> +		return -EINVAL;
> +
>  	if (riov)
>  		riov->i = riov->used = 0;
> -	else if (wiov)
> +	if (wiov)
>  		wiov->i = wiov->used = 0;
> -	else
> -		/* You must want something! */
> -		BUG();
>  
>  	for (;;) {
>  		void *addr;
> -- 
> 2.26.2

