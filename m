Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC2545EAFA
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 11:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353204AbhKZKGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238410AbhKZKEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 05:04:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2EA61107;
        Fri, 26 Nov 2021 10:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637920856;
        bh=Fc1PdRLRen+DGEhThIDCZO7g9kO6oEmaVSpVVeUKPhQ=;
        h=From:To:Cc:Subject:Date:From;
        b=hVOBaKkrwZBnZqwdmxG99IHkccy7479PW5vku6oZLCW0uQPlrM2DPdzDyx1PpUKRE
         WCw9Ul4Fj1u0mmC3lIXxTWdWPRUznOQhsC+5qGw1//gx3A+vxCLJPZpICQLUBCzw+i
         FNYnsLYQZoYLw8/W6clrWQLir4L0ORKLYDCU7LKLBj1M23QDpSw1li0+8UPFVcEWKh
         Nr6ZDRgi1sNNTyWDf9oiaWqJ26XUyDRh3uHRI4x6gdx6Hqnz/kxy5AIMsxyOcn1vE8
         PlZGsmxgtMtbc5KotJ2/zsAJ7RnbIoVYhgE7OpQpn7FhkNT6R1EjsFi2R1qgARcPR1
         ruMgrwZgNgKzQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH] ceph: fix up non-directory creation in SGID directories
Date:   Fri, 26 Nov 2021 11:00:48 +0100
Message-Id: <20211126100048.3336609-1-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5562; h=from:subject; bh=V6RnQ7Ui0jRK3wF1bhVqn+wsJeGYrLdUvWyBhqDIGz8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQu2OCVv8bFdPGtjQeKBKJlPyc+DTmb9ZbvwgHb+D+eMgeF Z+TFd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykg4OR4ckc30oLmxgObz7HS2VfZ0 3uENE+nx29ZKNuFPMrx9nSTowMEwPimJOKjCcVGAUybt/9p0ZA6KlutsOmvlpV+xm7np/nBwA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Ceph always inherits the SGID bit if it is set on the parent inode,
while the generic inode_init_owner does not do this in a few cases where
it can create a possible security problem (cf. [1]).

Update ceph to strip the SGID bit just as inode_init_owner would.

This bug was detected by the mapped mount testsuite in [3]. The
testsuite tests all core VFS functionality and semantics with and
without mapped mounts. That is to say it functions as a generic VFS
testsuite in addition to a mapped mount testsuite. While working on
mapped mount support for ceph, SIGD inheritance was the only failing
test for ceph after the port.

The same bug was detected by the mapped mount testsuite in XFS in
January 2021 (cf. [2]).

[1]: commit 0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
[2]: commit 01ea173e103e ("xfs: fix up non-directory creation in SGID directories")
[3]: https://git.kernel.org/fs/xfs/xfstests-dev.git
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
The test used for this is [3]:

/* The following tests are concerned with setgid inheritance. These can be
 * filesystem type specific. For xfs, if a new file or directory is created
 * within a setgid directory and irix_sgid_inhiert is set then inherit the
 * setgid bit if the caller is in the group of the directory.
 */
static int setgid_create(void)
{
	int fret = -1;
	int file1_fd = -EBADF;
	pid_t pid;

	if (!caps_supported())
		return 0;

	if (fchmod(t_dir1_fd, S_IRUSR |
			      S_IWUSR |
			      S_IRGRP |
			      S_IWGRP |
			      S_IROTH |
			      S_IWOTH |
			      S_IXUSR |
			      S_IXGRP |
			      S_IXOTH |
			      S_ISGID), 0) {
		log_stderr("failure: fchmod");
		goto out;
	}

	/* Verify that the setgid bit got raised. */
	if (!is_setgid(t_dir1_fd, "", AT_EMPTY_PATH)) {
		log_stderr("failure: is_setgid");
		goto out;
	}

	pid = fork();
	if (pid < 0) {
		log_stderr("failure: fork");
		goto out;
	}
	if (pid == 0) {
		/* create regular file via open() */
		file1_fd = openat(t_dir1_fd, FILE1, O_CREAT | O_EXCL | O_CLOEXEC, S_IXGRP | S_ISGID);
		if (file1_fd < 0)
			die("failure: create");

		/* We're capable_wrt_inode_uidgid() and also our fsgid matches
		 * the directories gid.
		 */
		if (!is_setgid(t_dir1_fd, FILE1, 0))
			die("failure: is_setgid");

		/* create directory */
		if (mkdirat(t_dir1_fd, DIR1, 0000))
			die("failure: create");

		/* Directories always inherit the setgid bit. */
		if (!is_setgid(t_dir1_fd, DIR1, 0))
			die("failure: is_setgid");

		if (unlinkat(t_dir1_fd, FILE1, 0))
			die("failure: delete");

		if (unlinkat(t_dir1_fd, DIR1, AT_REMOVEDIR))
			die("failure: delete");

		exit(EXIT_SUCCESS);
	}
	if (wait_for_pid(pid))
		goto out;

	pid = fork();
	if (pid < 0) {
		log_stderr("failure: fork");
		goto out;
	}
	if (pid == 0) {
		if (!switch_ids(0, 10000))
			die("failure: switch_ids");

		if (!caps_down())
			die("failure: caps_down");

		/* create regular file via open() */
		file1_fd = openat(t_dir1_fd, FILE1, O_CREAT | O_EXCL | O_CLOEXEC, S_IXGRP | S_ISGID);
		if (file1_fd < 0)
			die("failure: create");

		/* Neither in_group_p() nor capable_wrt_inode_uidgid() so setgid
		 * bit needs to be stripped.
		 */
		if (is_setgid(t_dir1_fd, FILE1, 0))
			die("failure: is_setgid");

		/* create directory */
		if (mkdirat(t_dir1_fd, DIR1, 0000))
			die("failure: create");

		if (xfs_irix_sgid_inherit_enabled()) {
			/* We're not in_group_p(). */
			if (is_setgid(t_dir1_fd, DIR1, 0))
				die("failure: is_setgid");
		} else {
			/* Directories always inherit the setgid bit. */
			if (!is_setgid(t_dir1_fd, DIR1, 0))
				die("failure: is_setgid");
		}

		exit(EXIT_SUCCESS);
	}
	if (wait_for_pid(pid))
		goto out;

	fret = 0;
	log_debug("Ran test");
out:
	safe_close(file1_fd);

	return fret;
}
---
 fs/ceph/file.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 02a0a0fd9ccd..d9236b2c7a43 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -605,13 +605,25 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.cap.realm = cpu_to_le64(ci->i_snap_realm->ino);
 	in.cap.flags = CEPH_CAP_FLAG_AUTH;
 	in.ctime = in.mtime = in.atime = iinfo.btime;
-	in.mode = cpu_to_le32((u32)mode);
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
 	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
-	in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_mode & S_ISGID ?
-				dir->i_gid : current_fsgid()));
+	if (dir->i_mode & S_ISGID) {
+		in.gid = from_kgid(&init_user_ns, dir->i_gid);
+
+		/* Directories always inherit the setgid bit. */
+		if (S_ISDIR(mode))
+			mode |= S_ISGID;
+		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
+			 !in_group_p(dir->i_gid) &&
+			 !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
+			mode &= ~S_ISGID;
+	} else {
+		in.gid = from_kgid(&init_user_ns, current_fsgid());
+	}
+	in.mode = cpu_to_le32((u32)mode);
+
 	in.nlink = cpu_to_le32(1);
 	in.max_size = cpu_to_le64(lo->stripe_unit);
 

base-commit: 136057256686de39cc3a07c2e39ef6bc43003ff6
-- 
2.30.2

