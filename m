Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91C9368DC0
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 09:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhDWHQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 03:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhDWHQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 03:16:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5511AC06174A
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 00:15:56 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so704772pjj.3
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 00:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=d3vwsSBvNjlMZS1HnsQu5P2rXD3UhnjfCG/NtiaBq44=;
        b=y1stGpxwN4+rJTi10nNbl+O/wMLR5CqX0uWz/DFxFzO1JpQEGolorqCKw8H0vzni6u
         KHfxlxTOGA+oEdNeL3XoKQp0pdNf8uch7YxwlaB1VXicPzOFjXaD9BVBpWSGtVbvQbUJ
         Ym/3bwQBLGHBOo7EeREllCS2f9OdnjSlc1l6XLJ9Z5MTpA6No8092WD/XJi1BJDWpJmJ
         +55ZZHeBJ/Jx309SmH2Jvq0TEIgjpVKFThQ/Aream3/MGxGGLBLf3Z/OKAGNu00+OptS
         bYtaGIz3xn0/rLC2WCslO8G0naiX2QVF0/Pbw26yRYw/SVBvl6dWbr/5FBzSje4hWx0j
         +hxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=d3vwsSBvNjlMZS1HnsQu5P2rXD3UhnjfCG/NtiaBq44=;
        b=RqteFWqPbVYq24GP+jv7J+44JIunE/O3ZTFzmEQ6uRaWva2l1APg13moiu0XN935QA
         sm+FT9o3eWKzUYuOtWXdDhWWBVdTHSLUXiMPx/qzMiSLGR5HIKzZfebgi7oPhd+s3lXh
         VPXf3pFXjxlQrUdw7XKbc2/7zTyc2NyhMN+5iCFRf0JdZEiM4d7O6xUDiYJll/9xjpOM
         77gRB6EdJglCVI4rYjwZj+pQH7qYF8+R3S6H1rPyjfqJqM9uAgI7v6aKt8sI4U5Rq8Lk
         2x4KBdsMrqBs18s025X2D016fw7zSsL3+HtOWKyLgdQhAQor3sUOZTShaMxJNYe+rIf4
         PoSA==
X-Gm-Message-State: AOAM532Q4uTc3/EPjQc4Vvd9c5imLDHe/+If1xQ9pYj975IMKLEX/QxH
        KE3wVxom2gEJhl0YELE0fjEMrA==
X-Google-Smtp-Source: ABdhPJw7PXpo1l1XvSNvmbejE5Mxtoki1oPvjwS+n6m+y1abkj2CuSmf+qnmjADwdgSi5EJYOr5z8w==
X-Received: by 2002:a17:90a:cc0d:: with SMTP id b13mr2873798pju.219.1619162155728;
        Fri, 23 Apr 2021 00:15:55 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id n48sm3804061pfv.130.2021.04.23.00.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 00:15:55 -0700 (PDT)
Date:   Fri, 23 Apr 2021 00:15:55 -0700 (PDT)
X-Google-Original-Date: Fri, 23 Apr 2021 00:15:53 PDT (-0700)
Subject:     Re: [PATCH] RISC-V: Fix error code returned by riscv_hartid_to_cpuid()
In-Reply-To: <20210415085522.108624-1-anup.patel@wdc.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        anup@brainfault.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <Anup.Patel@wdc.com>,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Message-ID: <mhng-b5a84423-0884-4378-9a8c-86c1d00a302c@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021 01:55:22 PDT (-0700), Anup Patel wrote:
> We should return a negative error code upon failure in

Not just should: the PLIC driver assumed this was the return flavor and 
will overflow a per_cpu because it doesn't detect the error.  IIUC this 
will manifest if we have more harts that NR_CPUS, which is a possible 
configuration.

That said, it's gone unnoticed for ~3 years so I'm inclined to leave it 
out of fixes because I have nothing else and this late in the cycle is 
always a bit touchy.  It's kind of splitting hairs as it'll just get 
backported, but post-rc8 is an odd spot to be in.

Is this actually manifesting as a crash for you?

Sorry I missed this last week.

> riscv_hartid_to_cpuid() instead of NR_CPUS. This is also
> aligned with all uses of riscv_hartid_to_cpuid() which
> expect negative error code upon failure.
>
> Fixes: 6825c7a80f18 ("RISC-V: Add logical CPU indexing for RISC-V")

Also

Fixes: f99fb607fb2b ("RISC-V: Use Linux logical CPU number instead of hartid")

which is what actually manifests the bug -- again, kind of splitting 
hairs as it's the patch after.

> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  arch/riscv/kernel/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
> index ea028d9e0d24..d44567490d91 100644
> --- a/arch/riscv/kernel/smp.c
> +++ b/arch/riscv/kernel/smp.c
> @@ -54,7 +54,7 @@ int riscv_hartid_to_cpuid(int hartid)
>  			return i;
>
>  	pr_err("Couldn't find cpu id for hartid [%d]\n", hartid);
> -	return i;
> +	return -ENOENT;
>  }
>
>  void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out)
