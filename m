Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14AB3AF660
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 21:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFUTrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 15:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhFUTrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 15:47:32 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512D0C061574;
        Mon, 21 Jun 2021 12:45:17 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id d9so8359260ioo.2;
        Mon, 21 Jun 2021 12:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Y3SdFOpgn9f8xPbU/XLhVyXHKAyTiYOJXfuPpl5RTc=;
        b=fH1wX9zm2TTi16haf37MG4vd/AJJEP0PXDug7EU8K7lHpQvLpHCYuFusBH8rTiAXcw
         ic8Uw5SoD03r6eQ/HsbXgwckC81IcDA9zM0uJkz6Lax9eLrDVjnny4R/NuzUmsYacM4K
         ggsr0KRQ0duCJI+e1LnNBAbu/iJyt6UUcBfN++ecTTtyJur5BRXE+Hc4R6RAaVi6gmwq
         j1vpvuLk86DbGCriAcJcQ4pDhM4VvfHJN6vGKmJypNcWSQFGk+IE3Sx/9YyxIhFUEdMH
         LpxxRdZMx/oHyxk7VwcEPbl4U3ZGQ6WOSFyR35xwfG5nov/iqk7DRl09wCxRXJobfzcT
         5oQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Y3SdFOpgn9f8xPbU/XLhVyXHKAyTiYOJXfuPpl5RTc=;
        b=D3iHiydTWwkgnFo/IIBpr7FvfSAqDFozCkC5uM17pAP+cXOYI5XjJEDCsjlbHQ+8qp
         OfzVNJkn3AtpGs4Jpx/iKoilD2pFMcjqFmTFto1QEerCNWfW08B9marKh9LlvHpYVp5/
         iA64umrkGhU2wK84OifptgfOevqi/sJWIcquE2SHj/2/mCTGNsLFqr1tFeG+4z2Z0TPF
         MMILxPCQASjsnDmmZ4A74j2las0ssSpu91VrUYDoHsNV4EBi2gUd17tZkpLjOjxcsZcf
         iE5Fayfg5RFhjb93uF4BpBXJ0XUxeQFw2nTnpYujL0TlyzTnjJQqEOlDQXMDd3NbReXp
         wXEg==
X-Gm-Message-State: AOAM530f9hUZo8o5JzfIVIpaQGCvCbGkxYpb/BRyhe2i7k3GSo2qHQnk
        TwUA94HEPmPRkz/YH8vzXxoIAJzdQP7RTjTUtq1aPmPHKh7SgQ==
X-Google-Smtp-Source: ABdhPJwu0/rQQNg9mM8KhcNzAfkTcNE2pj8AyHJ0WJMiGfdM9WWkCchxyDAoKcWQ3GY7ioDshL6q1CEuuUiaiAYbg7o=
X-Received: by 2002:a6b:f704:: with SMTP id k4mr21572629iog.191.1624304716841;
 Mon, 21 Jun 2021 12:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210603165231.110559-1-jlayton@kernel.org> <20210603165231.110559-4-jlayton@kernel.org>
In-Reply-To: <20210603165231.110559-4-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 21 Jun 2021 21:45:04 +0200
Message-ID: <CAOi1vP9pYJcN8Ecq-5fm=jaFiWaCD0DOmJV9a9CYRnHPBigjXg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ceph: must hold snap_rwsem when filling inode for
 async create
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 3, 2021 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> ...and add a lockdep assertion for it to ceph_fill_inode().
>
> Cc: stable@vger.kernel.org # v5.7+
> Fixes: 9a8d03ca2e2c3 ("ceph: attempt to do async create when possible")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c  | 3 +++
>  fs/ceph/inode.c | 2 ++
>  2 files changed, 5 insertions(+)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index a01ad342a91d..d3874c2df4b1 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -578,6 +578,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>         struct ceph_inode_info *ci = ceph_inode(dir);
>         struct inode *inode;
>         struct timespec64 now;
> +       struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>         struct ceph_vino vino = { .ino = req->r_deleg_ino,
>                                   .snap = CEPH_NOSNAP };
>
> @@ -615,8 +616,10 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>
>         ceph_file_layout_to_legacy(lo, &in.layout);
>
> +       down_read(&mdsc->snap_rwsem);
>         ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
>                               req->r_fmode, NULL);
> +       up_read(&mdsc->snap_rwsem);
>         if (ret) {
>                 dout("%s failed to fill inode: %d\n", __func__, ret);
>                 ceph_dir_clear_complete(dir);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e1c63adb196d..df0c8a724609 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -777,6 +777,8 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>         umode_t mode = le32_to_cpu(info->mode);
>         dev_t rdev = le32_to_cpu(info->rdev);
>
> +       lockdep_assert_held(&mdsc->snap_rwsem);
> +
>         dout("%s %p ino %llx.%llx v %llu had %llu\n", __func__,
>              inode, ceph_vinop(inode), le64_to_cpu(info->version),
>              ci->i_version);
> --
> 2.31.1
>

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
