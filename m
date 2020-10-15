Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF6F28F970
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391555AbgJOTaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 15:30:10 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50354 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391545AbgJOTaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 15:30:09 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id 684432010689;
        Thu, 15 Oct 2020 12:30:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 684432010689
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602790207;
        bh=9NGeGQRohl9PtkCe5+rjPLu7210zJwIg66GpUXhny78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfXiEQLD/PSUzNXwhW+ImRFBQ6HYWdpUWC3fIVxWWY2IgQIO/TcQ3JrswQzV+vbCx
         /kAGOpBLiMsmax40iMgDo/Mwtmx+Rj5c01FErwnUMt8eq9p8s7i/KT5DoLjwk74mXe
         vaV8Zi1xAzaTE3OUI/Lz7RFrvA+QiLE3UzwW4QQE=
From:   Daniel Burgener <dburgener@linux.microsoft.com>
To:     stable@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        selinux@vger.kernel.org, jmorris@namei.org, sashal@kernel.org
Subject: [PATCH v5.4 3/3] selinux: Create new booleans and class dirs out of tree
Date:   Thu, 15 Oct 2020 15:29:56 -0400
Message-Id: <20201015192956.1797021-4-dburgener@linux.microsoft.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to avoid concurrency issues around selinuxfs resource availability
during policy load, we first create new directories out of tree for
reloaded resources, then swap them in, and finally delete the old versions.

This fix focuses on concurrency in each of the two subtrees swapped, and
not concurrency between the trees.  This means that it is still possible
that subsequent reads to eg the booleans directory and the class directory
during a policy load could see the old state for one and the new for the other.
The problem of ensuring that policy loads are fully atomic from the perspective
of userspace is larger than what is dealt with here.  This commit focuses on
ensuring that the directories contents always match either the new or the old
policy state from the perspective of userspace.

In the previous implementation, on policy load /sys/fs/selinux is updated
by deleting the previous contents of
/sys/fs/selinux/{class,booleans} and then recreating them.  This means
that there is a period of time when the contents of these directories do not
exist which can cause race conditions as userspace relies on them for
information about the policy.  In addition, it means that error recovery in
the event of failure is challenging.

In order to demonstrate the race condition that this series fixes, you
can use the following commands:

while true; do cat /sys/fs/selinux/class/service/perms/status
>/dev/null; done &
while true; do load_policy; done;

In the existing code, this will display errors fairly often as the class
lookup fails.  (In normal operation from systemd, this would result in a
permission check which would be allowed or denied based on policy settings
around unknown object classes.) After applying this patch series you
should expect to no longer see such error messages.

This has been backported to 5.4 for inclusion in stable.  Because prior to this
series in the main kernel some refactoring of SELinux policy loading had been
done, the backport required changing some function call arguments.

The most significant change of note in the backport is as follows:

In previous versions of the kernel, on a policy load, three directories
in the selinuxfs were recreated: class, booleans and policy_capabilities.
Changes to the selinuxfs code after 5.4 but prior to this series removed
the recreation of the policy_capabilities code, so that was not modified in
this series.  For this backport, I left the existing recreation functionality
of policy_capabilities intact, modifying only the class and booleans
directories, as in the original series.

As a final note about changes from the original patch, I dropped a patch
that was only style cleanup, so this patch no longer takes advantage of
the style changes.

Signed-off-by: Daniel Burgener <dburgener@linux.microsoft.com>
---
 security/selinux/selinuxfs.c | 119 +++++++++++++++++++++++++++--------
 1 file changed, 93 insertions(+), 26 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ea21f3ef4a6f..ac553d88cb35 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -20,6 +20,7 @@
 #include <linux/fs_context.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
+#include <linux/namei.h>
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/security.h>
@@ -351,7 +352,11 @@ static int sel_make_policycap(struct selinux_fs_info *fsi);
 static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
 			unsigned long *ino);
 
