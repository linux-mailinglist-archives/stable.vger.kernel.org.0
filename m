Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB95D4614C9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 13:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhK2MPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 07:15:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56624 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhK2MNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 07:13:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 458856131C;
        Mon, 29 Nov 2021 12:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B35C004E1;
        Mon, 29 Nov 2021 12:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638187787;
        bh=v6zMLoUPAMkvGSVCoE+y+jIpp7dLFnKY8cJpXFvXlO0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZWf3xV2U8l1CVKYPoTAF5AIMs7OwsilcT4qAbU0/0TJhEemylaErEW7xS2LEv4VUB
         cedzYbjhcXrGqzL+elQdOj5qull6Xn64g4oSShHg2/7u6YKvZOFzumA5UGkvH5WxgB
         N6j4TUfq1tzDQKbyU5h5zHnENGsrT74F0+8symnjGnPQ76r0r43kxkDdcGRzL9sGwg
         ZvBy9pyuNwfcs3v726N+rGgfpIuEdDqkGLhLeCqcyjFq+2J1z0OMsl3W9iPc6YUfbs
         sT1fb56e3hnAHVZioTgvUCrWtLqk5iZBvevWst42MGHXTUxr2Nw2vEhRXM+r7i51tc
         TbVINusGA2kdQ==
Message-ID: <cc7fe167e997b001084c84141a9e03db8abe1211.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix up non-directory creation in SGID
 directories
