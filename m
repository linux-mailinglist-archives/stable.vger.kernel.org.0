Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7876C64B0B6
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 09:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiLMIDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 03:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiLMIDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 03:03:19 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0EE65A9
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 00:03:15 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id q128so13823502vsa.13
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 00:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c6c3ok7BNGAyoJuELxPUEc8u5M2aciuCbkFM1L7MAUo=;
        b=RCUvNnbJI+91HkoMedlvWgdf30froxuVO2Gykly/fNsH0pVdS3UepBkhX0mbnY8MYX
         T0b9099z1tqP99dZ3QpkaeKr9l8/zLkU87F83P3ZwaKAa/B/jfPPvTKRF8lRgYe003Mw
         XlBDrvmgpUYpa+qsoBc/MhEGCAgqQx9F5z++C1kAtWg0zT2vA/WyYjssaLFQB9c1py8D
         wf8KDKLTHClwfAT2+dlg5rd1eo4RQraGt4MdHZBSrCROgIJPyyn+sHSgxu4pWxDx8VmB
         1uEdas4MCSHgZ5RjCPbpflVCe0GRe32QaUhChmEOXqEQTCfVvkuopzetn2w+gVpUdGAb
         jrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c6c3ok7BNGAyoJuELxPUEc8u5M2aciuCbkFM1L7MAUo=;
        b=3LBFHQIYd95ovCzF3m8xohLM+i2dmKxeWZB+kWYycvfNGoW91AqzK2t/vfQly6QUku
         CWYQ1bSYh38tTimoveLUBAc2gQINzv9ECxOA4bWeT3svpWVYnExjy09eKaUBzYLHPNJm
         VnbtiNZAFHkK4mfJMk4x7uXiqOSkD/gKPVi127e0EUXPTi/+zXreWfriAVrc8ggCJzfb
         X5JU2OdW8d5JPxz+BrizN/xO2jKgyuDgN4vILm8aMObfyqZq/K4zATTsaxz6Wz61UbqU
         biBxww7bGocLyjnwu5Lq0Oj0fld2Vdb0xKw4aj1LNC11qkmukMevNTMegJZH4ecjy4vw
         4roA==
X-Gm-Message-State: ANoB5pkulguGpmUL2dL0oR/ClSN09EG6C6U+fDqsLepX87ML/vph7R0F
        RgcgAcme86xAMpnNZanFe6Uhvw+HLev7M7tIu7Yl7B4sPwU=
X-Google-Smtp-Source: AA0mqf7JaV7ycT+tYmIfe5eJy63r67PARvNBAv1cVKe2gfEqRf2iR/bLt3sYzlWdoZgIA902+I//YJ8Y0lkX4HMBXdg=
X-Received: by 2002:a05:6102:c8c:b0:3b0:9171:95f7 with SMTP id
 f12-20020a0561020c8c00b003b0917195f7mr32639878vst.3.1670918594043; Tue, 13
 Dec 2022 00:03:14 -0800 (PST)
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org> <20221205190809.690922836@linuxfoundation.org>
In-Reply-To: <20221205190809.690922836@linuxfoundation.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 13 Dec 2022 10:03:02 +0200
Message-ID: <CAOQ4uxhmZ4RnG0mGaMivyQjS43cUykyO-oVtCLX4AFyrnTXrVA@mail.gmail.com>
Subject: Re: [PATCH 6.0 044/124] vfs: fix copy_file_range() averts filesystem
 freeze protection
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Namjae Jeon <linkinjeon@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 5, 2022 at 9:24 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> [ Upstream commit 10bc8e4af65946b727728d7479c028742321b60a ]
>
> Commit 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs
> copies") removed fallback to generic_copy_file_range() for cross-fs
> cases inside vfs_copy_file_range().

Hi Greg,

The regressing commit is in v5.15.53.
Please apply this fix to 5.15.y.

I will test and post backports of cross-fs copy_file_range() fixes
to pre 5.15 kernels.
See: https://bugzilla.kernel.org/show_bug.cgi?id=216800

Thanks,
Amir.

