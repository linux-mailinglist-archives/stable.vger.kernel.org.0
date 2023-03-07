Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E556AF462
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCGTQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjCGTQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:13 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2FAB78AF;
        Tue,  7 Mar 2023 10:59:39 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p6so15256800plf.0;
        Tue, 07 Mar 2023 10:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cLQxmjFeKMgd96wW6+/hw3wJEcmjhKS1r8iizNu8AA=;
        b=omh40ba32jnbzmiVsKWmle/HxtoYjTXhjFPISDCFYHPlvPzHGiwYktWY87rDVTfWo8
         /lM8WKiLviRtuadroV8yKlWBjlYm4+/o1VETCkyzNMmpCFhJgNko62gQon7l+E6ppsaI
         1kilNMVtAmXKMQmdRzrff3lOrXgPItiSAfRckV+3QVMDwuZ7TKjB1g2PgpGl7jsgjgEy
         64jwchXmyZtoKquMKul9DxobIoxPLiHtUB7AOhpRcid5G6VxhHILB63GNAdFun1IMJgp
         ZdWITF778Xf0PKlx1aI1sn6MTFm6eKXW1eN7x3SwUCWwAfo48Mgmb1AjBhaZuhu4Mbud
         OQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7cLQxmjFeKMgd96wW6+/hw3wJEcmjhKS1r8iizNu8AA=;
        b=u5XzZIAHa3A6qNWk9VjymGZ9H6sEXBG5J9gybcEU01QuAjHVR7uy5ihC1ae90p92L6
         EJfZ8qEAdHqHTWe9AXsIrmsJFk8YrSEwdZpWO6dtKQj3+bLW6nTD7Vrg3nBdi7IB5Bea
         AhPcXBndJvuknIeFCfxwauhRMGducK9R14S2aXMrN33Vh2HjWkdUlnTnHMaEldFI4TJM
         x90cPmKl3IcXNoliGuNH8mWzxDzO1ywC2qTv94Xk1z1SwmSGJY3+qcHnmUCbIsvcNZ07
         KrZdHmTtjGVnm/22LGP+Vfmz50px89jNY9gh2uj6s75dA39l14LMqcfsdJstZfXMaDop
         MuJg==
X-Gm-Message-State: AO0yUKVVonQA/lCJQJyDTTzTcpDpfA94qoDcSQUCNpy7pDXVX5IKUjCs
        2X0FNUaVPS8NPojyKX8IzqlVMofxQ7iNNg==
X-Google-Smtp-Source: AK7set+725pKg7nqbaDDMVji0JnABlmKZ1vg49HPXNDdijw2IhJliptSndH+scClK/nq3HF1HgnefQ==
X-Received: by 2002:a17:902:7c08:b0:19e:8088:b852 with SMTP id x8-20020a1709027c0800b0019e8088b852mr13739465pll.10.1678215578837;
        Tue, 07 Mar 2023 10:59:38 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:38 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5.15 10/11] attr: use consistent sgid stripping checks
Date:   Tue,  7 Mar 2023 10:59:21 -0800
Message-Id: <20230307185922.125907-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230307185922.125907-1-leah.rumancik@gmail.com>
References: <20230307185922.125907-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit ed5a7047d2011cb6b2bf84ceb6680124cc6a7d95 upstream.

[backport to 5.15.y, prior to vfsgid_t]

Currently setgid stripping in file_remove_privs()'s should_remove_suid()
helper is inconsistent with other parts of the vfs. Specifically, it only
raises ATTR_KILL_SGID if the inode is S_ISGID and S_IXGRP but not if the
inode isn't in the caller's groups and the caller isn't privileged over the
inode although we require this already in setattr_prepare() and
setattr_copy() and so all filesystem implement this requirement implicitly
because they have to use setattr_{prepare,copy}() anyway.

But the inconsistency shows up in setgid stripping bugs for overlayfs in
xfstests (e.g., generic/673, generic/683, generic/685, generic/686,
generic/687). For example, we test whether suid and setgid stripping works
correctly when performing various write-like operations as an unprivileged
user (fallocate, reflink, write, etc.):

