Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8233F3CCE94
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 09:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhGSHhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 03:37:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234789AbhGSHhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 03:37:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626680074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jOr/p3ZhI+etOrrN3Zi2nraDobql1IKzoKipTp4TP6E=;
        b=LDMzhtTkuXYe/KdChauf6G5gbonjVqz9wuYo2QNwLCSmIrL8K5QSQbP78hENVw68UppQQF
        +WWIGt8GMaO7jxpPq9a3aer8NwgneC1p3MRA7h9FbQg/Q9xH9ajWdaCLgavXIkNtVXLwUG
        bbr/LldyDAX8ARVyECIRaU07052KYrY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-N3cDzGw2OYKXn6XayWHiBg-1; Mon, 19 Jul 2021 03:34:33 -0400
X-MC-Unique: N3cDzGw2OYKXn6XayWHiBg-1
Received: by mail-wm1-f72.google.com with SMTP id n5-20020a05600c3b85b02902152e9caa1dso3599740wms.3
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 00:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jOr/p3ZhI+etOrrN3Zi2nraDobql1IKzoKipTp4TP6E=;
        b=NnCEL34oAp+rRs6EsMnslLDC/BFHoHBgkIrjM8FDLWcDb3HEjAnJQ7HjOEQcFNTQhH
         dcuqELJKtjahC4S+j07uyuRAceVBKY11bYSaYd6zJixY9zN8kZ9l9q4lheJz7MoSLib1
         KeJMVW2wMvpFtzgSisJWm4YfHePVVufJD8l6vQyJ+euGH0qhxIbqs5j8A+XrnUYe5lHv
         QamZkNu4PBE6Fs6B49DS6jsEUxkv1RWGcDYFpLsbYHYsexKL8fbfldINKXP2l6488Mk7
         IN8CY2o67uVjZoZOkjnP8nvPhYCOqaKSEyifym9xZVNwsaNPeYdn+OZbkfcy/gEeZmN6
         Z+OA==
X-Gm-Message-State: AOAM531X6cAWnV4hgdFPq8c7Q3D5VXxvPXp1x9RBU4mPCCupcRODU5ZG
        G8a99E/3wzjLcn9kl2Efa2ih2LPXZgI5UG2dJQH124Kv5eCOEAVxcJJdjHu/Ha4LP2grazOgEKs
        9uhgqOInoPpa1kgiU
X-Received: by 2002:a1c:4603:: with SMTP id t3mr30543674wma.178.1626680072118;
        Mon, 19 Jul 2021 00:34:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4JmBlHgpvtENl1P0gPmtxrbpR7YPHRRWA08ddnW+DEM6maj6QCOlmFbATn/hUjX9m+hB8yg==
X-Received: by 2002:a1c:4603:: with SMTP id t3mr30543647wma.178.1626680071866;
        Mon, 19 Jul 2021 00:34:31 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.17.146])
        by smtp.gmail.com with ESMTPSA id m32sm18461358wms.23.2021.07.19.00.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 00:34:31 -0700 (PDT)
Subject: Re: [PATCH] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20210629131542.743888-1-clg@kaod.org>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <8eed20ea-1b87-7263-95f0-c09dc9cd656e@redhat.com>
Date:   Mon, 19 Jul 2021 09:34:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629131542.743888-1-clg@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/06/2021 15:15, Cédric Le Goater wrote:
> On PowerVM, CPU-less nodes can be populated with hot-plugged CPUs at
> runtime. Today, the IPI is not created for such nodes, and hot-plugged
> CPUs use a bogus IPI, which leads to soft lockups.
> 
> We could create the node IPI on demand but it is a bit complex because
> this code would be called under bringup_up() and some IRQ locking is
> being done. The simplest solution is to create the IPIs for all nodes
> at startup.
> 
> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
> Cc: stable@vger.kernel.org # v5.13
> Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
> 
> This patch breaks old versions of irqbalance (<= v1.4). Possible nodes
> are collected from /sys/devices/system/node/ but CPU-less nodes are
> not listed there. When interrupts are scanned, the link representing
> the node structure is NULL and segfault occurs.
> 
> Version 1.7 seems immune. 
> 
> ---
>  arch/powerpc/sysdev/xive/common.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index f3b16ed48b05..5d2c58dba57e 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1143,10 +1143,6 @@ static int __init xive_request_ipi(void)
>  		struct xive_ipi_desc *xid = &xive_ipis[node];
>  		struct xive_ipi_alloc_info info = { node };
>  
> -		/* Skip nodes without CPUs */
> -		if (cpumask_empty(cpumask_of_node(node)))
> -			continue;
> -
>  		/*
>  		 * Map one IPI interrupt per node for all cpus of that node.
>  		 * Since the HW interrupt number doesn't have any meaning,
> 

What happened to this fix? Will it be merged?

Thanks,
Laurent

