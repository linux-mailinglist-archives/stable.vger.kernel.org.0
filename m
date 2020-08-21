Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F070A24D6EF
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 16:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgHUOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 10:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgHUOGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 10:06:18 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62668C061573;
        Fri, 21 Aug 2020 07:06:17 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id i129so874965vsi.3;
        Fri, 21 Aug 2020 07:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=tzsAX6Gcfon7AdapRu244uwbgo4S+HdYR+eziW7H+ws=;
        b=XuJitGHqRnjedHT2nmxGm4CZQDUnUjoFmGGrc3U+11Bafes+c4sdIOojRmOBxc6qqZ
         cdq4vg2bjiZ/ozgZV1O/OhQvl+mQGwWX8fWw/ku+Y5GTVJEcVNmw77NBpoh6OhDENVLY
         TOH3m/EzHKnSIEhP+n20Fof6UyGCnkhqNQxTqnLd2QWJbOj5h0zNUzy8MoXP3wblQmS3
         d+bvDxaAiMFVYYhAWQ0zvKeME4i7xWDIyO5JDyBuKPwJuRwrnEAPjlrsz3TAYrZHKPn/
         MXalnF/WCeMVYGWZjEn0fzfyFxrDMuDG8OsE/4kB/7+JQxVjv2k8cqTDrMJpmtp0qYMY
         Mycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=tzsAX6Gcfon7AdapRu244uwbgo4S+HdYR+eziW7H+ws=;
        b=H8U8s8D3jj8aUi4KLLyiRufQsnx6zxaOK9szqkDlkp3O+c3JISJrmIw2DTMOfu8Sun
         6IaUAfn0IIpV4ryFZkNIr/sforgNyzoMm5vdIT+KWptYyBockyoidcdcLUswGOlbrYQT
         2KH4Z2XKAG3LEx6lUwZThvo82rXrHV27jtK0iibltUBWtBqc7GWdJmtOAGRe5hNGqwap
         Cjo2BNgDVvUIVeZPd6STTW8nBFT1fVWSAani945u/rBugE+NZMqlKF9CO2MbEasRdfr0
         vTRpx6v4+yPw1IyYkq36YB+/GePOCPDdBucjTTaFB7vdYF/N8WuK40sMFZgSBNM+OPRH
         n/7g==
X-Gm-Message-State: AOAM532WOjSlRsLlWRL5GOmNjlcXncCOhICaB600Wskps9WMAYGSvubp
        TKUtbtQt+JnKas4J6G/PVz2rKJblsNdGbWhDUbr+ofWe
X-Google-Smtp-Source: ABdhPJzebiWJIOZoRKdMlKFMtU/bWwVzAPl6F1o01V42EtcC1JxeFyisWsTg48slbfGzrthLzptQzyi3L7cMx7dmB5g=
X-Received: by 2002:a67:89ca:: with SMTP id l193mr1906642vsd.206.1598018775379;
 Fri, 21 Aug 2020 07:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200821131727.6883-1-marcos@mpdesouza.com>
In-Reply-To: <20200821131727.6883-1-marcos@mpdesouza.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 21 Aug 2020 15:06:04 +0100
Message-ID: <CAL3q7H5CYsRZLT+JAf9pGsrTyXVfyO_KAC6Xhc5X=t4VVtkRog@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: block-group: Fix free-space bitmap threshould
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 2:43 PM Marcos Paulo de Souza
<marcos@mpdesouza.com> wrote:
>
> From: Marcos Paulo de Souza <mpdesouza@suse.com>
>
> [BUG]
> After commit 9afc66498a0b ("btrfs: block-group: refactor how we read one
> block group item"), cache->length is being assigned after calling
> btrfs_create_block_group_cache. This causes a problem since
> set_free_space_tree_thresholds is calculate the free-space threshould to
> decide is the free-space tree should convert from extents to bitmaps.
>
> The current code calls set_free_space_tree_thresholds with cache->length
> being 0, which then makes cache->bitmap_high_thresh being zero. This
> implies the system will always use bitmap instead of extents, which is
> not desired if the block group is not fragmented.
>
> This behavior can be seen by a test that expects to repair systems
> with FREE_SPACE_EXTENT and FREE_SPACE_BITMAP, but the current code only
> created FREE_SPACE_BITMAP.
>
> [FIX]
> Call set_free_space_tree_thresholds after setting cache->length.
>
> Link: https://github.com/kdave/btrfs-progs/issues/251
> Fixes: 9afc66498a0b ("btrfs: block-group: refactor how we read one block =
group item")
> CC: stable@vger.kernel.org # 5.8+
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>
>  Changes from v1:
>  * Add a warning in set_free_space_tree_thresholds when bg->length is zer=
o (Qu)
>
>  fs/btrfs/block-group.c     | 4 +++-
>  fs/btrfs/free-space-tree.c | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 44fdfa2eeb2e..01e8ba1da1d3 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1798,7 +1798,6 @@ static struct btrfs_block_group *btrfs_create_block=
_group_cache(
>
>         cache->fs_info =3D fs_info;
>         cache->full_stripe_len =3D btrfs_full_stripe_len(fs_info, start);
> -       set_free_space_tree_thresholds(cache);
>
>         cache->discard_index =3D BTRFS_DISCARD_INDEX_UNUSED;
>
> @@ -1908,6 +1907,8 @@ static int read_one_block_group(struct btrfs_fs_inf=
o *info,
>
>         read_block_group_item(cache, path, key);
>
> +       set_free_space_tree_thresholds(cache);
> +
>         if (need_clear) {
>                 /*
>                  * When we mount with old space cache, we need to
> @@ -2128,6 +2129,7 @@ int btrfs_make_block_group(struct btrfs_trans_handl=
e *trans, u64 bytes_used,
>                 return -ENOMEM;
>
>         cache->length =3D size;
> +       set_free_space_tree_thresholds(cache);
>         cache->used =3D bytes_used;
>         cache->flags =3D type;
>         cache->last_byte_to_unpin =3D (u64)-1;
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 8b1f5c8897b7..1d191fbc754b 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -22,6 +22,9 @@ void set_free_space_tree_thresholds(struct btrfs_block_=
group *cache)
>         size_t bitmap_size;
>         u64 num_bitmaps, total_bitmap_size;
>
> +       if (cache->length =3D=3D 0)
> +               btrfs_warn(cache->fs_info, "block group length is zero");

This alone is not very useful.
With something like:

if (WARN_ON(cache->length) =3D=3D 0)
  .... (and the message including the block group's logical address
too, the ->start field)

Such a bug is much easier to spot. If a test case from fstests
triggers it, it will be reported as a test failure.

Why not an ASSERT() instead? Though I don't have a strong preference
between the two for this case.
Either option will make it easy to spot with fstests.

As for the rest, the fix itself looks good to me.
You can later add,

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +
>         /*
>          * We convert to bitmaps when the disk space required for using e=
xtents
>          * exceeds that required for using bitmaps.
> --
> 2.28.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
