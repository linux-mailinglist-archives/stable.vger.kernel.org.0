Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF392D9521
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388844AbgLNJXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 04:23:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407581AbgLNJXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 04:23:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607937702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ExG60KKlF27+8sDgoAULeoQK5L/9Xh4S1a/pTyDpoc=;
        b=bxrAMd5u4S/BmljlkT8o+5wIF7kbvzjAnQJb8CA0ifTkdV6xhNE6J6amrddyC1UK+KYSjD
        veQwpKsYmOr9ION5vurM72Y4yycle65wN9YxQOQzvtxgD/yVHtnhWDFf4FplNT6syZ3Jc0
        MSaC6yZqpHP8ChNuoq9cQobC8YpvzDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-HC01vjxcOq2wGt7rQy6bSA-1; Mon, 14 Dec 2020 04:21:41 -0500
X-MC-Unique: HC01vjxcOq2wGt7rQy6bSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 671CD801817;
        Mon, 14 Dec 2020 09:21:38 +0000 (UTC)
Received: from [10.36.114.184] (ovpn-114-184.ams2.redhat.com [10.36.114.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86E9210016F6;
        Mon, 14 Dec 2020 09:21:35 +0000 (UTC)
Subject: Re: [PATCH] ARM: dts: ux500: Reserve memory carveouts
To:     Linus Walleij <linus.walleij@linaro.org>, arm@kernel.org,
        soc@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Pavel Procopiuc <pavel.procopiuc@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>, wi nk <wink@technolu.st>
References: <20201213225517.3838501-1-linus.walleij@linaro.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <cc06e06b-ff24-68a2-f5f3-c8533118a34d@redhat.com>
Date:   Mon, 14 Dec 2020 10:21:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201213225517.3838501-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13.12.20 23:55, Linus Walleij wrote:
> The Ux500 platforms have some memory carveouts set aside for
> communicating with the modem and for the initial secure software
> (ISSW). These areas are protected by the memory controller
> and will result in an external abort if accessed like common
> read/write memory.
> 
> On the legacy boot loaders, these were set aside by using
> cmdline arguments such as this:
> 
>   mem=96M@0 mem_mtrace=15M@96M mem_mshared=1M@111M
>   mem_modem=16M@112M mali.mali_mem=32M@128M mem=96M@160M
>   hwmem=127M@256M mem_issw=1M@383M mem_ram_console=1M@384M
>   mem=638M@385M
> 
> Reserve the relevant areas in the device tree instead. The
> "mali", "hwmem", "mem_ram_console" and the trailing 1MB at the
> end of the memory reservations in the list are not relevant for
> the upstream kernel as these are nowadays replaced with
> upstream technologies such as CMA. The modem and ISSW
> reservations are necessary.
> 
> This was manifested in a bug that surfaced in response to
> commit 7fef431be9c9 ("mm/page_alloc: place pages to tail in __free_pages_core()")
> which changes the behaviour of memory allocations
> in such a way that the platform will sooner run into these
> dangerous areas, with "Unhandled fault: imprecise external
> abort (0xc06) at 0xb6fd83dc" or similar: the real reason
> turns out to be that the PTE is pointing right into one of
> the reserved memory areas. We were just lucky until now.
> 
> We need to augment the DB8500 and DB8520 SoCs similarly
> and also create a new include for the DB9500 used in the
> Snowball since this does not have a modem and thus does
> not need the modem memory reservation, albeit it needs
> the ISSW reservation.
> 
> Cc: stable@vger.kernel.org
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ARM SoC folks: please apply this directly for fixes.

Can we come up with a Fixes: tag or has this been broken forever?
(assuming modern boot loaders)

> 
> David: just FYI if you run into more of these type of
> regressions. Actually the patch is unintentionally good
> at smoking out other bugs :D

Thanks for CCing - I'm adding some people that ran into similar issues,
but not sure if the other bugreports are related (or have similar root
causes).

Thanks a lot!

> ---
>  arch/arm/boot/dts/ste-db8500.dtsi  | 38 ++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/ste-db8520.dtsi  | 38 ++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/ste-db9500.dtsi  | 35 +++++++++++++++++++++++++++
>  arch/arm/boot/dts/ste-snowball.dts |  2 +-
>  4 files changed, 112 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/ste-db9500.dtsi
> 
> diff --git a/arch/arm/boot/dts/ste-db8500.dtsi b/arch/arm/boot/dts/ste-db8500.dtsi
> index d309fad32229..344d29853bf7 100644
> --- a/arch/arm/boot/dts/ste-db8500.dtsi
> +++ b/arch/arm/boot/dts/ste-db8500.dtsi
> @@ -12,4 +12,42 @@ cpu@300 {
>  					    200000 0>;
>  		};
>  	};
> +
> +	reserved-memory {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		/* Modem trace memory */
> +		ram@06000000 {
> +			reg = <0x06000000 0x00f00000>;
> +			no-map;
> +		};
> +
> +		/* Modem shared memory */
> +		ram@06f00000 {
> +			reg = <0x06f00000 0x00100000>;
> +			no-map;
> +		};
> +
> +		/* Modem private memory */
> +		ram@07000000 {
> +			reg = <0x07000000 0x01000000>;
> +			no-map;
> +		};
> +
> +		/*
> +		 * Initial Secure Software ISSW memory
> +		 *
> +		 * This is probably only used if the kernel tries
> +		 * to actually call into trustzone to run secure
> +		 * applications, which the mainline kernel probably
> +		 * will not do on this old chipset. But you can never
> +		 * be too careful, so reserve this memory anyway.
> +		 */
> +		ram@17f00000 {
> +			reg = <0x17f00000 0x00100000>;
> +			no-map;
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/ste-db8520.dtsi b/arch/arm/boot/dts/ste-db8520.dtsi
> index 48bd8728ae27..287804e9e183 100644
> --- a/arch/arm/boot/dts/ste-db8520.dtsi
> +++ b/arch/arm/boot/dts/ste-db8520.dtsi
> @@ -12,4 +12,42 @@ cpu@300 {
>  					    200000 0>;
>  		};
>  	};
> +
> +	reserved-memory {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		/* Modem trace memory */
> +		ram@06000000 {
> +			reg = <0x06000000 0x00f00000>;
> +			no-map;
> +		};
> +
> +		/* Modem shared memory */
> +		ram@06f00000 {
> +			reg = <0x06f00000 0x00100000>;
> +			no-map;
> +		};
> +
> +		/* Modem private memory */
> +		ram@07000000 {
> +			reg = <0x07000000 0x01000000>;
> +			no-map;
> +		};
> +
> +		/*
> +		 * Initial Secure Software ISSW memory
> +		 *
> +		 * This is probably only used if the kernel tries
> +		 * to actually call into trustzone to run secure
> +		 * applications, which the mainline kernel probably
> +		 * will not do on this old chipset. But you can never
> +		 * be too careful, so reserve this memory anyway.
> +		 */
> +		ram@17f00000 {
> +			reg = <0x17f00000 0x00100000>;
> +			no-map;
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/ste-db9500.dtsi b/arch/arm/boot/dts/ste-db9500.dtsi
> new file mode 100644
> index 000000000000..0afff703191c
> --- /dev/null
> +++ b/arch/arm/boot/dts/ste-db9500.dtsi
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include "ste-dbx5x0.dtsi"
> +
> +/ {
> +	cpus {
> +		cpu@300 {
> +			/* cpufreq controls */
> +			operating-points = <1152000 0
> +					    800000 0
> +					    400000 0
> +					    200000 0>;
> +		};
> +	};
> +
> +	reserved-memory {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		/*
> +		 * Initial Secure Software ISSW memory
> +		 *
> +		 * This is probably only used if the kernel tries
> +		 * to actually call into trustzone to run secure
> +		 * applications, which the mainline kernel probably
> +		 * will not do on this old chipset. But you can never
> +		 * be too careful, so reserve this memory anyway.
> +		 */
> +		ram@17f00000 {
> +			reg = <0x17f00000 0x00100000>;
> +			no-map;
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/ste-snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
> index be90e73c923e..27d8a07718a0 100644
> --- a/arch/arm/boot/dts/ste-snowball.dts
> +++ b/arch/arm/boot/dts/ste-snowball.dts
> @@ -4,7 +4,7 @@
>   */
>  
>  /dts-v1/;
> -#include "ste-db8500.dtsi"
> +#include "ste-db9500.dtsi"
>  #include "ste-href-ab8500.dtsi"
>  #include "ste-href-family-pinctrl.dtsi"
>  
> 


-- 
Thanks,

David / dhildenb

