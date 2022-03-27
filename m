Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DE04E8A3E
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 23:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiC0Vkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 17:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiC0Vkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 17:40:33 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37EB33A0E;
        Sun, 27 Mar 2022 14:38:52 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 39C331EC0445;
        Sun, 27 Mar 2022 23:38:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1648417127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=yY2YO2yI1wDQsqCh9TwGDSc6J5E2vMROt0/Y5L3W2YA=;
        b=Bd2NRiBlYU/7gjHBDaGDBMPmNPrj6YrgLnik0JFCUMNqqNsSF9qFQiyUx7qjqEHK3j8s39
        B/qxAv/7yle1SEMTiVl887UXaAl+/jMVBAPd18f3FLn8EdpSudD4bffCbGBCX1pq30LdUb
        xBpzOPclfpQln19/XQaswOtTPZCPPTI=
Date:   Sun, 27 Mar 2022 23:38:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org,
        David Laight <David.Laight@aculab.com>,
        Jiri Hladky <hladky.jiri@googlemail.com>
Subject: Re: [PATCH v5 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Message-ID: <YkDZY8n1k5SJw9st@zn.tnic>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <20220310015306.445359-2-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220310015306.445359-2-ammarfaizi2@gnuweeb.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 08:53:05AM +0700, Ammar Faizi wrote:
> The asm constraint does not reflect that the asm statement can modify
> the value of @loops. But the asm statement in delay_loop() does modify
> the @loops.
> 
> Specifiying the wrong constraint may lead to undefined behavior, it may
> clobber random stuff (e.g. local variable, important temporary value in
> regs, etc.).

This is especially dangerous when the compiler decides to inline the
function and since it doesn't know that the value gets modified, it
might decide to use it from a register directly without reloading it.

Add that to the commit message pls.

> Fix this by changing the constraint from "a" (as an input) to "+a" (as
> an input and output).
> 
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Jiri Hladky <hladky.jiri@googlemail.com>

All those Ccs in the commit message are not really needed -
get_maintainers.pl gives the correct list already.

> Cc: stable@vger.kernel.org # v2.6.27+

I don't see the need for the stable Cc. Or do you have a case where
a corruption really does happen?

> Fixes: e01b70ef3eb ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")

Commit sha1 (e01b70ef3eb) needs to be at least 12 chars long:

e01b70ef3eb3 ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")

This is best fixed by doing:

[core]
        abbrev = 12

in your .git/config

> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  arch/x86/lib/delay.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
> index 65d15df6212d..0e65d00e2339 100644
> --- a/arch/x86/lib/delay.c
> +++ b/arch/x86/lib/delay.c
> @@ -54,8 +54,8 @@ static void delay_loop(u64 __loops)
>  		"	jnz 2b		\n"
>  		"3:	dec %0		\n"
>  
> -		: /* we don't need output */
> -		:"a" (loops)
> +		: "+a" (loops)
> +		:
>  	);

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
