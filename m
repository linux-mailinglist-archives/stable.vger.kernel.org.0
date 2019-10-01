Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2BEC3342
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 13:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfJALqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 07:46:50 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:38397 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJALqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 07:46:50 -0400
Received: by mail-vs1-f68.google.com with SMTP id b123so9111657vsb.5;
        Tue, 01 Oct 2019 04:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=3IIVJGpufy9CYobEbO211vdFNuEq+mTO0jolseDiF1A=;
        b=QHvTHsynGaaF1bDxUJUUY3JkA0oMoeqOUsPcZjTey+weSKK+6Uj2idXVEYCe2UzOtS
         hKwkMMAHlrtulRD5xHCSELEbjRJze+jjIUXUgkBHXKlUxroJHtcvdO8LpJFJPlnaOMHO
         najvRlFfE/Y1/9LXvIPs6k4sYU3Gm0a3DcRNBvNh4+BpOkLazTiexnnuwVYjoETQmg9K
         XteDzfoNSvDTiIJpfHmV922bapGCFTONVxxBMIu8FgRZ9VsM5q3EykYdaCY/Y7MMIMSg
         EwO0W55Yzkn8X0ePNcWW7j80f7xuaNnybsT7OvkRAy5gkvjr0JWitlvBFzzg9Jv5pQqf
         Aslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=3IIVJGpufy9CYobEbO211vdFNuEq+mTO0jolseDiF1A=;
        b=QqZZM2jv2ifzGS4L+Xv9dFHf3xiNclpV/FnEKjzWPAAlJQW5sdHHf5vbnHQYmgPIjA
         ljLg8bz3xy3rG//7OuV+hs/Yxu1w3SYai6NBtluXozNISSrh/rnm08KuQ4Dcy0agqrdb
         aqvOFlvmHCio48GoEyu+KBz0OjT+qSGQOc/SCuUfp5DLAX9l8eF3eNFt1WjEf8OM68jZ
         9gmtJ1tFoJGtPqM85Hta7//3QNXaGawsy3sVvsPNootIdJMepgd/aU4xe5SWWfRgZAxB
         Pf2sRee7QqWoEPnGs8vbjHUs+KZOf6FT+cJTv4R+pvlWg8xbXOA5iUxg5iWRA73STt+5
         OWOg==
X-Gm-Message-State: APjAAAWveD0dauAJV3Zy0yLMSUNfRotvOewykmMDNaT7HqafzobD8H+p
        nMho0CT/4YIHk1A8zYfRtvnon6bi4K5Gds2onmk=
X-Google-Smtp-Source: APXvYqwih+nIYH2qiGTlL64AeXL3cYz1WTsEqSJ/pVatoJd/veMXYC3GaoqERc2YBxIy/Gq1LBOfgL/WoLBuHUc1NQI=
X-Received: by 2002:a67:6044:: with SMTP id u65mr1249997vsb.95.1569930408617;
 Tue, 01 Oct 2019 04:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190930202725.1317-1-josef@toxicpanda.com>
In-Reply-To: <20190930202725.1317-1-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 1 Oct 2019 12:46:36 +0100
Message-ID: <CAL3q7H5WOOoskDS2728079PJVYJa37ZPiQ5ES8eYuu6p-PS+Lg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix incorrect updating of log root tree
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 11:25 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> We've historically had reports of being unable to mount file systems
> because the tree log root couldn't be read.  Usually this is the "parent
> transid failure", but could be any of the related errors, including
> "fsid mismatch" or "bad tree block", depending on which block got
> allocated.
>
> The modification of the individual log root items are serialized on the
> per-log root root_mutex.  This means that any modification to the
> per-subvol log root_item is completely protected.
>
> However we update the root item in the log root tree outside of the log
> root tree log_mutex.  We do this in order to allow multiple subvolumes
> to be updated in each log transaction.
>
> This is problematic however because when we are writing the log root
> tree out we update the super block with the _current_ log root node
> information.  Since these two operations happen independently of each
> other, you can end up updating the log root tree in between writing out
> the dirty blocks and setting the super block to point at the current
> root.
>
> This means we'll point at the new root node that hasn't been written
> out, instead of the one we should be pointing at.  Thus whatever garbage
> or old block we end up pointing at complains when we mount the file
> system later and try to replay the log.
>
> Fix this by copying the log's root item into a local root item copy.
> Then once we're safely under the log_root_tree->log_mutex we update the
> root item in the log_root_tree.  This way we do not modify the
> log_root_tree while we're committing it, fixing the problem.
>
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Chris Mason <clm@fb.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good to me, great catch!
Thanks.

