Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D6637EF9B
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbhELXOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:14:32 -0400
Received: from mail.ispras.ru ([83.149.199.84]:37386 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443603AbhELWff (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 18:35:35 -0400
Received: from monopod.intra.ispras.ru (unknown [10.10.3.121])
        by mail.ispras.ru (Postfix) with ESMTPS id CF6394076B2A;
        Wed, 12 May 2021 22:34:22 +0000 (UTC)
Date:   Thu, 13 May 2021 01:34:22 +0300 (MSK)
From:   Alexander Monakov <amonakov@ispras.ru>
To:     Huang Rui <ray.huang@amd.com>
cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
In-Reply-To: <20210425073451.2557394-1-ray.huang@amd.com>
Message-ID: <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
References: <20210425073451.2557394-1-ray.huang@amd.com>
User-Agent: Alpine 2.20.13 (LNX 116 2015-12-14)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 25 Apr 2021, Huang Rui wrote:

> Some AMD Ryzen generations has different calculation method on maximum
> perf. 255 is not for all asics, some specific generations should use 166
> as the maximum perf. Otherwise, it will report incorrect frequency value
> like below:

The commit message says '255', but the code:

> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
>  		break;
>  	}
>  }
> +
> +u32 amd_get_highest_perf(void)
> +{
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> +			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
> +	    return 166;
> +
> +	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> +			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
> +	    return 166;
> +
> +	return 225;
> +}

says 225? This is probably a typo? In any case they are out of sync.

Alexander
