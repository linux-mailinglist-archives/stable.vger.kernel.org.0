Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878FB3E5E1F
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhHJOkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:40:24 -0400
Received: from 10.mo52.mail-out.ovh.net ([87.98.187.244]:49742 "EHLO
        10.mo52.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241056AbhHJOkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 10:40:23 -0400
X-Greylist: delayed 7800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 10:40:23 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.188])
        by mo52.mail-out.ovh.net (Postfix) with ESMTPS id 4F9CE28D983;
        Tue, 10 Aug 2021 14:10:34 +0200 (CEST)
Received: from kaod.org (37.59.142.96) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 10 Aug
 2021 14:10:33 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-96R001585fc535-c7b1-4071-ab7c-464b626dbf3e,
                    8F36BE46FB8773C29BD4C9A30C998E4B5B7B2B54) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 90.89.73.13
Subject: Re: [PATCH v2] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
To:     <linuxppc-dev@lists.ozlabs.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>, <stable@vger.kernel.org>,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>
References: <20210807072057.184698-1-clg@kaod.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <dbcf71dc-2e5e-a6bc-9b55-f4e2f023dfd5@kaod.org>
Date:   Tue, 10 Aug 2021 14:10:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210807072057.184698-1-clg@kaod.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.96]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 898aff2c-2d0f-455e-ae6c-791ba1f98149
X-Ovh-Tracer-Id: 7834574503954189094
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddrjeelgdehtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeehuedtheeghfdvhedtueelteegvdefueektdefiefhffffieduuddtudfhgfevtdenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtoheplhhinhhugihpphgtqdguvghvsehlihhsthhsrdhoiihlrggsshdrohhrgh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/7/21 9:20 AM, Cédric Le Goater wrote:
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

I forgot to add that this version does break irqbalance anymore, since
Linux is not mapping interrupts of CPU-less nodes.

Anyhow, irqbalance is now fixed : 

  https://github.com/Irqbalance/irqbalance/commit/a7f81483a95a94d6a62ca7fb999a090e01c0de9b

So v1 (plus irqbalance patch above) or v2 are safe to use. I do prefer 
v2.

Thanks to Laurent and Srikar for the extra tests,

C.

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

