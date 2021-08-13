Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1813EB3FE
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbhHMK1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:27:02 -0400
Received: from mout.gmx.net ([212.227.17.20]:47527 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239176AbhHMK1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 06:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1628850388;
        bh=ywTVctPNctTpKzUZHsaHFh4mJPSI9BtSDjqRJvpHWV4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=kvMlhsIUS9wIdOA36rJMXIVxttDP/5VGnijK8fh6WoiRrLCUkQDetx/UKdyD86gHA
         HSII6GEdfm6brO0oBct4ePlQ8uB3pFYt/F2oSy1DeK9Bz3zyDcePOR5Juc7eWN9WU+
         RvvRlMFPWmSX2oOTTY87jeFXDMRaGV3w+tyrIHFc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MkYbu-1mxCof0qis-00m2cS; Fri, 13
 Aug 2021 12:26:27 +0200
Subject: Re: [PATCH 4/7] btrfs: qgroup: try to flush qgroup space when we get
 -EDQUOT
To:     Anand Jain <anand.jain@oracle.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
 <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0711671b-b08c-ee78-7271-b756dd1b579e@gmx.com>
Date:   Fri, 13 Aug 2021 18:26:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <740e4978ebebfc08491db3f52264f7b5ba60ed96.1628845854.git.anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zJypqf8afDZp5GvzGHwTB0qAmH6jd+oss/YhqUx1/NIu9Pe4PFL
 I4TA6O/6/sg8boVMg75kCdmgb3qaW2W22iR4iP3TgHojT+wp6G4QVlLLekL08P3WVFJfGtp
 FslmKOtXMmM8bYV/cZNXg4EWAq2VhAXsbVeYyEgtIfLNyckRfQlwJJdGyn+/RZx0tjTBGaV
 JTXeTHCZ0JC1OoeTdTQzA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:srUJEQdgiHU=:jXGRD/N4UtpXCWDUNJQc4G
 H+qPG1Qail8rzgnFFGRcX7E9tvzED8jdGlj7tuNoE/PHdAFfg+BzBPwJfYpOVV7STo0NntObI
 F0Uf47eQJTqlNY4dyQGZgSpReoXhJ87nT+uIyTc6XQfWjoe7Q0Ykf/yhCNAyESukyWwv75iEq
 JyZSrMoQQJMWQBUQjf8JIWHKHrX+2r8U7paa73ur3zL02heH9C47M3738Ya/u3+D8rK2e6Ord
 K/8OrYiA5ufyQtWdPYtFtrTjNk1Z2xNO3poH+ZYudGVAWBd+AYymo7jWlnG/NwNNNtRjP+lxm
 t+rdTB1Y5oOgDGBq05/NUx2DlowuvrRAYQE9jTxiEvFtlBPkBB+Bhj1JNEZAp9YSX9RfXapZ+
 Glr8gOSjAcqJM9Ebbfemsd2R4NwpSpF4S+qBwkXR2cq3BZBr3QQUiM+vFLNroEFooAtGj2x0G
 nRHsk7xYY36i3KGmDgoRTNfdakBvSsvmIHMs/rT3ZLN4+vmU95sVFOInZImoZ0OYH2hc5/vEC
 pvnIYAC8iTmKWXhXAUaXL+vOKp2sUw2k2CSnXFmpoDI8iPFIJM1H4i2XHaRNgzIjQoV5GSmTd
 mMnJioySyTQ4LQgDk/NEB0+bRS9diaOXwx6pssvL2FG0jPafOFTmthqEC37ZPnF5zxJQ66Ian
 k63zrGiMlTzJtPYJJ5L/cFVTHw6RqbSNXyG03TW4ZZ2edFnkc5FWdvfildcrpd2YwVnxNVmD0
 LyYBH8lI2g3nATH9Ja3C9oxsqGBcYUfjpoTezxei7xvsd+114x12mQHAFmip9hsPzEW7FnFUt
 UrwLuxDP2mNS6OqalFrbl3//yectGLSMvZnFithE+zCUVtdRnqDpLOKJBcZ6vFZOe3RL+wvxH
 JEzoF/lJvTIXsJc8Q8QSzirivQGHGNU+pOEnNBTqyQV4s64Tuyp4a+Kx0aH5eqDYifd2oX+wV
 PcauoHeDSJjISgqbOUR3WeoPN6DhBaqSI86P7NRHBgKlLMg/TsNvUxefi2k8vh1upDKh6b381
 z0zHYQvVe3Wzx+WTjVCiSVfYC2ARsuV2GP9QR+B2Laj4y8ox3qRUldcppSDbPdOpjJBfprXcV
 9Op5O1OnJYNsXVe8I7CsEMo46xXcHApRXT7Qo38GX0vH3WNOS+k/pXCrA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/8/13 =E4=B8=8B=E5=8D=885:55, Anand Jain wrote:
> From: Qu Wenruo <wqu@suse.com>
>
> commit c53e9653605dbf708f5be02902de51831be4b009 upstream

This lacks certain upstream fixes for it:

f9baa501b4fd6962257853d46ddffbc21f27e344 btrfs: fix deadlock when
cloning inline extents and using qgroups

4d14c5cde5c268a2bc26addecf09489cb953ef64 btrfs: don't flush from
btrfs_delayed_inode_reserve_metadata

6f23277a49e68f8a9355385c846939ad0b1261e7 btrfs: qgroup: don't commit
transaction when we already hold the handle

All these fixes are to ensure we don't try to flush in context where we
shouldn't.

Without them, it can hit various deadlock.

Thanks,
Qu
>
> [PROBLEM]
> There are known problem related to how btrfs handles qgroup reserved
> space.  One of the most obvious case is the the test case btrfs/153,
> which do fallocate, then write into the preallocated range.
>
>    btrfs/153 1s ... - output mismatch (see xfstests-dev/results//btrfs/1=
53.out.bad)
>        --- tests/btrfs/153.out     2019-10-22 15:18:14.068965341 +0800
>        +++ xfstests-dev/results//btrfs/153.out.bad      2020-07-01 20:24=
:40.730000089 +0800
>        @@ -1,2 +1,5 @@
>         QA output created by 153
>        +pwrite: Disk quota exceeded
>        +/mnt/scratch/testfile2: Disk quota exceeded
>        +/mnt/scratch/testfile2: Disk quota exceeded
>         Silence is golden
>        ...
>        (Run 'diff -u xfstests-dev/tests/btrfs/153.out xfstests-dev/resul=
ts//btrfs/153.out.bad'  to see the entire diff)
>
> [CAUSE]
> Since commit c6887cd11149 ("Btrfs: don't do nocow check unless we have t=
o"),
> we always reserve space no matter if it's COW or not.
>
> Such behavior change is mostly for performance, and reverting it is not
> a good idea anyway.
>
> For preallcoated extent, we reserve qgroup data space for it already,
> and since we also reserve data space for qgroup at buffered write time,
> it needs twice the space for us to write into preallocated space.
>
> This leads to the -EDQUOT in buffered write routine.
>
> And we can't follow the same solution, unlike data/meta space check,
> qgroup reserved space is shared between data/metadata.
> The EDQUOT can happen at the metadata reservation, so doing NODATACOW
> check after qgroup reservation failure is not a solution.
>
> [FIX]
> To solve the problem, we don't return -EDQUOT directly, but every time
> we got a -EDQUOT, we try to flush qgroup space:
>
> - Flush all inodes of the root
>    NODATACOW writes will free the qgroup reserved at run_dealloc_range()=
.
>    However we don't have the infrastructure to only flush NODATACOW
>    inodes, here we flush all inodes anyway.
>
> - Wait for ordered extents
>    This would convert the preallocated metadata space into per-trans
>    metadata, which can be freed in later transaction commit.
>
> - Commit transaction
>    This will free all per-trans metadata space.
>
> Also we don't want to trigger flush multiple times, so here we introduce
> a per-root wait list and a new root status, to ensure only one thread
> starts the flushing.
>
> Fixes: c6887cd11149 ("Btrfs: don't do nocow check unless we have to")
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   fs/btrfs/ctree.h   |   3 ++
>   fs/btrfs/disk-io.c |   1 +
>   fs/btrfs/qgroup.c  | 100 +++++++++++++++++++++++++++++++++++++++++----
>   3 files changed, 96 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 7960359dbc70..5448dc62e915 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -945,6 +945,8 @@ enum {
>   	BTRFS_ROOT_DEAD_TREE,
>   	/* The root has a log tree. Used only for subvolume roots. */
>   	BTRFS_ROOT_HAS_LOG_TREE,
> +	/* Qgroup flushing is in progress */
> +	BTRFS_ROOT_QGROUP_FLUSHING,
>   };
>
>   /*
> @@ -1097,6 +1099,7 @@ struct btrfs_root {
>   	spinlock_t qgroup_meta_rsv_lock;
>   	u64 qgroup_meta_rsv_pertrans;
>   	u64 qgroup_meta_rsv_prealloc;
> +	wait_queue_head_t qgroup_flush_wait;
>
>   	/* Number of active swapfiles */
>   	atomic_t nr_swapfiles;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e6aa94a583e9..e3bcab38a166 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1154,6 +1154,7 @@ static void __setup_root(struct btrfs_root *root, =
struct btrfs_fs_info *fs_info,
>   	mutex_init(&root->log_mutex);
>   	mutex_init(&root->ordered_extent_mutex);
>   	mutex_init(&root->delalloc_mutex);
> +	init_waitqueue_head(&root->qgroup_flush_wait);
>   	init_waitqueue_head(&root->log_writer_wait);
>   	init_waitqueue_head(&root->log_commit_wait[0]);
>   	init_waitqueue_head(&root->log_commit_wait[1]);
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 50c45b4fcfd4..b312ac645e08 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3479,17 +3479,58 @@ static int qgroup_unreserve_range(struct btrfs_i=
node *inode,
>   }
>
>   /*
> - * Reserve qgroup space for range [start, start + len).
> + * Try to free some space for qgroup.
>    *
> - * This function will either reserve space from related qgroups or doin=
g
> - * nothing if the range is already reserved.
> + * For qgroup, there are only 3 ways to free qgroup space:
> + * - Flush nodatacow write
> + *   Any nodatacow write will free its reserved data space at run_delal=
loc_range().
> + *   In theory, we should only flush nodatacow inodes, but it's not yet
> + *   possible, so we need to flush the whole root.
>    *
> - * Return 0 for successful reserve
> - * Return <0 for error (including -EQUOT)
> + * - Wait for ordered extents
> + *   When ordered extents are finished, their reserved metadata is fina=
lly
> + *   converted to per_trans status, which can be freed by later commit
> + *   transaction.
>    *
> - * NOTE: this function may sleep for memory allocation.
> + * - Commit transaction
> + *   This would free the meta_per_trans space.
> + *   In theory this shouldn't provide much space, but any more qgroup s=
pace
> + *   is needed.
>    */
> -int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
> +static int try_flush_qgroup(struct btrfs_root *root)
> +{
> +	struct btrfs_trans_handle *trans;
> +	int ret;
> +
> +	/*
> +	 * We don't want to run flush again and again, so if there is a runnin=
g
> +	 * one, we won't try to start a new flush, but exit directly.
> +	 */
> +	if (test_and_set_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state)) {
> +		wait_event(root->qgroup_flush_wait,
> +			!test_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state));
> +		return 0;
> +	}
> +
> +	ret =3D btrfs_start_delalloc_snapshot(root);
> +	if (ret < 0)
> +		goto out;
> +	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
> +
> +	trans =3D btrfs_join_transaction(root);
> +	if (IS_ERR(trans)) {
> +		ret =3D PTR_ERR(trans);
> +		goto out;
> +	}
> +
> +	ret =3D btrfs_commit_transaction(trans);
> +out:
> +	clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state);
> +	wake_up(&root->qgroup_flush_wait);
> +	return ret;
> +}
> +
> +static int qgroup_reserve_data(struct btrfs_inode *inode,
>   			struct extent_changeset **reserved_ret, u64 start,
>   			u64 len)
>   {
> @@ -3542,6 +3583,34 @@ int btrfs_qgroup_reserve_data(struct btrfs_inode =
*inode,
>   	return ret;
>   }
>
> +/*
> + * Reserve qgroup space for range [start, start + len).
> + *
> + * This function will either reserve space from related qgroups or do n=
othing
> + * if the range is already reserved.
> + *
> + * Return 0 for successful reservation
> + * Return <0 for error (including -EQUOT)
> + *
> + * NOTE: This function may sleep for memory allocation, dirty page flus=
hing and
> + *	 commit transaction. So caller should not hold any dirty page locked=
.
> + */
> +int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
> +			struct extent_changeset **reserved_ret, u64 start,
> +			u64 len)
> +{
> +	int ret;
> +
> +	ret =3D qgroup_reserve_data(inode, reserved_ret, start, len);
> +	if (ret <=3D 0 && ret !=3D -EDQUOT)
> +		return ret;
> +
> +	ret =3D try_flush_qgroup(inode->root);
> +	if (ret < 0)
> +		return ret;
> +	return qgroup_reserve_data(inode, reserved_ret, start, len);
> +}
> +
>   /* Free ranges specified by @reserved, normally in error path */
>   static int qgroup_free_reserved_data(struct btrfs_inode *inode,
>   			struct extent_changeset *reserved, u64 start, u64 len)
> @@ -3712,7 +3781,7 @@ static int sub_root_meta_rsv(struct btrfs_root *ro=
ot, int num_bytes,
>   	return num_bytes;
>   }
>
> -int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
> +static int qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
>   				enum btrfs_qgroup_rsv_type type, bool enforce)
>   {
>   	struct btrfs_fs_info *fs_info =3D root->fs_info;
> @@ -3739,6 +3808,21 @@ int __btrfs_qgroup_reserve_meta(struct btrfs_root=
 *root, int num_bytes,
>   	return ret;
>   }
>
> +int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
> +				enum btrfs_qgroup_rsv_type type, bool enforce)
> +{
> +	int ret;
> +
> +	ret =3D qgroup_reserve_meta(root, num_bytes, type, enforce);
> +	if (ret <=3D 0 && ret !=3D -EDQUOT)
> +		return ret;
> +
> +	ret =3D try_flush_qgroup(root);
> +	if (ret < 0)
> +		return ret;
> +	return qgroup_reserve_meta(root, num_bytes, type, enforce);
> +}
> +
>   void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
>   {
>   	struct btrfs_fs_info *fs_info =3D root->fs_info;
>
