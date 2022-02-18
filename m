Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22C64BBE2C
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 18:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbiBRRRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 12:17:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238471AbiBRRRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 12:17:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086162B7615;
        Fri, 18 Feb 2022 09:16:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9EBD8219A4;
        Fri, 18 Feb 2022 17:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645204559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zpVTMN5crc6K1MF78ftYrPJFMOci1TdJrt+hVPeq/w=;
        b=AsIMLeva+P0GlDGnDCf06J1i2KnXl+5nAmZgGIujgukrWdYIBDgdf/mq3I4M5VFzd4D85B
        W2s21/X3770XiMfAyPtEt183uB3cqgDmQvXAFWuJgQBnhoS74aYEYH/08CfnLgwOI+PoCp
        ilCITaX5bktqFSC0gKzll2tHQHeAC6w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645204559;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zpVTMN5crc6K1MF78ftYrPJFMOci1TdJrt+hVPeq/w=;
        b=BlzL7u0HyzyzyKkOmqAUVW78roUbpkvRBvQYkZkUyV0AN4k6LkgMUPs2TM2jYoRRLgIcCI
        FLPOuApZD1L/bJBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 545C813CBE;
        Fri, 18 Feb 2022 17:15:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oclrE0/UD2IhVQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 18 Feb 2022 17:15:59 +0000
Message-ID: <a5ab4496-8190-6221-72c7-d1ff2e6cf1d4@suse.cz>
Date:   Fri, 18 Feb 2022 18:14:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] slab: remove __alloc_size attribute from
 __kmalloc_track_caller
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable <stable@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev
References: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/18/22 14:13, Greg Kroah-Hartman wrote:
> Commit c37495d6254c ("slab: add __alloc_size attributes for better
> bounds checking") added __alloc_size attributes to a bunch of kmalloc
> function prototypes.  Unfortunately the change to __kmalloc_track_caller
> seems to cause clang to generate broken code and the first time this is
> called when booting, the box will crash.
> 
> While the compiler problems are being reworked and attempted to be
> solved, let's just drop the attribute to solve the issue now.  Once it
> is resolved it can be added back.

Could we instead wrap it in some #ifdef that' only true for clang build?
That would make the workaround more precise and self-documented. Even
better if it can trigger using clang version range and once a fixed
clang version is here, it can be updated to stay true for older clangs.

> Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
> Cc: stable <stable@vger.kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Daniel Micay <danielmicay@gmail.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  include/linux/slab.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 37bde99b74af..5b6193fd8bd9 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -660,8 +660,7 @@ static inline __alloc_size(1, 2) void *kcalloc(size_t n, size_t size, gfp_t flag
>   * allocator where we care about the real place the memory allocation
>   * request comes from.
>   */
> -extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
> -				   __alloc_size(1);
> +extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
>  #define kmalloc_track_caller(size, flags) \
>  	__kmalloc_track_caller(size, flags, _RET_IP_)
>  

