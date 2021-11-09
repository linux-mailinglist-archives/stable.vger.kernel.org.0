Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAB44AFD8
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 15:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhKIPAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 10:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234127AbhKIPAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 10:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ED7C610A8;
        Tue,  9 Nov 2021 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636469883;
        bh=jYTdgqoQxjEzyhQsiioM2IxXbnEV9oZMGsHLq+o4SOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqmZw1hOjzzkKF5eLfalUl00C3P23lvho5if8hncUKywQGEhdl4hSOU9NWs97m6m1
         Ymtb5QPgVHTAE8uesDOdn7MAZSyz6SchxOso6Zi7/4PJTMAyNeTEHQUTQF3uAY+gj5
         UrYNfTKmJeeBE7kGSdzWCHOlvX6pslZlxfJLx35Xn0jxlOzZWlNs1WJoH9mSqVzNXA
         IwEVMG0S0cbhDNsF77b2/qMLmlzIB/VVEMNk4H9uv0Z5NDxmdSXJYS3w05+AaF8aiI
         ZKeZrr3bVDUVKzllOYWkzLQH2XgdDBlJD3Gtr7GYSLb9GynFk4p+2Ftgmy/eDn/AXy
         PeBaieBQfzNnQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
Cc:     Seth Forshee <seth.forshee@digitalocean.com>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org
Subject: [PATCH 2/2] generic: test circular mappings
Date:   Tue,  9 Nov 2021 15:57:13 +0100
Message-Id: <20211109145713.1868404-2-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109145713.1868404-1-brauner@kernel.org>
References: <20211109145713.1868404-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18591; h=from:subject; bh=sFnzotghS5L2I3DOTDkuQptwt+JKJmdPKLXmdfFlv40=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR29bjPdtle3HdI4/trDuYHrC/TQxxC1mudvdt+xW+DuPuV c+leHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABfZy/DPJPq2z4svx3J/WS12WrD7s0 7UjmWR4gdzfzbdiHngs2fTIkaGnsOtr5qfSk31nbDMe3Jly+4/LwPin3hPceGTWu7O/z+BHwA=
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

This test makes sure that setattr behaves correctly on idmapped mounts
that make use of circular mappings. Such mappings may e.g. be used to
allow two users to share home directories through the same idmapped
mount. The tests are explained in detail in code comments.

Cc: Seth Forshee <seth.forshee@digitalocean.com>
Cc: Eryu Guan <guaneryu@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 src/idmapped-mounts/idmapped-mounts.c | 434 +++++++++++++++++++++++++-
 src/idmapped-mounts/utils.c           |  43 ++-
 tests/generic/651                     |  27 ++
 tests/generic/651.out                 |   2 +
 4 files changed, 503 insertions(+), 3 deletions(-)
 create mode 100755 tests/generic/651
 create mode 100644 tests/generic/651.out

diff --git a/src/idmapped-mounts/idmapped-mounts.c b/src/idmapped-mounts/idmapped-mounts.c
index 83b7c89a..b803d171 100644
--- a/src/idmapped-mounts/idmapped-mounts.c
+++ b/src/idmapped-mounts/idmapped-mounts.c
@@ -14,6 +14,7 @@
 #include <linux/limits.h>
 #include <linux/types.h>
 #include <pthread.h>
+#include <pwd.h>
 #include <sched.h>
 #include <stdbool.h>
 #include <sys/fsuid.h>
@@ -409,6 +410,23 @@ static inline bool switch_fsids(uid_t fsuid, gid_t fsgid)
 	return true;
 }
 
+static inline bool switch_resids(uid_t uid, gid_t gid)
+{
+	if (setresgid(gid, gid, gid))
+		return log_errno(false, "failure: setregid");
+
+	if (setresuid(uid, uid, uid))
+		return log_errno(false, "failure: setresuid");
+
+	if (setfsgid(-1) != gid)
+		return log_errno(false, "failure: setfsgid(-1)");
+
+	if (setfsuid(-1) != uid)
+		return log_errno(false, "failure: setfsuid(-1)");
+
+	return true;
+}
+
 static inline bool switch_userns(int fd, uid_t uid, gid_t gid, bool drop_caps)
 {
 	if (setns(fd, CLONE_NEWUSER))
@@ -636,6 +654,11 @@ __attribute__((unused)) static int print_r(int fd, const char *path)
 
 	return ret;
 }
