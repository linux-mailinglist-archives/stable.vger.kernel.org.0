Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833814EC9C9
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348893AbiC3QjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 12:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348873AbiC3QjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 12:39:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20331197AE1
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 09:37:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0301617DB
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 16:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5002C340EE;
        Wed, 30 Mar 2022 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648658235;
        bh=aIzpnbSoeV6BRU27rskCwpaMAFtkWTVdBR2+8S8JXMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Krrartz/ECqTlBmQaGlvpMZ1cbiF+9yVlftq9J+o/t45tJQKr8NhurBqupEO9d0pA
         ZYLJ0KWwlJxECueMrZN912NH76vsVMa9UcjiqngTP+trfZ8hxe2sWU1EupHZtPQmjs
         LZJOjkHgbIe3wp0g63lyHEbNt1W9adb7M3BVjm1k=
Date:   Wed, 30 Mar 2022 18:37:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] stddef: Introduce struct_group() helper macro
Message-ID: <YkSHOIOUwweHuog9@kroah.com>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329220256.72283-1-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 03:02:55PM -0700, Tadeusz Struk wrote:
> Please apply this to stable 5.10.y, 5.15.y
> ---8<---
> 
> From: Kees Cook <keescook@chromium.org>
> 
> Upstream commit: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")
> 
> Kernel code has a regular need to describe groups of members within a
> structure usually when they need to be copied or initialized separately
> from the rest of the surrounding structure. The generally accepted design
> pattern in C is to use a named sub-struct:
> 
>         struct foo {
>                 int one;
>                 struct {
>                         int two;
>                         int three, four;
>                 } thing;
>                 int five;
>         };
> 
> This would allow for traditional references and sizing:
> 
>         memcpy(&dst.thing, &src.thing, sizeof(dst.thing));
> 
> However, doing this would mean that referencing struct members enclosed
> by such named structs would always require including the sub-struct name
> in identifiers:
> 
>         do_something(dst.thing.three);
> 
> This has tended to be quite inflexible, especially when such groupings
> need to be added to established code which causes huge naming churn.
> Three workarounds exist in the kernel for this problem, and each have
> other negative properties.
> 
> To avoid the naming churn, there is a design pattern of adding macro
> aliases for the named struct:
> 
>         #define f_three thing.three
> 
> This ends up polluting the global namespace, and makes it difficult to
> search for identifiers.
> 
> Another common work-around in kernel code avoids the pollution by avoiding
> the named struct entirely, instead identifying the group's boundaries using
> either a pair of empty anonymous structs of a pair of zero-element arrays:
> 
>         struct foo {
>                 int one;
>                 struct { } start;
>                 int two;
>                 int three, four;
>                 struct { } finish;
>                 int five;
>         };
> 
>         struct foo {
>                 int one;
>                 int start[0];
>                 int two;
>                 int three, four;
>                 int finish[0];
>                 int five;
>         };
> 
> This allows code to avoid needing to use a sub-struct named for member
> references within the surrounding structure, but loses the benefits of
> being able to actually use such a struct, making it rather fragile. Using
> these requires open-coded calculation of sizes and offsets. The efforts
> made to avoid common mistakes include lots of comments, or adding various
> BUILD_BUG_ON()s. Such code is left with no way for the compiler to reason
> about the boundaries (e.g. the "start" object looks like it's 0 bytes
> in length), making bounds checking depend on open-coded calculations:
> 
>         if (length > offsetof(struct foo, finish) -
>                      offsetof(struct foo, start))
>                 return -EINVAL;
>         memcpy(&dst.start, &src.start, offsetof(struct foo, finish) -
>                                        offsetof(struct foo, start));
> 
> However, the vast majority of places in the kernel that operate on
> groups of members do so without any identification of the grouping,
> relying either on comments or implicit knowledge of the struct contents,
> which is even harder for the compiler to reason about, and results in
> even more fragile manual sizing, usually depending on member locations
> outside of the region (e.g. to copy "two" and "three", use the start of
> "four" to find the size):
> 
>         BUILD_BUG_ON((offsetof(struct foo, four) <
>                       offsetof(struct foo, two)) ||
>                      (offsetof(struct foo, four) <
>                       offsetof(struct foo, three));
>         if (length > offsetof(struct foo, four) -
>                      offsetof(struct foo, two))
>                 return -EINVAL;
>         memcpy(&dst.two, &src.two, length);
> 
> In order to have a regular programmatic way to describe a struct
> region that can be used for references and sizing, can be examined for
> bounds checking, avoids forcing the use of intermediate identifiers,
> and avoids polluting the global namespace, introduce the struct_group()
> macro. This macro wraps the member declarations to create an anonymous
> union of an anonymous struct (no intermediate name) and a named struct
> (for references and sizing):
> 
>         struct foo {
>                 int one;
>                 struct_group(thing,
>                         int two;
>                         int three, four;
>                 );
>                 int five;
>         };
> 
>         if (length > sizeof(src.thing))
>                 return -EINVAL;
>         memcpy(&dst.thing, &src.thing, length);
>         do_something(dst.three);
> 
> There are some rare cases where the resulting struct_group() needs
> attributes added, so struct_group_attr() is also introduced to allow
> for specifying struct attributes (e.g. __align(x) or __packed).
> Additionally, there are places where such declarations would like to
> have the struct be tagged, so struct_group_tagged() is added.
> 
> Given there is a need for a handful of UAPI uses too, the underlying
> __struct_group() macro has been defined in UAPI so it can be used there
> too.
> 
> To avoid confusing scripts/kernel-doc, hide the macro from its struct
> parsing.
> 
> Co-developed-by: Keith Packard <keithp@keithp.com>
> Signed-off-by: Keith Packard <keithp@keithp.com>
> Acked-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Link: https://lore.kernel.org/lkml/20210728023217.GC35706@embeddedor
> Enhanced-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Link: https://lore.kernel.org/lkml/41183a98-bdb9-4ad6-7eab-5a7292a6df84@rasmusvillemoes.dk
> Enhanced-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/lkml/1d9a2e6df2a9a35b2cdd50a9a68cac5991e7e5f0.camel@intel.com
> Enhanced-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Link: https://lore.kernel.org/lkml/YQKa76A6XuFqgM03@phenom.ffwll.local
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  include/linux/stddef.h      | 48 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/stddef.h | 24 +++++++++++++++++++
>  2 files changed, 72 insertions(+)

Any specific reason this backport dropped a whole file from the original
commit?

You can't send me modified patches without mentioning it, otherwise I
assume you are doing something wrong :(

greg k-h
