Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE993B94CF
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 18:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhGAQpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 12:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhGAQpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 12:45:05 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF2DC061762;
        Thu,  1 Jul 2021 09:42:34 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id n9so4539797qtk.7;
        Thu, 01 Jul 2021 09:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=z4q75R0Q6Sz3iwmboWJRmvIu39o6GUQ4vxHfUFp3gH8=;
        b=D1tfVwV4Rh4Z4eITQ/lPtSIbpZmncblLI1O4moENg6uAvg4dG9YhxLrdkTdMam77cN
         jtca3Yk7qsui28Ufzap1MpzJTgNMutl28cCsmSCMxDnoGb4UruF2ywCngXWmSTPKsFR0
         R0g/KG1jLb5+Uj0GqSKOyaqOvM5Xz7A1rqZg/KtBksiNRHqGP9pp0XErXHg0cNbVI9C8
         7lufOY9aGg4HhXvV/dVXTfVe+4GF2lE272QgT/nbTkTcjez7jUIa1fmWNCgCA/HOsuFX
         mXEhgytw9TFqnCYG35o+RIHrPTd/FukRVvqJ6Aqvx70+q6wDReO2M/nUNDON/P3iksHR
         84QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=z4q75R0Q6Sz3iwmboWJRmvIu39o6GUQ4vxHfUFp3gH8=;
        b=QPfdHI0Kyo3Sm/ici+kMhgO3IFRX0GxkAvz2FAJwW7Lz+3MkEUqNo88DLSIyb51LQS
         yFSeKH1AAomo+8+N1D2+uW/MKI8iJASOC6zHMrXQ52tkkegdLbT4p3Pkq5d/lWU2Oj5q
         K0lDH3R7zYj/8B6LYiB9tjXbK/snJ2MKuRT1I7XdifEV8SwfVXTrEI5ej8DBy2Y15/BA
         IHAy/BWIE5HB8w/VADK+3GeT9WCCz+nsfPHnkTtaF0TK1l34Dg2N0pj6t+JTAnVlX3eO
         0kiSJP3F0SdZZWpX8Y5S4VFici+cTcIN2PYJwahS97DMdg5j7/3rp8UZDd+j1DAB6VML
         ShVA==
X-Gm-Message-State: AOAM531U4erDWJfPN6c3HJ0JgEr9nHLQPvrfjhPhd4Ra2iCx0Fh28JJ9
        jgnw25HrWt64QPE+krmWrQG0fE2ZWc+kz4g6jPcwQy6utUE=
X-Google-Smtp-Source: ABdhPJxf5OG3jaH/75EDWmpSfK/hc3jAYA/03Vxue2n4t4PddKgJEGik/GLnFn1Lt2+dwNv/IEItWa0e3HthjuFuP94=
X-Received: by 2002:a05:622a:1c2:: with SMTP id t2mr805902qtw.213.1625157753496;
 Thu, 01 Jul 2021 09:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210628085728.2813793-1-naohiro.aota@wdc.com>
In-Reply-To: <20210628085728.2813793-1-naohiro.aota@wdc.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 1 Jul 2021 17:42:22 +0100
Message-ID: <CAL3q7H4LsXDK8rTr3yEkftMm9ok9kWdQuwxk57Pke5oJ+EZOZQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: properly split extent_map for REQ_OP_ZONE_APPEND
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:06 AM Naohiro Aota <naohiro.aota@wdc.com> wrote:
>
> Damien reported a test failure with btrfs/209. The test itself ran fine,
> but the fsck run afterwards reported a corrupted filesystem.
>
> The filesystem corruption happens because we're splitting an extent and
> then writing the extent twice. We have to split the extent though, becaus=
e
> we're creating too large extents for a REQ_OP_ZONE_APPEND operation.
>
> When dumping the extent tree, we can see two EXTENT_ITEMs at the same
> start address but different lengths.
>
> $ btrfs inspect dump-tree /dev/nullb1 -t extent
> ...
>    item 19 key (269484032 EXTENT_ITEM 126976) itemoff 15470 itemsize 53
>            refs 1 gen 7 flags DATA
>            extent data backref root FS_TREE objectid 257 offset 786432 co=
unt 1
>    item 20 key (269484032 EXTENT_ITEM 262144) itemoff 15417 itemsize 53
>            refs 1 gen 7 flags DATA
>            extent data backref root FS_TREE objectid 257 offset 786432 co=
unt 1
>
> The duplicated EXTENT_ITEMs originally come from wrongly split extent_map=
 in
