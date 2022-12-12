Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF7064A65A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 18:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbiLLR5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 12:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiLLR5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 12:57:08 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718206415;
        Mon, 12 Dec 2022 09:57:06 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qk9so30140539ejc.3;
        Mon, 12 Dec 2022 09:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GeX6QG8bAXPsmOO88LgQ/PI9pedX5OeuJ8nmc7sUT7s=;
        b=ZWV48V7VzwltAnTDMELXcIUUWNDwAEj7eSzSn5ULUETh9htM3YAdqSI1+dyr7qz7xJ
         Hpdyc/vCtA90XgEDgUqGCOM/lxBr0lpYDavWp+5EzdbJF2MeoVJWNH5160vsdbSteX4/
         /G3fACqTZ/fCOIr22dE19idCSlJw+V1b+i1n9C4bdSsUMrUtMR/01fL4NUUZc84fQ2ZB
         HiY0HbkzlexVbzfxDIOf98pe3KNWJxBQxvr/xmGkuoui0pmVXJKFiilGcRbhvK7YfNDF
         UojTc0nTXfBmOV0EG8K2OuJZDqhRwhGG1gf576/r/XMsh+dryiOJcKEX0pEvHixJccqF
         WaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GeX6QG8bAXPsmOO88LgQ/PI9pedX5OeuJ8nmc7sUT7s=;
        b=4cTmLgeN4Ls4oUv8fyHGA24KiB0KjISYYciarkZv4DG08UAsyKzgDjMZxH7pRK0Nhz
         imwJPjCmDOlBMfuJbZnXGkw4wklMP0xYKmeSmeLshaLMS8M3S7sBcWgYxWgEMcHRdFnn
         L947IBZ1uCBlW23R1ytGNJ4etL2eLvMZLnjcHMpLFJY9H9VkT1XOR4p97m0Ruo5x/mgk
         u1hrM2pJXDy+mMkfopVL2gU+BVXE3crEm99ldFVHINw6Kcq9AEmZdYsRcyRjS9viDjJP
         j1cxmHhr33ttYAZ+3+c1m6LYgNdcaR/RzkVCZent3FL8wqzGwA6o0ju3xIRgQNJ5eKbl
         3ueQ==
X-Gm-Message-State: ANoB5pkSm+S86EYOtgVHXiIk9MzpTd8wPCmExF3yKBkoqOVKtJUin2xh
        k0gB5sjwQ8NVcts8lUtpOefIPGB8TlcuUdCT4HY=
X-Google-Smtp-Source: AA0mqf5I3w7S7w2Vr/1wAWhzOoI3K1rjiBf0HCbWIXNS/Mktpf+a+5iGQ1I3i4fA/3XYNAlsijvWxFibMeCjGfpK6IE=
X-Received: by 2002:a17:906:28db:b0:7c1:4a75:a3a7 with SMTP id
 p27-20020a17090628db00b007c14a75a3a7mr850236ejd.171.1670867824936; Mon, 12
 Dec 2022 09:57:04 -0800 (PST)
MIME-Version: 1.0
References: <20221118020642.472484-1-xiubli@redhat.com> <20221118020642.472484-3-xiubli@redhat.com>
In-Reply-To: <20221118020642.472484-3-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 12 Dec 2022 18:56:52 +0100
Message-ID: <CAOi1vP-dhH-Z9_dgGLLkqwoZ5di1Bp4o+5zeJRgRHddU=X1AwQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v3] ceph: add ceph_lock_info support for file_lock
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, lhenriques@suse.de,
        mchangir@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
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

On Fri, Nov 18, 2022 at 3:07 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When ceph releasing the file_lock it will try to get the inode pointer
> from the fl->fl_file, which the memory could already be released by
> another thread in filp_close(). Because in VFS layer the fl->fl_file
> doesn't increase the file's reference counter.
>
> Will switch to use ceph dedicate lock info to track the inode.
>
> And in ceph_fl_release_lock() we should skip all the operations if
> the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
> the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
> inserting it to the inode lock list, which is when copying the lock.
>
> Cc: stable@vger.kernel.org
> Cc: Jeff Layton <jlayton@kernel.org>
> URL: https://tracker.ceph.com/issues/57986
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/locks.c                 | 20 ++++++++++++++++++--
>  include/linux/ceph/ceph_fs_fl.h | 17 +++++++++++++++++
>  include/linux/fs.h              |  2 ++
>  3 files changed, 37 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/ceph/ceph_fs_fl.h
>
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index b191426bf880..621f38f10a88 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -34,18 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
>  {
>         struct inode *inode = file_inode(dst->fl_file);
>         atomic_inc(&ceph_inode(inode)->i_filelock_ref);
> +       dst->fl_u.ceph_fl.fl_inode = igrab(inode);
>  }
>
> +/*
> + * Do not use the 'fl->fl_file' in release function, which
> + * is possibly already released by another thread.
> + */
>  static void ceph_fl_release_lock(struct file_lock *fl)
>  {
> -       struct inode *inode = file_inode(fl->fl_file);
> -       struct ceph_inode_info *ci = ceph_inode(inode);
> +       struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
> +       struct ceph_inode_info *ci;
> +
> +       /*
> +        * If inode is NULL it should be a request file_lock,
> +        * nothing we can do.
> +        */
> +       if (!inode)
> +               return;
> +
> +       ci = ceph_inode(inode);
>         if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>                 /* clear error when all locks are released */
>                 spin_lock(&ci->i_ceph_lock);
>                 ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
>                 spin_unlock(&ci->i_ceph_lock);
>         }
> +       fl->fl_u.ceph_fl.fl_inode = NULL;
> +       iput(inode);
>  }
>
>  static const struct file_lock_operations ceph_fl_lock_ops = {
> diff --git a/include/linux/ceph/ceph_fs_fl.h b/include/linux/ceph/ceph_fs_fl.h
> new file mode 100644
> index 000000000000..ad1cf96329f9
> --- /dev/null
> +++ b/include/linux/ceph/ceph_fs_fl.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ceph_fs_fl.h - Ceph lock info
> + *
> + * LGPL2
> + */
> +
> +#ifndef CEPH_FS_FL_H
> +#define CEPH_FS_FL_H
> +
> +#include <linux/fs.h>
> +
> +struct ceph_lock_info {
> +       struct inode *fl_inode;
> +};
> +
> +#endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d6cb42b7e91c..2b03d5e375d7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1066,6 +1066,7 @@ bool opens_in_grace(struct net *);
>
>  /* that will die - we need it for nfs_lock_info */
>  #include <linux/nfs_fs_i.h>
> +#include <linux/ceph/ceph_fs_fl.h>
>
>  /*
>   * struct file_lock represents a generic "file lock". It's used to represent
> @@ -1119,6 +1120,7 @@ struct file_lock {
>                         int state;              /* state of grant or error if -ve */
>                         unsigned int    debug_id;
>                 } afs;
> +               struct ceph_lock_info   ceph_fl;

Hi Xiubo and Jeff,

Xiubo, instead of defining struct ceph_lock_info and including
a CephFS-specific header file in linux/fs.h, I think we should repeat
what was done for AFS -- particularly given that ceph_lock_info ends up
being a dummy type that isn't mentioned anywhere else.

Jeff, could you please ack this with your file locking hat on?

Thanks,

                Ilya
