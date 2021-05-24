Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F5A38E48B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhEXKuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 06:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhEXKuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 06:50:16 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC80C061574;
        Mon, 24 May 2021 03:48:48 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id h21so20280562qtu.5;
        Mon, 24 May 2021 03:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=l+yuPCcYzjeH7rGjqqAffdPfdpOmTydJVYtjWgZ35uY=;
        b=XedBne4/YiA/RtYMeTuK6773wAuTlp8NQzHAPHkt6WrGB//7ReEz/Uelp3NubD7Gqu
         qYjTc3MtyPGZC+Kv8x6ZY0NYNNhVDRVVFzdoxlgyGKc14mc16bYEDLvDjYb/HwyszLdX
         REkA3ZbE2ME4c7hRwsJNx6RVMWtsw2R3StGWICxu2W6wEqXAP5OpZL5/1cl4nEHSisR8
         TpePEEuuygaBHY8osm1rX7qYKdbE3K8+Q9+vZmh+xfStsVYnnWAcDVIncRqb9VMSR9o+
         V+eFEKDJZ1qD7T7pKkOC4Q732jh+T0feiM7EsY70rgMNDYsKF3C5BcxnJfIOqiIZgawV
         nCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=l+yuPCcYzjeH7rGjqqAffdPfdpOmTydJVYtjWgZ35uY=;
        b=JO+f808+Uo1sfTSe013//HfDfRCL1VEr4rInyzxrojisUMFCsJlTxrtn5jmevvhnbX
         dxEKYidhd9k5VGNEeXEoogSJS+EKXFZZOTMR8TxAGrw6GFi1bpN6A0DS6XrDRcr66Jzf
         Ek0JPkmakESo5g9Ek4sorCsOlmZFr1gyyumgdwkHQEeD28xo3d+ZvKIo/kliF2DhrkYG
         6YZVwmNSzujH3goUFoXVMLFIn5D0JGajhUQJfhS3sSthFsUTdRm64Kq1uzQ5id3UqFd1
         WsiZZl4ZSlp9QojJ7pcLEHzk+EVRYiWwyS22XM0Hc81vyGcblefCjDq6KE5uyp8culhT
         GLNQ==
X-Gm-Message-State: AOAM531SaFuXCLEW18RQ5lEYk+/jcQaF8RMfC2UX7FOI88P/Ecmsxawd
        PqcTKnCFqL5slTmUba8ZIKvlv7uLqNW+gIBYWrA3xLLA
X-Google-Smtp-Source: ABdhPJx+yw5Mq1iULEcB97vUXpNhUymOSOZcgEqRCyBNDiF1DMQ3HBFb5bsScegMNU025TPWj5XXhvsOen/+LDNpIPU=
X-Received: by 2002:ac8:5402:: with SMTP id b2mr6961416qtq.259.1621853327881;
 Mon, 24 May 2021 03:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <58fd56f2942d80bee34108035bd5708a19ac56ed.1621458943.git.josef@toxicpanda.com>
In-Reply-To: <58fd56f2942d80bee34108035bd5708a19ac56ed.1621458943.git.josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 24 May 2021 11:48:37 +0100
Message-ID: <CAL3q7H5O8_KRfRQfxm4ri0yefM0_iN9-sJeJg7EKoSt3K+=cOw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not write supers if we have an fs error
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 10:20 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> Error injection testing uncovered a pretty severe problem where we could
> end up committing a super that pointed to the wrong tree roots,
> resulting in transid mismatch errors.
>
> The way we commit the transaction is we update the super copy with the
> current generations and bytenrs of the important roots, and then copy
> that into our super_for_commit.  Then we allow transactions to continue
> again, we write out the dirty pages for the transaction, and then we
> write the super.  If the write out fails we'll bail and skip writing the
> supers.
>
> However since we've allowed a new transaction to start, we can have a
> log attempting to sync at this point, which would be blocked on
> fs_info->tree_log_mutex.  Once the commit fails we're allowed to do the
> log tree commit, which uses super_for_commit, which now points at fs
> tree's that were not written out.
>
> Fix this by checking BTRFS_FS_STATE_ERROR once we acquire the
> tree_log_mutex.  This way if the transaction commit fails we're sure to
> see this bit set and we can skip writing the super out.  This patch
> fixes this specific transid mismatch error I was seeing with this
> particular error path.
>
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/tree-log.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 0278f489e7d9..83e8f105869b 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3302,6 +3302,22 @@ int btrfs_sync_log(struct btrfs_trans_handle *tran=
s,
>          *    begins and releases it only after writing its superblock.
>          */
>         mutex_lock(&fs_info->tree_log_mutex);
> +
> +       /*
> +        * The transaction writeout phase could have failed, and thus mar=
ked the

To be more clear, it would be better to say "The previous
transaction", as otherwise it will be
confusing when reading the comment.

Other than that, it looks good, great catch.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> +        * fs in an error state.  We must not commit here, as we could ha=
ve
> +        * updated our generation in the super_for_commit and writing the=
 super
> +        * here would result in transid mismatches.  If there is an error=
 here
> +        * just bail.
> +        */
> +       if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
> +               ret =3D -EIO;
> +               btrfs_set_log_full_commit(trans);
> +               btrfs_abort_transaction(trans, ret);
> +               mutex_unlock(&fs_info->tree_log_mutex);
> +               goto out_wake_log_root;
> +       }
> +
>         btrfs_set_super_log_root(fs_info->super_for_commit, log_root_star=
t);
>         btrfs_set_super_log_root_level(fs_info->super_for_commit, log_roo=
t_level);
>         ret =3D write_all_supers(fs_info, 1);
> --
> 2.26.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
