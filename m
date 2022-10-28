Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643F5611C22
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJ1VG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJ1VG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:06:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770D6249885;
        Fri, 28 Oct 2022 14:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37DEDB82B08;
        Fri, 28 Oct 2022 21:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5710C433C1;
        Fri, 28 Oct 2022 21:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666991182;
        bh=v6kfg8IcSFY9dQNnIOsCwbA0rp3CWLwX37NbA9GNDZg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G1j8yKZUvUCyP6p0T206fYCh6r5e1sPODeEcSJCnSZQnZRRnswSIFJgFmeAAFLhvO
         jkJkBxAvQOszKBDLMbZnVRV4Wjr0A5Ck5YIO8xg/bzX49dacSnxsudNco9hrTjx1f/
         n1BEREy10EFgKv3bs5VgXOIGsWsyAtRoxVpNXnGPc1oz9DOYh30+oR20IpA1vxmD4/
         qlSA3RGtg6ZIafhGa95hBb2NzRXZlKOt1T+ETFmSQwxkJFuBPZLo7Bv7bBpI07CFxX
         mJ4soIklEHf0ng5KvHaHH5SVbe2S3OS3hzOe3zt2M+vlA7UXbAR0/T3dwM4TLjKCv/
         TOtmJexszZQpQ==
Received: by mail-ej1-f49.google.com with SMTP id y14so15782904ejd.9;
        Fri, 28 Oct 2022 14:06:22 -0700 (PDT)
X-Gm-Message-State: ACrzQf3v2tfXnH62BYn1DcCNTqmTSrupHSVxtduZuVdq8mY8a8j3suw8
        wsKYTvfFaPhhBeAGLsxrwA4g4k+/RqkFfTry5Dw=
X-Google-Smtp-Source: AMsMyM4JYK5belrwpEhuA8ojFZzHfF5XA/F3cvcWo8FCyQkPfGzeaItnioezDwiIua5UKyxArzf7LhfQ0PTNgKA+8IQ=
X-Received: by 2002:a17:907:1c14:b0:7a6:38d7:5993 with SMTP id
 nc20-20020a1709071c1400b007a638d75993mr1166014ejc.3.1666991181015; Fri, 28
 Oct 2022 14:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221025073705.17692-1-jinpu.wang@ionos.com>
In-Reply-To: <20221025073705.17692-1-jinpu.wang@ionos.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 28 Oct 2022 14:06:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5+F3EU1QDdJm-ViThdPfW_Gv83+H03MzZUHtZSy9xs1w@mail.gmail.com>
Message-ID: <CAPhsuW5+F3EU1QDdJm-ViThdPfW_Gv83+H03MzZUHtZSy9xs1w@mail.gmail.com>
Subject: Re: [PATCHv3] md/bitmap: Fix bitmap chunk size overflow issues
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-raid@vger.kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 12:37 AM Jack Wang <jinpu.wang@ionos.com> wrote:
>
> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>
> - limit bitmap chunk size internal u64 variable to values not overflowing
>   the u32 bitmap superblock structure variable stored on persistent media
> - assign bitmap chunk size internal u64 variable from unsigned values to
>   avoid possible sign extension artifacts when assigning from a s32 value
>
> The bug has been there since at least kernel 4.0.
> Steps to reproduce it:
> 1: mdadm -C /dev/mdx -l 1 --bitmap=internal --bitmap-chunk=256M -e 1.2
> -n2 /dev/rnbd1 /dev/rnbd2
> 2 resize member device rnbd1 and rnbd2 to 8 TB
> 3 mdadm --grow /dev/mdx --size=max
>
> The bitmap_chunksize will overflow without patch.
>
> Cc: stable@vger.kernel.org
>
> Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> Signed-off-by: Song Liu <song@kernel.org>

Applied to md-next. Thanks!

Song

> ---
> v3: fix build warning on i386.
>  drivers/md/md-bitmap.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 63ece30114e5..e7cc6ba1b657 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
>         sb = kmap_atomic(bitmap->storage.sb_page);
>         pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
>         pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
> -       pr_debug("       version: %d\n", le32_to_cpu(sb->version));
> +       pr_debug("       version: %u\n", le32_to_cpu(sb->version));
>         pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
>                  le32_to_cpu(*(__le32 *)(sb->uuid+0)),
>                  le32_to_cpu(*(__le32 *)(sb->uuid+4)),
> @@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
>         pr_debug("events cleared: %llu\n",
>                  (unsigned long long) le64_to_cpu(sb->events_cleared));
>         pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
> -       pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
> -       pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
> +       pr_debug("     chunksize: %u B\n", le32_to_cpu(sb->chunksize));
> +       pr_debug("  daemon sleep: %us\n", le32_to_cpu(sb->daemon_sleep));
>         pr_debug("     sync size: %llu KB\n",
>                  (unsigned long long)le64_to_cpu(sb->sync_size)/2);
> -       pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind));
> +       pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
>         kunmap_atomic(sb);
>  }
>
> @@ -2105,7 +2105,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>                         bytes = DIV_ROUND_UP(chunks, 8);
>                         if (!bitmap->mddev->bitmap_info.external)
>                                 bytes += sizeof(bitmap_super_t);
> -               } while (bytes > (space << 9));
> +               } while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
> +                       (BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
>         } else
>                 chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
>
> @@ -2150,7 +2151,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>         bitmap->counts.missing_pages = pages;
>         bitmap->counts.chunkshift = chunkshift;
>         bitmap->counts.chunks = chunks;
> -       bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
> +       bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
>                                                      BITMAP_BLOCK_SHIFT);
>
>         blocks = min(old_counts.chunks << old_counts.chunkshift,
> @@ -2176,8 +2177,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>                                 bitmap->counts.missing_pages = old_counts.pages;
>                                 bitmap->counts.chunkshift = old_counts.chunkshift;
>                                 bitmap->counts.chunks = old_counts.chunks;
> -                               bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
> -                                                                            BITMAP_BLOCK_SHIFT);
> +                               bitmap->mddev->bitmap_info.chunksize =
> +                                       1UL << (old_counts.chunkshift + BITMAP_BLOCK_SHIFT);
>                                 blocks = old_counts.chunks << old_counts.chunkshift;
>                                 pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
>                                 break;
> @@ -2537,6 +2538,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
>         if (csize < 512 ||
>             !is_power_of_2(csize))
>                 return -EINVAL;
> +       if (BITS_PER_LONG > 32 && csize >= (1ULL << (BITS_PER_BYTE *
> +               sizeof(((bitmap_super_t *)0)->chunksize))))
> +               return -EOVERFLOW;
>         mddev->bitmap_info.chunksize = csize;
>         return len;
>  }
> --
> 2.34.1
>
