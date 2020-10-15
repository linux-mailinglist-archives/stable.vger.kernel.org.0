Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C4D28F96F
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391556AbgJOTaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 15:30:10 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50336 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391541AbgJOTaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 15:30:07 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id 92E5B20B4905;
        Thu, 15 Oct 2020 12:30:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 92E5B20B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602790206;
        bh=/s1+tL8aN2AlrCdowqTni81s0i+w8b2KrVLgK9GG9ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4JX5bR3xjDFZ/tCxetWOgXh2Rg3TqqmeZAMenuBtiKEcsKeKA/spES60iIIsULm4
         P4EEOnQ9CSe09OAZuDdKNbGXdwh4Wo7Rtv7+PltRu70+9JNTBTj/tspGQcuJh2IsMf
         eliJoRWB2JgsKEFOZR0IbarmLTQ+MkdTHml3gcqQ=
From:   Daniel Burgener <dburgener@linux.microsoft.com>
To:     stable@vger.kernel.org
Cc:     stephen.smalley.work@gmail.com, paul@paul-moore.com,
        selinux@vger.kernel.org, jmorris@namei.org, sashal@kernel.org
Subject: [PATCH v5.4 2/3] selinux: Refactor selinuxfs directory populating functions
Date:   Thu, 15 Oct 2020 15:29:55 -0400
Message-Id: <20201015192956.1797021-3-dburgener@linux.microsoft.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sel_make_bools and sel_make_classes take the specific elements of
selinux_fs_info that they need rather than the entire struct.

This will allow a future patch to pass temporary elements that are not in
the selinux_fs_info struct to these functions so that the original elements
can be preserved until we are ready to perform the switch over.

Signed-off-by: Daniel Burgener <dburgener@linux.microsoft.com>
---
 security/selinux/selinuxfs.c | 40 +++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 092c7295f78d..ea21f3ef4a6f 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -340,8 +340,11 @@ static const struct file_operations sel_policyvers_ops = {
 };
 
 /* declaration for sel_write_load */
-static int sel_make_bools(struct selinux_fs_info *fsi);
-static int sel_make_classes(struct selinux_fs_info *fsi);
+static int sel_make_bools(struct selinux_fs_info *fsi, struct dentry *bool_dir,
+			  unsigned int *bool_num, char ***bool_pending_names,
+			  unsigned int **bool_pending_values);
+static int sel_make_classes(struct selinux_fs_info *fsi, struct dentry *class_dir,
+			    unsigned long *last_class_ino);
 static int sel_make_policycap(struct selinux_fs_info *fsi);
 
 /* declaration for sel_make_class_dirs */
@@ -531,13 +534,15 @@ static int sel_make_policy_nodes(struct selinux_fs_info *fsi)
 
 	sel_remove_old_policy_nodes(fsi);
 
-	ret = sel_make_bools(fsi);
+	ret = sel_make_bools(fsi, fsi->bool_dir, &fsi->bool_num,
+			     &fsi->bool_pending_names, &fsi->bool_pending_values);
 	if (ret) {
 		pr_err("SELinux: failed to load policy booleans\n");
 		return ret;
 	}
 
-	ret = sel_make_classes(fsi);
+	ret = sel_make_classes(fsi, fsi->class_dir,
+			       &fsi->last_class_ino);
 	if (ret) {
 		pr_err("SELinux: failed to load policy classes\n");
 		return ret;
@@ -1348,12 +1353,13 @@ static void sel_remove_entries(struct dentry *de)
 
 #define BOOL_DIR_NAME "booleans"
 
-static int sel_make_bools(struct selinux_fs_info *fsi)
+static int sel_make_bools(struct selinux_fs_info *fsi, struct dentry *bool_dir,
+			  unsigned int *bool_num, char ***bool_pending_names,
+			  unsigned int **bool_pending_values)
 {
 	int i, ret;
 	ssize_t len;
 	struct dentry *dentry = NULL;
-	struct dentry *dir = fsi->bool_dir;
 	struct inode *inode = NULL;
 	struct inode_security_struct *isec;
 	char **names = NULL, *page;
@@ -1372,12 +1378,12 @@ static int sel_make_bools(struct selinux_fs_info *fsi)
 
 	for (i = 0; i < num; i++) {
 		ret = -ENOMEM;
-		dentry = d_alloc_name(dir, names[i]);
+		dentry = d_alloc_name(bool_dir, names[i]);
 		if (!dentry)
 			goto out;
 
 		ret = -ENOMEM;
-		inode = sel_make_inode(dir->d_sb, S_IFREG | S_IRUGO | S_IWUSR);
+		inode = sel_make_inode(bool_dir->d_sb, S_IFREG | S_IRUGO | S_IWUSR);
 		if (!inode) {
 			dput(dentry);
 			goto out;
@@ -1406,9 +1412,9 @@ static int sel_make_bools(struct selinux_fs_info *fsi)
 		inode->i_ino = i|SEL_BOOL_INO_OFFSET;
 		d_add(dentry, inode);
 	}
-	fsi->bool_num = num;
-	fsi->bool_pending_names = names;
-	fsi->bool_pending_values = values;
+	*bool_num = num;
+	*bool_pending_names = names;
+	*bool_pending_values = values;
 
 	free_page((unsigned long)page);
 	return 0;
@@ -1421,7 +1427,7 @@ static int sel_make_bools(struct selinux_fs_info *fsi)
 		kfree(names);
 	}
 	kfree(values);
-	sel_remove_entries(dir);
+	sel_remove_entries(bool_dir);
 
 	return ret;
 }
@@ -1806,7 +1812,9 @@ static int sel_make_class_dir_entries(char *classname, int index,
 	return rc;
 }
 
-static int sel_make_classes(struct selinux_fs_info *fsi)
+static int sel_make_classes(struct selinux_fs_info *fsi,
+			    struct dentry *class_dir,
+			    unsigned long *last_class_ino)
 {
 
 	int rc, nclasses, i;
@@ -1817,13 +1825,13 @@ static int sel_make_classes(struct selinux_fs_info *fsi)
 		return rc;
 
 	/* +2 since classes are 1-indexed */
-	fsi->last_class_ino = sel_class_to_ino(nclasses + 2);
+	*last_class_ino = sel_class_to_ino(nclasses + 2);
 
 	for (i = 0; i < nclasses; i++) {
 		struct dentry *class_name_dir;
 
-		class_name_dir = sel_make_dir(fsi->class_dir, classes[i],
-					      &fsi->last_class_ino);
+		class_name_dir = sel_make_dir(class_dir, classes[i],
+					      last_class_ino);
 		if (IS_ERR(class_name_dir)) {
 			rc = PTR_ERR(class_name_dir);
 			goto out;
-- 
2.25.4