+#else
+__attribute__((unused)) static int print_r(int fd, const char *path)
+{
+	return 0;
+}
 #endif
 
 /* fd_to_fd - transfer data from one fd to another */
@@ -13325,6 +13348,401 @@ out:
 	return fret;
 }
 
+#define USER1 "fsgqa"
+#define USER2 "fsgqa2"
+
+/**
+ * lookup_ids - lookup uid and gid for a username
+ * @name: [in]  name of the user
+ * @uid:  [out] pointer to the user-ID
+ * @gid:  [out] pointer to the group-ID
+ *
+ * Lookup the uid and gid of a user.
+ *
+ * Return: On success, true is returned.
+ *         On error, false is returned.
+ */
+static bool lookup_ids(const char *name, uid_t *uid, gid_t *gid)
+{
+	bool bret = false;
+	struct passwd *pwentp = NULL;
+	struct passwd pwent;
+	char *buf;
+	ssize_t bufsize;
+	int ret;
+
+	bufsize = sysconf(_SC_GETPW_R_SIZE_MAX);
+	if (bufsize < 0)
+		bufsize = 1024;
+
+	buf = malloc(bufsize);
+	if (!buf)
+		return bret;
+
+	ret = getpwnam_r(name, &pwent, buf, bufsize, &pwentp);
+	if (!ret && pwentp) {
+		*uid = pwent.pw_uid;
+		*gid = pwent.pw_gid;
+		bret = true;
+	}
+
+	free(buf);
+	return bret;
+}
+
+/**
+ * setattr_fix - test that setattr works correctly
+ *
+ * Test that ->setattr() works correctly for idmapped mounts with circular
+ * idmappings such as:
+ *
+ * b:1000:1001:1
+ * b:1001:1000:1
+ *
+ * Assume a directory /source with two files:
+ *
+ * /source/file1 | 1000:1000
+ * /source/file2 | 1001:1001
+ *
+ * and we create an idmapped mount of /source at /target with an idmapped of:
+ *
+ * mnt_userns:        1000:1001:1
+ *                    1001:1000:1
+ *
+ * In the idmapped mount file1 will be owned by uid 1001 and file2 by uid 1000:
+ *
+ * /target/file1 | 1001:1001
+ * /target/file2 | 1000:1000
+ *
+ * Because in essence the idmapped mount switches ownership for {g,u}id 1000
+ * and {g,u}id 1001.
+ *
+ * 1. A user with fs{g,u}id 1000 must be allowed to setattr /target/file2 from
+ *    {g,u}id 1000 in the idmapped mount to {g,u}id 1000.
+ * 2. A user with fs{g,u}id 1001 must be allowed to setattr /target/file1 from
+ *    {g,u}id 1001 in the idmapped mount to {g,u}id 1001.
+ * 3. A user with fs{g,u}id 1000 must fail to setattr /target/file1 from
+ *    {g,u}id 1001 in the idmapped mount to {g,u}id 1000.
+ *    This must fail with EPERM. The caller's fs{g,u}id doesn't match the
+ *    {g,u}id of the file.
+ * 4. A user with fs{g,u}id 1001 must fail to setattr /target/file2 from
+ *    {g,u}id 1000 in the idmapped mount to {g,u}id 1000.
+ *    This must fail with EPERM. The caller's fs{g,u}id doesn't match the
+ *    {g,u}id of the file.
+ * 5. Both, a user with fs{g,u}id 1000 and a user with fs{g,u}id 1001, must
+ *    fail to setattr /target/file1 owned by {g,u}id 1001 in the idmapped mount
+ *    and /target/file2 owned by {g,u}id 1000 in the idmapped mount to any
+ *    {g,u}id apart from {g,u}id 1000 or 1001 with EINVAL.
+ *    Only {g,u}id 1000 and 1001 have a mapping in the idmapped mount. Other
+ *    {g,u}id are unmapped.
+ */
+static int setattr_fix(void)
+{
+	int fret = -1;
+	int open_tree_fd = -EBADF;
+	struct mount_attr attr = {
+		.attr_set	= MOUNT_ATTR_IDMAP,
+		.userns_fd	= -EBADF,
+	};
+	int ret;
+	uid_t user1_uid, user2_uid;
+	gid_t user1_gid, user2_gid;
+	pid_t pid;
+	struct list idmap;
+	struct list *it_cur, *it_next;
+
+	if (!caps_supported())
+		return 0;
+
+	list_init(&idmap);
+
+	if (!lookup_ids(USER1, &user1_uid, &user1_gid)) {
+		log_stderr("failure: lookup_user");
+		goto out;
+	}
+
+	if (!lookup_ids(USER2, &user2_uid, &user2_gid)) {
+		log_stderr("failure: lookup_user");
+		goto out;
+	}
+
+	log_debug("Found " USER1 " with uid(%d) and gid(%d) and " USER2 " with uid(%d) and gid(%d)",
+		  user1_uid, user1_gid, user2_uid, user2_gid);
+
+	if (mkdirat(t_dir1_fd, DIR1, 0777)) {
+		log_stderr("failure: mkdirat");
+		goto out;
+	}
+
+	if (mknodat(t_dir1_fd, DIR1 "/" FILE1, S_IFREG | 0644, 0)) {
+		log_stderr("failure: mknodat");
+		goto out;
+	}
+
+	if (chown_r(t_mnt_fd, T_DIR1, user1_uid, user1_gid)) {
+		log_stderr("failure: chown_r");
+		goto out;
+	}
+
+	if (mknodat(t_dir1_fd, DIR1 "/" FILE2, S_IFREG | 0644, 0)) {
+		log_stderr("failure: mknodat");
+		goto out;
+	}
+
+	if (fchownat(t_dir1_fd, DIR1 "/" FILE2, user2_uid, user2_gid, AT_SYMLINK_NOFOLLOW)) {
+		log_stderr("failure: fchownat");
+		goto out;
+	}
+
+	print_r(t_mnt_fd, T_DIR1);
+
+	/* u:1000:1001:1 */
+	ret = add_map_entry(&idmap, user1_uid, user2_uid, 1, ID_TYPE_UID);
+	if (ret) {
+		log_stderr("failure: add_map_entry");
+		goto out;
+	}
+
+	/* u:1001:1000:1 */
+	ret = add_map_entry(&idmap, user2_uid, user1_uid, 1, ID_TYPE_UID);
+	if (ret) {
+		log_stderr("failure: add_map_entry");
+		goto out;
+	}
+
+	/* g:1000:1001:1 */
+	ret = add_map_entry(&idmap, user1_gid, user2_gid, 1, ID_TYPE_GID);
+	if (ret) {
+		log_stderr("failure: add_map_entry");
+		goto out;
+	}
+
+	/* g:1001:1000:1 */
+	ret = add_map_entry(&idmap, user2_gid, user1_gid, 1, ID_TYPE_GID);
+	if (ret) {
+		log_stderr("failure: add_map_entry");
+		goto out;
+	}
+
+	attr.userns_fd = get_userns_fd_from_idmap(&idmap);
+	if (attr.userns_fd < 0) {
+		log_stderr("failure: get_userns_fd");
+		goto out;
+	}
+
+	open_tree_fd = sys_open_tree(t_dir1_fd, DIR1,
+				     AT_NO_AUTOMOUNT |
+				     AT_SYMLINK_NOFOLLOW |
+				     OPEN_TREE_CLOEXEC |
+				     OPEN_TREE_CLONE |
+				     AT_RECURSIVE);
+	if (open_tree_fd < 0) {
+		log_stderr("failure: sys_open_tree");
+		goto out;
+	}
+
+	if (sys_mount_setattr(open_tree_fd, "", AT_EMPTY_PATH, &attr, sizeof(attr))) {
+		log_stderr("failure: sys_mount_setattr");
+		goto out;
+	}
+
+	print_r(open_tree_fd, "");
+
+	pid = fork();
+	if (pid < 0) {
+		log_stderr("failure: fork");
+		goto out;
+	}
+	if (pid == 0) {
+		/* switch to {g,u}id 1001 */
+		if (!switch_resids(user2_uid, user2_gid))
+			die("failure: switch_resids");
+
+		/* drop all capabilities */
+		if (!caps_down())
+			die("failure: caps_down");
+
+		/*
+		 * The {g,u}id 0 is not mapped in this idmapped mount so this
+		 * needs to fail with EINVAL.
+		 */
+		if (!fchownat(open_tree_fd, FILE1, 0, 0, AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EINVAL)
+			die("failure: errno");
+
+		/*
+		 * A user with fs{g,u}id 1001 must be allowed to change
+		 * ownership of /target/file1 owned by {g,u}id 1001 in this
+		 * idmapped mount to {g,u}id 1001.
+		 */
+		if (fchownat(open_tree_fd, FILE1, user2_uid, user2_gid,
+			     AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+
+		/* Verify that the ownership is still {g,u}id 1001. */
+		if (!expected_uid_gid(open_tree_fd, FILE1, AT_SYMLINK_NOFOLLOW,
+				      user2_uid, user2_gid))
+			die("failure: check ownership");
+
+		/*
+		 * A user with fs{g,u}id 1001 must not be allowed to change
+		 * ownership of /target/file1 owned by {g,u}id 1001 in this
+		 * idmapped mount to {g,u}id 1000.
+		 */
+		if (!fchownat(open_tree_fd, FILE1, user1_uid, user1_gid,
+			      AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EPERM)
+			die("failure: errno");
+
+		/* Verify that the ownership is still {g,u}id 1001. */
+		if (!expected_uid_gid(open_tree_fd, FILE1, AT_SYMLINK_NOFOLLOW,
+				      user2_uid, user2_gid))
+			die("failure: check ownership");
+
+		/*
+		 * A user with fs{g,u}id 1001 must not be allowed to change
+		 * ownership of /target/file2 owned by {g,u}id 1000 in this
+		 * idmapped mount to {g,u}id 1000.
+		 */
+		if (!fchownat(open_tree_fd, FILE2, user1_uid, user1_gid,
+			      AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EPERM)
+			die("failure: errno");
+
+		/* Verify that the ownership is still {g,u}id 1000. */
+		if (!expected_uid_gid(open_tree_fd, FILE2, AT_SYMLINK_NOFOLLOW,
+				      user1_uid, user1_gid))
+			die("failure: check ownership");
+
+		/*
+		 * A user with fs{g,u}id 1001 must not be allowed to change
+		 * ownership of /target/file2 owned by {g,u}id 1000 in this
+		 * idmapped mount to {g,u}id 1001.
+		 */
+		if (!fchownat(open_tree_fd, FILE2, user2_uid, user2_gid,
+			      AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EPERM)
+			die("failure: errno");
+
+		/* Verify that the ownership is still {g,u}id 1000. */
+		if (!expected_uid_gid(open_tree_fd, FILE2, AT_SYMLINK_NOFOLLOW,
+				      user1_uid, user1_gid))
+			die("failure: check ownership");
+
+		exit(EXIT_SUCCESS);
+	}
+	if (wait_for_pid(pid))
+		goto out;
+
+	pid = fork();
+	if (pid < 0) {
+		log_stderr("failure: fork");
+		goto out;
+	}
+	if (pid == 0) {
+		/* switch to {g,u}id 1000 */
+		if (!switch_resids(user1_uid, user1_gid))
+			die("failure: switch_resids");
+
+		/* drop all capabilities */
+		if (!caps_down())
+			die("failure: caps_down");
+
+		/*
+		 * The {g,u}id 0 is not mapped in this idmapped mount so this
+		 * needs to fail with EINVAL.
+		 */
+		if (!fchownat(open_tree_fd, FILE1, 0, 0, AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EINVAL)
+			die("failure: errno");
+
+		/*
+		 * A user with fs{g,u}id 1000 must be allowed to change
+		 * ownership of /target/file2 owned by {g,u}id 1000 in this
+		 * idmapped mount to {g,u}id 1000.
+		 */
+		if (fchownat(open_tree_fd, FILE2, user1_uid, user1_gid,
+			     AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+
+		/* Verify that the ownership is still {g,u}id 1000. */
+		if (!expected_uid_gid(open_tree_fd, FILE2, AT_SYMLINK_NOFOLLOW,
+				      user1_uid, user1_gid))
+			die("failure: check ownership");
+
+		/*
+		 * A user with fs{g,u}id 1000 must not be allowed to change
+		 * ownership of /target/file2 owned by {g,u}id 1000 in this
+		 * idmapped mount to {g,u}id 1001.
+		 */
+		if (!fchownat(open_tree_fd, FILE2, user2_uid, user2_gid,
+			      AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EPERM)
+			die("failure: errno");
+
+		/* Verify that the ownership is still {g,u}id 1000. */
+		if (!expected_uid_gid(open_tree_fd, FILE2, AT_SYMLINK_NOFOLLOW,
+				      user1_uid, user1_gid))
+			die("failure: check ownership");
+
+		/*
+		 * A user with fs{g,u}id 1000 must not be allowed to change
+		 * ownership of /target/file1 owned by {g,u}id 1001 in this
+		 * idmapped mount to {g,u}id 1000.
+		 */
+		if (!fchownat(open_tree_fd, FILE1, user1_uid, user1_gid,
+			     AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EPERM)
+			die("failure: errno");
+
+		/* Verify that the ownership is still {g,u}id 1001. */
+		if (!expected_uid_gid(open_tree_fd, FILE1, AT_SYMLINK_NOFOLLOW,
+				      user2_uid, user2_gid))
+			die("failure: check ownership");
+
+		/*
+		 * A user with fs{g,u}id 1000 must not be allowed to change
+		 * ownership of /target/file1 owned by {g,u}id 1001 in this
+		 * idmapped mount to {g,u}id 1001.
+		 */
+		if (!fchownat(open_tree_fd, FILE1, user2_uid, user2_gid,
+			      AT_SYMLINK_NOFOLLOW))
+			die("failure: change ownership");
+		if (errno != EPERM)
+			die("failure: errno");
+
+		/* Verify that the ownership is still {g,u}id 1001. */
+		if (!expected_uid_gid(open_tree_fd, FILE1, AT_SYMLINK_NOFOLLOW,
+				      user2_uid, user2_gid))
+			die("failure: check ownership");
+
+		exit(EXIT_SUCCESS);
+	}
+	if (wait_for_pid(pid))
+		goto out;
+
+	fret = 0;
+	log_debug("Ran test");
+out:
+	safe_close(attr.userns_fd);
+	safe_close(open_tree_fd);
+
+	list_for_each_safe(it_cur, &idmap, it_next) {
+		list_del(it_cur);
+		free(it_cur->elem);
+		free(it_cur);
+	}
+
+	return fret;
+}
+
 static void usage(void)
 {
 	fprintf(stderr, "Description:\n");
@@ -13342,6 +13760,7 @@ static void usage(void)
 	fprintf(stderr, "--test-fscaps-regression     Run fscap regression tests\n");
 	fprintf(stderr, "--test-nested-userns         Run nested userns idmapped mount testsuite\n");
 	fprintf(stderr, "--test-btrfs                 Run btrfs specific idmapped mount testsuite\n");
+	fprintf(stderr, "--test-setattr-fix           Run setattr regression tests\n");
 
 	_exit(EXIT_SUCCESS);
 }
@@ -13358,6 +13777,7 @@ static const struct option longopts[] = {
 	{"test-fscaps-regression",	no_argument,		0,	'g'},
 	{"test-nested-userns",		no_argument,		0,	'n'},
 	{"test-btrfs",			no_argument,		0,	'b'},
+	{"test-setattr-fix",		no_argument,		0,	'i'},
 	{NULL,				0,			0,	  0},
 };
 
@@ -13449,6 +13869,10 @@ struct t_idmapped_mounts t_btrfs[] = {
 	{ btrfs_subvolume_lookup_user,					"test unprivileged subvolume lookup",								},
 };
 
+struct t_idmapped_mounts t_setattr_fix[] = {
+	{ setattr_fix,							"test that setattr works correctly",								},
+};
+
 static bool run_test(struct t_idmapped_mounts suite[], size_t suite_size)
 {
 	int i;
@@ -13487,7 +13911,8 @@ int main(int argc, char *argv[])
 	int fret, ret;
 	int index = 0;
 	bool supported = false, test_btrfs = false, test_core = false,
-	     test_fscaps_regression = false, test_nested_userns = false;
+	     test_fscaps_regression = false, test_nested_userns = false,
+	     test_setattr_fix = false;
 
 	while ((ret = getopt_long_only(argc, argv, "", longopts, &index)) != -1) {
 		switch (ret) {
@@ -13521,6 +13946,9 @@ int main(int argc, char *argv[])
 		case 'e':
 			t_device_scratch = optarg;
 			break;
+		case 'i':
+			test_setattr_fix = true;
+			break;
 		case 'h':
 			/* fallthrough */
 		default:
@@ -13609,6 +14037,10 @@ int main(int argc, char *argv[])
 	if (test_btrfs && !run_test(t_btrfs, ARRAY_SIZE(t_btrfs)))
 		goto out;
 
+	if (test_setattr_fix &&
+	    !run_test(t_setattr_fix, ARRAY_SIZE(t_setattr_fix)))
+		goto out;
+
 	fret = EXIT_SUCCESS;
 
 out:
diff --git a/src/idmapped-mounts/utils.c b/src/idmapped-mounts/utils.c
index c2afa8dc..faf06fcd 100644
--- a/src/idmapped-mounts/utils.c
+++ b/src/idmapped-mounts/utils.c
@@ -183,6 +183,43 @@ static int map_ids_from_idmap(struct list *idmap, pid_t pid)
 	return 0;
 }
 
+#ifdef DEBUG_TRACE
+static void __print_idmaps(pid_t pid, bool gid)
+{
+	char path_mapping[STRLITERALLEN("/proc/") + INTTYPE_TO_STRLEN(pid_t) +
+			  STRLITERALLEN("/_id_map") + 1];
+	char *line = NULL;
+	size_t len = 0;
+	int ret;
+	FILE *f;
+
+	ret = snprintf(path_mapping, sizeof(path_mapping), "/proc/%d/%cid_map",
+		       pid, gid ? 'g' : 'u');
+	if (ret < 0 || (size_t)ret >= sizeof(path_mapping))
+		return;
+
+	f = fopen(path_mapping, "r");
+	if (!f)
+		return;
+
+	while ((ret = getline(&line, &len, f)) > 0)
+		fprintf(stderr, "%s", line);
+
+	fclose(f);
+	free(line);
+}
+
+static void print_idmaps(pid_t pid)
+{
+	__print_idmaps(pid, false);
+	__print_idmaps(pid, true);
+}
+#else
+static void print_idmaps(pid_t pid)
+{
+}
+#endif
+
 int get_userns_fd_from_idmap(struct list *idmap)
 {
 	int ret;
@@ -199,10 +236,12 @@ int get_userns_fd_from_idmap(struct list *idmap)
 		return ret;
 
 	ret = snprintf(path_ns, sizeof(path_ns), "/proc/%d/ns/user", pid);
-	if (ret < 0 || (size_t)ret >= sizeof(path_ns))
+	if (ret < 0 || (size_t)ret >= sizeof(path_ns)) {
 		ret = -EIO;
-	else
+	} else {
 		ret = open(path_ns, O_RDONLY | O_CLOEXEC | O_NOCTTY);
+		print_idmaps(pid);
+	}
 
 	(void)kill(pid, SIGKILL);
 	(void)wait_for_pid(pid);
diff --git a/tests/generic/651 b/tests/generic/651
new file mode 100755
index 00000000..49b288d0
--- /dev/null
+++ b/tests/generic/651
@@ -0,0 +1,27 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Christian Brauner.  All Rights Reserved.
+#
+# FS QA Test 651
+#
+# Test that setattr works correctly.
+#
+. ./common/preamble
+_begin_fstest auto attr cap idmapped mount perms
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs generic
+_require_idmapped_mounts
+_require_test
+
+echo "Silence is golden"
+
+$here/src/idmapped-mounts/idmapped-mounts --test-setattr-fix \
+	--device "$TEST_DEV" --mount "$TEST_DIR" --fstype "$FSTYP"
+
+status=$?
+exit
diff --git a/tests/generic/651.out b/tests/generic/651.out
new file mode 100644
index 00000000..51d73665
--- /dev/null
+++ b/tests/generic/651.out
@@ -0,0 +1,2 @@
+QA output created by 651
+Silence is golden

base-commit: bae1d15f6421cbe99b3e2e134c39d50248e7c261
-- 
2.30.2

