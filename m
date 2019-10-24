Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21724E2943
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 06:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfJXEGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 00:06:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46474 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfJXEGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 00:06:09 -0400
Received: by mail-pg1-f196.google.com with SMTP id e15so13376130pgu.13;
        Wed, 23 Oct 2019 21:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=atI3gS2MGyIOjrTR3VunsKklUxG6dRrAl/pbBtzsoWc=;
        b=mmj2bmcy+JWI/uUf9GNnYjUK9DAwI76y/91IqmvFESwdIyvy/6ySLAQ/u8wKznhQ2r
         QxHwYtbsAdPqQ2IS41S5Ih4Xav4Ig1H0flttKRwmjmE6uG2WVSXICYTYAfTbHYMclSsu
         x9UqpOndh0xGHy90bagZ4AWwFXK1VN5BcSXEuOcZaBvMcqmYBg5bC19pCQ93ZQRucHFR
         hjscDb0V4nOVDmV5vf5gnGevqHi9iarwvlpYy0qonUZ1DQ6gHSEsK+/ly3DEM+GvgZkr
         ZUol4j5oQgN9dq2d0yln8XWSBydUbkL7xSQhwEtX9X8L/WppC37M1iRQcDCpjKUgISco
         It6A==
X-Gm-Message-State: APjAAAUVF+QnmDCxdWG3Tb5f0ZU0ywu97k4nJTjjA8QMLnSDhPOCsbfu
        /TYW4G0yjz5SNJnq5kTqWaBmpeodkR9Frw==
X-Google-Smtp-Source: APXvYqzFD35dvIj1is9aDYIJkqFuwSM9EbPEVTCqFA/d/Fsrill3EaFOFte4LDEAQR5p3TYTnG5Q/w==
X-Received: by 2002:a63:f854:: with SMTP id v20mr8946190pgj.92.1571889968341;
        Wed, 23 Oct 2019 21:06:08 -0700 (PDT)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id l62sm26476097pfl.167.2019.10.23.21.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 21:06:07 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:06:24 -0700
From:   Paul Burton <paulburton@kernel.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, paul.burton@mips.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: elf_hwcap: Export microMIPS and vz
Message-ID: <20191024040624.eezpuusvhujfffud@lantea.localdomain>
References: <20191023152551.10535-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191023152551.10535-1-jiaxun.yang@flygoat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jiaxun,

On Wed, Oct 23, 2019 at 11:25:51PM +0800, Jiaxun Yang wrote:
> After further discussion with userland library develpoer,
> we addressed another two ASEs that can be used runtimely in programs.
> 
> Export them in hwcap as well to benefit userspace programs.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: <stable@vger.kernel.org> # 4.4+
> ---
>  arch/mips/include/uapi/asm/hwcap.h | 2 ++
>  arch/mips/kernel/cpu-probe.c       | 7 ++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
> index 1ade1daa4921..e1a9bac62149 100644
> --- a/arch/mips/include/uapi/asm/hwcap.h
> +++ b/arch/mips/include/uapi/asm/hwcap.h
> @@ -17,5 +17,7 @@
>  #define HWCAP_LOONGSON_MMI  (1 << 11)
>  #define HWCAP_LOONGSON_EXT  (1 << 12)
>  #define HWCAP_LOONGSON_EXT2 (1 << 13)
> +#define HWCAP_MIPS_MICROMIPS (1 << 14)
> +#define HWCAP_MIPS_VZ       (1 << 15)

What's the motivation for exposing VZ? Userland can't actually use it
without something like KVM, which already exposes a means of detecting
whether VZ is supported (try the creating a VM of type KVM_VM_MIPS_VZ &
see if it works). I'm not sure what userland would be able to do with
this information in AT_HWCAP.

Thanks,
    Paul

>  #endif /* _UAPI_ASM_HWCAP_H */
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index f521cbf934e7..11e853d88aae 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -2213,8 +2213,13 @@ void cpu_probe(void)
>  	if (cpu_has_loongson_ext2)
>  		elf_hwcap |= HWCAP_LOONGSON_EXT2;
>  
> -	if (cpu_has_vz)
> +	if (cpu_has_mmips)
> +		elf_hwcap |= HWCAP_MIPS_MICROMIPS;
> +
> +	if (cpu_has_vz) {
> +		elf_hwcap |= HWCAP_MIPS_VZ;
>  		cpu_probe_vz(c);
> +	}
>  
>  	cpu_probe_vmbits(c);
>  
> -- 
> 2.23.0
> 