echo "Test 1 - qa_user, non-exec file $verb"
setup_testfile
chmod a+rws $junk_file
commit_and_check "$qa_user" "$verb" 64k 64k

The test basically creates a file with 6666 permissions. While the file has
the S_ISUID and S_ISGID bits set it does not have the S_IXGRP set. On a
regular filesystem like xfs what will happen is:

sys_fallocate()
-> vfs_fallocate()
   -> xfs_file_fallocate()
      -> file_modified()
         -> __file_remove_privs()
            -> dentry_needs_remove_privs()
               -> should_remove_suid()
            -> __remove_privs()
               newattrs.ia_valid = ATTR_FORCE | kill;
               -> notify_change()
                  -> setattr_copy()

In should_remove_suid() we can see that ATTR_KILL_SUID is raised
unconditionally because the file in the test has S_ISUID set.

But we also see that ATTR_KILL_SGID won't be set because while the file
is S_ISGID it is not S_IXGRP (see above) which is a condition for
ATTR_KILL_SGID being raised.

So by the time we call notify_change() we have attr->ia_valid set to
ATTR_KILL_SUID | ATTR_FORCE. Now notify_change() sees that
ATTR_KILL_SUID is set and does:

ia_valid = attr->ia_valid |= ATTR_MODE
attr->ia_mode = (inode->i_mode & ~S_ISUID);

which means that when we call setattr_copy() later we will definitely
update inode->i_mode. Note that attr->ia_mode still contains S_ISGID.

Now we call into the filesystem's ->setattr() inode operation which will
end up calling setattr_copy(). Since ATTR_MODE is set we will hit:

