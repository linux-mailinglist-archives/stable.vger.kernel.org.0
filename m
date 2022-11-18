Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FFA62EFC2
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 09:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbiKRIk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 03:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbiKRIkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 03:40:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9102AE0F7;
        Fri, 18 Nov 2022 00:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D46C6238C;
        Fri, 18 Nov 2022 08:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D200C433D7;
        Fri, 18 Nov 2022 08:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668760793;
        bh=0ho9HeENCwTxJiNWvhHjQkHcio/HQKeJG5c6zaF4b7o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HtsSVVxEs9gUort0xR+4mCc2gQq+L+p18ivRxMcIJIFMQP3E+KcQ8J6LqsdOEN3jZ
         i3xpYD3eUjauYrDuiVtgOs1MNGpRxe7WbYh20SU/C4ZBMnmz2WeX7on1Z33SOGRbQb
         qAkdPRXTsZiPOK3zxn8dPmeVluh0zTTjZ5vmOcfn06lfpq0bSlWYz8fDVJn6GyRtAQ
         mcsZ92CYyCS49O9q1lsWBvfrM3NYMvLA0cEElLHtTMj7OKndzQfbJECUDkmKttGO9n
         gE9IzSoIEc1ugQnSU7I/B4AQ8sUF1kE3Fx1LXHLbziyvvqVRwPO9e9721NdqKud0lD
         WLQupgVuOncFQ==
Received: by mail-ej1-f52.google.com with SMTP id ft34so11223026ejc.12;
        Fri, 18 Nov 2022 00:39:53 -0800 (PST)
X-Gm-Message-State: ANoB5pllqy0yBQaJvBPztxlLCL763zun/cachqYK3uaO3BRP9aHZFkEI
        PTRrkm4iOJfEbmPEUDTRqMo6HLjZtKpxHShKZMA=
X-Google-Smtp-Source: AA0mqf5sHRaE85vQdNRNsYQf0I8Pa3DUcGnsBj6zsfcQQbTJCxCIhzNYrqerG4UB/xQ/pdqBwSRH93ilA3Ks4sWGDrU=
X-Received: by 2002:a17:906:8994:b0:7ae:ea4:583c with SMTP id
 gg20-20020a170906899400b007ae0ea4583cmr5048018ejc.587.1668760791747; Fri, 18
 Nov 2022 00:39:51 -0800 (PST)
MIME-Version: 1.0
References: <Y3WA2BU0vtsOu6pJ@zx2c4.com> <20221117003915.2092851-1-Jason@zx2c4.com>
In-Reply-To: <20221117003915.2092851-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 18 Nov 2022 09:39:39 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHpOFOu9AywZJXVk-pL_Er7RbB1V2bV2t1dt7oB+iU3=g@mail.gmail.com>
Message-ID: <CAMj1kXHpOFOu9AywZJXVk-pL_Er7RbB1V2bV2t1dt7oB+iU3=g@mail.gmail.com>
Subject: Re: [PATCH v2] efi: random: zero out secret after use and do not take minimum
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-efi@vger.kernel.org, stable@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Nov 2022 at 01:39, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Taking the minimum is wrong, if the bootloader or EFI stub is actually
> passing on a bunch of bytes that it expects the kernel to hash itself.
> Ideally, a bootloader will hash it for us, but STUB won't do that, so we
> should map all the bytes. Also, all those bytes must be zeroed out after
> use to preserve forward secrecy.
>
> Fixes: 161a438d730d ("efi: random: reduce seed size to 32 bytes")
> Cc: stable@vger.kernel.org # v4.14+
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v1->v2:
> - Cap size to 1k.
>  drivers/firmware/efi/efi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

Thanks. I'll just incorporate this into the patch that does the
concatenation of seeds in the stub, which is queued up for v6.2

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index a46df5d1d094..c7c7178902c2 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -611,7 +611,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
>
>                 seed = early_memremap(efi_rng_seed, sizeof(*seed));
>                 if (seed != NULL) {
> -                       size = min(seed->size, EFI_RANDOM_SEED_SIZE);
> +                       size = min_t(u32, SZ_1K, seed->size);
>                         early_memunmap(seed, sizeof(*seed));
>                 } else {
>                         pr_err("Could not map UEFI random seed!\n");
> @@ -622,6 +622,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
>                         if (seed != NULL) {
>                                 pr_notice("seeding entropy pool\n");
>                                 add_bootloader_randomness(seed->bits, size);
> +                               memzero_explicit(seed->bits, size);
>                                 early_memunmap(seed, sizeof(*seed) + size);
>                         } else {
>                                 pr_err("Could not map UEFI random seed!\n");
> --
> 2.38.1
>
