Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDB65BDE7F
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 09:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiITHj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 03:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiITHjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 03:39:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B796110A;
        Tue, 20 Sep 2022 00:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EPYrlVGiKpdpbA6kdaZ0jwplt5Pre4ouMyusTzUeVIw=; b=TTjE5iXBhwOeWW8cH5+inlMWz6
        VyILMbPz2WbM62keQkmVEZNv6aaIG6qxReKBQL06UCfhcjOVaL/tiFkV7Ukhoz4pmlaojIody+6Cj
        VXdUOzWQOWRJMOMRCMaDy2ZVEWrjIlOFgb6JWUvegtbjCnb0vfHUCxhAQRu9/PzgjvCvLd161WX1Q
        YRBownaz/IhHrSWKJMngqQo2LzXHbQzYDhfRb49WmKpj/oj0ECv8c9YlXmpdoFuJfaotXU29c3t7M
        xaWJUhA8/N0uksTCA4n1ngGEyqgcVzQcYI38HeQijZuQiS+I6Shpd8+X5S9KnAyAyrVu4gCUeTDLk
        6Glkun3g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oaXqQ-005MEW-6B; Tue, 20 Sep 2022 07:39:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C069B300074;
        Tue, 20 Sep 2022 09:38:58 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 769E42BB3E534; Tue, 20 Sep 2022 09:38:58 +0200 (CEST)
Date:   Tue, 20 Sep 2022 09:38:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
        dev@der-flo.net, Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] x86/uaccess: Avoid check_object_size() in
 copy_from_user_nmi()
Message-ID: <YyluEuFn/ejLgvYk@hirez.programming.kicks-ass.net>
References: <20220919201648.2250764-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919201648.2250764-1-keescook@chromium.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 19, 2022 at 01:16:48PM -0700, Kees Cook wrote:
> The check_object_size() helper under CONFIG_HARDENED_USERCOPY is
> designed to skip any checks where the length is known at compile time as
> a reasonable heuristic to avoid "likely known-good" cases. However, it can
> only do this when the copy_*_user() helpers are, themselves, inline too.
> 
> Using find_vmap_area() requires taking a spinlock. The check_object_size()
> helper can call find_vmap_area() when the destination is in vmap memory.
> If show_regs() is called in interrupt context, it will attempt a call to
> copy_from_user_nmi(), which may call check_object_size() and then
> find_vmap_area(). If something in normal context happens to be in the
> middle of calling find_vmap_area() (with the spinlock held), the interrupt
> handler will hang forever.
> 
> The copy_from_user_nmi() call is actually being called with a fixed-size
> length, so check_object_size() should never have been called in
> the first place. Given the narrow constraints, just replace the
> __copy_from_user_inatomic() call with an open-coded version that calls
> only into the sanitizers and not check_object_size(), followed by a call
> to raw_copy_from_user().
> 
> Reported-by: Yu Zhao <yuzhao@google.com>
> Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
> Reported-by: dev@der-flo.net
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

>  arch/x86/lib/usercopy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
> index ad0139d25401..d2aff9b176cf 100644
> --- a/arch/x86/lib/usercopy.c
> +++ b/arch/x86/lib/usercopy.c
> @@ -44,7 +44,8 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
>  	 * called from other contexts.
>  	 */
>  	pagefault_disable();
> -	ret = __copy_from_user_inatomic(to, from, n);
> +	instrument_copy_from_user(to, from, n);
> +	ret = raw_copy_from_user(to, from, n);
>  	pagefault_enable();
>  
>  	return ret;
> -- 
> 2.34.1
> 
