Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363E43B94F7
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhGAQ6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 12:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGAQ6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 12:58:34 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCA2C061762;
        Thu,  1 Jul 2021 09:56:03 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id g3so4557159qth.11;
        Thu, 01 Jul 2021 09:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=btlruZEYONxhUZkvkyJ1ZQlV9jHYMFZiLXps6S94GG4=;
        b=hmfyUcUYymxj/VGqIC8jCG8xu+i2NOaiBiBFAjvU0/wDJDAW11Yv+uHdKvtGcSZlgb
         Nub4DRToyv4Ms/is0nCOpc9W+VNoxjLs6awt+sc7j5m3VCBghXCYc8xTGEYUW7JJiYTT
         yYOH5vw6pZHDHbVj4QdVEjHFnIGuiDM9HBw27zx9wUmatvDJEIKw3j9Y2QFf6+UxHIIe
         pwIUyABqnxHsGLqGox746q8Rn/GOP4BZSDUNKvplaI07C/z8amrWhC+ugdDWZzaj7vXE
         g3UryUvdy5HjFPk+RaJhv1mkhe71tAbICRyeN0HJjTTA2bHbR7kMiUGXM/oSqDPgrpJB
         nuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=btlruZEYONxhUZkvkyJ1ZQlV9jHYMFZiLXps6S94GG4=;
        b=HpGO0kbMyekR2geTwEX6Z+W55yaWGZA4M2GnI7bwsTf/dtZ0uXZalep3hd4qJoYiRx
         w8TuBRAfgiGKN+aU2k44HuSO2CqEeajvj49EKeWkopxg9cIKYvsRqn0RvOu+pJjQKEAu
         E1gZRvVmespXDyIp0YiGQqTpm2uWdJd6rDsGhir/GeOj81WP9yBZ72l49vZwx+e6DDsR
         Bpf76lyxo4wAsQxwe3vN8dDMdihT3QU33L/TDyqVd8R7yPdbMI/7NQSMtJuL2GXzbbRO
         vS7SrAhwMgvovx2TpQq4VZdCmYLUjZeRyUvtVhgKxv4J16jgRtu50Yqx66q9+PfsPpOm
         cg8A==
X-Gm-Message-State: AOAM530i+ClATgijffF8dN82s1dXHPrkCkfpTqHffo6krh4u/t4wEo+f
        00ujHHbunMDfOf69WT3JgpxGNg9imEjHIftH7ag=
X-Google-Smtp-Source: ABdhPJwNETeN/2zMN0GkT/Gwo92Hgv70Z0uR3stGVk+9YUAaYs/D8wu1m8OdPMwofGi0QvqwLnLRJOmRX1xA/HjXoEE=
X-Received: by 2002:a05:622a:1708:: with SMTP id h8mr854556qtk.183.1625158562495;
 Thu, 01 Jul 2021 09:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210628085728.2813793-1-naohiro.aota@wdc.com> <CAL3q7H4LsXDK8rTr3yEkftMm9ok9kWdQuwxk57Pke5oJ+EZOZQ@mail.gmail.com>
In-Reply-To: <CAL3q7H4LsXDK8rTr3yEkftMm9ok9kWdQuwxk57Pke5oJ+EZOZQ@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 1 Jul 2021 17:55:51 +0100
Message-ID: <CAL3q7H6dMNGQ+RKrK91pZsbXQO9852fE+pqZDzo53xOvDAeYFA@mail.gmail.com>
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

