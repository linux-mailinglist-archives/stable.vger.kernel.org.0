Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256844F0B6D
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 18:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbiDCQ7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbiDCQ7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 12:59:36 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AB0326D9;
        Sun,  3 Apr 2022 09:57:42 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649005061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tfXrkBnVhjzrSwPZ0Laq9qOonGjVgWvsNc2Gv3Ncd+c=;
        b=dvO3fnMR8Rqjh/M8WmNPijFfQ7EVMUklhEGzbPDD3IlHlBiI58R0d5aM32WjMV5AqmSXbu
        jmtex8GkM13wX6Db/DejMcADu9QhrRZdauTKyjclSUKdExs+BkxUXcaQC9xvAYQGg05xXR
        uzF+d1BUltlSSqr9Py8FTY5YXLgXf+c0a4b35Z6Z9UngSSCjOyZSh1hRBzcq9o2f/edgGv
        3/aFpTMQ+J0Hpm6roDPTuY5F+drRLhHZFyfaRRDIgpuF9VFo9heJEX+AQijjLLLmPJUUVC
        Jpd6QwKE50NKnkOW89E6BMBdXY4DDIEmVp/FreSp4PUOLaTx5XvYXaVaSkCvCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649005061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tfXrkBnVhjzrSwPZ0Laq9qOonGjVgWvsNc2Gv3Ncd+c=;
        b=PNYRgzlU5vnuF03DCEere9Ai1yJR65djGR9xY/V4o8Hw6YV0C8ksumiS9+y2t6Z4dxYOMG
        M5MKdjILbTSCrzDw==
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jiri Hladky <hladky.jiri@googlemail.com>
Subject: Re: [PATCH v6 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
In-Reply-To: <20220329104705.65256-2-ammarfaizi2@gnuweeb.org>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
 <20220329104705.65256-2-ammarfaizi2@gnuweeb.org>
Date:   Sun, 03 Apr 2022 18:57:40 +0200
Message-ID: <87zgl2ksu3.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29 2022 at 17:47, Ammar Faizi wrote:
> The asm constraint does not reflect that the asm statement can modify
> the value of @loops. But the asm statement in delay_loop() does modify
> the @loops.
>
> Specifiying the wrong constraint may lead to undefined behavior, it may
> clobber random stuff (e.g. local variable, important temporary value in
> regs, etc.). This is especially dangerous when the compiler decides to
> inline the function and since it doesn't know that the value gets
> modified, it might decide to use it from a register directly without
> reloading it.
>
> Fix this by changing the constraint from "a" (as an input) to "+a" (as
> an input and output).

This analysis is plain wrong. The assembly code operates on a register
and not on memory:

	asm volatile(
		"	test %0,%0	\n"
		"	jz 3f		\n"
		"	jmp 1f		\n"

		".align 16		\n"
		"1:	jmp 2f		\n"

		".align 16		\n"
		"2:	dec %0		\n"
		"	jnz 2b		\n"
		"3:	dec %0		\n"

		: /* we don't need output */
---->		:"a" (loops)

This tells the compiler to use [RE]AX and initialize it from the
variable 'loops'. It's never written back because all '%0' in the above
assembly are substituted with [RE]AX. This also tells the compiler that
the inline assembly clobbers [RE]AX and that's all it needs to know.

Nothing to fix here, whether the code is inlined or not.

Thanks,

        tglx