if (ia_valid & ATTR_MODE) {
        umode_t mode = attr->ia_mode;
        vfsgid_t vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
        if (!vfsgid_in_group_p(vfsgid) &&
            !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
                mode &= ~S_ISGID;
        inode->i_mode = mode;
}

and since the caller in the test is neither capable nor in the group of the
inode the S_ISGID bit is stripped.

But assume the file isn't suid then ATTR_KILL_SUID won't be raised which
has the consequence that neither the setgid nor the suid bits are stripped
even though it should be stripped because the inode isn't in the caller's
groups and the caller isn't privileged over the inode.

If overlayfs is in the mix things become a bit more complicated and the bug
shows up more clearly. When e.g., ovl_setattr() is hit from
ovl_fallocate()'s call to file_remove_privs() then ATTR_KILL_SUID and
ATTR_KILL_SGID might be raised but because the check in notify_change() is
questioning the ATTR_KILL_SGID flag again by requiring S_IXGRP for it to be
stripped the S_ISGID bit isn't removed even though it should be stripped:

sys_fallocate()
-> vfs_fallocate()
   -> ovl_fallocate()
      -> file_remove_privs()
         -> dentry_needs_remove_privs()
            -> should_remove_suid()
         -> __remove_privs()
            newattrs.ia_valid = ATTR_FORCE | kill;
            -> notify_change()
               -> ovl_setattr()
                  // TAKE ON MOUNTER'S CREDS
                  -> ovl_do_notify_change()
                     -> notify_change()
                  // GIVE UP MOUNTER'S CREDS
     // TAKE ON MOUNTER'S CREDS
     -> vfs_fallocate()
        -> xfs_file_fallocate()
           -> file_modified()
              -> __file_remove_privs()
                 -> dentry_needs_remove_privs()
                    -> should_remove_suid()
                 -> __remove_privs()
                    newattrs.ia_valid = attr_force | kill;
                    -> notify_change()

The fix for all of this is to make file_remove_privs()'s
should_remove_suid() helper to perform the same checks as we already
require in setattr_prepare() and setattr_copy() and have notify_change()
not pointlessly requiring S_IXGRP again. It doesn't make any sense in the
first place because the caller must calculate the flags via
should_remove_suid() anyway which would raise ATTR_KILL_SGID.

While we're at it we move should_remove_suid() from inode.c to attr.c
where it belongs with the rest of the iattr helpers. Especially since it
returns ATTR_KILL_S{G,U}ID flags. We also rename it to
setattr_should_drop_suidgid() to better reflect that it indicates both
setuid and setgid bit removal and also that it returns attr flags.

Running xfstests with this doesn't report any regressions. We should really
try and use consistent checks.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/trace/ftrace.rst |  2 +-
 fs/attr.c                      | 33 +++++++++++++++++++--------------
 fs/fuse/file.c                 |  2 +-
 fs/inode.c                     |  7 ++++---
 fs/internal.h                  |  2 +-
 fs/ocfs2/file.c                |  4 ++--
 fs/open.c                      |  8 ++++----
 include/linux/fs.h             |  2 +-
 8 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
index 4e5b26f03d5b..d036946bce7a 100644
--- a/Documentation/trace/ftrace.rst
+++ b/Documentation/trace/ftrace.rst
@@ -2929,7 +2929,7 @@ Produces::
               bash-1994  [000] ....  4342.324898: ima_get_action <-process_measurement
               bash-1994  [000] ....  4342.324898: ima_match_policy <-ima_get_action
               bash-1994  [000] ....  4342.324899: do_truncate <-do_last
-              bash-1994  [000] ....  4342.324899: should_remove_suid <-do_truncate
+              bash-1994  [000] ....  4342.324899: setattr_should_drop_suidgid <-do_truncate
               bash-1994  [000] ....  4342.324899: notify_change <-do_truncate
               bash-1994  [000] ....  4342.324900: current_fs_time <-notify_change
               bash-1994  [000] ....  4342.324900: current_kernel_time <-current_fs_time
diff --git a/fs/attr.c b/fs/attr.c
index 965be68ed8fa..0ca14cbd4b8b 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -48,34 +48,39 @@ int setattr_should_drop_sgid(struct user_namespace *mnt_userns,
 	return 0;
 }
 
-/*
- * The logic we want is
+/**
+ * setattr_should_drop_suidgid - determine whether the set{g,u}id bit needs to
+ *                               be dropped
+ * @mnt_userns:	user namespace of the mount @inode was found from
+ * @inode:	inode to check
  *
- *	if suid or (sgid and xgrp)
- *		remove privs
+ * This function determines whether the set{g,u}id bits need to be removed.
+ * If the setuid bit needs to be removed ATTR_KILL_SUID is returned. If the
+ * setgid bit needs to be removed ATTR_KILL_SGID is returned. If both
+ * set{g,u}id bits need to be removed the corresponding mask of both flags is
+ * returned.
+ *
+ * Return: A mask of ATTR_KILL_S{G,U}ID indicating which - if any - setid bits
+ * to remove, 0 otherwise.
  */
-int should_remove_suid(struct dentry *dentry)
+int setattr_should_drop_suidgid(struct user_namespace *mnt_userns,
+				struct inode *inode)
 {
-	umode_t mode = d_inode(dentry)->i_mode;
+	umode_t mode = inode->i_mode;
 	int kill = 0;
 
 	/* suid always must be killed */
 	if (unlikely(mode & S_ISUID))
 		kill = ATTR_KILL_SUID;
 
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
+	kill |= setattr_should_drop_sgid(mnt_userns, inode);
 
 	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
 		return kill;
 
 	return 0;
 }
-EXPORT_SYMBOL(should_remove_suid);
+EXPORT_SYMBOL(setattr_should_drop_suidgid);
 
 /**
  * chown_ok - verify permissions to chown inode
@@ -440,7 +445,7 @@ int notify_change(struct user_namespace *mnt_userns, struct dentry *dentry,
 		}
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+		if (mode & S_ISGID) {
 			if (!(ia_valid & ATTR_MODE)) {
 				ia_valid = attr->ia_valid |= ATTR_MODE;
 				attr->ia_mode = inode->i_mode;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index cc95a1c37644..2b19d281351e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1295,7 +1295,7 @@ static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			return err;
 
 		if (fc->handle_killpriv_v2 &&
-		    should_remove_suid(file_dentry(file))) {
+		    setattr_should_drop_suidgid(&init_user_ns, file_inode(file))) {
 			goto writethrough;
 		}
 
diff --git a/fs/inode.c b/fs/inode.c
index 3811269259e1..079b64f9b756 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1869,7 +1869,8 @@ EXPORT_SYMBOL(touch_atime);
  * response to write or truncate. Return 0 if nothing has to be changed.
  * Negative value on error (change should be denied).
  */
-int dentry_needs_remove_privs(struct dentry *dentry)
+int dentry_needs_remove_privs(struct user_namespace *mnt_userns,
+			      struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	int mask = 0;
@@ -1878,7 +1879,7 @@ int dentry_needs_remove_privs(struct dentry *dentry)
 	if (IS_NOSEC(inode))
 		return 0;
 
-	mask = should_remove_suid(dentry);
+	mask = setattr_should_drop_suidgid(mnt_userns, inode);
 	ret = security_inode_need_killpriv(dentry);
 	if (ret < 0)
 		return ret;
@@ -1920,7 +1921,7 @@ int file_remove_privs(struct file *file)
 	if (IS_NOSEC(inode) || !S_ISREG(inode->i_mode))
 		return 0;
 
-	kill = dentry_needs_remove_privs(dentry);
+	kill = dentry_needs_remove_privs(file_mnt_user_ns(file), dentry);
 	if (kill < 0)
 		return kill;
 	if (kill)
diff --git a/fs/internal.h b/fs/internal.h
index 45cf31d7380b..46df4ce58e87 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -149,7 +149,7 @@ extern int vfs_open(const struct path *, struct file *);
  */
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
-extern int dentry_needs_remove_privs(struct dentry *dentry);
+int dentry_needs_remove_privs(struct user_namespace *, struct dentry *dentry);
 bool in_group_or_capable(struct user_namespace *mnt_userns,
 			 const struct inode *inode, kgid_t gid);
 
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index fc5f780fa235..92182d4be247 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1994,7 +1994,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		}
 	}
 
