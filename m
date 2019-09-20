Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0500B94EE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 18:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391015AbfITQHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 12:07:30 -0400
Received: from foss.arm.com ([217.140.110.172]:46840 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390878AbfITQH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 12:07:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49D5A337;
        Fri, 20 Sep 2019 09:07:29 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BD5F3F575;
        Fri, 20 Sep 2019 09:07:28 -0700 (PDT)
Subject: Re: [PATCH 3/3] genirq/irqdomain: Detect type race in
 irq_create_fwspec_mapping()
To:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc:     Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Glavinic-Pecotic, Matija (EXT - DE/Ulm)" 
        <matija.glavinic-pecotic.ext@nokia.com>,
        "Adamski, Krzysztof (Nokia - PL/Wroclaw)" 
        <krzysztof.adamski@nokia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20190912094343.5480-1-alexander.sverdlin@nokia.com>
 <20190912094343.5480-4-alexander.sverdlin@nokia.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <e86441c4-9ce2-b0f2-f8ca-2823497b4d6d@kernel.org>
Date:   Fri, 20 Sep 2019 17:07:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912094343.5480-4-alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/09/2019 10:44, Sverdlin, Alexander (Nokia - DE/Ulm) wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> irq_create_fwspec_mapping() can race with itself during IRQ trigger type
> configuration. Possible scenarios include:
> 
> - Mapping exists, two irq_create_fwspec_mapping() running in parallel do
>   not detect type mismatch, IRQ remains configured with one of the
>   different trigger types randomly
> - Second call to irq_create_fwspec_mapping() sees existing mapping just
>   created by first call, but earlier irqd_set_trigger_type() call races
>   with later irqd_set_trigger_type() => totally undetected, IRQ type
>   is being set randomly to either one or another type

Is that an actual thing? Frankly, the scenario you're describing here
seems to carry the hallmarks of a completely broken system. Can you
point at a system supported in mainline that would behave as such?

Thanks,

	M.
-- 
Jazz is not dead, it just smells funny...
