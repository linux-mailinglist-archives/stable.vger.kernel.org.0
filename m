Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3828F62817E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiKNNjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiKNNjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:39:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12B620BEE;
        Mon, 14 Nov 2022 05:39:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 903FC611A1;
        Mon, 14 Nov 2022 13:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080DFC433C1;
        Mon, 14 Nov 2022 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668433168;
        bh=cyGUgtr2otkWYH4TggRInQa0UWTOM8gl47QGyy1GPeA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DUcibMCxl++eFiZqJXhMFYb29mqFPqHvNRh58OzPhZiV4YRrQTXmxJgJf+FjFaj2y
         emk6C+Aw2QJR8nnUTvTCN3eoOCs7me8g8itS+fBk0KWrBrqXHPFr1knknFYfopWF/G
         Jx41eMhe3CVg76x1A5B9Bq6lEaKa5MbymSnC9UVT6P/iUGiIMYlGDgrTLWui+aft1c
         wvjSmSmXpAzlf7RODX0YQgcKtB5ucJLauLlJ7twUFEoceaBE/9MhmF4r18349gh2lS
         OJ6UvgJ8FamyRJOFWYoE6aVqJS6XSjIheRrqBMEEaznf5ONVIbymJT71kX3a/Qvj0o
         1pp8kzGh6onkg==
Message-ID: <46a1398be032ee6d06aef7df5e336b6ce2ba8f53.camel@kernel.org>
Subject: Re: [PATCH 2/2 v2] ceph: use a xarray to record all the opened
 files for each inode
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com,
        viro@zeniv.linux.org.uk
Cc:     lhenriques@suse.de, mchangir@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 14 Nov 2022 08:39:26 -0500
In-Reply-To: <20221114051901.15371-3-xiubli@redhat.com>
References: <20221114051901.15371-1-xiubli@redhat.com>
         <20221114051901.15371-3-xiubli@redhat.com>
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
> When releasing the file locks the fl->fl_file memory could be
> already released by another thread in filp_close(), so we couldn't
> depend on fl->fl_file to get the inode. Just use a xarray to record
> the opened files for each inode.
>=20
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/57986
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c  |  9 +++++++++
>  fs/ceph/inode.c |  4 ++++
>  fs/ceph/locks.c | 17 ++++++++++++++++-
>  fs/ceph/super.h |  4 ++++
>  4 files changed, 33 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 85afcbbb5648..cb4a9c52df27 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -231,6 +231,13 @@ static int ceph_init_file_info(struct inode *inode, =
struct file *file,
>  			fi->flags |=3D CEPH_F_SYNC;
> =20
>  		file->private_data =3D fi;
> +
> +		ret =3D xa_insert(&ci->i_opened_files, (unsigned long)file,
> +				CEPH_FILP_AVAILABLE, GFP_KERNEL);
> +		if (ret) {
> +			kmem_cache_free(ceph_file_cachep, fi);
> +			return ret;
> +		}
>  	}
> =20
>  	ceph_get_fmode(ci, fmode, 1);
> @@ -932,6 +939,8 @@ int ceph_release(struct inode *inode, struct file *fi=
le)
>  		dout("release inode %p regular file %p\n", inode, file);
>  		WARN_ON(!list_empty(&fi->rw_contexts));
> =20
> +		xa_erase(&ci->i_opened_files, (unsigned long)file);
> +
>  		ceph_fscache_unuse_cookie(inode, file->f_mode & FMODE_WRITE);
>  		ceph_put_fmode(ci, fi->fmode, 1);
> =20
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 77b0cd9af370..554450838e44 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -619,6 +619,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb=
)
>  	INIT_LIST_HEAD(&ci->i_unsafe_iops);
>  	spin_lock_init(&ci->i_unsafe_lock);
> =20
> +	xa_init(&ci->i_opened_files);
> +
>  	ci->i_snap_realm =3D NULL;
>  	INIT_LIST_HEAD(&ci->i_snap_realm_item);
>  	INIT_LIST_HEAD(&ci->i_snap_flush_item);
> @@ -637,6 +639,8 @@ void ceph_free_inode(struct inode *inode)
>  {
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
> =20
> +	xa_destroy(&ci->i_opened_files);
> +
>  	kfree(ci->i_symlink);
>  #ifdef CONFIG_FS_ENCRYPTION
>  	kfree(ci->fscrypt_auth);
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index d8385dd0076e..a176a30badd0 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -42,9 +42,10 @@ static void ceph_fl_copy_lock(struct file_lock *dst, s=
truct file_lock *src)
> =20
>  static void ceph_fl_release_lock(struct file_lock *fl)
>  {
> -	struct ceph_file_info *fi =3D fl->fl_file->private_data;
>  	struct inode *inode =3D fl->fl_u.ceph_fl.fl_inode;
>  	struct ceph_inode_info *ci;
> +	struct ceph_file_info *fi;
> +	void *val;
> =20
>  	/*
>  	 * If inode is NULL it should be a request file_lock,
> @@ -54,6 +55,20 @@ static void ceph_fl_release_lock(struct file_lock *fl)
>  		return;
> =20
>  	ci =3D ceph_inode(inode);
> +
> +	/*
> +	 * For Posix-style locks, it may race between filp_close()s,
> +	 * and it's possible that the 'file' memory pointed by
> +	 * 'fl->fl_file' has been released. If so just skip it.
> +	 */
> +	rcu_read_lock();
> +	val =3D xa_load(&ci->i_opened_files, (unsigned long)fl->fl_file);
> +	if (val =3D=3D CEPH_FILP_AVAILABLE) {
> +		fi =3D fl->fl_file->private_data;
> +		atomic_dec(&fi->num_locks);

Don't you need to remove the old atomic_dec from this function if you
move it here?

> +	}
> +	rcu_read_unlock();
> +
>  	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>  		/* clear error when all locks are released */
>  		spin_lock(&ci->i_ceph_lock);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 7b75a84ba48d..b3e89192cbec 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -329,6 +329,8 @@ struct ceph_inode_xattrs_info {
>  	u64 version, index_version;
>  };
> =20
> +#define CEPH_FILP_AVAILABLE         xa_mk_value(1)
> +
>  /*
>   * Ceph inode.
>   */
> @@ -434,6 +436,8 @@ struct ceph_inode_info {
>  	struct list_head i_unsafe_iops;   /* uncommitted mds inode ops */
>  	spinlock_t i_unsafe_lock;
> =20
> +	struct xarray		i_opened_files;
> +
>  	union {
>  		struct ceph_snap_realm *i_snap_realm; /* snap realm (if caps) */
>  		struct ceph_snapid_map *i_snapid_map; /* snapid -> dev_t */

This looks like it'll work, but it's a lot of extra work, having to
track this extra xarray just on the off chance that one of these fd's
might have file locks. The num_locks field is only checked in one place
in ceph_get_caps.

Here's what I'd recommend instead:

Have ceph_get_caps look at the lists in inode->i_flctx and see whether
any of its locks have an fl_file that matches the @filp argument in that
function. Most inodes never get any file locks, so in most cases  this
will turn out to just be a NULL pointer check for i_flctx anyway.

Then you can just remove the num_locks field and call the new helper
from ceph_get_caps instead. I'll send along a proposed patch for the
helper in a bit.
--=20
Jeff Layton <jlayton@kernel.org>