From:   Jeff Layton <jlayton@kernel.org>
To:     Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Date:   Mon, 29 Nov 2021 07:09:45 -0500
In-Reply-To: <20211129111639.3633764-1-brauner@kernel.org>
References: <20211129111639.3633764-1-brauner@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-11-29 at 12:16 +0100, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> Ceph always inherits the SGID bit if it is set on the parent inode,
> while the generic inode_init_owner does not do this in a few cases where
> it can create a possible security problem (cf. [1]).
> 
> Update ceph to strip the SGID bit just as inode_init_owner would.
> 
> This bug was detected by the mapped mount testsuite in [3]. The
> testsuite tests all core VFS functionality and semantics with and
> without mapped mounts. That is to say it functions as a generic VFS
> testsuite in addition to a mapped mount testsuite. While working on
> mapped mount support for ceph, SIGD inheritance was the only failing
> test for ceph after the port.
> 
> The same bug was detected by the mapped mount testsuite in XFS in
> January 2021 (cf. [2]).
> 
> [1]: commit 0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
> [2]: commit 01ea173e103e ("xfs: fix up non-directory creation in SGID directories")
> [3]: https://git.kernel.org/fs/xfs/xfstests-dev.git
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: ceph-devel@vger.kernel.org
> CC: linux-fsdevel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v2 */
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - Add missing cpu_to_le32() when assigning to in.gid to prevent sparse
>     warnings.
> 
> The test used for this is [3]:
> 
> /* The following tests are concerned with setgid inheritance. These can be
>  * filesystem type specific. For xfs, if a new file or directory is created
>  * within a setgid directory and irix_sgid_inhiert is set then inherit the
>  * setgid bit if the caller is in the group of the directory.
>  */
> static int setgid_create(void)
> {
> 	int fret = -1;
> 	int file1_fd = -EBADF;
> 	pid_t pid;
> 
> 	if (!caps_supported())
> 		return 0;
> 
> 	if (fchmod(t_dir1_fd, S_IRUSR |
> 			      S_IWUSR |
> 			      S_IRGRP |
> 			      S_IWGRP |
> 			      S_IROTH |
> 			      S_IWOTH |
> 			      S_IXUSR |
> 			      S_IXGRP |
> 			      S_IXOTH |
> 			      S_ISGID), 0) {
> 		log_stderr("failure: fchmod");
> 		goto out;
> 	}
> 
> 	/* Verify that the setgid bit got raised. */
> 	if (!is_setgid(t_dir1_fd, "", AT_EMPTY_PATH)) {
> 		log_stderr("failure: is_setgid");
> 		goto out;
> 	}
> 
> 	pid = fork();
> 	if (pid < 0) {
> 		log_stderr("failure: fork");
> 		goto out;
> 	}
> 	if (pid == 0) {
> 		/* create regular file via open() */
> 		file1_fd = openat(t_dir1_fd, FILE1, O_CREAT | O_EXCL | O_CLOEXEC, S_IXGRP | S_ISGID);
> 		if (file1_fd < 0)
> 			die("failure: create");
> 
> 		/* We're capable_wrt_inode_uidgid() and also our fsgid matches
> 		 * the directories gid.
> 		 */
> 		if (!is_setgid(t_dir1_fd, FILE1, 0))
> 			die("failure: is_setgid");
> 
> 		/* create directory */
> 		if (mkdirat(t_dir1_fd, DIR1, 0000))
> 			die("failure: create");
> 
> 		/* Directories always inherit the setgid bit. */
> 		if (!is_setgid(t_dir1_fd, DIR1, 0))
> 			die("failure: is_setgid");
> 
> 		if (unlinkat(t_dir1_fd, FILE1, 0))
> 			die("failure: delete");
> 
> 		if (unlinkat(t_dir1_fd, DIR1, AT_REMOVEDIR))
> 			die("failure: delete");
> 
> 		exit(EXIT_SUCCESS);
> 	}
> 	if (wait_for_pid(pid))
> 		goto out;
> 
> 	pid = fork();
> 	if (pid < 0) {
> 		log_stderr("failure: fork");
> 		goto out;
> 	}
> 	if (pid == 0) {
> 		if (!switch_ids(0, 10000))
> 			die("failure: switch_ids");
> 
> 		if (!caps_down())
> 			die("failure: caps_down");
> 
> 		/* create regular file via open() */
> 		file1_fd = openat(t_dir1_fd, FILE1, O_CREAT | O_EXCL | O_CLOEXEC, S_IXGRP | S_ISGID);
> 		if (file1_fd < 0)
> 			die("failure: create");
> 
> 		/* Neither in_group_p() nor capable_wrt_inode_uidgid() so setgid
> 		 * bit needs to be stripped.
> 		 */
> 		if (is_setgid(t_dir1_fd, FILE1, 0))
> 			die("failure: is_setgid");
> 
> 		/* create directory */
> 		if (mkdirat(t_dir1_fd, DIR1, 0000))
> 			die("failure: create");
> 
> 		if (xfs_irix_sgid_inherit_enabled()) {
> 			/* We're not in_group_p(). */
> 			if (is_setgid(t_dir1_fd, DIR1, 0))
> 				die("failure: is_setgid");
> 		} else {
> 			/* Directories always inherit the setgid bit. */
> 			if (!is_setgid(t_dir1_fd, DIR1, 0))
> 				die("failure: is_setgid");
> 		}
> 
> 		exit(EXIT_SUCCESS);
> 	}
> 	if (wait_for_pid(pid))
> 		goto out;
> 
> 	fret = 0;
> 	log_debug("Ran test");
> out:
> 	safe_close(file1_fd);
> 
> 	return fret;
> }
> ---
>  fs/ceph/file.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 02a0a0fd9ccd..65d65c51d91d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -605,13 +605,25 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>  	in.cap.realm = cpu_to_le64(ci->i_snap_realm->ino);
>  	in.cap.flags = CEPH_CAP_FLAG_AUTH;
>  	in.ctime = in.mtime = in.atime = iinfo.btime;
> -	in.mode = cpu_to_le32((u32)mode);
>  	in.truncate_seq = cpu_to_le32(1);
>  	in.truncate_size = cpu_to_le64(-1ULL);
>  	in.xattr_version = cpu_to_le64(1);
>  	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
> -	in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_mode & S_ISGID ?
> -				dir->i_gid : current_fsgid()));
> +	if (dir->i_mode & S_ISGID) {
> +		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
> +
> +		/* Directories always inherit the setgid bit. */
> +		if (S_ISDIR(mode))
> +			mode |= S_ISGID;
> +		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
> +			 !in_group_p(dir->i_gid) &&
> +			 !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
> +			mode &= ~S_ISGID;
> +	} else {
> +		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
> +	}
> +	in.mode = cpu_to_le32((u32)mode);
> +
>  	in.nlink = cpu_to_le32(1);
>  	in.max_size = cpu_to_le64(lo->stripe_unit);
>  
> 
> base-commit: d58071a8a76d779eedab38033ae4c821c30295a5

Thanks Christian,

Merged into our "testing" branch. We'll plan to get this up to Linus
fairly soon since it's marked for stable.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
