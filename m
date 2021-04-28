Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41AC36D628
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 13:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbhD1LM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 07:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239179AbhD1LMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 07:12:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD22661428;
        Wed, 28 Apr 2021 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619608298;
        bh=6/5PSNK2l/2+czWBATeA3iJvrkGMvaqFUXikdMYh9aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFoFD9KI05j4t+afcGcZE0E379iO9CVjzILDaBBKEYBweKZ0uldeV2QOICrqsKPSo
         HCKKGzjJ69HCHsuG1FFqQPvW5E1nVFyohUi/5/pjzyBbxklA7Ge8lgHqKgAZNtI4CC
         kd9jcCgrEhX15tbY6IzHn445fgneC6rRbFBgAaZevG/G8Vwl7Up7aHJxi3Nstp7FdI
         etBpKC1nPgTXppClmQLxRDRUpo2y3dYBU+plXKn2B9ZddpOZS2PavqXRJ1yY9APCWA
         McO6G7ZzBOjnuejzDfMaGDne225ztrHopeW+cCKi0+LTudHB66N8JiZmHg+FbOY5MG
         EfBfLdEctJFDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        "Andrew G . Morgan" <morgan@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 2/4] capabilities: require CAP_SETFCAP to map uid 0
Date:   Wed, 28 Apr 2021 07:11:31 -0400
Message-Id: <20210428111133.1343210-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428111133.1343210-1-sashal@kernel.org>
References: <20210428111133.1343210-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Serge E. Hallyn" <serge@hallyn.com>

[ Upstream commit db2e718a47984b9d71ed890eb2ea36ecf150de18 ]

cap_setfcap is required to create file capabilities.

Since commit 8db6c34f1dbc ("Introduce v3 namespaced file capabilities"),
a process running as uid 0 but without cap_setfcap is able to work
around this as follows: unshare a new user namespace which maps parent
uid 0 into the child namespace.

While this task will not have new capabilities against the parent
namespace, there is a loophole due to the way namespaced file
capabilities are represented as xattrs.  File capabilities valid in
userns 1 are distinguished from file capabilities valid in userns 2 by
the kuid which underlies uid 0.  Therefore the restricted root process
can unshare a new self-mapping namespace, add a namespaced file
capability onto a file, then use that file capability in the parent
namespace.

To prevent that, do not allow mapping parent uid 0 if the process which
opened the uid_map file does not have CAP_SETFCAP, which is the
capability for setting file capabilities.

As a further wrinkle: a task can unshare its user namespace, then open
its uid_map file itself, and map (only) its own uid.  In this case we do
not have the credential from before unshare, which was potentially more
restricted.  So, when creating a user namespace, we record whether the
creator had CAP_SETFCAP.  Then we can use that during map_write().

With this patch:

1. Unprivileged user can still unshare -Ur

   ubuntu@caps:~$ unshare -Ur
   root@caps:~# logout

2. Root user can still unshare -Ur

   ubuntu@caps:~$ sudo bash
   root@caps:/home/ubuntu# unshare -Ur
   root@caps:/home/ubuntu# logout

3. Root user without CAP_SETFCAP cannot unshare -Ur:

   root@caps:/home/ubuntu# /sbin/capsh --drop=cap_setfcap --
   root@caps:/home/ubuntu# /sbin/setcap cap_setfcap=p /sbin/setcap
   unable to set CAP_SETFCAP effective capability: Operation not permitted
   root@caps:/home/ubuntu# unshare -Ur
   unshare: write failed /proc/self/uid_map: Operation not permitted

Note: an alternative solution would be to allow uid 0 mappings by
processes without CAP_SETFCAP, but to prevent such a namespace from
writing any file capabilities.  This approach can be seen at [1].

