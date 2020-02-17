Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FAB161604
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 16:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgBQPXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 10:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbgBQPXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Feb 2020 10:23:17 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AE4222464
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581952995;
        bh=nGy1lbmlsE02K8IM752m4QrHgHMzqoytnR/N5trdhuM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YVWCIRR/YSEuKkZxwoMfjLq1DsSHOiZctotmZDFVqlpkoGBowv46KMKnVmsRnFBNP
         azPanoikqHJ5bz84UuCbg6/ZuoHGa6LoiYK8Z3SHH6ZVMyIBOY0GQSURyfDLIPiZPC
         skox/eI/a8OdSO99Q/B5ooboZX2Q4RQ9+FSsiJUM=
Received: by mail-wm1-f46.google.com with SMTP id p17so18889924wma.1
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 07:23:15 -0800 (PST)
X-Gm-Message-State: APjAAAUobNip2ga52qPpMiYh/bUEr9WcXE+hCrFEvNAmBXgjM7XvgUHt
        HcBb+D0StrD5DccVRv2irxqgueZLupmSfkTCYTXLYg==
X-Google-Smtp-Source: APXvYqyHORjwouYreTl4kAhc6BiIMxJdcGTSfhxyKg5tSCNd6yz3fr9OpNIKkFDxeYSV+ojwle73cM5xcMxQx+jVKhA=
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr22583343wmj.1.1581952993983;
 Mon, 17 Feb 2020 07:23:13 -0800 (PST)
MIME-Version: 1.0
References: <20200217123354.21140-1-Jason@zx2c4.com>
In-Reply-To: <20200217123354.21140-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 17 Feb 2020 16:23:03 +0100
X-Gmail-Original-Message-ID: <CAKv+Gu83dOKGbYU1t3_KZevB_rn-ktoropFrjASjsv3DozrV1A@mail.gmail.com>
Message-ID: <CAKv+Gu83dOKGbYU1t3_KZevB_rn-ktoropFrjASjsv3DozrV1A@mail.gmail.com>
Subject: Re: [PATCH] efi: READ_ONCE rng seed size before munmap
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Feb 2020 at 13:34, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> This function is consistent with using size instead of seed->size
> (except for one place that this patch fixes), but it reads seed->size
> without using READ_ONCE, which means the compiler might still do
> something unwanted. So, this commit simply adds the READ_ONCE
> wrapper.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org

Thanks Jason

I've queued this in efi/urgent with a fixes: tag rather than a cc:
stable, since it only applies clean to v5.4 and later. We'll need a
backport to 4.14 and 4.19 as well, which has a trivial conflict
(s/add_bootloader_randomness/add_device_randomness/) but we'll need to
wait for this patch to hit Linus's tree first.


> ---
>  drivers/firmware/efi/efi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 621220ab3d0e..21ea99f65113 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -552,7 +552,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>
>                 seed = early_memremap(efi.rng_seed, sizeof(*seed));
>                 if (seed != NULL) {
> -                       size = seed->size;
> +                       size = READ_ONCE(seed->size);
>                         early_memunmap(seed, sizeof(*seed));
>                 } else {
>                         pr_err("Could not map UEFI random seed!\n");
> @@ -562,7 +562,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>                                               sizeof(*seed) + size);
>                         if (seed != NULL) {
>                                 pr_notice("seeding entropy pool\n");
> -                               add_bootloader_randomness(seed->bits, seed->size);
> +                               add_bootloader_randomness(seed->bits, size);
>                                 early_memunmap(seed, sizeof(*seed) + size);
>                         } else {
>                                 pr_err("Could not map UEFI random seed!\n");
> --
> 2.25.0
>
