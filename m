Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F98517017
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 15:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbiEBNTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 09:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbiEBNTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 09:19:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BF9B7DB;
        Mon,  2 May 2022 06:16:23 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BF8D41EC0455;
        Mon,  2 May 2022 15:16:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651497377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8Du5mhQpClCe63DlL1soyfIFMl+Tuup4QOsRHcJzHLA=;
        b=kTxrJpfCB2IpFm2spR7sHrzbfysjjdwDU2kk2r3VY+z1qWFUENqp8K8BU6gyMCOZ1/ZrZd
        pwYJmUQFCw+5uIp2S8HfSnOoIy0BSEHkY9vx9srnhb3QAGMq6TxqvjyQSWa8KUAHZl/Cgt
        LQo4J/psrZVBQeeoWjqgrs0B4B++IJ4=
Date:   Mon, 2 May 2022 15:16:16 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Filipe Manana <fdmanana@suse.com>, stable@vger.kernel.org
Subject: Re: [patch 1/3] x86/fpu: Prevent FPU state corruption
Message-ID: <Ym/ZoAIvawVUljjz@zn.tnic>
References: <20220501192740.203963477@linutronix.de>
 <20220501193102.588689270@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220501193102.588689270@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 01, 2022 at 09:31:43PM +0200, Thomas Gleixner wrote:
> The latter is checking whether some other context already uses FPU in the
> kernel, but if that's not the case then it allows FPU to be used
> unconditionally even if the calling context interupted a fpregs_lock()

Unknown word [interupted] in commit message.
Suggestions: ['interrupted', ...

>  /*
>   * Can we use the FPU in kernel mode with the
>   * whole "kernel_fpu_begin/end()" sequence?

While at it, drop the "we": "Can the FPU be used in kernel mode... "

> - *
> - * It's always ok in process context (ie "not interrupt")
> - * but it is sometimes ok even from an irq.
>   */
>  bool irq_fpu_usable(void)
>  {
> -	return !in_interrupt() ||
> -		interrupted_user_mode() ||
> -		interrupted_kernel_fpu_idle();
> +	if (WARN_ON_ONCE(in_nmi()))
> +		return false;
> +
> +	/* In kernel FPU usage already active? */
> +	if (this_cpu_read(in_kernel_fpu))
> +		return false;
> +
> +	/*
> +	 * When not in NMI or hard interrupt context, FPU can be used:

"... can be used in:"

> +	 *
> +	 * - Task context is safe except from within fpregs_lock()'ed
> +	 *   critical regions.
> +	 *
> +	 * - Soft interrupt processing context which cannot happen
> +	 *   while in a fpregs_lock()'ed critical region.

But those are only nitpicks. With those fixed:

Reviewed-by: Borislav Petkov <bp@suse.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
