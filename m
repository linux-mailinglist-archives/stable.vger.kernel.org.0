Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24B2B894A
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 02:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgKSBG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 20:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgKSBG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 20:06:57 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9406AC0613D4;
        Wed, 18 Nov 2020 17:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=DkkuC7VWEA5rRpQu3YK0mSSXd45pdIlKRWtL53OACIQ=; b=mxdTQ/3OC5TCr90LtaZiv6/FqR
        Jfd2m1//leZEM5AxDifA6+F3GugpswdGWbh2qqV4ueuBiNOoskoxzchoZyRaP9w0ychgO1LqzYOXx
        k523oMstVx3E2RoLdSCyWE8D/OKqBC7O4vwyv+bFW9bEt7B9kHG9V3gUE1ocq3EvCG8mu0cOC+VNR
        Km4NSwa69+ZMFyn3d3wqsInfWb4RjKaE70Kx6rnZy43OFRotYTDAtr76J+8NZ9PHqfLp35UEte80J
        6F3ll8qUTEZtryn8NBdd57wEAwNe+BGrZs5M3HcXsL7sWng2cjOTBR93HGej3xDxZ57dMD0i1fYuQ
        RPKAkubA==;
Received: from [2601:1c0:6280:3f0::bcc4]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfYPS-0000Oi-Gw; Thu, 19 Nov 2020 01:06:50 +0000
Subject: Re: [PATCH 1/1] kernel/crash_core.c - Add crashkernel=auto for x86
 and ARM
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     john.p.donnelly@oracle.com, stable@vger.kernel.org,
        Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Vinod Koul <vkoul@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Anson Huang <Anson.Huang@nxp.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?Q?Diego_Elio_Petten=c3=b2?= <flameeyes@flameeyes.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7f9e6b63-1727-379b-55b7-9ad2bbdb2e5b@infradead.org>
Date:   Wed, 18 Nov 2020 17:06:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201118232431.21832-1-saeed.mirzamohammadi@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/18/20 3:24 PM, Saeed Mirzamohammadi wrote:
> This adds crashkernel=auto feature to configure reserved memory for
> vmcore creation to both x86 and ARM platforms based on the total memory
> size.
> 
> Cc: stable@vger.kernel.org

why?

> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> ---
>  Documentation/admin-guide/kdump/kdump.rst |  5 +++++
>  arch/arm64/Kconfig                        | 26 ++++++++++++++++++++++-
>  arch/arm64/configs/defconfig              |  1 +
>  arch/x86/Kconfig                          | 26 ++++++++++++++++++++++-
>  arch/x86/configs/x86_64_defconfig         |  1 +
>  kernel/crash_core.c                       | 20 +++++++++++++++--
>  6 files changed, 75 insertions(+), 4 deletions(-)
> 

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1515f6f153a0..d359dcffa80e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig

> @@ -1135,6 +1135,30 @@ config CRASH_DUMP
>  
>  	  For more details see Documentation/admin-guide/kdump/kdump.rst
>  
> +if CRASH_DUMP
> +
> +config CRASH_AUTO_STR
> +        string "Memory reserved for crash kernel"

use tab instead of spaces above.

> +	depends on CRASH_DUMP
> +        default "1G-64G:128M,64G-1T:256M,1T-:512M"

ditto.

> +	help
> +	  This configures the reserved memory dependent
> +	  on the value of System RAM. The syntax is:
> +	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> +	              range=start-[end]
> +
> +	  For example:
> +	      crashkernel=512M-2G:64M,2G-:128M
> +
> +	  This would mean:
> +
> +	      1) if the RAM is smaller than 512M, then don't reserve anything
> +	         (this is the "rescue" case)
> +	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> +	      3) if the RAM size is larger than 2G, then reserve 128M
> +
> +endif # CRASH_DUMP
> +
>  config XEN_DOM0
>  	def_bool y
>  	depends on XEN

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f6946b81f74a..bacd17312bb1 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig

> @@ -2049,6 +2049,30 @@ config CRASH_DUMP
>  	  (CONFIG_RELOCATABLE=y).
>  	  For more details see Documentation/admin-guide/kdump/kdump.rst
>  
> +if CRASH_DUMP
> +
> +config CRASH_AUTO_STR
> +        string "Memory reserved for crash kernel" if X86_64

ditto.

> +	depends on CRASH_DUMP
> +        default "1G-64G:128M,64G-1T:256M,1T-:512M"

ditto.

> +	help
> +	  This configures the reserved memory dependent
> +	  on the value of System RAM. The syntax is:
> +	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> +	              range=start-[end]
> +
> +	  For example:
> +	      crashkernel=512M-2G:64M,2G-:128M
> +
> +	  This would mean:
> +
> +	      1) if the RAM is smaller than 512M, then don't reserve anything
> +	         (this is the "rescue" case)
> +	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> +	      3) if the RAM size is larger than 2G, then reserve 128M
> +
> +endif # CRASH_DUMP
> +
>  config KEXEC_JUMP
>  	bool "kexec jump"
>  	depends on KEXEC && HIBERNATION

> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 106e4500fd53..a44cd9cc12c4 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -7,6 +7,7 @@
>  #include <linux/crash_core.h>
>  #include <linux/utsname.h>
>  #include <linux/vmalloc.h>
> +#include <linux/kexec.h>
>  
>  #include <asm/page.h>
>  #include <asm/sections.h>
> @@ -41,6 +42,15 @@ static int __init parse_crashkernel_mem(char *cmdline,
>  					unsigned long long *crash_base)
>  {
>  	char *cur = cmdline, *tmp;
> +	unsigned long long total_mem = system_ram;
> +
> +	/*
> +	 * Firmware sometimes reserves some memory regions for it's own use.

	                                                       its

> +	 * so we get less than actual system memory size.
> +	 * Workaround this by round up the total size to 128M which is
> +	 * enough for most test cases.
> +	 */
> +	total_mem = roundup(total_mem, SZ_128M);


thanks.
-- 
~Randy

