Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEB5573B13
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 18:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiGMQXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 12:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236637AbiGMQXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 12:23:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984CC2C13B;
        Wed, 13 Jul 2022 09:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QbdkBLup6jXB8yWubblicxIBOf4zsK4ibRKurIlBFxo=; b=giW4MC/bMYism0l+yLNjTWxR6i
        8lH3HQ0qJY3/eKLtL3pGhjN76TZrPH3spK9Jsydgy9W+rPVxDQG3E7i6V5D8S8+ZhWuIZ87yYE1Pn
        xN1afL4O6kKj976ssx1amJZJ9ogrq6WMKKbpZer0TZJPc43cNI57wNaPDFErW8LGsnagJfQEp3uPP
        xNOIllnki+Zh5YutIY0tFN6fOA0l+P1yioL9TTDBAxiGfkBZc19r6r0KIlqpR1IqeFzPF36rJAhyh
        2IKlWousBal7xTHnIZIdjIiKnHJuecQJuZ9tOGoJxwGkoHkfjdsRUZZFJaGIMXDbagk18JRGrzjWH
        mPQ2IY/A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBf8N-008OIL-GX; Wed, 13 Jul 2022 16:22:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 66E67300110;
        Wed, 13 Jul 2022 18:22:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 43AEF2013A006; Wed, 13 Jul 2022 18:22:41 +0200 (CEST)
Date:   Wed, 13 Jul 2022 18:22:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] x86/speculation: Use DECLARE_PER_CPU for
 x86_spec_ctrl_current
Message-ID: <Ys7xUVjpNyXY0nXf@hirez.programming.kicks-ass.net>
References: <20220713152436.2294819-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713152436.2294819-1-nathan@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 08:24:37AM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]
>   DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
>                       ^
>   arch/x86/include/asm/nospec-branch.h:283:12: note: previous declaration is here
>   extern u64 x86_spec_ctrl_current;
>              ^
>   1 error generated.
> 
> The declaration should be using DECLARE_PER_CPU instead so all
> attributes stay in sync.
> 
> Cc: stable@vger.kernel.org
> Fixes: fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> 
> v1 -> v2: https://lore.kernel.org/20220713152222.1697913-1-nathan@kernel.org/
> 
> * Use asm/percpu.h instead of linux/percpu.h to avoid static call
>   include errors.
> 
>  arch/x86/include/asm/nospec-branch.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index bb05ed4f46bd..10a3bfc1eb23 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -11,6 +11,7 @@
>  #include <asm/cpufeatures.h>
>  #include <asm/msr-index.h>
>  #include <asm/unwind_hints.h>
> +#include <asm/percpu.h>
>  
>  #define RETPOLINE_THUNK_SIZE	32
>  

When I tried this earlier today I ran into cyclic headers, you sure this
works?
