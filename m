Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDF62CCE6
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 22:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiKPVoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 16:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiKPVoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 16:44:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CFC15A1E;
        Wed, 16 Nov 2022 13:44:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A115EB81ECD;
        Wed, 16 Nov 2022 21:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5350AC433D6;
        Wed, 16 Nov 2022 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668635074;
        bh=IHiduSNYsg5S8cPDQwEi96SyL7Ez96k4r6QMHuOj31g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=s665AiDVg3riUmTl+gdggjdRwKzT3EXmikeSVUi2u+VllalgRl3OSP0bEnV3xCaH/
         qSZ2+9zRQCABSywVAkZ3g1et6XHu7jIKNnGcz01sHH+jXu+3eZ/qhAMbbbJJTadHzo
         rqbppzIvt8N1cVJtb8quo1vhHr64Tg1G8NAQa88xKzef9opPvQMqPGom9grptM070a
         CKrZasyIiVBfrw97xc1oQPvPC1QTF40+sDxRIbRgPbrGxDX2np73ir1CpHoxa2194F
         OMK298VR6VKxt6/z6iCFREs9jPXxGLEKTKPSKaS8jYoF1omE22pxxgBaaXCMCx1CPA
         4j9zdMg0HmDvA==
Received: by mail-lf1-f47.google.com with SMTP id s8so14590992lfc.8;
        Wed, 16 Nov 2022 13:44:34 -0800 (PST)
X-Gm-Message-State: ANoB5pnsNQmIEMBVMn4ew2yhI2kcXuZjUJUPEBcDbUs1YKrZlr3HpW4B
        GFzS/4kqgwEaU5/cZuuLcBlo6Cp5Wn1yWGHLRxQ=
X-Google-Smtp-Source: AA0mqf7ZYtVjEoKUkiNEekrv1lBz0sKO573GSlGaGQ0JZAslZsvcNwuAylmavwFxGU02vaYWofO2c+IHqqTKyTw228g=
X-Received: by 2002:a05:6512:3c89:b0:4a2:bfd2:b218 with SMTP id
 h9-20020a0565123c8900b004a2bfd2b218mr5905lfv.228.1668635072254; Wed, 16 Nov
 2022 13:44:32 -0800 (PST)
MIME-Version: 1.0
References: <20221116200555.2046552-1-Jason@zx2c4.com>
In-Reply-To: <20221116200555.2046552-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 16 Nov 2022 22:44:20 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHJ4vQ=2dnJCAR1eOaM9FPvokYb_DODu+3MAR7XMMQ7fw@mail.gmail.com>
Message-ID: <CAMj1kXHJ4vQ=2dnJCAR1eOaM9FPvokYb_DODu+3MAR7XMMQ7fw@mail.gmail.com>
Subject: Re: [PATCH] efi: random: zero out secret after use and do not take minimum
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

On Wed, 16 Nov 2022 at 21:06, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Taking the minimum is wrong, if the bootloader or EFI stub is actually
> passing on a bunch of bytes that it expects the kernel to hash itself.

We still need some kind of limit, just so things don't explode if
seed->size is bogus.

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
>  drivers/firmware/efi/efi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index f73709f7589a..819409b7b43b 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -630,7 +630,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
>
>                 seed = early_memremap(efi_rng_seed, sizeof(*seed));
>                 if (seed != NULL) {
> -                       size = min(seed->size, EFI_RANDOM_SEED_SIZE);
> +                       size = seed->size;
>                         early_memunmap(seed, sizeof(*seed));
>                 } else {
>                         pr_err("Could not map UEFI random seed!\n");
> @@ -641,6 +641,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
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
