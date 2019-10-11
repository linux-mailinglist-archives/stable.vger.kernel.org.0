Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA00D4427
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 17:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfJKP2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 11:28:40 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:36734 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfJKP2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 11:28:40 -0400
Received: by mail-ua1-f68.google.com with SMTP id r25so3168729uam.3;
        Fri, 11 Oct 2019 08:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=gG7it/crfOrZwO0WugIYeE+Eee8dCmrmWscLif2IMEM=;
        b=PxM3J757a7zoQaxLjfs6l8xTZ7vx40lFsNCG5xyoVnedAOnlT6GeAp3l0n5Bf7o6we
         m757XFh6KeXan67Fh6uqrtqs8alxAecKi8Wx+8GqsKf2+TKaBsm3JcJJ8JulLTI57JnN
         gjh0/8yiZ7uSsFidn1sTLndX4bDP4m2LMZEYfem/HX8qxw9qoNz7iIsvN6+Gjr6haCI/
         3uWBnzQqyH+XpnaBpezajuurhgRi+vpaVsdaKSMFyagZKkx4n+BQCMDHKpr2PH1C59jY
         BeYwe6FDASHIrDmlYyv8jHRKxdoqIfJFLU4r+8+j0P0lB+x+y+lSKqEVFlF60xCSalr+
         eFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=gG7it/crfOrZwO0WugIYeE+Eee8dCmrmWscLif2IMEM=;
        b=rbnyrOdKby78t1gmcS7GrV/VJnWThX27Pxeg7+mVBNVKolKahUALy2/PA+T5Ke59Ub
         1ZSJHB99tz0XSTysvuUOyyN9Or86zxIcbvIraPXgu8zzhpAluZfo14qzlIFzsT1B5Tc0
         jm3nNDqBGcoJt+y5MNxo4pbuQRVwrx53/ZUWJgcmyzyUjjIcpZTUmKL+yzV7xAj1YWGh
         yeYUQRcGEhPjeBgi4EmPmLvalCBbKfIWnmq6Ui+9ajGdWFGnJF9bjpU0e/jr6CfXKUuZ
         GnrAl9lFJwjodPGI2pj1wEIj4a/7Tm7J5i+30gBisaAoGuTc3mpG8+UQezHAOyQK97q8
         vN3Q==
X-Gm-Message-State: APjAAAWgkd1p9n4xpG8DaDhrT+rqWsS5bzmc9ygxiT5g7N9JI/wtylv0
        iFWvoJ6uCYXnPeEj62S5mzbz+Ln+5/LYTaJVwOU=
X-Google-Smtp-Source: APXvYqxkzD5RGTz3+egXK16gooND+KNXUG7no83KEAhQpmSD5eXFOnujLhfjXYsLmXx47+ydtbIi3XE3jZFXHFB4Afg=
X-Received: by 2002:ab0:59ed:: with SMTP id k42mr4195049uad.27.1570807719427;
 Fri, 11 Oct 2019 08:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191011130354.8232-1-josef@toxicpanda.com>
In-Reply-To: <20191011130354.8232-1-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 11 Oct 2019 16:28:28 +0100
Message-ID: <CAL3q7H79yipNYZgO2Es-Zn0mBKbWoH07Zdv4P473C5NQv9fEqA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: save i_size in compress_file_range
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 2:05 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> We hit a regression while rolling out 5.2 internally where we were
> hitting the following panic
>
> kernel BUG at mm/page-writeback.c:2659!
> RIP: 0010:clear_page_dirty_for_io+0xe6/0x1f0
> Call Trace:
>  __process_pages_contig+0x25a/0x350
>  ? extent_clear_unlock_delalloc+0x43/0x70
>  submit_compressed_extents+0x359/0x4d0
>  normal_work_helper+0x15a/0x330
>  process_one_work+0x1f5/0x3f0
>  worker_thread+0x2d/0x3d0
>  ? rescuer_thread+0x340/0x340
>  kthread+0x111/0x130
>  ? kthread_create_on_node+0x60/0x60
>  ret_from_fork+0x1f/0x30
>
> this is happening because the page is not locked when doing
> clear_page_dirty_for_io.  Looking at the core dump it was because our
> async_extent had a ram_size of 24576 but our async_chunk range only
> spanned 20480, so we had a whole extra page in our ram_size for our
> async_extent.
>
> This happened because we try not to compress pages outside of our
> i_size, however a cleanup patch changed us to do
>
> actual_end =3D min_t(u64, i_size_read(inode), end + 1);
>
> which is problematic because i_size_read() can evaluate to different
> values in between checking and assigning.  So either a expanding
> truncate or a fallocate could increase our i_size while we're doing

Well, not just those operations but a write starting at or beyond eof
could also do it,
since at writeback time we don't hold the inode's lock and the
buffered write path doesn't lock the range if it starts at or past
current i_size.

> writeout and actual_end would end up being past the range we have
> locked.
>
> I confirmed this was what was happening by installing a debug kernel
> that had
>
> actual_end =3D min_t(u64, i_size_read(inode), end + 1);
> if (actual_end > end + 1) {
>         printk(KERN_ERR "WE GOT FUCKED\n");

I think we coud be more polite on changelogs and mailing lists, or we
could add a tag in the subjects warning about improper content like
video games and music records :)

>         actual_end =3D end + 1;
> }
>
> and installing it onto 500 boxes of the tier that had been seeing the
> problem regularly.  Last night I got my debug message and no panic,
> confirming what I expected.
>
> Fixes: 62b37622718c ("btrfs: Remove isize local variable in compress_file=
_range")
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Anyway, looks good to me.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/inode.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2eb1d7249f83..9a483d1f61f8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -474,6 +474,7 @@ static noinline int compress_file_range(struct async_=
chunk *async_chunk)
>         u64 start =3D async_chunk->start;
>         u64 end =3D async_chunk->end;
>         u64 actual_end;
> +       loff_t i_size =3D i_size_read(inode);
>         int ret =3D 0;
>         struct page **pages =3D NULL;
>         unsigned long nr_pages;
> @@ -488,7 +489,13 @@ static noinline int compress_file_range(struct async=
_chunk *async_chunk)
>         inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
>                         SZ_16K);
>
> -       actual_end =3D min_t(u64, i_size_read(inode), end + 1);
> +       /*
> +        * We need to save i_size before now because it could change in b=
etween
> +        * us evaluating the size and assigning it.  This is because we l=
ock and
> +        * unlock the page in truncate and fallocate, and then modify the=
 i_size
> +        * later on.
> +        */
> +       actual_end =3D min_t(u64, i_size, end + 1);
>  again:
>         will_compress =3D 0;
>         nr_pages =3D (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
> --
> 2.21.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
