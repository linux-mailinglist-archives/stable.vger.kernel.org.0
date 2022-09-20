Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63225BDDEF
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 09:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbiITHPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 03:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiITHPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 03:15:19 -0400
X-Greylist: delayed 424 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 20 Sep 2022 00:14:54 PDT
Received: from mx.der-flo.net (mx.der-flo.net [193.160.39.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4316D402F5;
        Tue, 20 Sep 2022 00:14:53 -0700 (PDT)
Received: by mx.der-flo.net (Postfix, from userid 110)
        id CCA17160F1A; Tue, 20 Sep 2022 09:07:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Received: from localhost (unknown [IPv6:2a02:1210:22e1:1f00:fb89:69cb:433e:eb56])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 537E2160145;
        Tue, 20 Sep 2022 09:07:45 +0200 (CEST)
Date:   Tue, 20 Sep 2022 09:07:44 +0200
From:   Florian Lehner <dev@der-flo.net>
To:     Kees Cook <keescook@chromium.org>
Cc:     Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] x86/uaccess: Avoid check_object_size() in
 copy_from_user_nmi()
Message-ID: <YylmwJOyDCPP11fg@der-flo.net>
References: <20220919201648.2250764-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220919201648.2250764-1-keescook@chromium.org>
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
> v2: drop the call explicitly instead of using inline to do it
> v1: https://lore.kernel.org/lkml/20220916135953.1320601-1-keescook@chromium.org
> ---
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

Thanks!

Tested-by: Florian Lehner <dev@der-flo.net>