Background history: commit 95ebabde382 ("capabilities: Don't allow
writing ambiguous v3 file capabilities") tried to fix the issue by
preventing v3 fscaps to be written to disk when the root uid would map
to the same uid in nested user namespaces.  This led to regressions for
various workloads.  For example, see [2].  Ultimately this is a valid
use-case we have to support meaning we had to revert this change in
3b0c2d3eaa83 ("Revert 95ebabde382c ("capabilities: Don't allow writing
ambiguous v3 file capabilities")").

Link: https://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux.git/log/?h=2021-04-15/setfcap-nsfscaps-v4 [1]
Link: https://github.com/containers/buildah/issues/3071 [2]
Signed-off-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Andrew G. Morgan <morgan@kernel.org>
Tested-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/user_namespace.h  |  3 ++
 include/uapi/linux/capability.h |  3 +-
 kernel/user_namespace.c         | 65 +++++++++++++++++++++++++++++++--
 3 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 64cf8ebdc4ec..f6c5f784be5a 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -63,6 +63,9 @@ struct user_namespace {
 	kgid_t			group;
 	struct ns_common	ns;
 	unsigned long		flags;
+	/* parent_could_setfcap: true if the creator if this ns had CAP_SETFCAP
+	 * in its effective capability set at the child ns creation time. */
+	bool			parent_could_setfcap;
 
 #ifdef CONFIG_KEYS
 	/* List of joinable keyrings in this namespace.  Modification access of
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index c6ca33034147..2ddb4226cd23 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -335,7 +335,8 @@ struct vfs_ns_cap_data {
 
 #define CAP_AUDIT_CONTROL    30
 
-/* Set or remove capabilities on files */
+/* Set or remove capabilities on files.
+   Map uid=0 into a child user namespace. */
 
 #define CAP_SETFCAP	     31
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index af612945a4d0..9a4b980d695b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -106,6 +106,7 @@ int create_user_ns(struct cred *new)
 	if (!ns)
 		goto fail_dec;
 
+	ns->parent_could_setfcap = cap_raised(new->cap_effective, CAP_SETFCAP);
 	ret = ns_alloc_inum(&ns->ns);
 	if (ret)
 		goto fail_free;
@@ -841,6 +842,60 @@ static int sort_idmaps(struct uid_gid_map *map)
 	return 0;
 }
 
+/**
+ * verify_root_map() - check the uid 0 mapping
+ * @file: idmapping file
+ * @map_ns: user namespace of the target process
+ * @new_map: requested idmap
+ *
+ * If a process requests mapping parent uid 0 into the new ns, verify that the
+ * process writing the map had the CAP_SETFCAP capability as the target process
+ * will be able to write fscaps that are valid in ancestor user namespaces.
+ *
+ * Return: true if the mapping is allowed, false if not.
+ */
+static bool verify_root_map(const struct file *file,
+			    struct user_namespace *map_ns,
+			    struct uid_gid_map *new_map)
+{
+	int idx;
+	const struct user_namespace *file_ns = file->f_cred->user_ns;
+	struct uid_gid_extent *extent0 = NULL;
+
+	for (idx = 0; idx < new_map->nr_extents; idx++) {
+		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
+			extent0 = &new_map->extent[idx];
+		else
+			extent0 = &new_map->forward[idx];
+		if (extent0->lower_first == 0)
+			break;
+
+		extent0 = NULL;
+	}
+
+	if (!extent0)
+		return true;
+
+	if (map_ns == file_ns) {
+		/* The process unshared its ns and is writing to its own
+		 * /proc/self/uid_map.  User already has full capabilites in
+		 * the new namespace.  Verify that the parent had CAP_SETFCAP
+		 * when it unshared.
+		 * */
+		if (!file_ns->parent_could_setfcap)
+			return false;
+	} else {
+		/* Process p1 is writing to uid_map of p2, who is in a child
+		 * user namespace to p1's.  Verify that the opener of the map
+		 * file has CAP_SETFCAP against the parent of the new map
+		 * namespace */
+		if (!file_ns_capable(file, map_ns->parent, CAP_SETFCAP))
+			return false;
+	}
+
+	return true;
+}
+
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -848,7 +903,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 			 struct uid_gid_map *parent_map)
 {
 	struct seq_file *seq = file->private_data;
-	struct user_namespace *ns = seq->private;
+	struct user_namespace *map_ns = seq->private;
 	struct uid_gid_map new_map;
 	unsigned idx;
 	struct uid_gid_extent extent;
@@ -895,7 +950,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	/*
 	 * Adjusting namespace settings requires capabilities on the target.
 	 */
-	if (cap_valid(cap_setid) && !file_ns_capable(file, ns, CAP_SYS_ADMIN))
+	if (cap_valid(cap_setid) && !file_ns_capable(file, map_ns, CAP_SYS_ADMIN))
 		goto out;
 
 	/* Parse the user data */
@@ -965,7 +1020,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 
 	ret = -EPERM;
 	/* Validate the user is allowed to use user id's mapped to. */
-	if (!new_idmap_permitted(file, ns, cap_setid, &new_map))
+	if (!new_idmap_permitted(file, map_ns, cap_setid, &new_map))
 		goto out;
 
 	ret = -EPERM;
@@ -1086,6 +1141,10 @@ static bool new_idmap_permitted(const struct file *file,
 				struct uid_gid_map *new_map)
 {
 	const struct cred *cred = file->f_cred;
+
+	if (cap_setid == CAP_SETUID && !verify_root_map(file, ns, new_map))
+		return false;
+
 	/* Don't allow mappings that would allow anything that wouldn't
 	 * be allowed without the establishment of unprivileged mappings.
 	 */
-- 
2.30.2

