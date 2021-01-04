Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E94E2E9BF2
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbhADRYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 12:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADRYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 12:24:31 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37AAC061574;
        Mon,  4 Jan 2021 09:23:50 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id w79so24062181qkb.5;
        Mon, 04 Jan 2021 09:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=mXc0FwdMxtcGLe+O48tzC3uXRwT0ffZD99+ISuL0ssA=;
        b=jcByy9C6xJ27R1C35nNa85oIu0J/iD60Gjj0p/PGBxfXbn6SVLqUGR3v9ZWZmd+c5f
         9arXr4o6BPd85PoY71l+0N53dcgLtAaJ0TRDb1KSyf17S4SRKKx2Rs2nnzWE4wNaDJGU
         oWpFu/N4DrBWTvukt/xd8b3s5fLJiiiLs096SoEn7jfibPpEBxjHxlLqlrOhzMmPDFU1
         d8EhBCEIwGgb/4WvP+Qi9CXPKcybvOFsVrZeIji0KgBbnpD3NfPEch4ZiuvAYNrqaj75
         gk/rYFS1qQZkRnVS4DdL9GaDguDgf+VAlZVXw4Z3vxjyGtJ295VaqzUo+U5lYEF39CiJ
         wOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=mXc0FwdMxtcGLe+O48tzC3uXRwT0ffZD99+ISuL0ssA=;
        b=gtSuL+7o0YrDPWET81vV/M9cW9A9KJBLoexwmjH11iXAr0DGeiOpbPJ6uXLR12kMtn
         fz4VmfwmFm7qd4e3qYqeIZvzETerkn0RzvZWtx0UvClbThyZD+qr0crvZwQ4vlq0Jok1
         PAbAhd/2S+8YyhTOmrhAKC1MPeHMH43cGvG9SUYqpbRj8ljwRtzMYZl8IX8LdaeDHPMI
         4b2gRFSLGuwoYD1IkF4MIozz/K17UORAFjUDEiQ9PfhL3b16P6PnaElmvMaxVwuh7yTW
         0iguN0N02Lc/EJNzgNCmPxiR1BBd+rxIAh+5UvzfUruVzO6WSL0e7v32p4lzE8KDP5tF
         n/qg==
X-Gm-Message-State: AOAM533VsVHxylGB6nn1+pspbOHHjMqplsBORVm+fa3TAKMT6zil5IAM
        WH6NZVfgEBuFQyVkrT09wmlG80u1/7xnWhg+5IU66AFlP34=
X-Google-Smtp-Source: ABdhPJwn5a5M7KCkaISG6Cd/tsFtYyO7MzVUGIvlRQuDGAviI9/qYfwVE60igvNSfnMpk32JDdGaXgMRzL5UAfqsSOk=
X-Received: by 2002:a37:bc07:: with SMTP id m7mr68477604qkf.438.1609781029516;
 Mon, 04 Jan 2021 09:23:49 -0800 (PST)
