Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D839450618
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 14:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhKON5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 08:57:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhKON5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 08:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636984488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1oW9sD+2AlinVXXOjh9UHbzKRCqNVMJhsj45Nv42XRs=;
        b=Q3SBB7qrFxlx7mQ76Fe6aStVqtwfNiTwGJHZHIjvK1T7CxnfGRReElrcKG0Zc0Z9mQZw+f
        lMj1A84h5p/y7aKNg/TaZmX6xgYaGhMl1U+vETtBJe2WhxmKt7FOXegufyxLXPyaPYJHFO
        0E6jJxQmybJaDqVd/2xsjjt+ZfalKKQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-Off_WssQMKSzbHKg9vj2TA-1; Mon, 15 Nov 2021 08:54:47 -0500
X-MC-Unique: Off_WssQMKSzbHKg9vj2TA-1
Received: by mail-qt1-f197.google.com with SMTP id 4-20020ac85744000000b002b2f329efc2so809239qtx.12
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 05:54:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1oW9sD+2AlinVXXOjh9UHbzKRCqNVMJhsj45Nv42XRs=;
        b=Y/diKQndl2VjWOFfPLfR0vzcjhLopGWVXQEf/mnT3uv+o7LKKBcpLKYW0ZaHMX4wxT
         8ErGLqAc6nhU1xDyOI57WZKa9734uCwhloaVhaQ2WGbzihS6gHPDaBn3gKoSwgewxSy0
         u48wDQtuJ0UjtP8zp1Zl26I2X2t8u9yn8b5k2y8qtc09KLTv4f06Awf998n/2UR7jQ0e
         VlCkk1TrhJq65nIprjxnFnrm4Y4kvaMUT/uvNCAAprPci9lgJpdFcTbqvu89lme0EbsU
         5OIRMT5CPzdWGlmcN5BX4FB7N3sAkbefi+XWHO9XWvDRjYFmCsTy+mAbiWLme/nS2mCp
         nkXg==
X-Gm-Message-State: AOAM530V75+PGBCh6kzdZ1P+0CJ4tEZdy+u+HFmo5oA+1FrSGk96p55D
        bIoNUpMGB+tQAoR/QHspgZz3+ISrN4NFCqrYuQbDQJn3Egd5y1rn8xtuPJhTrq2EVpfmMg/ibL/
        AhAUvp0mzj9+FymlZKClcJA77sxscAfnX
X-Received: by 2002:a05:622a:54d:: with SMTP id m13mr40084055qtx.33.1636984486256;
        Mon, 15 Nov 2021 05:54:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTm8JYuDG6GEhTO5KI4SZG6p+GRfwe8qHsK3jkuxd72OMJUQDzywaCHfaBzK0+pYhBcm1jJnOYdBWlrDtl7dM=
X-Received: by 2002:a05:622a:54d:: with SMTP id m13mr40084027qtx.33.1636984486058;
 Mon, 15 Nov 2021 05:54:46 -0800 (PST)
MIME-Version: 1.0
References: <20210816125444.082226187@linuxfoundation.org> <20210816125447.013365592@linuxfoundation.org>
In-Reply-To: <20210816125447.013365592@linuxfoundation.org>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Mon, 15 Nov 2021 14:54:35 +0100
Message-ID: <CAOssrKe5S4AGUD+TUT2AkeWo-7Cjfbw4vX-d3bPi6xfNOVY-CA@mail.gmail.com>
Subject: Re: [PATCH 5.13 089/151] ovl: fix deadlock in splice write
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        syzbot <syzbot+579885d1a9a833336209@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Looks like upstream commit b91b6b019fd ("ovl: fix deadlock in splice
write") needs to be added to linux-5.4.y.

The reason is that commit 82a763e61e2b ("ovl: simplify file splice")
was backported to v5.4.155, and the above commit fixes this.

Applies cleanly and I reviewed that the backport is correct.

Thanks,
Miklos

On Mon, Aug 16, 2021 at 3:13 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Miklos Szeredi <mszeredi@redhat.com>
>
> [ Upstream commit 9b91b6b019fda817eb52f728eb9c79b3579760bc ]
>
> There's possibility of an ABBA deadlock in case of a splice write to an
> overlayfs file and a concurrent splice write to a corresponding real file.
>
> The call chain for splice to an overlay file:
>
>  -> do_splice                     [takes sb_writers on overlay file]
>    -> do_splice_from
>      -> iter_file_splice_write    [takes pipe->mutex]
>        -> vfs_iter_write
>          ...
>          -> ovl_write_iter        [takes sb_writers on real file]
>
> And the call chain for splice to a real file:
>
>  -> do_splice                     [takes sb_writers on real file]
>    -> do_splice_from
>      -> iter_file_splice_write    [takes pipe->mutex]
>
> Syzbot successfully bisected this to commit 82a763e61e2b ("ovl: simplify
> file splice").
>
> Fix by reverting the write part of the above commit and by adding missing
> bits from ovl_write_iter() into ovl_splice_write().
>
> Fixes: 82a763e61e2b ("ovl: simplify file splice")
> Reported-and-tested-by: syzbot+579885d1a9a833336209@syzkaller.appspotmail.com
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/overlayfs/file.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 46 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 4d53d3b7e5fe..d081faa55e83 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -392,6 +392,51 @@ out_unlock:
>         return ret;
>  }
>
> +/*
> + * Calling iter_file_splice_write() directly from overlay's f_op may deadlock
> + * due to lock order inversion between pipe->mutex in iter_file_splice_write()
> + * and file_start_write(real.file) in ovl_write_iter().
> + *
> + * So do everything ovl_write_iter() does and call iter_file_splice_write() on
> + * the real file.
> + */
> +static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
> +                               loff_t *ppos, size_t len, unsigned int flags)
> +{
> +       struct fd real;
> +       const struct cred *old_cred;
> +       struct inode *inode = file_inode(out);
> +       struct inode *realinode = ovl_inode_real(inode);
> +       ssize_t ret;
> +
> +       inode_lock(inode);
> +       /* Update mode */
> +       ovl_copyattr(realinode, inode);
> +       ret = file_remove_privs(out);
> +       if (ret)
> +               goto out_unlock;
> +
> +       ret = ovl_real_fdget(out, &real);
> +       if (ret)
> +               goto out_unlock;
> +
> +       old_cred = ovl_override_creds(inode->i_sb);
> +       file_start_write(real.file);
> +
> +       ret = iter_file_splice_write(pipe, real.file, ppos, len, flags);
> +
> +       file_end_write(real.file);
> +       /* Update size */
> +       ovl_copyattr(realinode, inode);
> +       revert_creds(old_cred);
> +       fdput(real);
> +
> +out_unlock:
> +       inode_unlock(inode);
> +
> +       return ret;
> +}
> +
>  static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  {
>         struct fd real;
> @@ -603,7 +648,7 @@ const struct file_operations ovl_file_operations = {
>         .fadvise        = ovl_fadvise,
>         .flush          = ovl_flush,
>         .splice_read    = generic_file_splice_read,
> -       .splice_write   = iter_file_splice_write,
> +       .splice_write   = ovl_splice_write,
>
>         .copy_file_range        = ovl_copy_file_range,
>         .remap_file_range       = ovl_remap_file_range,
> --
> 2.30.2
>
>
>