On Thu, Jul 1, 2021 at 5:42 PM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Mon, Jun 28, 2021 at 10:06 AM Naohiro Aota <naohiro.aota@wdc.com> wrot=
e:
> >
> > Damien reported a test failure with btrfs/209. The test itself ran fine=
,
> > but the fsck run afterwards reported a corrupted filesystem.
> >
> > The filesystem corruption happens because we're splitting an extent and
> > then writing the extent twice. We have to split the extent though, beca=
use
> > we're creating too large extents for a REQ_OP_ZONE_APPEND operation.
> >
> > When dumping the extent tree, we can see two EXTENT_ITEMs at the same
> > start address but different lengths.
> >
> > $ btrfs inspect dump-tree /dev/nullb1 -t extent
> > ...
> >    item 19 key (269484032 EXTENT_ITEM 126976) itemoff 15470 itemsize 53
> >            refs 1 gen 7 flags DATA
> >            extent data backref root FS_TREE objectid 257 offset 786432 =
count 1
> >    item 20 key (269484032 EXTENT_ITEM 262144) itemoff 15417 itemsize 53
> >            refs 1 gen 7 flags DATA
> >            extent data backref root FS_TREE objectid 257 offset 786432 =
count 1
> >
> > The duplicated EXTENT_ITEMs originally come from wrongly split extent_m=
ap in
> > extract_ordered_extent(). Since extract_ordered_extent() uses
> > create_io_em() to split an existing extent_map, we will have
> > split->orig_start !=3D split->start. Then, it will be logged with non-z=
ero
> > "extent data offset". Finally, the logged entries are replayed into
> > a duplicated EXTENT_ITEM.
> >
> > Introduce and use proper splitting function for extent_map. The functio=
n is
> > intended to be simple and specific usage for extract_ordered_extent() e=
.g.
> > not supporting compression case (we do not allow splitting compressed
> > extent_map anyway).
> >
> > Fixes: d22002fd37bd ("btrfs: zoned: split ordered extent when bio is se=
nt")
> > Cc: stable@vger.kernel.org # 5.12+
> > Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> > Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> > ---
> >  fs/btrfs/inode.c | 151 ++++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 122 insertions(+), 29 deletions(-)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index e6eb20987351..79cdcaeab8de 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -2271,13 +2271,131 @@ static blk_status_t btrfs_submit_bio_start(str=
uct inode *inode, struct bio *bio,
> >         return btrfs_csum_one_bio(BTRFS_I(inode), bio, 0, 0);
> >  }
> >
> > +/*
> > + * split_zoned_em - split an extent_map at [start, start+len]
> > + *
> > + * This function is intended to be used only for extract_ordered_exten=
t().
> > + */
> > +static int split_zoned_em(struct btrfs_inode *inode, u64 start, u64 le=
n,
> > +                         u64 pre, u64 post)
> > +{
> > +       struct extent_map_tree *em_tree =3D &inode->extent_tree;
> > +       struct extent_map *em;
> > +       struct extent_map *split_pre =3D NULL;
> > +       struct extent_map *split_mid =3D NULL;
> > +       struct extent_map *split_post =3D NULL;
> > +       int ret =3D 0;
> > +       int modified;
> > +       unsigned long flags;
> > +
> > +       /* Sanity check */
> > +       if (pre =3D=3D 0 && post =3D=3D 0)
> > +               return 0;
> > +
> > +       split_pre =3D alloc_extent_map();
> > +       if (pre)
> > +               split_mid =3D alloc_extent_map();
> > +       if (post)
> > +               split_post =3D alloc_extent_map();
> > +       if (!split_pre || (pre && !split_mid) || (post && !split_post))=
 {
> > +               ret =3D -ENOMEM;
> > +               goto out;
> > +       }
> > +
> > +       ASSERT(pre + post < len);
> > +
> > +       lock_extent(&inode->io_tree, start, start + len - 1);
> > +       write_lock(&em_tree->lock);
> > +       em =3D lookup_extent_mapping(em_tree, start, len);
> > +       if (!em) {
> > +               ret =3D -EIO;
> > +               goto out_unlock;
> > +       }
> > +
> > +       ASSERT(em->len =3D=3D len);
> > +       ASSERT(!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags));
> > +       ASSERT(em->block_start < EXTENT_MAP_LAST_BYTE);
> > +
> > +       flags =3D em->flags;
> > +       clear_bit(EXTENT_FLAG_PINNED, &em->flags);
> > +       clear_bit(EXTENT_FLAG_LOGGING, &flags);
> > +       modified =3D !list_empty(&em->list);
> > +
> > +       /*
> > +        * First, replace the em with a new extent_map starting from
> > +        * em->start
> > +        */
> > +
> > +       split_pre->start =3D em->start;
> > +       split_pre->len =3D pre ? pre : (em->len - post);
> > +       split_pre->orig_start =3D split_pre->start;
> > +       split_pre->block_start =3D em->block_start;
> > +       split_pre->block_len =3D split_pre->len;
> > +       split_pre->orig_block_len =3D split_pre->block_len;
> > +       split_pre->ram_bytes =3D split_pre->len;
> > +       split_pre->flags =3D flags;
> > +       split_pre->compress_type =3D em->compress_type;
> > +       split_pre->generation =3D em->generation;
> > +
> > +       replace_extent_mapping(em_tree, em, split_pre, modified);
> > +
> > +       /*
> > +        * Now we only have an extent_map at:
> > +        *     [em->start, em->start + pre] if pre !=3D 0
> > +        *     [em->start, em->start + em->len - post] if pre =3D=3D 0
> > +        */
> > +
> > +       if (pre) {
> > +               /* Insert the middle extent_map */
> > +               split_mid->start =3D em->start + pre;
> > +               split_mid->len =3D em->len - pre - post;
> > +               split_mid->orig_start =3D split_mid->start;
> > +               split_mid->block_start =3D em->block_start + pre;
> > +               split_mid->block_len =3D split_mid->len;
> > +               split_mid->orig_block_len =3D split_mid->block_len;
> > +               split_mid->ram_bytes =3D split_mid->len;
> > +               split_mid->flags =3D flags;
> > +               split_mid->compress_type =3D em->compress_type;
> > +               split_mid->generation =3D em->generation;
> > +               add_extent_mapping(em_tree, split_mid, modified);
> > +       }
> > +
> > +       if (post) {
> > +               split_post->start =3D em->start + em->len - post;
> > +               split_post->len =3D post;
> > +               split_post->orig_start =3D split_post->start;
> > +               split_post->block_start =3D em->block_start + em->len -=
 post;
> > +               split_post->block_len =3D split_post->len;
> > +               split_post->orig_block_len =3D split_post->block_len;
> > +               split_post->ram_bytes =3D split_post->len;
> > +               split_post->flags =3D flags;
> > +               split_post->compress_type =3D em->compress_type;
> > +               split_post->generation =3D em->generation;
> > +               add_extent_mapping(em_tree, split_post, modified);
> > +       }
>
> So this happens when running delalloc, after creating the original
> extent map and ordered extent, the original "em" must have had the
> PINNED flag set.
>
> The "pre" and "post" extent maps should have the PINNED flag set. It's
> important to have the flag set to prevent extent map merging, which
> could result in a log corruption if the file is being fsync'ed
> multiple times in the current transaction and running delalloc was
> triggered precisely by an fsync. The corruption result would be
> logging extent items with overlapping ranges, since we construct them
> based on extent maps, and that's why we have the PINNED flag to
> prevent merging.

Well, it actually happens that merging should not happen because the
original extent map was in the list of modified extents, and so should
be the new extent maps.
But we are really supposed to have the PINNED flag from the moment we
run delalloc and create a new extent map until the respective ordered
extent completes and unpins it.

Also EXTENT_FLAG_LOGGING should not be set at this point - if it were
we would screw up with a task logging the extent map.

Maybe assert that it is not set in the original extent map?
And also assert that the original em is in the list of modified
extents and has the PINNED flag set?

Thanks.

>
> Or did I miss something?
>
> Thanks.
>
> > +
> > +       /* once for us */
> > +       free_extent_map(em);
> > +       /* once for the tree */
> > +       free_extent_map(em);
> > +
> > +out_unlock:
> > +       write_unlock(&em_tree->lock);
> > +       unlock_extent(&inode->io_tree, start, start + len - 1);
> > +out:
> > +       free_extent_map(split_pre);
> > +       free_extent_map(split_mid);
> > +       free_extent_map(split_post);
> > +
> > +       return ret;
> > +}
> > +
> >  static blk_status_t extract_ordered_extent(struct btrfs_inode *inode,
> >                                            struct bio *bio, loff_t file=
_offset)
> >  {
> >         struct btrfs_ordered_extent *ordered;
> > -       struct extent_map *em =3D NULL, *em_new =3D NULL;
> > -       struct extent_map_tree *em_tree =3D &inode->extent_tree;
> >         u64 start =3D (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
> > +       u64 file_len;
> >         u64 len =3D bio->bi_iter.bi_size;
> >         u64 end =3D start + len;
> >         u64 ordered_end;
> > @@ -2317,41 +2435,16 @@ static blk_status_t extract_ordered_extent(stru=
ct btrfs_inode *inode,
> >                 goto out;
> >         }
> >
> > +       file_len =3D ordered->num_bytes;
> >         pre =3D start - ordered->disk_bytenr;
> >         post =3D ordered_end - end;
> >
> >         ret =3D btrfs_split_ordered_extent(ordered, pre, post);
> >         if (ret)
> >                 goto out;
> > -
> > -       read_lock(&em_tree->lock);
> > -       em =3D lookup_extent_mapping(em_tree, ordered->file_offset, len=
);
> > -       if (!em) {
> > -               read_unlock(&em_tree->lock);
> > -               ret =3D -EIO;
> > -               goto out;
> > -       }
> > -       read_unlock(&em_tree->lock);
> > -
> > -       ASSERT(!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags));
> > -       /*
> > -        * We cannot reuse em_new here but have to create a new one, as
> > -        * unpin_extent_cache() expects the start of the extent map to =
be the
> > -        * logical offset of the file, which does not hold true anymore=
 after
> > -        * splitting.
> > -        */
> > -       em_new =3D create_io_em(inode, em->start + pre, len,
> > -                             em->start + pre, em->block_start + pre, l=
en,
> > -                             len, len, BTRFS_COMPRESS_NONE,
> > -                             BTRFS_ORDERED_REGULAR);
> > -       if (IS_ERR(em_new)) {
> > -               ret =3D PTR_ERR(em_new);
> > -               goto out;
> > -       }
> > -       free_extent_map(em_new);
> > +       ret =3D split_zoned_em(inode, file_offset, file_len, pre, post)=
;
> >
> >  out:
> > -       free_extent_map(em);
> >         btrfs_put_ordered_extent(ordered);
> >
> >         return errno_to_blk_status(ret);
> > --
> > 2.32.0
> >
>
>
> --
> Filipe David Manana,
>
> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you'=
re right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