-/* declaration for sel_remove_old_policy_nodes */
+/* declaration for sel_make_policy_nodes */
+static struct dentry *sel_make_disconnected_dir(struct super_block *sb,
+						unsigned long *ino);
+
+/* declaration for sel_make_policy_nodes */
 static void sel_remove_entries(struct dentry *de);
 
 static ssize_t sel_read_mls(struct file *filp, char __user *buf,
@@ -508,53 +513,101 @@ static const struct file_operations sel_policy_ops = {
 	.llseek		= generic_file_llseek,
 };
 
-static void sel_remove_old_policy_nodes(struct selinux_fs_info *fsi)
+static void sel_remove_old_bool_data(unsigned int bool_num, char **bool_names,
+				unsigned int *bool_values)
 {
 	u32 i;
 
 	/* bool_dir cleanup */
-	for (i = 0; i < fsi->bool_num; i++)
-		kfree(fsi->bool_pending_names[i]);
-	kfree(fsi->bool_pending_names);
-	kfree(fsi->bool_pending_values);
-	fsi->bool_num = 0;
-	fsi->bool_pending_names = NULL;
-	fsi->bool_pending_values = NULL;
-
-	sel_remove_entries(fsi->bool_dir);
-
-	/* class_dir cleanup */
-	sel_remove_entries(fsi->class_dir);
-
+	for (i = 0; i < bool_num; i++)
+		kfree(bool_names[i]);
+	kfree(bool_names);
+	kfree(bool_values);
 }
 
+#define BOOL_DIR_NAME "booleans"
+
 static int sel_make_policy_nodes(struct selinux_fs_info *fsi)
 {
-	int ret;
+	int ret = 0;
+	struct dentry *tmp_parent, *tmp_bool_dir, *tmp_class_dir, *old_dentry;
+	unsigned int tmp_bool_num, old_bool_num;
+	char **tmp_bool_names, **old_bool_names;
+	unsigned int *tmp_bool_values, *old_bool_values;
+	unsigned long tmp_ino = fsi->last_ino; /* Don't increment last_ino in this function */
 
-	sel_remove_old_policy_nodes(fsi);
+	tmp_parent = sel_make_disconnected_dir(fsi->sb, &tmp_ino);
+	if (IS_ERR(tmp_parent))
+		return PTR_ERR(tmp_parent);
 
-	ret = sel_make_bools(fsi, fsi->bool_dir, &fsi->bool_num,
-			     &fsi->bool_pending_names, &fsi->bool_pending_values);
+	tmp_ino = fsi->bool_dir->d_inode->i_ino - 1; /* sel_make_dir will increment and set */
+	tmp_bool_dir = sel_make_dir(tmp_parent, BOOL_DIR_NAME, &tmp_ino);
+	if (IS_ERR(tmp_bool_dir)) {
+		ret = PTR_ERR(tmp_bool_dir);
+		goto out;
+	}
+
+	tmp_ino = fsi->class_dir->d_inode->i_ino - 1; /* sel_make_dir will increment and set */
+	tmp_class_dir = sel_make_dir(tmp_parent, "classes", &tmp_ino);
+	if (IS_ERR(tmp_class_dir)) {
+		ret = PTR_ERR(tmp_class_dir);
+		goto out;
+	}
+
+	ret = sel_make_bools(fsi, tmp_bool_dir, &tmp_bool_num,
+			     &tmp_bool_names, &tmp_bool_values);
 	if (ret) {
 		pr_err("SELinux: failed to load policy booleans\n");
-		return ret;
+		goto out;
 	}
 
-	ret = sel_make_classes(fsi, fsi->class_dir,
+	ret = sel_make_classes(fsi, tmp_class_dir,
 			       &fsi->last_class_ino);
 	if (ret) {
 		pr_err("SELinux: failed to load policy classes\n");
-		return ret;
+		goto out;
 	}
 
 	ret = sel_make_policycap(fsi);
 	if (ret) {
 		pr_err("SELinux: failed to load policy capabilities\n");
-		return ret;
+		goto out;
 	}
 
-	return 0;
+	/* booleans */
+	old_dentry = fsi->bool_dir;
+	lock_rename(tmp_bool_dir, old_dentry);
+	d_exchange(tmp_bool_dir, fsi->bool_dir);
+
+	old_bool_num = fsi->bool_num;
+	old_bool_names = fsi->bool_pending_names;
+	old_bool_values = fsi->bool_pending_values;
+
+	fsi->bool_num = tmp_bool_num;
+	fsi->bool_pending_names = tmp_bool_names;
+	fsi->bool_pending_values = tmp_bool_values;
+
+	sel_remove_old_bool_data(old_bool_num, old_bool_names, old_bool_values);
+
+	fsi->bool_dir = tmp_bool_dir;
+	unlock_rename(tmp_bool_dir, old_dentry);
+
+	/* classes */
+	old_dentry = fsi->class_dir;
+	lock_rename(tmp_class_dir, old_dentry);
+	d_exchange(tmp_class_dir, fsi->class_dir);
+	fsi->class_dir = tmp_class_dir;
+	unlock_rename(tmp_class_dir, old_dentry);
+
+out:
+	/* Since the other temporary dirs are children of tmp_parent
+	 * this will handle all the cleanup in the case of a failure before
+	 * the swapover
+	 */
+	sel_remove_entries(tmp_parent);
+	dput(tmp_parent); /* d_genocide() only handles the children */
+
+	return ret;
 }
 
 static ssize_t sel_write_load(struct file *file, const char __user *buf,
@@ -1351,8 +1404,6 @@ static void sel_remove_entries(struct dentry *de)
 	shrink_dcache_parent(de);
 }
 
-#define BOOL_DIR_NAME "booleans"
-
 static int sel_make_bools(struct selinux_fs_info *fsi, struct dentry *bool_dir,
 			  unsigned int *bool_num, char ***bool_pending_names,
 			  unsigned int **bool_pending_values)
@@ -1910,6 +1961,22 @@ static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
 	return dentry;
 }
 
+static struct dentry *sel_make_disconnected_dir(struct super_block *sb,
+						unsigned long *ino)
+{
+	struct inode *inode = sel_make_inode(sb, S_IFDIR | S_IRUGO | S_IXUGO);
+
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_op = &simple_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	inode->i_ino = ++(*ino);
+	/* directory inodes start off with i_nlink == 2 (for "." entry) */
+	inc_nlink(inode);
+	return d_obtain_alias(inode);
+}
+
 #define NULL_FILE_NAME "null"
 
 static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
-- 
2.25.4

