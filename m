Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474051075D8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 17:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfKVQc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 11:32:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51643 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfKVQc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 11:32:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id g206so7828004wme.1
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 08:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ia/lzVKxfww33iqRsLBLiSmQop3hQK5gp/YYL2H2vf4=;
        b=Xa/5OxwwzYhMTw1TkmD6+3+QOf8jNKO3BdMwf1R9Gy5hk6TVN43UGeNYEXDtDOXLPN
         Cl05w7MpsH+1RhSZwcU9a5T3qYHANUHSmwCpozdUkeCGeHbHfZXNCaju0bbOXqpE0fil
         XLpRyK682vnBYc9NC/+K5NCyeOfSLTZKMMX2zr0BSFHaU5xd1bGoN7cJSASUTKGQygOB
         3R9AmieCRNGqPQ0P0SKe7cWm/9NnhYvAY16xi6HdM/PiManOInA/25MOyfu5Kna5rchh
         Ydv0xWryXPkRoa8loOsamT+bY1hbRjhsLshawzfTbBzNPGREa1X5D4rWHKvlaA/g6Mlz
         y4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ia/lzVKxfww33iqRsLBLiSmQop3hQK5gp/YYL2H2vf4=;
        b=bSQ3cgBSJedQo+deq9svw5I/sy4DjElHM/qsTVrXc8yGyNKCDqs/JRczWtcOlCVHH6
         AB2v2LOYkdMYw1ZAcf14+2N48YGiUhOGlShXmCkGCc/CZ7DJ23Ms+k2DjIXtsW34GbXH
         vJQ0Sl5jCld/Yz5a/2SKTEAJh23yh5ogvLzrHpZWr65TvmYAB/oYdqk/6uAb31t30Jt8
         eqB5fknPAlqunhkpMpX04DIQ/2ASj9V7pA5z4auEYTHYqlJyrNBkAR6pevc15IGEtmTi
         JKge1eLcFVyj9vsl/t/ix4p+EqK5VMEfgvO0Y3XcAjgkc+ZgIQe5bImRJ/rL6nZKEsZt
         rwdA==
X-Gm-Message-State: APjAAAV3ZmPMjvbK2IvHp/qt8Y1CTWdXeEjscmdSZdQwiAZ2BSWVMtkx
        rM8XhsSLKd4EQRNN7ie37CorZvsNmw4=
X-Google-Smtp-Source: APXvYqx66nh6tbyxruiuPsZyce9yb2FKnIH9MSPjgOXpDDoJDJ4MtVP/s5IhjfyPvrDniFZdMkTwxA==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr4652589wmk.109.1574440376469;
        Fri, 22 Nov 2019 08:32:56 -0800 (PST)
Received: from dell ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id x5sm3801833wmj.7.2019.11.22.08.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 08:32:56 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:32:39 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 1/9] ARM: 8904/1: skip nomap memblocks while finding
 the lowmem/highmem boundary
Message-ID: <20191122163239.GE3296@dell>
References: <20191122105113.11213-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Nov 2019, Lee Jones wrote:

> From: Chester Lin <clin@suse.com>
> 
> [ Upstream commit 1d31999cf04c21709f72ceb17e65b54a401330da ]
> 
> adjust_lowmem_bounds() checks every memblocks in order to find the boundary
> between lowmem and highmem. However some memblocks could be marked as NOMAP
> so they are not used by kernel, which should be skipped while calculating
> the boundary.
> 
> Signed-off-by: Chester Lin <clin@suse.com>
> Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mm/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)

Please don't apply this.

> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index aead23f15213..d9ddb5721565 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -1121,6 +1121,9 @@ void __init sanity_check_meminfo(void)
>  		phys_addr_t block_end = reg->base + reg->size;
>  		phys_addr_t size_limit = reg->size;
>  
> +		if (memblock_is_nomap(reg))
> +			continue;
> +
>  		if (reg->base >= vmalloc_limit)
>  			highmem = 1;
>  		else

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