MIME-Version: 1.0
References: <7a1048dfbc8d2f5f3869f072146ec3e499bc0ac2.1609779712.git.josef@toxicpanda.com>
In-Reply-To: <7a1048dfbc8d2f5f3869f072146ec3e499bc0ac2.1609779712.git.josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 4 Jan 2021 17:23:38 +0000
Message-ID: <CAL3q7H5-L7Qs1ecZXPNiQ58rOCMXbpRaPPVFaEEnL0Gcmmfyvw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Use the normal writeback path for flushing delalloc
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        stable@vger.kernel.org,
        =?UTF-8?Q?Ren=C3=A9_Rebe?= <rene@exactcode.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 4, 2021 at 5:06 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> This is a revert for 38d715f494f2 ("btrfs: use
> btrfs_start_delalloc_roots in shrink_delalloc").  A user reported a
> problem where performance was significantly worse with this patch
> applied.  The problem needs to be fixed with proper pre-flushing, and
> changes to how we deal with the work queues for the inodes.  However
> that work is much more complicated than is acceptable for stable, and
> simply reverting this patch fixes the problem.  The original patch was
> a cleanup of the code, so it's fine to revert it.  My numbers for the
> original reported test, which was untarring a copy of the firefox
> sources, are as follows
>
> 5.9     0m54.258s
> 5.10    1m26.212s
> Fix     0m35.038s
>
> cc: stable@vger.kernel.org # 5.10
> Reported-by: Ren=C3=A9 Rebe <rene@exactcode.de>
> Fixes: 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in shrink_del=
alloc")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> Dave, this is ontop of linus's branch, because we've changed the argument=
s for
> btrfs_start_delalloc_roots in misc-next, and this needs to go back to 5.1=
0 ASAP.
> I can send a misc-next version if you want to have it there as well while=
 we're
> waiting for it to go into linus's tree, just let me know.

Adding this to stable releases will also make the following fix not
work on stable releases:

https://lore.kernel.org/linux-btrfs/39c2a60aa682f69f9823f51aa119d37ef4b9f83=
4.1606909923.git.fdmanana@suse.com/

Since now the async reclaim task can trigger writeback through
writeback_inodes_sb_nr() and not only through
btrfs_start_delalloc_roots().
Other than changing that patch to make extent_write_cache_pages() do
nothing when the inode has the bit BTRFS_INODE_NO_DELALLOC_FLUSH set,
I'm not seeing other simple ways to do it.

Thanks.

>
>  fs/btrfs/space-info.c | 54 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 64099565ab8f..a2b322275b8d 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -465,6 +465,28 @@ void btrfs_dump_space_info(struct btrfs_fs_info *fs_=
info,
>         up_read(&info->groups_sem);
>  }
>
> +static void btrfs_writeback_inodes_sb_nr(struct btrfs_fs_info *fs_info,
> +                                        unsigned long nr_pages, u64 nr_i=
tems)
> +{
> +       struct super_block *sb =3D fs_info->sb;
> +
> +       if (down_read_trylock(&sb->s_umount)) {
> +               writeback_inodes_sb_nr(sb, nr_pages, WB_REASON_FS_FREE_SP=
ACE);
> +               up_read(&sb->s_umount);
> +       } else {
> +               /*
> +                * We needn't worry the filesystem going from r/w to r/o =
though
> +                * we don't acquire ->s_umount mutex, because the filesys=
tem
> +                * should guarantee the delalloc inodes list be empty aft=
er
> +                * the filesystem is readonly(all dirty pages are written=
 to
> +                * the disk).
> +                */
> +               btrfs_start_delalloc_roots(fs_info, nr_items);
> +               if (!current->journal_info)
> +                       btrfs_wait_ordered_roots(fs_info, nr_items, 0, (u=
64)-1);
> +       }
> +}
> +
>  static inline u64 calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
>                                         u64 to_reclaim)
>  {
> @@ -490,8 +512,10 @@ static void shrink_delalloc(struct btrfs_fs_info *fs=
_info,
>         struct btrfs_trans_handle *trans;
>         u64 delalloc_bytes;
>         u64 dio_bytes;
> +       u64 async_pages;
>         u64 items;
>         long time_left;
> +       unsigned long nr_pages;
>         int loops;
>
>         /* Calc the number of the pages we need flush for space reservati=
on */
> @@ -532,8 +556,36 @@ static void shrink_delalloc(struct btrfs_fs_info *fs=
_info,
>
>         loops =3D 0;
>         while ((delalloc_bytes || dio_bytes) && loops < 3) {
> -               btrfs_start_delalloc_roots(fs_info, items);
> +               nr_pages =3D min(delalloc_bytes, to_reclaim) >> PAGE_SHIF=
T;
> +
> +               /*
> +                * Triggers inode writeback for up to nr_pages. This will=
 invoke
> +                * ->writepages callback and trigger delalloc filling
> +                *  (btrfs_run_delalloc_range()).
> +                */
> +               btrfs_writeback_inodes_sb_nr(fs_info, nr_pages, items);
> +               /*
> +                * We need to wait for the compressed pages to start befo=
re
> +                * we continue.
> +                */
> +               async_pages =3D atomic_read(&fs_info->async_delalloc_page=
s);
> +               if (!async_pages)
> +                       goto skip_async;
> +
> +               /*
> +                * Calculate how many compressed pages we want to be writ=
ten
> +                * before we continue. I.e if there are more async pages =
than we
> +                * require wait_event will wait until nr_pages are writte=
n.
> +                */
> +               if (async_pages <=3D nr_pages)
> +                       async_pages =3D 0;
> +               else
> +                       async_pages -=3D nr_pages;
>
> +               wait_event(fs_info->async_submit_wait,
> +                          atomic_read(&fs_info->async_delalloc_pages) <=
=3D
> +                          (int)async_pages);
> +skip_async:
>                 loops++;
>                 if (wait_ordered && !trans) {
>                         btrfs_wait_ordered_roots(fs_info, items, 0, (u64)=
-1);
> --
> 2.26.2
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
