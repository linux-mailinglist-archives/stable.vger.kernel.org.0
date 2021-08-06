Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FEC3E2A83
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 14:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343643AbhHFM3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 08:29:24 -0400
Received: from 10.mo548.mail-out.ovh.net ([46.105.77.235]:42317 "EHLO
        10.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243697AbhHFM3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 08:29:23 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2021 08:29:23 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.180])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 7A22A21528;
        Fri,  6 Aug 2021 11:50:44 +0000 (UTC)
Received: from kaod.org (37.59.142.106) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 6 Aug
 2021 13:50:44 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-106R006bcd50b7e-2836-479a-8c36-44614f20876d,
                    16539864E05634894329FA20EA83374F96163E53) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.66.77.115
Subject: Re: [PATCH] powerpc/xive: Do not skip CPU-less nodes when creating
 the IPIs
To:     <linuxppc-dev@lists.ozlabs.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>, <stable@vger.kernel.org>,
        Geetika Moolchandani <Geetika.Moolchandani1@ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>,
        David Gibson <dgibson@redhat.com>
References: <20210629131542.743888-1-clg@kaod.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <481023b5-6857-1331-23cd-e9eabd511821@kaod.org>
Date:   Fri, 6 Aug 2021 13:50:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629131542.743888-1-clg@kaod.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.106]
X-ClientProxiedBy: DAG4EX2.mxp5.local (172.16.2.32) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 83c5ca11-b7a2-4bc7-93f8-aa49a58418c9
X-Ovh-Tracer-Id: 2455587698605460329
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvtddrjedugdegfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeehuedtheeghfdvhedtueelteegvdefueektdefiefhffffieduuddtudfhgfevtdenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhg
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/29/21 3:15 PM, Cédric Le Goater wrote:
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

This is an irqbalance regression due to :

  https://github.com/Irqbalance/irqbalance/pull/172

I will report through an issue. 

Anyhow, there is a better approach which is to allocate IPIs for all 
nodes at boot time and do the mapping on demand. Removing the mapping 
on last use seems more complex though. 

I will send a v2 after some tests.  

Thanks,

C.

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

