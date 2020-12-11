Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BC82D73DB
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgLKKX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 05:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgLKKXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 05:23:20 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4D4C0613CF;
        Fri, 11 Dec 2020 02:22:40 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id 1so7913016qka.0;
        Fri, 11 Dec 2020 02:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=YuPZHdVgAGWAofDwCNuBJINnSSjfEBVFS3IZCVIkx6U=;
        b=d1ZCiEEgLdptNLqFv8mDobfBYlk/v8X+Io8lsFuiJCMowxvNM50C0ZM1FqQ5Ko2QUy
         K1pAJiAXf2Mmp0EIpYkL3WogGrnillatMvHWOgcT+3O1rM99jgCIRNZ2bzQqWRL+dQ4t
         KQJlfBR6Ophn6d32ND2Fa9REXt9kAnH+LIzMfaKk/vlz3QnF5T0KnAz20NjHbjJZXpF4
         Zq7AGtoLO+R5iau0fcvfQ4yYeS1cj9EkjUyiD/gfWfq/q9iNUpv7EXtI59yjICLS/VEu
         Kp6D67Hbs5/aqnD+7mWMG3eN9QoyTa8G0ikzUC0jOcWlfcvbqzoxe2TY2NZL5EI9mgUF
         i2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=YuPZHdVgAGWAofDwCNuBJINnSSjfEBVFS3IZCVIkx6U=;
        b=ozjggBIM6u+H+0ru4Qs7QMVbC9zkgKm3o6rW5SGxwc+tClRFUbKXXSihlhZJ1DpoId
         hS8cEaonWA5//RblAl2IQ7uiNx/PLt1BoUfCtuSvuT+V5cyubjT/+2XoHuzstK7idKVR
         R8Pm+Xh6YMDCqpioyWdh5M6s3PsTvb5elDpKD8fLk237eqT7mkvxRuADM7KBkvzKpyKz
         LfFTkF9lApa4AlDLnGsWenaz4qM5+25Ax/dvx4wr9DwL03dfCUU0lnXy5W36XCMZetn9
         ryn4FKvSBBWCqW68drsGMrNFS0S6OCtON/inCHi2/l0B3Dn41f+GyK09Br3pbVJoS2P3
         fvbA==
X-Gm-Message-State: AOAM5304KamrZzF+vN52JfaoFlTGWcFUVqjBHwcjGYV0MX87B9rRx5S6
        mu5fizcpl/tLuuaB/DyJ0nEeI32YRzv8di88bkHBeDhj1q0=
X-Google-Smtp-Source: ABdhPJzs4KX/niW7nAMdLSKD7XWJujp8iQkTOHNRORsm+Nj4X9Y+Ewklmo117YMhOKdLkLnYE+6pJLP27AJ6rV4PvUc=
X-Received: by 2002:ae9:df47:: with SMTP id t68mr14541475qkf.438.1607682159614;
 Fri, 11 Dec 2020 02:22:39 -0800 (PST)
MIME-Version: 1.0
References: <e5f7fe3ad3a612efeda53f016904aff332db6f8a.1607610739.git.josef@toxicpanda.com>
In-Reply-To: <e5f7fe3ad3a612efeda53f016904aff332db6f8a.1607610739.git.josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 11 Dec 2020 10:22:28 +0000
Message-ID: <CAL3q7H56AvqWuA8gJsUdnz=QLg-yUTS6RbdZJVU4+EbnPFK_bQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix possible free space tree corruption with
 online conversion
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 11, 2020 at 8:56 AM Josef Bacik <josef@toxicpanda.com> wrote:
>
> While running btrfs/011 in a loop I would often ASSERT() while trying to
> add a new free space entry that already existed, or get an -EEXIST while
> adding a new block to the extent tree, which is another indication of
> double allocation.
>
> This occurs because when we do the free space tree population, we create
> the new root and then populate the tree and commit the transaction.
> The problem is when you create a new root, the root node and commit root
> node are the same.  This means that caching a block group before the
> transaction is committed can race with other operations modifying the
> free space tree, and thus you can get double adds and other sort of
> shenanigans.  This is only a problem for the first transaction, once
> we've committed the transaction we created the free space tree in we're
> OK to use the free space tree to cache block groups.
>
> Fix this by marking the fs_info as unsafe to load the free space tree,
> and fall back on the old slow method.  We could be smarter than this,
> for example caching the block group while we're populating the free
> space tree, but since this is a serious problem I've opted for the
> simplest solution.
>
> cc: stable@vger.kernel.org
> Fixes: a5ed91828518 ("Btrfs: implement the free space B-tree")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Looks good, but the explanation you gave in the reply to Nikolay's
comment makes it easier to realize how the problem happens.
I think it should be mentioned, in the changelog, that the operations
that can concurrently modify the free space tree are the insertions
from running delayed references.

Anyway,

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>  fs/btrfs/block-group.c     | 11 ++++++++++-
>  fs/btrfs/ctree.h           |  3 +++
>  fs/btrfs/free-space-tree.c | 10 +++++++++-
>  3 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 52f2198d44c9..b8bbdd95743e 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -673,7 +673,16 @@ static noinline void caching_thread(struct btrfs_wor=
k *work)
>                 wake_up(&caching_ctl->wait);
>         }
>
> -       if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
> +       /*
> +        * If we are in the transaction that populated the free space tre=
e we
> +        * can't actually cache from the free space tree as our commit ro=
ot and
> +        * real root are the same, so we could change the contents of the=
 blocks
> +        * while caching.  Instead do the slow caching in this case, and =
after
> +        * the transaction has committed we will be safe.
> +        */
> +       if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
> +           !(test_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
> +                      &fs_info->flags)))
>                 ret =3D load_free_space_tree(caching_ctl);
>         else
>                 ret =3D load_extent_tree_free(caching_ctl);
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 3935d297d198..4a60d81da5cb 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -562,6 +562,9 @@ enum {
>
>         /* Indicate that we need to cleanup space cache v1 */
>         BTRFS_FS_CLEANUP_SPACE_CACHE_V1,
> +
> +       /* Indicate that we can't trust the free space tree for caching y=
et. */
> +       BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED,
>  };
>
>  /*
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index e33a65bd9a0c..a33bca94d133 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1150,6 +1150,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_in=
fo *fs_info)
>                 return PTR_ERR(trans);
>
>         set_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
> +       set_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
>         free_space_root =3D btrfs_create_tree(trans,
>                                             BTRFS_FREE_SPACE_TREE_OBJECTI=
D);
>         if (IS_ERR(free_space_root)) {
> @@ -1171,11 +1172,18 @@ int btrfs_create_free_space_tree(struct btrfs_fs_=
info *fs_info)
>         btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
>         btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE_VALID);
>         clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
> +       ret =3D btrfs_commit_transaction(trans);
>
> -       return btrfs_commit_transaction(trans);
> +       /*
> +        * Now that we've committed the transaction any reading of our co=
mmit
> +        * root will be safe, so we can cache from the free space tree no=
w.
> +        */
> +       clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
> +       return ret;
>
>  abort:
>         clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
> +       clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
>         btrfs_abort_transaction(trans, ret);
>         btrfs_end_transaction(trans);
>         return ret;
> --
> 2.26.2
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
