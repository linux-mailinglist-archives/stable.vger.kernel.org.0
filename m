Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7E14BBE43
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 18:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbiBRRUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 12:20:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiBRRUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 12:20:21 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73971074E6
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:20:04 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so4241439ooi.7
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CKMthUXCokgWPQMB0IqyzdQ/Xmbb9rlJivmagQi36I=;
        b=cydyiGcMci/xbRpUq63u1Hv+UdC/Vor48jhWgM7lnEFrIn3NnvwrUKdNfQL/0Fw3sF
         BPu6GRfWcYeuJIW0u0sEfSq/qHLjsHrf0Lr1QlWxT9DHzJ4CtDczMy2Ih6PCgNjqFMoe
         0Jwiw76Ky/0w+VPlCcij25Qcmzrr4WJfMVppv7iJxRlseur+qiVYeMkBO/y1cvuQqCll
         qntNTuHAjURsYJVdD8NLvjqIb56sxiqWTxTy/6IZzvOt/MtWGDXvw8lTBJ9E4rMIIT+/
         o7qHHhgWo8AD24vQQnBiC2Ygm1AUVGrIgmhYLjtfUtM431V/1dc62FN14QHkSBMze8GV
         /99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CKMthUXCokgWPQMB0IqyzdQ/Xmbb9rlJivmagQi36I=;
        b=J4ajca5qvLXh4Rr3pNl/Ony2gbnIEm0U3DxdeKuSkIQ3XGz5lRnCbxKb91MarRGYaw
         7gqBTOrGugmHGSi9/VkZP5tOU1O9yYcG35OmiUjqIrMA9OVgG+Ltsq8pr6VSncFflcbC
         5QE14uma7vSl7u9qzTt+xlNemsFhdhtSaBhvTgiFMT6XWmgslmeNHkle2hu2R/4jtEpx
         BMiggAj0XPCXA9f9Wh9j58mcySpsOJfVTngnK/8+Nn3o4XwyJ281WNgrL6WFXFg9GBLr
         6sp8X01sPjPtY1mkXw8s413XSPMTD2o/obbHHd+37gpU5fhOIER8mM5O+bqqI3CaZLM1
         KXXA==
X-Gm-Message-State: AOAM532JXFnjkNxSloNFA8ZGtRbDtgwxXjcMu3N+CR4A+J09HO/B5byp
        Y1JKS6a9xRlue/p4b3otAbqN33v4kUB47/iYS7g2+w==
X-Google-Smtp-Source: ABdhPJy4WTc78tZjJuxIgpcdJcD0ARkv52fe0fcQtgKg4EF2No3CqEz35B6g2+kkVmHNmdLz8XExDdjk1pj92tWB4lE=
X-Received: by 2002:a05:6870:12d1:b0:ce:c0c9:6e0 with SMTP id
 17-20020a05687012d100b000cec0c906e0mr4581469oam.306.1645204802484; Fri, 18
 Feb 2022 09:20:02 -0800 (PST)
MIME-Version: 1.0
References: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
In-Reply-To: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 18 Feb 2022 09:19:51 -0800
Message-ID: <CAKwvOd=4uwMVBwYU8XPP+cHkw5V1S_t7i8psMTRySsKEcDVZ_A@mail.gmail.com>
Subject: Re: [PATCH] slab: remove __alloc_size attribute from __kmalloc_track_caller
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 5:14 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Commit c37495d6254c ("slab: add __alloc_size attributes for better
> bounds checking") added __alloc_size attributes to a bunch of kmalloc
> function prototypes.  Unfortunately the change to __kmalloc_track_caller
> seems to cause clang to generate broken code and the first time this is
> called when booting, the box will crash.
>
> While the compiler problems are being reworked and attempted to be
> solved, let's just drop the attribute to solve the issue now.  Once it
> is resolved it can be added back.

Sorry about the mess; we'll get it cleaned up!
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1599

>
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
> -                                  __alloc_size(1);
> +extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
>  #define kmalloc_track_caller(size, flags) \
>         __kmalloc_track_caller(size, flags, _RET_IP_)
>
> --
> 2.35.1
>


-- 
Thanks,
~Nick Desaulniers
