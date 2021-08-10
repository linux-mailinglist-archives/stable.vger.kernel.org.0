Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011583E5693
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbhHJJR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:17:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238762AbhHJJR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628587023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DkeSzP9VkPfYeQax1YyqIkrY67oSguQu+huTioXkYzU=;
        b=FRkXGl6jJoEMMabub/VthuGq65mlOPefPY+ZaiStNK5ztjqZSFunAPiCTqSWppto77N/Dk
        QL4ZzxCqYfBJKXlepqOWRdbX0g9By8BfitJi58srIEOWqN+l/TQto6h0pf3OQtG8GKj31A
        3kTaZRmJkxiziLgTg01Cag12l/t5dVM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-_S--knHTNGSFs2hVDsJQ-w-1; Tue, 10 Aug 2021 05:17:02 -0400
X-MC-Unique: _S--knHTNGSFs2hVDsJQ-w-1
Received: by mail-wm1-f69.google.com with SMTP id g70-20020a1c20490000b02902e6753bf473so836182wmg.0
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 02:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DkeSzP9VkPfYeQax1YyqIkrY67oSguQu+huTioXkYzU=;
        b=dLcfw6jL0Vhld8UQN3aJKOSAxM25FQmKJWsulN7+hrAyNQ0mVzeT9zV9Vo1iBfBzTX
         C+l/19FOpR8TRFU6s33kGw8xmrA8InY8No/gdFAlJms0sJdbroI8hFQ/9QAGwvYep+Mf
         cbPQChmclh5PdiMp3Q8KgI6lZ3q0L5yVFhQ/CWGWiyuEFqTwXMpL1raQbzpT+xQufJMk
         4fpJ6F3fl9T7gh8yLkr90nQKBgd6D9wmaq1aN1BTGTUyreUP1N7j4rHTI/L6cuvpwgIh
         r7t9jovBMsGd8XghuWTDMnN0RfANLEOSyWvQupC83ZKXhnNvlL7X7gbfoOf3Py2uW3Hj
         ZlYA==
X-Gm-Message-State: AOAM531zpJpT1lzYas4tdldeoFtwYoRrdMaI7VW3yWgwgZ+vggKdYhE2
        uOcIfc5L2PN8zoMugQQt1mGkcllrTq/31T75SCGmnNTXTNy2x7DTOM8kbiSNHjpCphc/gB9IuY4
        KyPiVKvg8xL4RWY7y
X-Received: by 2002:a05:6000:18c8:: with SMTP id w8mr29282047wrq.90.1628587021388;
        Tue, 10 Aug 2021 02:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPpAi2iIuiLcaawwo2LlD5s7f6gCdx1fyQNes5mi5FZ5eTN577mJvACJkEIhw95UIoeBgHVQ==
X-Received: by 2002:a05:6000:18c8:: with SMTP id w8mr29282031wrq.90.1628587021170;
        Tue, 10 Aug 2021 02:17:01 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.28.170])
        by smtp.gmail.com with ESMTPSA id z6sm19515786wmp.1.2021.08.10.02.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:17:00 -0700 (PDT)
Subject: Re: [PATCH v2] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20210807072057.184698-1-clg@kaod.org>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <350be6b1-a6a9-93f1-5146-d3a76790ed6e@redhat.com>
Date:   Tue, 10 Aug 2021 11:16:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210807072057.184698-1-clg@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/08/2021 09:20, Cédric Le Goater wrote:
> On PowerVM, CPU-less nodes can be populated with hot-plugged CPUs at
> runtime. Today, the IPI is not created for such nodes, and hot-plugged
> CPUs use a bogus IPI, which leads to soft lockups.
> 
> We can not directly allocate and request the IPI on demand because
> bringup_up() is called under the IRQ sparse lock. The alternative is
> to allocate the IPIs for all possible nodes at startup and to request
> the mapping on demand when the first CPU of a node is brought up.
> 
> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
> Cc: stable@vger.kernel.org # v5.13
> Reported-by: Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Laurent Vivier <lvivier@redhat.com>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> Message-Id: <20210629131542.743888-1-clg@kaod.org>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
>  arch/powerpc/sysdev/xive/common.c | 35 +++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index dbdbbc2f1dc5..943fd30095af 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -67,6 +67,7 @@ static struct irq_domain *xive_irq_domain;
>  static struct xive_ipi_desc {
>  	unsigned int irq;
>  	char name[16];
> +	atomic_t started;
>  } *xive_ipis;
>  
>  /*
> @@ -1120,7 +1121,7 @@ static const struct irq_domain_ops xive_ipi_irq_domain_ops = {
>  	.alloc  = xive_ipi_irq_domain_alloc,
>  };
>  
> -static int __init xive_request_ipi(void)
> +static int __init xive_init_ipis(void)
>  {
>  	struct fwnode_handle *fwnode;
>  	struct irq_domain *ipi_domain;
> @@ -1144,10 +1145,6 @@ static int __init xive_request_ipi(void)
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
> @@ -1159,11 +1156,6 @@ static int __init xive_request_ipi(void)
>  		xid->irq = ret;
>  
>  		snprintf(xid->name, sizeof(xid->name), "IPI-%d", node);
> -
> -		ret = request_irq(xid->irq, xive_muxed_ipi_action,
> -				  IRQF_PERCPU | IRQF_NO_THREAD, xid->name, NULL);
> -
> -		WARN(ret < 0, "Failed to request IPI %d: %d\n", xid->irq, ret);
>  	}
>  
>  	return ret;
> @@ -1178,6 +1170,22 @@ static int __init xive_request_ipi(void)
>  	return ret;
>  }
>  
> +static int __init xive_request_ipi(unsigned int cpu)
> +{
> +	struct xive_ipi_desc *xid = &xive_ipis[early_cpu_to_node(cpu)];
> +	int ret;
> +
> +	if (atomic_inc_return(&xid->started) > 1)
> +		return 0;
> +
> +	ret = request_irq(xid->irq, xive_muxed_ipi_action,
> +			  IRQF_PERCPU | IRQF_NO_THREAD,
> +			  xid->name, NULL);
> +
> +	WARN(ret < 0, "Failed to request IPI %d: %d\n", xid->irq, ret);
> +	return ret;
> +}
> +
>  static int xive_setup_cpu_ipi(unsigned int cpu)
>  {
>  	unsigned int xive_ipi_irq = xive_ipi_cpu_to_irq(cpu);
> @@ -1192,6 +1200,9 @@ static int xive_setup_cpu_ipi(unsigned int cpu)
>  	if (xc->hw_ipi != XIVE_BAD_IRQ)
>  		return 0;
>  
> +	/* Register the IPI */
> +	xive_request_ipi(cpu);
> +
>  	/* Grab an IPI from the backend, this will populate xc->hw_ipi */
>  	if (xive_ops->get_ipi(cpu, xc))
>  		return -EIO;
> @@ -1231,6 +1242,8 @@ static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
>  	if (xc->hw_ipi == XIVE_BAD_IRQ)
>  		return;
>  
> +	/* TODO: clear IPI mapping */
> +
>  	/* Mask the IPI */
>  	xive_do_source_set_mask(&xc->ipi_data, true);
>  
> @@ -1253,7 +1266,7 @@ void __init xive_smp_probe(void)
>  	smp_ops->cause_ipi = xive_cause_ipi;
>  
>  	/* Register the IPI */
> -	xive_request_ipi();
> +	xive_init_ipis();
>  
>  	/* Allocate and setup IPI for the boot CPU */
>  	xive_setup_cpu_ipi(smp_processor_id());
> 

Tested-by: Laurent Vivier <lvivier@redhat.com>