> extract_ordered_extent(). Since extract_ordered_extent() uses
> create_io_em() to split an existing extent_map, we will have
> split->orig_start !=3D split->start. Then, it will be logged with non-zer=
o
> "extent data offset". Finally, the logged entries are replayed into
> a duplicated EXTENT_ITEM.
>
> Introduce and use proper splitting function for extent_map. The function =
is
> intended to be simple and specific usage for extract_ordered_extent() e.g=
.
> not supporting compression case (we do not allow splitting compressed
> extent_map anyway).
>
> Fixes: d22002fd37bd ("btrfs: zoned: split ordered extent when bio is sent=
")
> Cc: stable@vger.kernel.org # 5.12+
> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> ---
>  fs/btrfs/inode.c | 151 ++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 122 insertions(+), 29 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e6eb20987351..79cdcaeab8de 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2271,13 +2271,131 @@ static blk_status_t btrfs_submit_bio_start(struc=
t inode *inode, struct bio *bio,
>         return btrfs_csum_one_bio(BTRFS_I(inode), bio, 0, 0);
>  }
>
> +/*
> + * split_zoned_em - split an extent_map at [start, start+len]
> + *
> + * This function is intended to be used only for extract_ordered_extent(=
).
> + */
> +static int split_zoned_em(struct btrfs_inode *inode, u64 start, u64 len,
> +                         u64 pre, u64 post)
> +{
> +       struct extent_map_tree *em_tree =3D &inode->extent_tree;
> +       struct extent_map *em;
> +       struct extent_map *split_pre =3D NULL;
> +       struct extent_map *split_mid =3D NULL;
> +       struct extent_map *split_post =3D NULL;
> +       int ret =3D 0;
> +       int modified;
> +       unsigned long flags;
> +
> +       /* Sanity check */
> +       if (pre =3D=3D 0 && post =3D=3D 0)
> +               return 0;
> +
> +       split_pre =3D alloc_extent_map();
> +       if (pre)
> +               split_mid =3D alloc_extent_map();
> +       if (post)
> +               split_post =3D alloc_extent_map();
> +       if (!split_pre || (pre && !split_mid) || (post && !split_post)) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
> +
> +       ASSERT(pre + post < len);
> +
> +       lock_extent(&inode->io_tree, start, start + len - 1);
> +       write_lock(&em_tree->lock);
> +       em =3D lookup_extent_mapping(em_tree, start, len);
> +       if (!em) {
> +               ret =3D -EIO;
> +               goto out_unlock;
> +       }
> +
> +       ASSERT(em->len =3D=3D len);
> +       ASSERT(!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags));
> +       ASSERT(em->block_start < EXTENT_MAP_LAST_BYTE);
> +
> +       flags =3D em->flags;
> +       clear_bit(EXTENT_FLAG_PINNED, &em->flags);
> +       clear_bit(EXTENT_FLAG_LOGGING, &flags);
> +       modified =3D !list_empty(&em->list);
> +
> +       /*
> +        * First, replace the em with a new extent_map starting from
> +        * em->start
> +        */
> +
> +       split_pre->start =3D em->start;
> +       split_pre->len =3D pre ? pre : (em->len - post);
> +       split_pre->orig_start =3D split_pre->start;
> +       split_pre->block_start =3D em->block_start;
> +       split_pre->block_len =3D split_pre->len;
> +       split_pre->orig_block_len =3D split_pre->block_len;
> +       split_pre->ram_bytes =3D split_pre->len;
> +       split_pre->flags =3D flags;
> +       split_pre->compress_type =3D em->compress_type;
> +       split_pre->generation =3D em->generation;
> +
> +       replace_extent_mapping(em_tree, em, split_pre, modified);
> +
> +       /*
> +        * Now we only have an extent_map at:
> +        *     [em->start, em->start + pre] if pre !=3D 0
> +        *     [em->start, em->start + em->len - post] if pre =3D=3D 0
> +        */
> +
> +       if (pre) {
> +               /* Insert the middle extent_map */
> +               split_mid->start =3D em->start + pre;
> +               split_mid->len =3D em->len - pre - post;
> +               split_mid->orig_start =3D split_mid->start;
> +               split_mid->block_start =3D em->block_start + pre;
> +               split_mid->block_len =3D split_mid->len;
> +               split_mid->orig_block_len =3D split_mid->block_len;
> +               split_mid->ram_bytes =3D split_mid->len;
> +               split_mid->flags =3D flags;
> +               split_mid->compress_type =3D em->compress_type;
> +               split_mid->generation =3D em->generation;
> +               add_extent_mapping(em_tree, split_mid, modified);
> +       }
> +
> +       if (post) {
> +               split_post->start =3D em->start + em->len - post;
> +               split_post->len =3D post;
> +               split_post->orig_start =3D split_post->start;
> +               split_post->block_start =3D em->block_start + em->len - p=
ost;
> +               split_post->block_len =3D split_post->len;
> +               split_post->orig_block_len =3D split_post->block_len;
> +               split_post->ram_bytes =3D split_post->len;
> +               split_post->flags =3D flags;
> +               split_post->compress_type =3D em->compress_type;
> +               split_post->generation =3D em->generation;
> +               add_extent_mapping(em_tree, split_post, modified);
> +       }

So this happens when running delalloc, after creating the original
extent map and ordered extent, the original "em" must have had the
PINNED flag set.

The "pre" and "post" extent maps should have the PINNED flag set. It's
important to have the flag set to prevent extent map merging, which
could result in a log corruption if the file is being fsync'ed
multiple times in the current transaction and running delalloc was
triggered precisely by an fsync. The corruption result would be
logging extent items with overlapping ranges, since we construct them
based on extent maps, and that's why we have the PINNED flag to
prevent merging.

Or did I miss something?

Thanks.

> +
> +       /* once for us */
> +       free_extent_map(em);
> +       /* once for the tree */
> +       free_extent_map(em);
> +
> +out_unlock:
> +       write_unlock(&em_tree->lock);
> +       unlock_extent(&inode->io_tree, start, start + len - 1);
> +out:
> +       free_extent_map(split_pre);
> +       free_extent_map(split_mid);
> +       free_extent_map(split_post);
> +
> +       return ret;
> +}
> +
>  static blk_status_t extract_ordered_extent(struct btrfs_inode *inode,
>                                            struct bio *bio, loff_t file_o=
ffset)
>  {
>         struct btrfs_ordered_extent *ordered;
> -       struct extent_map *em =3D NULL, *em_new =3D NULL;
> -       struct extent_map_tree *em_tree =3D &inode->extent_tree;
>         u64 start =3D (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
> +       u64 file_len;
>         u64 len =3D bio->bi_iter.bi_size;
>         u64 end =3D start + len;
>         u64 ordered_end;
> @@ -2317,41 +2435,16 @@ static blk_status_t extract_ordered_extent(struct=
 btrfs_inode *inode,
>                 goto out;
>         }
>
> +       file_len =3D ordered->num_bytes;
>         pre =3D start - ordered->disk_bytenr;
>         post =3D ordered_end - end;
>
>         ret =3D btrfs_split_ordered_extent(ordered, pre, post);
>         if (ret)
>                 goto out;
> -
> -       read_lock(&em_tree->lock);
> -       em =3D lookup_extent_mapping(em_tree, ordered->file_offset, len);
> -       if (!em) {
> -               read_unlock(&em_tree->lock);
> -               ret =3D -EIO;
> -               goto out;
> -       }
> -       read_unlock(&em_tree->lock);
> -
> -       ASSERT(!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags));
> -       /*
> -        * We cannot reuse em_new here but have to create a new one, as
> -        * unpin_extent_cache() expects the start of the extent map to be=
 the
> -        * logical offset of the file, which does not hold true anymore a=
fter
> -        * splitting.
> -        */
> -       em_new =3D create_io_em(inode, em->start + pre, len,
> -                             em->start + pre, em->block_start + pre, len=
,
> -                             len, len, BTRFS_COMPRESS_NONE,
> -                             BTRFS_ORDERED_REGULAR);
> -       if (IS_ERR(em_new)) {
> -               ret =3D PTR_ERR(em_new);
> -               goto out;
> -       }
> -       free_extent_map(em_new);
> +       ret =3D split_zoned_em(inode, file_offset, file_len, pre, post);
>
>  out:
> -       free_extent_map(em);
>         btrfs_put_ordered_extent(ordered);
>
>         return errno_to_blk_status(ret);
> --
> 2.32.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
