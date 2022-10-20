Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B146068BF
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 21:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJTTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 15:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJTTQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 15:16:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE43717FD6B;
        Thu, 20 Oct 2022 12:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BB961B59;
        Thu, 20 Oct 2022 19:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9792C433C1;
        Thu, 20 Oct 2022 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666293415;
        bh=iA6iqLVBU4InDwFUi50gijZS4ScfA1zpMCm16EDWt2Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qHICLtBlqtazXfq5dVw3Ecq241ew6eaiFqUVsHyLWwk42Eo8PjwU1wEOBTmldOdWI
         775Z3rvybrpwSCSePzzpSflHMDuPcwWd3NU6TSw1ledUz7ZyDhtu6PZhmQVNofKxAZ
         ZWvE01MXZoucl4DQBbn4w/D09fFY6GYS6aSIbga8Bv9k9R95sVBQwgSCHCxYrP4qPn
         xHtKUfTCEfQItavfVAXYUXi6CzrLZrYKNPP5WeizgRB8c5cMvlP7RnRc2MgmVUEkK1
         sIp9RHy6hwvhm6rUuB2F7Y8ewnl9jsdC8+S73W/82o3SCQw+TuKzsoX9Mrl0mFNqRs
         jTwyKYvW67rcQ==
Received: by mail-ej1-f54.google.com with SMTP id y14so1825775ejd.9;
        Thu, 20 Oct 2022 12:16:55 -0700 (PDT)
X-Gm-Message-State: ACrzQf1Tw3NR57CZgOqTFGpvlXkNiEFQ6XadDKU7krfh1hk3kRncpdfX
        K9gnckFxoIWIw/n/8+ZKC5Euzr3nOBYutVx3dm0=
X-Google-Smtp-Source: AMsMyM7QDc36YRtje51mks9RurOTw27/lwKC1MkDCD2ahmQVIA8dHb6CJ6MbpG7UBgYLeaQiaqRLRmKTtlMg3QtDsQs=
X-Received: by 2002:a17:906:794b:b0:790:2dc7:3115 with SMTP id
 l11-20020a170906794b00b007902dc73115mr12412636ejo.3.1666293414026; Thu, 20
 Oct 2022 12:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <20221017100951.22727-1-jinpu.wang@ionos.com>
In-Reply-To: <20221017100951.22727-1-jinpu.wang@ionos.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Oct 2022 12:16:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7QOvp-tF5-Fo+2NXaKWVicQj1xmu_BPyU_UoUboHCSnw@mail.gmail.com>
Message-ID: <CAPhsuW7QOvp-tF5-Fo+2NXaKWVicQj1xmu_BPyU_UoUboHCSnw@mail.gmail.com>
Subject: Re: [PATCHv2] md/bitmap: Fix bitmap chunk size overflow issues
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-raid@vger.kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 3:09 AM Jack Wang <jinpu.wang@ionos.com> wrote:
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

Applied to md-next. Thanks!

Song


> ---
> v1->v2: extend commit message for steps to reproduce the problem.
>         fix the warning reported by buildbot
>
>  drivers/md/md-bitmap.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bf6dffadbe6f..d4bf7f603ef6 100644
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
> @@ -2534,6 +2535,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
>         if (csize < 512 ||
>             !is_power_of_2(csize))
>                 return -EINVAL;
> +       if (csize >= (1ULL << (BITS_PER_BYTE *
> +               sizeof(((bitmap_super_t *)0)->chunksize))))
> +               return -EOVERFLOW;
>         mddev->bitmap_info.chunksize = csize;
>         return len;
>  }
> --
> 2.34.1
>