> ---
>  fs/btrfs/tree-log.c | 36 +++++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 9 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 7cac09a6f007..1d7f22951ef2 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2908,7 +2908,8 @@ static int walk_log_tree(struct btrfs_trans_handle =
*trans,
>   * in the tree of log roots
>   */
>  static int update_log_root(struct btrfs_trans_handle *trans,
> -                          struct btrfs_root *log)
> +                          struct btrfs_root *log,
> +                          struct btrfs_root_item *root_item)
>  {
>         struct btrfs_fs_info *fs_info =3D log->fs_info;
>         int ret;
> @@ -2916,10 +2917,10 @@ static int update_log_root(struct btrfs_trans_han=
dle *trans,
>         if (log->log_transid =3D=3D 1) {
>                 /* insert root item on the first sync */
>                 ret =3D btrfs_insert_root(trans, fs_info->log_root_tree,
> -                               &log->root_key, &log->root_item);
> +                               &log->root_key, root_item);
>         } else {
>                 ret =3D btrfs_update_root(trans, fs_info->log_root_tree,
> -                               &log->root_key, &log->root_item);
> +                               &log->root_key, root_item);
>         }
>         return ret;
>  }
> @@ -3017,6 +3018,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans=
,
>         struct btrfs_fs_info *fs_info =3D root->fs_info;
>         struct btrfs_root *log =3D root->log_root;
>         struct btrfs_root *log_root_tree =3D fs_info->log_root_tree;
> +       struct btrfs_root_item new_root_item;
>         int log_transid =3D 0;
>         struct btrfs_log_ctx root_log_ctx;
>         struct blk_plug plug;
> @@ -3080,17 +3082,25 @@ int btrfs_sync_log(struct btrfs_trans_handle *tra=
ns,
>                 goto out;
>         }
>
> +       /*
> +        * We _must_ update under the root->log_mutex in order to make su=
re we
> +        * have a consistent view of the log root we are trying to commit=
 at
> +        * this moment.
> +        *
> +        * We _must_ copy this into a local copy, because we are not hold=
ing the
> +        * log_root_tree->log_mutex yet.  This is important because when =
we
> +        * commit the log_root_tree we must have a consistent view of the
> +        * log_root_tree when we update the super block to point at the
> +        * log_root_tree bytenr.  If we update the log_root_tree here we'=
ll race
> +        * with the commit and possibly point at the new block which we m=
ay not
> +        * have written out.
> +        */
>         btrfs_set_root_node(&log->root_item, log->node);
> +       memcpy(&new_root_item, &log->root_item, sizeof(new_root_item));
>
>         root->log_transid++;
>         log->log_transid =3D root->log_transid;
>         root->log_start_pid =3D 0;
> -       /*
> -        * Update or create log root item under the root's log_mutex to p=
revent
> -        * races with concurrent log syncs that can lead to failure to up=
date
> -        * log root item because it was not created yet.
> -        */
> -       ret =3D update_log_root(trans, log);
>         /*
>          * IO has been started, blocks of the log tree have WRITTEN flag =
set
>          * in their headers. new modifications of the log will be written=
 to
> @@ -3111,6 +3121,14 @@ int btrfs_sync_log(struct btrfs_trans_handle *tran=
s,
>         mutex_unlock(&log_root_tree->log_mutex);
>
>         mutex_lock(&log_root_tree->log_mutex);
> +
> +       /*
> +        * Now we are safe to update the log_root_tree because we're unde=
r the
> +        * log_mutex, and we're a current writer so we're holding the com=
mit
> +        * open until we drop the log_mutex.
> +        */
> +       ret =3D update_log_root(trans, log, &new_root_item);
> +
>         if (atomic_dec_and_test(&log_root_tree->log_writers)) {
>                 /* atomic_dec_and_test implies a barrier */
>                 cond_wake_up_nomb(&log_root_tree->log_writer_wait);
> --
> 2.21.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
