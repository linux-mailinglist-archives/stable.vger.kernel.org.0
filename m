Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B4837A271
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 10:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhEKItR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 04:49:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhEKItQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 04:49:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620722890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PoB6tmhK0ojxZqg4RY27A1X/0CCVW4jvcBEro4rmZ2U=;
        b=DOPKK4oRwvrvoCYmx+JYC8HVRiAGWOfa+jnw2aKehisVd/ToQSG/EY5Vr4yU0l3kbQxbev
        QWXMNtH+PJy/I/+yVGvunNm4tEonUxIoTMdZ+9DrgU9ZhYNEPe6bGchNFT5cuG6COwQ/kr
        CHcHrWRJ4Ro9xdFEE2MVZX/fWVWZgx8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-m4n9cA6jNua4troa_Ty4Ew-1; Tue, 11 May 2021 04:48:08 -0400
X-MC-Unique: m4n9cA6jNua4troa_Ty4Ew-1
Received: by mail-wr1-f71.google.com with SMTP id v10-20020adfc40a0000b029010eb3c9a689so727682wrf.16
        for <stable@vger.kernel.org>; Tue, 11 May 2021 01:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PoB6tmhK0ojxZqg4RY27A1X/0CCVW4jvcBEro4rmZ2U=;
        b=q7yFVpnMUxTY+txDmWikUxDUE/vwcXdLZnxI9bTELpEq39XPxy/sd+pDBmkk6taKF/
         5uS3HfBrUUUxI6aUU+HRHSxZm0gWr/HspctoUHo461ilHHBISFyye9hUwAixuarZozQS
         fzhQ9jmAgoRJSkKuOM/4E2EeWQroVDMsuiy7IWOPkuKD/Ns56r6be0rEFEpbf4Krh1hD
         8TZEvbFsuW5dOe3tBZrGxmxw3+ylLJ11zOq/YBvTP8suNhbD9HUauOZ+1XX9/ZjJvXHD
         IST3C+blxoXY9pwYNTqGQZXDsqm3YX2kkpIe9/Pe01rJMlB4nrCwjnyn3nHFcks8vY26
         U9wA==
X-Gm-Message-State: AOAM533I8/IXuRnSZ/WKA4eBcEMLiXZ/dobz21EGGiiIX8qpLNA3jae6
        VCCOf/d2y081SpAn662kLTLEqodpxikOm9+tyrjFDwp6VM3TSxLrAxFkUMgdnkQsDQiWtQUthni
        K0dgDQZ0f9+WVAHyw
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr31902618wmh.42.1620722887553;
        Tue, 11 May 2021 01:48:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSGeb9zeNJcEJc46A/MASJMpLh0cSVeptzLQX8/dyHTwjbhVOWjTy0K8ideXs9zrKhUkYH5w==
X-Received: by 2002:a1c:4d01:: with SMTP id o1mr31902599wmh.42.1620722887375;
        Tue, 11 May 2021 01:48:07 -0700 (PDT)
Received: from redhat.com ([2a10:8004:640e:0:d1db:1802:5043:7b85])
        by smtp.gmail.com with ESMTPSA id l18sm26972171wrt.97.2021.05.11.01.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 01:48:06 -0700 (PDT)
Date:   Tue, 11 May 2021 04:48:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, maz@kernel.org, alex.williamson@redhat.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
Message-ID: <20210511044756-mutt-send-email-mst@kernel.org>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 08, 2021 at 03:11:52PM +0800, Zhu Lingshan wrote:
> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
> 
> The reverted commit may cause VM freeze on arm64 platform.
> Because on arm64 platform, stop a consumer will suspend the VM,
> the VM will freeze without a start consumer
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  virt/lib/irqbypass.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index c9bb3957f58a..28fda42e471b 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer *prod,
>  	if (prod->add_consumer)
>  		ret = prod->add_consumer(prod, cons);
>  
> -	if (ret)
> -		goto err_add_consumer;
> -
> -	ret = cons->add_producer(cons, prod);
> -	if (ret)
> -		goto err_add_producer;
> +	if (!ret) {
> +		ret = cons->add_producer(cons, prod);
> +		if (ret && prod->del_consumer)
> +			prod->del_consumer(prod, cons);
> +	}
>  
>  	if (cons->start)
>  		cons->start(cons);
>  	if (prod->start)
>  		prod->start(prod);
> -err_add_producer:
> -	if (prod->del_consumer)
> -		prod->del_consumer(prod, cons);
> -err_add_consumer:
> +
>  	return ret;
>  }
>  
> -- 
> 2.27.0

