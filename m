Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2001323C33E
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 04:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHECBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 22:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHECBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 22:01:04 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F808C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 19:01:02 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ep8so3449148pjb.3
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 19:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=9ujgTMErOugXJGLDOW+6kfeYveYxratHKMd3vkXVWx0=;
        b=SZPcne1M50q0PQsXDWDtWz8D11+ycf6bA7dSil5IILr+SLunUljaOJFchbTtuaLHVs
         HS1s20pNXJSMkCI4p0Za6DYKdjPyHbzgpI4NSPuAVQbE7N0yDpfZYLPp2z+w5phIbCa+
         XkLVAol1Ar6wcAZ06qvsvZ8o20Bu3Czgia06yT29l0BDv0H3W9CY+XYh4qadBg/bjpLt
         4qHagYTVE+rtR24HVKbGSHwRraa1pkPzCe3NW/u1Ua3eZZOoCSX/pDOWYSaL/qzhgiWz
         LzJZIjmKcyeJi8d09LpbDidY7GnqoT7XKNzrcgrQd6+CJaUppHwJNcyaKJ4UhDeixAmi
         THgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=9ujgTMErOugXJGLDOW+6kfeYveYxratHKMd3vkXVWx0=;
        b=AfXU02AIKIs1xgp0EOAnFj0JlIL5yQ9JQORtOACIOILG/yCUA9/6vGWAVh40DU1V5S
         6ofWjrMJJSK5NtNk9p1GXQvgSVVF6XRtEwJsRSbz+2GvigP7sqs/ZKwfBo5KwqXlYGpX
         2LlVddq56WMOPUbTbl1mtzCz8dyiiMQJhf4y/6F/Ok+NcsHzmjIBSJRlTI4xmSo2jpAW
         6z2NEBGNFP1uCFf8pMhTTx2u5WaeIVWY3yJqvdZUhsBEzXcr/eQ/yo8iBeIO8BHmNS7E
         N7A6v5oyge7fa5D8rVGJOEfVnOXDiye9Jt+ac9UUTzScYIBNG4YFb97c737wnAH/GY6h
         8dOw==
X-Gm-Message-State: AOAM533QI7QN6sDINYr1tPFddtB+PiGOEXXGKCa6dtSA8mJqOja3uWJc
        iOVibLl/WdmMvKjYOLFzA4mzUJ1wSVU=
X-Google-Smtp-Source: ABdhPJyVJl4QcVGhokReQnuV4IXkI6Z39+gx4n24p6Pb3SibpWq0c/KjqoNX86NC77LZeQZTPUza7w==
X-Received: by 2002:a17:90b:1493:: with SMTP id js19mr817438pjb.223.1596592861678;
        Tue, 04 Aug 2020 19:01:01 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id 198sm602494pfz.120.2020.08.04.19.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 19:01:01 -0700 (PDT)
Date:   Tue, 04 Aug 2020 19:01:01 -0700 (PDT)
X-Google-Original-Date: Tue, 04 Aug 2020 18:58:47 PDT (-0700)
Subject:     Re: [PATCH 1/2] riscv: ptrace: Use the correct API for `fcsr' access
In-Reply-To: <alpine.DEB.2.20.2007232213510.4462@tpp.orcam.me.uk>
CC:     linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     macro@wdc.com
Message-ID: <mhng-611be025-6e03-46a1-8a8a-6f6eeea04f57@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jul 2020 16:22:15 PDT (-0700), macro@wdc.com wrote:
> Adjust the calls to `user_regset_copyout' and `user_regset_copyin' in
> `riscv_fpr_get' and `riscv_fpr_set' respectively so as to use @start_pos
> and @end_pos according to API documentation in <linux/regset.h>, that is
> to point at the beginning and the end respectively of the data chunk to
> be copied.  Update @data accordingly, also for the first call, to make
> it clear which structure member is accessed.
>
> We currently have @start_pos fixed at 0 across all calls, which works as
> a result of the implementation, in particular because we have no padding
> between the FP general registers and the FP control and status register,
> but appears not to have been the intent of the API and is not what other
> ports do, requiring one to study the copy handlers to understand what is
> going on here.
>
> Signed-off-by: Maciej W. Rozycki <macro@wdc.com>
> Fixes: b8c8a9590e4f ("RISC-V: Add FP register ptrace support for gdb.")
> Cc: stable@vger.kernel.org # 4.20+
> ---
>  arch/riscv/kernel/ptrace.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> linux-riscv-ptrace-fcsr.diff
> Index: linux-hv/arch/riscv/kernel/ptrace.c
> ===================================================================
> --- linux-hv.orig/arch/riscv/kernel/ptrace.c
> +++ linux-hv/arch/riscv/kernel/ptrace.c
> @@ -61,10 +61,13 @@ static int riscv_fpr_get(struct task_str
>  	int ret;
>  	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
>
> -	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, fstate, 0,
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &fstate->f, 0,
>  				  offsetof(struct __riscv_d_ext_state, fcsr));

As far as I can tell the current code works correctly, it just requires
knowledge of the layout of __riscv_d_ext_state to determine that it functions
correctly.  This new code still requires that knowledge: the first blob copies
the F registers, but only works if the CSR is after the registers.  If we fix
both of those the code seems easier to read, but I don't think splitting the
difference helps any.

So I guess what I'm saying is: maybe that second line should be changed to
something like "ARRAY_SIZE(fstate->f)"?

>  	if (!ret) {
> -		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, fstate, 0,
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +					  &fstate->fcsr,
> +					  offsetof(struct __riscv_d_ext_state,
> +						   fcsr),
>  					  offsetof(struct __riscv_d_ext_state, fcsr) +
>  					  sizeof(fstate->fcsr));
>  	}
> @@ -80,10 +83,13 @@ static int riscv_fpr_set(struct task_str
>  	int ret;
>  	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
>
> -	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, fstate, 0,
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &fstate->f, 0,
>  				 offsetof(struct __riscv_d_ext_state, fcsr));
>  	if (!ret) {
> -		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, fstate, 0,
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +					 &fstate->fcsr,
> +					 offsetof(struct __riscv_d_ext_state,
> +						  fcsr),
>  					 offsetof(struct __riscv_d_ext_state, fcsr) +
>  					 sizeof(fstate->fcsr));
>  	}