-	if (file && should_remove_suid(file->f_path.dentry)) {
+	if (file && setattr_should_drop_suidgid(&init_user_ns, file_inode(file))) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -2282,7 +2282,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * inode. There's also the dinode i_size state which
 		 * can be lost via setattr during extending writes (we
 		 * set inode->i_size at the end of a write. */
-		if (should_remove_suid(dentry)) {
+		if (setattr_should_drop_suidgid(&init_user_ns, inode)) {
 			if (meta_level == 0) {
 				ocfs2_inode_unlock_for_extent_tree(inode,
 								   &di_bh,
diff --git a/fs/open.c b/fs/open.c
index 5e322f188e83..e93c33069055 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -54,7 +54,7 @@ int do_truncate(struct user_namespace *mnt_userns, struct dentry *dentry,
 	}
 
 	/* Remove suid, sgid, and file capabilities on truncate too */
-	ret = dentry_needs_remove_privs(dentry);
+	ret = dentry_needs_remove_privs(mnt_userns, dentry);
 	if (ret < 0)
 		return ret;
 	if (ret)
@@ -671,10 +671,10 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 		newattrs.ia_valid |= ATTR_GID;
 		newattrs.ia_gid = gid;
 	}
-	if (!S_ISDIR(inode->i_mode))
-		newattrs.ia_valid |=
-			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	inode_lock(inode);
+	if (!S_ISDIR(inode->i_mode))
+		newattrs.ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV |
+				     setattr_should_drop_sgid(mnt_userns, inode);
 	error = security_path_chown(path, uid, gid);
 	if (!error)
 		error = notify_change(mnt_userns, path->dentry, &newattrs,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index be9be4a7216c..9601c2d774c8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3133,7 +3133,7 @@ extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
-extern int should_remove_suid(struct dentry *);
+extern int setattr_should_drop_suidgid(struct user_namespace *, struct inode *);
 extern int file_remove_privs(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

