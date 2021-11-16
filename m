Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82DD45391E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239282AbhKPSFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:05:08 -0500
Received: from 2.mo552.mail-out.ovh.net ([178.33.105.233]:39505 "EHLO
        2.mo552.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239262AbhKPSFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 13:05:07 -0500
Received: from mxplan5.mail.ovh.net (unknown [10.109.138.7])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 1704921485;
        Tue, 16 Nov 2021 17:56:03 +0000 (UTC)
Received: from kaod.org (37.59.142.97) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 16 Nov
 2021 18:56:02 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-97G002d58e9868-7e9e-4c60-b756-0af7795efd8f,
                    BFAEB7FE3C4E2C4D96001007C3BA12B7689A693E) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 129.41.46.1
Message-ID: <de78659b-1044-b970-6626-e9a5ceeb42b7@kaod.org>
Date:   Tue, 16 Nov 2021 18:56:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] powerpc/xive: Change IRQ domain to a tree domain
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
CC:     <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kurz <groug@kaod.org>, <stable@vger.kernel.org>
References: <20211116134022.420412-1-clg@kaod.org>
 <874k8c82cn.wl-maz@kernel.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <874k8c82cn.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG9EX2.mxp5.local (172.16.2.82) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 0445f3c0-5ed6-4ebc-a344-ab6638c91627
X-Ovh-Tracer-Id: 17344206590952442788
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrfedvgddutdegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepieegvdffkeegfeetuddttddtveduiefhgeduffekiedtkeekteekhfffleevleelnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehgrhhouhhgsehkrghougdrohhrgh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 17:58, Marc Zyngier wrote:
> On Tue, 16 Nov 2021 13:40:22 +0000,
> Cédric Le Goater <clg@kaod.org> wrote:
>>
>> Commit 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains
>> exclusive") introduced an IRQ_DOMAIN_FLAG_NO_MAP flag to isolate the
>> 'nomap' domains still in use under the powerpc arch. With this new
>> flag, the revmap_tree of the IRQ domain is not used anymore. This
>> change broke the support of shared LSIs [1] in the XIVE driver because
>> it was relying on a lookup in the revmap_tree to query previously
>> mapped interrupts.
> 
> Just a lookup? Surely there is more to it, no?

nope. The HW IRQ for the INTx is defined in the DT. It is caught by
of_irq_parse_and_map_pci() which simply adds an extra mapping on the
same INTx since the previous one is not found.

Using an INTx is quite rare now days and a shared one is even more
uncommon I guess, I could only reproduced on the baremetal platform
with the QEMU PowerNV machine using the same virtio devices.

Thanks,

C.
  
> 
>> Linux now creates two distinct IRQ mappings on the
>> same HW IRQ which can lead to unexpected behavior in the drivers.
>>
>> The XIVE IRQ domain is not a direct mapping domain and its HW IRQ
>> interrupt number space is rather large : 1M/socket on POWER9 and
>> POWER10, change the XIVE driver to use a 'tree' domain type instead.
>>
>> [1] For instance, a linux KVM guest with virtio-rng and virtio-balloon
>>      devices.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org # v5.14+
>> Fixes: 4f86a06e2d6e ("irqdomain: Make normal and nomap irqdomains exclusive")
>> Signed-off-by: Cédric Le Goater <clg@kaod.org>
>> ---
>>
>>   Marc,
>>
>>   The Fixes tag is there because the patch in question revealed that
>>   something was broken in XIVE. genirq is not in cause. However, I
>>   don't know for PS3 and Cell. May be less critical for now.
> 
> Depends if they expect something that a no-map domain cannot provide.> 
>>   
>>   arch/powerpc/sysdev/xive/common.c | 3 +--
>>   arch/powerpc/sysdev/xive/Kconfig  | 1 -
>>   2 files changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
>> index fed6fd16c8f4..9d0f0fe25598 100644
>> --- a/arch/powerpc/sysdev/xive/common.c
>> +++ b/arch/powerpc/sysdev/xive/common.c
>> @@ -1536,8 +1536,7 @@ static const struct irq_domain_ops xive_irq_domain_ops = {
>>   
>>   static void __init xive_init_host(struct device_node *np)
>>   {
>> -	xive_irq_domain = irq_domain_add_nomap(np, XIVE_MAX_IRQ,
>> -					       &xive_irq_domain_ops, NULL);
>> +	xive_irq_domain = irq_domain_add_tree(np, &xive_irq_domain_ops, NULL);
>>   	if (WARN_ON(xive_irq_domain == NULL))
>>   		return;
>>   	irq_set_default_host(xive_irq_domain);
>> diff --git a/arch/powerpc/sysdev/xive/Kconfig b/arch/powerpc/sysdev/xive/Kconfig
>> index 97796c6b63f0..785c292d104b 100644
>> --- a/arch/powerpc/sysdev/xive/Kconfig
>> +++ b/arch/powerpc/sysdev/xive/Kconfig
>> @@ -3,7 +3,6 @@ config PPC_XIVE
>>   	bool
>>   	select PPC_SMP_MUXED_IPI
>>   	select HARDIRQS_SW_RESEND
>> -	select IRQ_DOMAIN_NOMAP
>>   
>>   config PPC_XIVE_NATIVE
>>   	bool
> 
> As long as this works, I'm happy with one less no-map user.
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> 
> 	M.
> 

