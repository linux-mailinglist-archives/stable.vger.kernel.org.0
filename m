Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D183BEC2
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 23:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389799AbfFJVgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 17:36:41 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35183 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389193AbfFJVgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 17:36:40 -0400
Received: by mail-lf1-f67.google.com with SMTP id a25so7721964lfg.2;
        Mon, 10 Jun 2019 14:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Rej20kkjw1s6/NuDHFu1LSDaaDgc1B6na4Qh5mIGHs=;
        b=L6Eh5bpPWDqJrRce6jr/YH8nhvi/ovn0+AYXzz5QTitpTydy6iYBFM2uCaoCPxy8MR
         7BMOYGbzvodQO+yyCeR65DhQivdRkCq4Jp+aiq+GGsHi+fATvmwgir/fm4SN7MY8wkfS
         NfRDuIBdcD7GJncvmlEpCD3hOX6MW4FMVLOXx/ZeARuAYNRCY1K6jMlAMxOsbYZ0adNG
         UvEShVw09af4P+j1qFD0AGR1rJ5Et8WdYoFA2VlUGjr87WcZCFoR4uVdf/WchsljKjTW
         pbVqpVamEJz+CMEee//5x14YRccws585QDEd/+vowv0UD6/v4QCqALx5NbQpmULiJCEO
         R5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Rej20kkjw1s6/NuDHFu1LSDaaDgc1B6na4Qh5mIGHs=;
        b=byDCRiFsxKPemnGuYIRzdNqOxDxNR2QuKGpBtNfINA6Dy10FRsoasmStZTu6S4PuEP
         8l+UMn0DuiZSF79Hg+qa/y275hb8ORwbMWke2NtBv2uBfZ7dgqj1fWpCFbyRFiS3f/fU
         zMvbcUmumPA1dGRIVnNfXCjoAzC5Wncwggqq5X4hjwab4YVVUOV0eRNXvereimCscvTT
         GFbi9J0jsZzs3nV3jyTBermc+EJ7gq51U2lx3JPgfOzstv549YHVOrmbgZH6udV5Wv65
         BA7xL/53VU2ICzYJDu4N3M3oMUCPJHY33LG2EvB8MmPHBzDJzofKT79mBSRxM0V68T6k
         BEyQ==
X-Gm-Message-State: APjAAAWO7ualVPqNLP8Cef3K65EQDXaXOaMkXE198rfJccArJKW7XE5R
        mNTFAtdBk+W+8c0G1KFVHMXKgrXguSce4qLpog==
X-Google-Smtp-Source: APXvYqz54F65u6CC5duv+2R12GYljJD63jzmRJrt6QlWfV7LDv+uhHtjZ4Gevb5DD6itm52SgZ2gCAFTbh1GzNV1ZEA=
X-Received: by 2002:a05:6512:1d2:: with SMTP id f18mr35036178lfp.173.1560202598429;
 Mon, 10 Jun 2019 14:36:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190605003838.13101-1-lsahlber@redhat.com>
In-Reply-To: <20190605003838.13101-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 10 Jun 2019 14:36:27 -0700
Message-ID: <CAKywueRYC2dm83zWCgrOVJc7J5s+UdMh-5NnF0sUOJ69NQ3qvQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: add spinlock for the openFileList to cifsInodeInfo
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=D0=B2=D1=82, 4 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 17:42, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> We can not depend on the tcon->open_file_lock here since in multiuser mod=
e
> we may have the same file/inode open via multiple different tcons.
>
> The current code is race prone and will crash if one user deletes a file
> at the same time a different user opens/create the file.
>
> To avoid this we need to have a spinlock attached to the inode and not th=
e tcon.
>
> RHBZ:  1580165
>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c   | 1 +
>  fs/cifs/cifsglob.h | 1 +
>  fs/cifs/file.c     | 8 ++++++--
>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f5fcd6360056..65d9771e49f9 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -303,6 +303,7 @@ cifs_alloc_inode(struct super_block *sb)
>         cifs_inode->uniqueid =3D 0;
>         cifs_inode->createtime =3D 0;
>         cifs_inode->epoch =3D 0;
> +       spin_lock_init(&cifs_inode->open_file_lock);
>         generate_random_uuid(cifs_inode->lease_key);
>
>         /*
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 334ff5f9c3f3..733ddd5fd480 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1377,6 +1377,7 @@ struct cifsInodeInfo {
>         struct rw_semaphore lock_sem;   /* protect the fields above */
>         /* BB add in lists for dirty pages i.e. write caching info for op=
lock */
>         struct list_head openFileList;
> +       spinlock_t      open_file_lock; /* protects openFileList */
>         __u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, sys=
tem */
>         unsigned int oplock;            /* oplock/lease level we have */
>         unsigned int epoch;             /* used to track lease state chan=
ges */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 06e27ac6d82c..97090693d182 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file=
 *file,
>         atomic_inc(&tcon->num_local_opens);
>
>         /* if readable file instance put first in list*/
> +       spin_lock(&cinode->open_file_lock);
>         if (file->f_mode & FMODE_READ)
>                 list_add(&cfile->flist, &cinode->openFileList);
>         else
>                 list_add_tail(&cfile->flist, &cinode->openFileList);
> +       spin_unlock(&cinode->open_file_lock);
>         spin_unlock(&tcon->open_file_lock);
>
>         if (fid->purge_cache)
> @@ -413,7 +415,9 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file=
, bool wait_oplock_handler)
>         cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
>
>         /* remove it from the lists */
> +       spin_lock(&cifsi->open_file_lock);
>         list_del(&cifs_file->flist);
> +       spin_unlock(&cifsi->open_file_lock);
>         list_del(&cifs_file->tlist);
>         atomic_dec(&tcon->num_local_opens);
>
> @@ -1950,9 +1954,9 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_i=
node, bool fsuid_only,
>                         return 0;
>                 }
>
> -               spin_lock(&tcon->open_file_lock);
> +               spin_lock(&cifs_inode->open_file_lock);
>                 list_move_tail(&inv_file->flist, &cifs_inode->openFileLis=
t);
> -               spin_unlock(&tcon->open_file_lock);
> +               spin_unlock(&cifs_inode->open_file_lock);
>                 cifsFileInfo_put(inv_file);
>                 ++refind;
>                 inv_file =3D NULL;
> --
> 2.13.6
>

Thanks for the patch. Looks good to me.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

I would only add a comment telling what an order of the locks should
be: cifs_tcon.open_file_lock and then cifsInodeInfo.open_file_lock.

--
Best regards,
Pavel Shilovsky
