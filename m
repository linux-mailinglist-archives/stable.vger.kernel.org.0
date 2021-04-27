Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A916C36C543
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 13:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhD0Lig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 07:38:36 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2927 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhD0Lie (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 07:38:34 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FV0165HZyz68996;
        Tue, 27 Apr 2021 19:30:02 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.62.217) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Apr 2021 13:37:46 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <jmorris@namei.org>, <paul@paul-moore.com>,
        <casey@schaufler-ca.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <reiserfs-devel@vger.kernel.org>, <selinux@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH v3 1/6] reiserfs: Add missing calls to reiserfs_security_free()
Date:   Tue, 27 Apr 2021 13:37:27 +0200
Message-ID: <20210427113732.471066-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427113732.471066-1-roberto.sassu@huawei.com>
References: <20210427113732.471066-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.62.217]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes
during inode creation") defined reiserfs_security_free() to free the name
and value of a security xattr allocated by the active LSM through
security_old_inode_init_security(). However, this function is not called
in the reiserfs code.

Thus, this patch adds a call to reiserfs_security_free() whenever
reiserfs_security_init() is called, and initializes value to NULL, to avoid
to call kfree() on an uninitialized pointer.

Fixes: 57fe60df6241 ("reiserfs: add atomic addition of selinux attributes during inode creation")
Cc: stable@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/reiserfs/namei.c          | 4 ++++
 fs/reiserfs/xattr_security.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index e6eb05e2b2f1..6b5c51a77fae 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -695,6 +695,7 @@ static int reiserfs_create(struct user_namespace *mnt_userns, struct inode *dir,
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -778,6 +779,7 @@ static int reiserfs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -877,6 +879,7 @@ static int reiserfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
@@ -1193,6 +1196,7 @@ static int reiserfs_symlink(struct user_namespace *mnt_userns,
 	retval = journal_end(&th);
 out_failed:
 	reiserfs_write_unlock(parent_dir->i_sb);
+	reiserfs_security_free(&security);
 	return retval;
 }
 
diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index bb2a0062e0e5..b1ad93b60475 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -50,6 +50,7 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
 	int error;
 
 	sec->name = NULL;
+	sec->value = NULL;
 
 	/* Don't add selinux attributes on xattrs - they'll never get used */
 	if (IS_PRIVATE(dir))
-- 
2.25.1

