Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7B02F433F
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 05:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbhAMEhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 23:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbhAMEhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 23:37:08 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26140C061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 20:36:28 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id c22so667014pgg.13
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 20:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=v8M6I4uoOoWPXGUxC7pSdwXF3g2dnNPkk0v2MpAf+W8=;
        b=lfLH3Q7jtZb/zf63+ZlMqsMcC8w3F5TQb86l4tvMJ69W3kq9KJ3fNfaGxUiHB8IYVt
         YZiKcz792a4vWjRFEsZ28UV0IDQJqaC0PAx7LIIXajyJrdb2MaWTfCyiUvS0PsjapXoX
         2mHjkVOv/ewD8RJZrwRx+okz602BY2KY1CKhHe2l4UNTvgBQvkmAy1rYeQKaqyPS5CFs
         OeF02veA+IG+TauO/+YvgLo+mdhPRq0rPMFV4Zik2UZJtky4dN4uyg714S6z7FPVTOKh
         0rM4JDCiWKFVR/krPTch5aK/hRh2CMSAzd5fkJC1+2FjLdMxhn1iD8U87o0q8cpdywkK
         wlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=v8M6I4uoOoWPXGUxC7pSdwXF3g2dnNPkk0v2MpAf+W8=;
        b=PMSHw4v32ZPNdTUEjIDjHD6Tw/jx9wJ1lcf+BgLmb3YY5p2qpq91UU6Ou4VP3jpWBp
         34HG13dvAEmTjJnidc2OxrUETrLKr4Zcud9Qk9MQDyrv5ob8dx3KnwqKFbpk29Ntl4aL
         hoTaI/sLIoAIbvwKnCGhT0imctjpYhZonNvNkIVPZVmr2K8ILjC0ucKOrwN7tZQVQZsR
         N6o8MDWZkB1sL1YeqgjVTNHxYsSNkkUnCqUOcrvU0JRvAQcInMpW7koCLdUUOzAM/mDa
         9jUYan9l/St/S29G9cQd0ViZZlwZvs65+9TX2x/tZRZWRogBl2EYodsZAeMwuGuDgY3u
         BT7w==
X-Gm-Message-State: AOAM5302s1PlR3r00/v6JUH/QhqpE9X273iTn120mCIYSf//oIJ1pdoh
        BckB3KHi+PdOWABjZI2wMoXjGg==
X-Google-Smtp-Source: ABdhPJytECWo9XHp2+7rMUBWFv2+jhZFSXfHRB71mo37McQGfiaXyJ4UdNIVwo05BSbwt6jorS/6VA==
X-Received: by 2002:a63:f64c:: with SMTP id u12mr343978pgj.98.1610512587525;
        Tue, 12 Jan 2021 20:36:27 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id a136sm786958pfd.149.2021.01.12.20.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 20:36:26 -0800 (PST)
Date:   Tue, 12 Jan 2021 20:36:26 -0800 (PST)
X-Google-Original-Date: Tue, 12 Jan 2021 20:16:53 PST (-0800)
Subject:     Re: [PATCH] riscv: Trace irq on only interrupt is enabled
In-Reply-To: <20201219002051.2891577-1-atish.patra@wdc.com>
CC:     linux-kernel@vger.kernel.org, Atish Patra <Atish.Patra@wdc.com>,
        stable@vger.kernel.org, aou@eecs.berkeley.edu,
        Anup Patel <Anup.Patel@wdc.com>, guoren@linux.alibaba.com,
        linux-riscv@lists.infradead.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Atish Patra <Atish.Patra@wdc.com>
Message-ID: <mhng-46e80f20-f58a-4f1b-b162-e2ad7b6df816@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Dec 2020 16:20:51 PST (-0800), Atish Patra wrote:
> We should call irq trace only if interrupt is going to be enabled during
> excecption handling. Otherwise, it results in following warning during
> boot with lock debugging enabled.
>
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] DEBUG_LOCKS_WARN_ON(early_boot_irqs_disabled)
> [    0.000000] WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:4085 lockdep_hardirqs_on_prepare+0x22a/0x22e
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.10.0-00022-ge20097fb37e2-dirty #548
> [    0.000000] epc: c005d5d4 ra : c005d5d4 sp : c1c01e80
> [    0.000000]  gp : c1d456e0 tp : c1c0a980 t0 : 00000000
> [    0.000000]  t1 : ffffffff t2 : 00000000 s0 : c1c01ea0
> [    0.000000]  s1 : c100f360 a0 : 0000002d a1 : c00666ee
> [    0.000000]  a2 : 00000000 a3 : 00000000 a4 : 00000000
> [    0.000000]  a5 : 00000000 a6 : c1c6b390 a7 : 3ffff00e
> [    0.000000]  s2 : c2384fe8 s3 : 00000000 s4 : 00000001
> [    0.000000]  s5 : c1c0a980 s6 : c1d48000 s7 : c1613b4c
> [    0.000000]  s8 : 00000fff s9 : 80000200 s10: c1613b40
> [    0.000000]  s11: 00000000 t3 : 00000000 t4 : 00000000
> [    0.000000]  t5 : 00000001 t6 : 00000000
>
> Fixes: 3c4697982982 ("riscv:Enable LOCKDEP_SUPPORT & fixup TRACE_IRQFLAGS_SUPPORT")
> Cc: stable@vger.kernel.org
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
>  arch/riscv/kernel/entry.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index 524d918f3601..7dea5ee5a3ac 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -124,15 +124,15 @@ skip_context_tracking:
>  	REG_L a1, (a1)
>  	jr a1
>  1:
> -#ifdef CONFIG_TRACE_IRQFLAGS
> -	call trace_hardirqs_on
> -#endif
>  	/*
>  	 * Exceptions run with interrupts enabled or disabled depending on the
>  	 * state of SR_PIE in m/sstatus.
>  	 */
>  	andi t0, s1, SR_PIE
>  	beqz t0, 1f
> +#ifdef CONFIG_TRACE_IRQFLAGS
> +	call trace_hardirqs_on
> +#endif
>  	csrs CSR_STATUS, SR_IE
>
>  1:

Thanks, this is on fixes.
