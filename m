Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFD668F773
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjBHSxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjBHSxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:53:42 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E862521EE
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 10:53:41 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id r17so4473514pff.9
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 10:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ARKAnyJbGCDixUf78i+l0G5zkCQxdhupYbkp6nMWaxY=;
        b=GR+o7rQZRnnVhmV8DKpfe5rs/4FwgZ4XFtphgEXVIyvnOUrWvYWq+8ESj61NPNAwJ3
         dwDUvoAgPU5ZnmGOSkt/w/3k1gynrD0KCQZa/uEl2Ep+xMfE8hg0eCu91ETY08mqyi/e
         0gnt4W1ItvQoMk/ZHnutPdnFE5V4Q++7LHZzY5bxKyxElcU/p8zOyjyMJi0mpQ6ImO1C
         6xar8VdeMfFd7NO8f/nu8KgeuHH9uat10q8VE27KqqqQpxm6B9rGY5RPI+mFyCTcdxSp
         3D0uP99uNs82jdJtiQcMwAd4Vl5MlluR/yNHDyP9P+Tsu0o6wJG+R5ZMvgdLQv/gc/mg
         N/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ARKAnyJbGCDixUf78i+l0G5zkCQxdhupYbkp6nMWaxY=;
        b=Anmi3dC4MYsaeUvmWrC6meuENfwJFzO9cgptOGScwsP/j2JPYAkEA9zdaRPE4QaX2p
         KIS7gJ6LDRIFNYZPrdl8JJEU4AFFAhRQnBLGEzQfJjRFAiBCmv4pcNscBvk+hvKpPLuw
         DqBqtzSham0oKgMyNAvTz4HGxi+CWZKH+ZbsBIs0+gMBYwx4a2FfV6t9GfLBM3lKfQ08
         OsCyaqbZqcgF0bg+ze6r7d4NRCTU+esampxj9/g3X8CtEthUzTx/HjdVf/i//ogGs8OO
         Fxo53DYVNLLLzivFiFsPFDaxUT2jB7Qps9x74btXwZXj6MdDW6zgTpZt5rob2GCCS4jK
         BGbw==
X-Gm-Message-State: AO0yUKUKLrYDngE03VdIx7NTlBGkETIVkALP1xQKzDqhu97sqshCjvJ4
        p0TUFOPgiXh7gUuFVkd0oPS0gOhF73ODae4N0mcJsQ==
X-Google-Smtp-Source: AK7set+qg/4GJecRaFbLM82rNlur1zcDRisirla89w82/iIvTgqEVWcL7Bup47k6dMJQSzwaLNHJzj/tQ2m6ZDI8CZA=
X-Received: by 2002:a62:5184:0:b0:5a8:4bf8:174e with SMTP id
 f126-20020a625184000000b005a84bf8174emr372120pfb.29.1675882420676; Wed, 08
 Feb 2023 10:53:40 -0800 (PST)
MIME-Version: 1.0
References: <20230208065133.220589-1-ebiggers@kernel.org>
In-Reply-To: <20230208065133.220589-1-ebiggers@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 8 Feb 2023 10:53:29 -0800
Message-ID: <CAKwvOdkYWXCYr75JkzHqMJ8j=UefW86Zq9tD_AyZQKzW__7TEA@mail.gmail.com>
Subject: Re: [PATCH] randstruct: disable Clang 15 support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Bill Wendling <morbo@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 7, 2023 at 10:52 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The randstruct support released in Clang 15 is unsafe to use due to a
> bug that can cause miscompilations: "-frandomize-layout-seed
> inconsistently randomizes all-function-pointers structs"
> (https://github.com/llvm/llvm-project/issues/60349).  It has been fixed
> on the Clang 16 release branch, so add a Clang version check.
>
> Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for the patch and report. Guessing that wasn't fun to debug.
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  security/Kconfig.hardening | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 53baa95cb644f..0f295961e7736 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -281,6 +281,9 @@ endmenu
>
>  config CC_HAS_RANDSTRUCT
>         def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
> +       # Randstruct was first added in Clang 15, but it isn't safe to use until
> +       # Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
> +       depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
>
>  choice
>         prompt "Randomize layout of sensitive kernel structures"
>
> base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
> --
> 2.39.1
>
>


-- 
Thanks,
~Nick Desaulniers
