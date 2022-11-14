Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924B5627C3A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiKNL0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbiKNL0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:26:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C8B1E3E1;
        Mon, 14 Nov 2022 03:24:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 593D6B80DF0;
        Mon, 14 Nov 2022 11:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17188C433D6;
        Mon, 14 Nov 2022 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668425048;
        bh=imtASeSIL+qML9y+rHVuvEdDIZi3PFoP8mhyneQinXQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r78oTwZiRJELGqVpcM+yfzOHg4AmLvE4OhdAqZQAUF+4D9H8WfO+aEhp7Tkwg5VvV
         izEB+qPe6Vuu9Orplj8MR2MlQf2sh3nuO0kwTvKI5jpnnd3Fd8Z1ZiUUDTp8O+FSIS
         8EIhqpMfYkIW4nu9zai8p0SbG8AsuiBGFe3kzXHhfQyD2TnnXTJQjXO05ZKBaTcR6j
         mGXkzvcAmTxkM3HWoY0LQiGHO1edbHcmhJBbXh7YroUqzePzeNobV8KgF4Xda3icz/
         3YliZrUMLmR7G/Blb7oLhs7Rcu8Diba0mXFxNdXd25PVgkggfrF3q7FeD1XldOgVfq
         rekdxE8LuQwvg==
Message-ID: <f2d6f7a3fa75710a1170a8969d948e85d056c272.camel@kernel.org>
Subject: Re: [PATCH 1/2 v2] ceph: add ceph_lock_info support for file_lock
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com,
        viro@zeniv.linux.org.uk
Cc:     lhenriques@suse.de, mchangir@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 14 Nov 2022 06:24:05 -0500
In-Reply-To: <20221114051901.15371-2-xiubli@redhat.com>
References: <20221114051901.15371-1-xiubli@redhat.com>
         <20221114051901.15371-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-11-14 at 13:19 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> When ceph releasing the file_lock it will try to get the inode pointer
> from the fl->fl_file, which the memory could already be released by
> another thread in filp_close(). Because in VFS layer the fl->fl_file
> doesn't increase the file's reference counter.
>=20
> Will switch to use ceph dedicate lock info to track the inode.
>=20
> And in ceph_fl_release_lock() we should skip all the operations if
> the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
> the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
> inserting it to the inode lock list, which is when copying the lock.
>=20
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57986
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/locks.c                 | 18 +++++++++++++++---
>  include/linux/ceph/ceph_fs_fl.h | 26 ++++++++++++++++++++++++++
>  include/linux/fs.h              |  2 ++
>  3 files changed, 43 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/ceph/ceph_fs_fl.h
>=20
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 3e2843e86e27..d8385dd0076e 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -34,22 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, =
struct file_lock *src)
>  {
>  	struct ceph_file_info *fi =3D dst->fl_file->private_data;
>  	struct inode *inode =3D file_inode(dst->fl_file);
> +
>  	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
>  	atomic_inc(&fi->num_locks);
> +	dst->fl_u.ceph_fl.fl_inode =3D igrab(inode);
>  }
> =20
>  static void ceph_fl_release_lock(struct file_lock *fl)
>  {
>  	struct ceph_file_info *fi =3D fl->fl_file->private_data;
> -	struct inode *inode =3D file_inode(fl->fl_file);
> -	struct ceph_inode_info *ci =3D ceph_inode(inode);
> -	atomic_dec(&fi->num_locks);
> +	struct inode *inode =3D fl->fl_u.ceph_fl.fl_inode;
> +	struct ceph_inode_info *ci;
> +
> +	/*
> +	 * If inode is NULL it should be a request file_lock,
> +	 * nothing we can do.
> +	 */
> +	if (!inode)
> +		return;
> +
> +	ci =3D ceph_inode(inode);
>  	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>  		/* clear error when all locks are released */
>  		spin_lock(&ci->i_ceph_lock);
>  		ci->i_ceph_flags &=3D ~CEPH_I_ERROR_FILELOCK;
>  		spin_unlock(&ci->i_ceph_lock);
>  	}
> +	iput(inode);
> +	atomic_dec(&fi->num_locks);

It doesn't look like this fixes the original issue. "fi" may be pointing
to freed memory at this point, right? I think you may need to get rid of
the "num_locks" field in ceph_file_info, and do that in a different way?

>  }
> =20
>  static const struct file_lock_operations ceph_fl_lock_ops =3D {
> diff --git a/include/linux/ceph/ceph_fs_fl.h b/include/linux/ceph/ceph_fs=
_fl.h
> new file mode 100644
> index 000000000000..02a412b26095
> --- /dev/null
> +++ b/include/linux/ceph/ceph_fs_fl.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ceph_fs.h - Ceph constants and data types to share between kernel and
> + * user space.
> + *
> + * Most types in this file are defined as little-endian, and are
> + * primarily intended to describe data structures that pass over the
> + * wire or that are stored on disk.
> + *
> + * LGPL2
> + */
> +
> +#ifndef CEPH_FS_FL_H
> +#define CEPH_FS_FL_H
> +
> +#include <linux/fs.h>
> +
> +/*
> + * Ceph lock info
> + */
> +
> +struct ceph_lock_info {
> +	struct inode *fl_inode;
> +};
> +
> +#endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e654435f1651..db4810d19e26 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1066,6 +1066,7 @@ bool opens_in_grace(struct net *);
> =20
>  /* that will die - we need it for nfs_lock_info */
>  #include <linux/nfs_fs_i.h>
> +#include <linux/ceph/ceph_fs_fl.h>
> =20
>  /*
>   * struct file_lock represents a generic "file lock". It's used to repre=
sent
> @@ -1119,6 +1120,7 @@ struct file_lock {
>  			int state;		/* state of grant or error if -ve */
>  			unsigned int	debug_id;
>  		} afs;
> +		struct ceph_lock_info	ceph_fl;
>  	} fl_u;
>  } __randomize_layout;
> =20

--=20
Jeff Layton <jlayton@kernel.org>