>
> To preserve behavior of nfsd and ksmbd server-side-copy, the fallback to
> generic_copy_file_range() was added in nfsd and ksmbd code, but that
> call is missing sb_start_write(), fsnotify hooks and more.
>
> Ideally, nfsd and ksmbd would pass a flag to vfs_copy_file_range() that
> will take care of the fallback, but that code would be subtle and we got
> vfs_copy_file_range() logic wrong too many times already.
>
> Instead, add a flag to explicitly request vfs_copy_file_range() to
> perform only generic_copy_file_range() and let nfsd and ksmbd use this
> flag only in the fallback path.
>
> This choise keeps the logic changes to minimum in the non-nfsd/ksmbd code
> paths to reduce the risk of further regressions.
>
> Fixes: 868f9f2f8e00 ("vfs: fix copy_file_range() regression in cross-fs copies")
> Tested-by: Namjae Jeon <linkinjeon@kernel.org>
> Tested-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ksmbd/vfs.c     |  6 +++---
>  fs/nfsd/vfs.c      |  4 ++--
>  fs/read_write.c    | 19 +++++++++++++++----
>  include/linux/fs.h |  8 ++++++++
>  4 files changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
> index 78d01033604c..c5c801e38b63 100644
> --- a/fs/ksmbd/vfs.c
> +++ b/fs/ksmbd/vfs.c
> @@ -1784,9 +1784,9 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
>                 ret = vfs_copy_file_range(src_fp->filp, src_off,
>                                           dst_fp->filp, dst_off, len, 0);
>                 if (ret == -EOPNOTSUPP || ret == -EXDEV)
> -                       ret = generic_copy_file_range(src_fp->filp, src_off,
> -                                                     dst_fp->filp, dst_off,
> -                                                     len, 0);
> +                       ret = vfs_copy_file_range(src_fp->filp, src_off,
> +                                                 dst_fp->filp, dst_off, len,
> +                                                 COPY_FILE_SPLICE);
>                 if (ret < 0)
>                         return ret;
>
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index f3cd614e1f1e..dc24d67d0ca4 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -572,8 +572,8 @@ ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
>         ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
>
>         if (ret == -EOPNOTSUPP || ret == -EXDEV)
> -               ret = generic_copy_file_range(src, src_pos, dst, dst_pos,
> -                                             count, 0);
> +               ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count,
> +                                         COPY_FILE_SPLICE);
>         return ret;
>  }
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 328ce8cf9a85..24b9668d6377 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1388,6 +1388,8 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
>                                 struct file *file_out, loff_t pos_out,
>                                 size_t len, unsigned int flags)
>  {
> +       lockdep_assert(sb_write_started(file_inode(file_out)->i_sb));
> +
>         return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
>                                 len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
>  }
> @@ -1424,7 +1426,9 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
>          * and several different sets of file_operations, but they all end up
>          * using the same ->copy_file_range() function pointer.
>          */
> -       if (file_out->f_op->copy_file_range) {
> +       if (flags & COPY_FILE_SPLICE) {
> +               /* cross sb splice is allowed */
> +       } else if (file_out->f_op->copy_file_range) {
>                 if (file_in->f_op->copy_file_range !=
>                     file_out->f_op->copy_file_range)
>                         return -EXDEV;
> @@ -1474,8 +1478,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>                             size_t len, unsigned int flags)
>  {
>         ssize_t ret;
> +       bool splice = flags & COPY_FILE_SPLICE;
>
> -       if (flags != 0)
> +       if (flags & ~COPY_FILE_SPLICE)
>                 return -EINVAL;
>
>         ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
> @@ -1501,14 +1506,14 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>          * same sb using clone, but for filesystems where both clone and copy
>          * are supported (e.g. nfs,cifs), we only call the copy method.
>          */
> -       if (file_out->f_op->copy_file_range) {
> +       if (!splice && file_out->f_op->copy_file_range) {
>                 ret = file_out->f_op->copy_file_range(file_in, pos_in,
>                                                       file_out, pos_out,
>                                                       len, flags);
>                 goto done;
>         }
>
> -       if (file_in->f_op->remap_file_range &&
> +       if (!splice && file_in->f_op->remap_file_range &&
>             file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
>                 ret = file_in->f_op->remap_file_range(file_in, pos_in,
>                                 file_out, pos_out,
> @@ -1528,6 +1533,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>          * consistent story about which filesystems support copy_file_range()
>          * and which filesystems do not, that will allow userspace tools to
>          * make consistent desicions w.r.t using copy_file_range().
> +        *
> +        * We also get here if caller (e.g. nfsd) requested COPY_FILE_SPLICE.
>          */
>         ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
>                                       flags);
> @@ -1582,6 +1589,10 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
>                 pos_out = f_out.file->f_pos;
>         }
>
> +       ret = -EINVAL;
> +       if (flags != 0)
> +               goto out;
> +
>         ret = vfs_copy_file_range(f_in.file, pos_in, f_out.file, pos_out, len,
>                                   flags);
>         if (ret > 0) {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7203f5582fd4..be074b6895b9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2087,6 +2087,14 @@ struct dir_context {
>   */
>  #define REMAP_FILE_ADVISORY            (REMAP_FILE_CAN_SHORTEN)
>
> +/*
> + * These flags control the behavior of vfs_copy_file_range().
> + * They are not available to the user via syscall.
> + *
> + * COPY_FILE_SPLICE: call splice direct instead of fs clone/copy ops
> + */
> +#define COPY_FILE_SPLICE               (1 << 0)
> +
>  struct iov_iter;
>  struct io_uring_cmd;
>
> --
> 2.35.1
>
>
>
