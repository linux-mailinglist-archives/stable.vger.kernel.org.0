Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E289691A34
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 09:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjBJIoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 03:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjBJIoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 03:44:15 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F29E72B6;
        Fri, 10 Feb 2023 00:44:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2156167207;
        Fri, 10 Feb 2023 08:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676018652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVINLfWoByaCJXVftpzcYlbIo/nk7wbOQy/Pd2ADzc4=;
        b=xni5+alhgoHFaCl1x313GvQBtvv3GPW+InczHZPd3O0X4AEl1e4wsuyhKTNm+1NUvHXNZF
        r9KJiyDalgrx4EaZkij5oNTuRIzwk0yWfd5cRuibsTb6RuJR9+zOqn31Jg9oxkfV+vEP4V
        F9Tz7D9CRy5WzrbfOKUYAUq7my/ZXqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676018652;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVINLfWoByaCJXVftpzcYlbIo/nk7wbOQy/Pd2ADzc4=;
        b=e5rcZXpyfz0QqEjd8c5zHyXM2ouAx2bUUTYUiu61xQ61hmcNND8ibgWMGHrrTr3uX5Qblh
        4sVTKfmLDUoSGuAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B6A2E13588;
        Fri, 10 Feb 2023 08:44:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MfPbK9sD5mPCEgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 10 Feb 2023 08:44:11 +0000
Message-ID: <046f0c76-f2b1-5df7-7c3e-76c0187da069@suse.cz>
Date:   Fri, 10 Feb 2023 09:44:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] Revert "slub: force on no_hash_pointers when slub_debug
 is enabled"
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
Cc:     Stephen Boyd <swboyd@chromium.org>, concord@gentoo.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Peter Gerber <peter@arbitrary.ch>
References: <20230208194712.never.999-kees@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230208194712.never.999-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/23 20:47, Kees Cook wrote:
> This reverts commit 792702911f581f7793962fbeb99d5c3a1b28f4c3.
> 
> Linking no_hash_pointers() to slub_debug has had a chilling effect
> on using slub_debug features for security hardening, since system
> builders are forced to choose between redzoning and heap address location
> exposures. Instead, just require that the "no_hash_pointers" boot param
> needs to be used to expose pointers during slub_debug reports.

Searching lore made me find [1] and I like the more concrete changelog as
well as updated documentation.

While it's convenient, it's probably indeed not slub's decision to enable
no_hash_pointers. But Stephen also has a point in reply to [1]. If the
data/address leak is indeed a concern, slub_debug will still print raw dumps
as part of the reports, so will e.g. dump_page(), so hashing %p is not a
complete solution and something more generic could be created for
controlling prints that distinguishes hardening vs debugging?

[1]
https://lore.kernel.org/all/8e472c9e-2076-bc25-5912-8433adf7b579@arbitrary.ch/

> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: concord@gentoo.org
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/lkml/202109200726.2EFEDC5@keescook/
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/kernel.h | 2 --
>  lib/vsprintf.c         | 2 +-
>  mm/slub.c              | 4 ----
>  3 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index fe6efb24d151..e3d9d3879495 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -229,8 +229,6 @@ int sscanf(const char *, const char *, ...);
>  extern __scanf(2, 0)
>  int vsscanf(const char *, const char *, va_list);
>  
> -extern int no_hash_pointers_enable(char *str);
> -
>  extern int get_option(char **str, int *pint);
>  extern char *get_options(const char *str, int nints, int *ints);
>  extern unsigned long long memparse(const char *ptr, char **retptr);
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index be71a03c936a..410b4a80a58a 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -2222,7 +2222,7 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
>  	return widen_string(buf, buf - buf_start, end, spec);
>  }
>  
> -int __init no_hash_pointers_enable(char *str)
> +static int __init no_hash_pointers_enable(char *str)
>  {
>  	if (no_hash_pointers)
>  		return 0;
> diff --git a/mm/slub.c b/mm/slub.c
> index 13459c69095a..63f7337dd433 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5005,10 +5005,6 @@ void __init kmem_cache_init(void)
>  	if (debug_guardpage_minorder())
>  		slub_max_order = 0;
>  
> -	/* Print slub debugging pointers without hashing */
> -	if (__slub_debug_enabled())
> -		no_hash_pointers_enable(NULL);
> -
>  	kmem_cache_node = &boot_kmem_cache_node;
>  	kmem_cache = &boot_kmem_cache;
>  

