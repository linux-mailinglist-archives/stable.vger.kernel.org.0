Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902A03BED32
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 19:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhGGRkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 13:40:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229953AbhGGRkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 13:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625679450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZcg4pbX4DqrmDVnsG+v20JrCZKWBMOdM4aseOUqFpw=;
        b=PCHPVMypu507z+IgX13p5Fyj/cehK9qKDqWMuv8HLRf21NyvZGxBfLDVgSL2Fo9fWK4jDe
        gbWi2bMkJUQMZIb6Mb5RXJeJZ1NIbBjF3j8KVgH++GE2M6QnvwEwYZNxLWhnemORjo82cR
        KK+FSXNCibjUYWM0gJ1giG17BO9IjiI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-hsEidu_2O1uS9bvLIdRJBg-1; Wed, 07 Jul 2021 13:37:29 -0400
X-MC-Unique: hsEidu_2O1uS9bvLIdRJBg-1
Received: by mail-wm1-f71.google.com with SMTP id m40-20020a05600c3b28b02901f42375a73fso1270762wms.5
        for <stable@vger.kernel.org>; Wed, 07 Jul 2021 10:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TZcg4pbX4DqrmDVnsG+v20JrCZKWBMOdM4aseOUqFpw=;
        b=NNw9dA16426ndW+EADTpKvoWtOLshD9clsYqyvA2Qo3ymywCeQQMuePVKIZ4Bcfaob
         Pv+140rGQIh4apycED1Klq2p8GeQb7qU5gi8BJ/IkGX0fNx+9aLZNiMCOmMDb7U4WAWO
         iEzwMh07Ozl65Gl0I6rwrci1hYA00aI5pxrVkup5UVaunHsVFuk0XhmumNcZmaea8UHU
         B8GkWQQhi+XIZH84VDNUa07KT6hDj7QoBZw7ILWydaKJ6kdqmNWEXdlpPZR8Yz0z0lg4
         0b2N+FGEbQirx5gVzajqucoJTgo5+d2k/sHyM/5vmMFhRM6LvrVSlHfBdrPckKIHU/4F
         /GOg==
X-Gm-Message-State: AOAM531w2kGOTfcE2q4lygR8rTbBDKrGrfIsWltUY2DRxFm/m9UDgMne
        ul9gxEJvcYuZy8fNMBIkNesDNzLIRYjbwXwi8bWW4tvOzCewai8IcwCiPMpRO0wPw0WseXeuVzT
        j2wWPRh0487a+ZS2W
X-Received: by 2002:a7b:c351:: with SMTP id l17mr28107950wmj.120.1625679448160;
        Wed, 07 Jul 2021 10:37:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz/LwMibWOtU4uAWyJ9yuaponiWXXmzXyq/qdmRqGDFpIVaWsqzbq/snuA9PDDhnqwxCsksA==
X-Received: by 2002:a7b:c351:: with SMTP id l17mr28107936wmj.120.1625679447987;
        Wed, 07 Jul 2021 10:37:27 -0700 (PDT)
Received: from [192.168.100.43] ([82.142.13.34])
        by smtp.gmail.com with ESMTPSA id z12sm17883895wrs.39.2021.07.07.10.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 10:37:27 -0700 (PDT)
Subject: Re: [PATCH] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20210629131542.743888-1-clg@kaod.org>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <36bc9257-b39b-ae6c-1df5-9006de989220@redhat.com>
Date:   Wed, 7 Jul 2021 19:37:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629131542.743888-1-clg@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
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

Tested-by: Laurent Vivier <lvivier@redhat.com>

