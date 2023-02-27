Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F736A3BEA
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 08:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjB0H7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 02:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjB0H7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 02:59:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92573903B;
        Sun, 26 Feb 2023 23:59:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DDA5B80C6D;
        Mon, 27 Feb 2023 07:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D609C4339C;
        Mon, 27 Feb 2023 07:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677484757;
        bh=r3JtwbSt9hd0ieyjiNYdehHR5ZIFOt8rUWtB2lFMujA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c1ooVtnqBuVyjobk14sUytCgwmrgVwXhwu5KcnijgDhKHp4qPTT5hza8dQLuBhi40
         g7n9VgT6P9SQxPj560pXMhhzWPAxHOMotThzFtEbWXGTg/pK7hMDUWAv4EsZWsIJnT
         vTvC71Mnn4TpMHRm99T1wvL3TtMSLwjXr7HWMgOSM9Iz0u4x9SOkpUQw3sAueNWsdR
         kT6bVwmgJFNJ+gjy3F0fMkOT9pxGlcpHASZfqR7Uf/x1DPxF06nSVP62bTzpScKczS
         +NXkCLq2GXBZdnAMJkXpUauC0xN3VbbtcFBKoKwlL1OkjapHuEeRc09S+3hQLkkPg1
         jgB/UMCJLCfTw==
Received: by mail-lj1-f173.google.com with SMTP id a10so5503500ljq.1;
        Sun, 26 Feb 2023 23:59:16 -0800 (PST)
X-Gm-Message-State: AO0yUKXqYzIF8y1vS/J++ksK6Ef0wxjR1tBbZeZR33YjTRbQTjvWdlBu
        qikJD5yHKkT8wWzD6eTQIYIovsW6EArQPpNAz4o=
X-Google-Smtp-Source: AK7set/OkBqCfPXZgBNSBX5Tge6wgHozfcCEGYqgntOmQMtk7ri6lQCxZFAkDy7QQhnKruTFniglKWuTvqsF+hQwpHU=
X-Received: by 2002:a2e:bc16:0:b0:295:acea:5875 with SMTP id
 b22-20020a2ebc16000000b00295acea5875mr2466101ljf.2.1677484755054; Sun, 26 Feb
 2023 23:59:15 -0800 (PST)
MIME-Version: 1.0
References: <20230227063223.1829703-1-ebiggers@kernel.org>
In-Reply-To: <20230227063223.1829703-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 27 Feb 2023 08:59:04 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFbUuH1_vp=+sAFDorFSaFFUsaLjzjHFPbv_OZ_VAPK=w@mail.gmail.com>
Message-ID: <CAMj1kXFbUuH1_vp=+sAFDorFSaFFUsaLjzjHFPbv_OZ_VAPK=w@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/aes-neonbs - fix crash with CFI enabled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Feb 2023 at 07:33, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> aesbs_ecb_encrypt(), aesbs_ecb_decrypt(), aesbs_xts_encrypt(), and
> aesbs_xts_decrypt() are called via indirect function calls.  Therefore
> they need to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause
> their type hashes to be emitted when the kernel is built with
> CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure if
> the compiler doesn't happen to optimize out the indirect calls.
>
> Fixes: c50d32859e70 ("arm64: Add types to indirect called assembly functions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm64/crypto/aes-neonbs-core.S | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
> index 7278a37c2d5c..baf450717b24 100644
> --- a/arch/arm64/crypto/aes-neonbs-core.S
> +++ b/arch/arm64/crypto/aes-neonbs-core.S
> @@ -15,6 +15,7 @@
>   */
>
>  #include <linux/linkage.h>
> +#include <linux/cfi_types.h>
>  #include <asm/assembler.h>
>
>         .text
> @@ -620,12 +621,12 @@ SYM_FUNC_END(aesbs_decrypt8)
>         .endm
>
>         .align          4
> -SYM_FUNC_START(aesbs_ecb_encrypt)
> +SYM_TYPED_FUNC_START(aesbs_ecb_encrypt)
>         __ecb_crypt     aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
>  SYM_FUNC_END(aesbs_ecb_encrypt)
>
>         .align          4
> -SYM_FUNC_START(aesbs_ecb_decrypt)
> +SYM_TYPED_FUNC_START(aesbs_ecb_decrypt)
>         __ecb_crypt     aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
>  SYM_FUNC_END(aesbs_ecb_decrypt)
>
> @@ -799,11 +800,11 @@ SYM_FUNC_END(__xts_crypt8)
>         ret
>         .endm
>
> -SYM_FUNC_START(aesbs_xts_encrypt)
> +SYM_TYPED_FUNC_START(aesbs_xts_encrypt)
>         __xts_crypt     aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
>  SYM_FUNC_END(aesbs_xts_encrypt)
>
> -SYM_FUNC_START(aesbs_xts_decrypt)
> +SYM_TYPED_FUNC_START(aesbs_xts_decrypt)
>         __xts_crypt     aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
>  SYM_FUNC_END(aesbs_xts_decrypt)
>
>
> base-commit: f3a2439f20d918930cc4ae8f76fe1c1afd26958f
> --
> 2.39.2
>
