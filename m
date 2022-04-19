Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69175077E8
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356827AbiDSSUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356722AbiDSSTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:19:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8EA3FBF1;
        Tue, 19 Apr 2022 11:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E79F6133A;
        Tue, 19 Apr 2022 18:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26A6C385A9;
        Tue, 19 Apr 2022 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392027;
        bh=NTFmc6yUB3G/+inTJha6H7dnjf/aU7LUIJdiD7wZZfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L6VfDCINbvdbdSo8Ur/d9+5zAT2JEHKE1+sdmH3J0Crk3/DbG82gW2cqRBnIRlSup
         Ue1nZ1GsKs61ULlwWCX4I+9gCL0+RUn1crlnhXky+w2eu9h5rK+AQwketQxUSENh+F
         7CcpxROVZSd0TuIgrHewx4vNDZSZzAYGrhdgbzaDtw05vmkn0bzMh61QMNSphuQFsO
         JKwBkM/fPZtPSHyMZ0VWbVSCeh02efVjMwB4hW0we2uMi6zBcgrJPLg9mxQCopR4CK
         VfVOAsIQeuNnstvAEvVunbRjcCUJ8mLV0noaxS1AvVEd90UGPZsP6KYSx6spK3mvTw
         e5gVakDZzk9PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>, David Disseldorp <ddiss@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/27] VFS: filename_create(): fix incorrect intent.
Date:   Tue, 19 Apr 2022 14:12:39 -0400
Message-Id: <20220419181242.485308-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NeilBrown <neilb@suse.de>

[ Upstream commit b3d4650d82c71b9c9a8184de9e8bb656012b289e ]

When asked to create a path ending '/', but which is not to be a
directory (LOOKUP_DIRECTORY not set), filename_create() will never try
to create the file.  If it doesn't exist, -ENOENT is reported.

However, it still passes LOOKUP_CREATE|LOOKUP_EXCL to the filesystems
->lookup() function, even though there is no intent to create.  This is
misleading and can cause incorrect behaviour.

If you try

   ln -s foo /path/dir/

where 'dir' is a directory on an NFS filesystem which is not currently
known in the dcache, this will fail with ENOENT.

But as the name is not in the dcache, nfs_lookup gets called with
LOOKUP_CREATE|LOOKUP_EXCL and so it returns NULL without performing any
lookup, with the expectation that a subsequent call to create the target
will be made, and the lookup can be combined with the creation.  In the
case with a trailing '/' and no LOOKUP_DIRECTORY, that call is never
made.  Instead filename_create() sees that the dentry is not (yet)
positive and returns -ENOENT - even though the directory actually
exists.

So only set LOOKUP_CREATE|LOOKUP_EXCL if there really is an intent to
create, and use the absence of these flags to decide if -ENOENT should
be returned.

Note that filename_parentat() is only interested in LOOKUP_REVAL, so we
split that out and store it in 'reval_flag'.  __lookup_hash() then gets
reval_flag combined with whatever create flags were determined to be
needed.

Reviewed-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3bb65f48fe1d..8882a70dc119 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3625,18 +3625,14 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 	struct qstr last;
+	bool want_dir = lookup_flags & LOOKUP_DIRECTORY;
+	unsigned int reval_flag = lookup_flags & LOOKUP_REVAL;
+	unsigned int create_flags = LOOKUP_CREATE | LOOKUP_EXCL;
 	int type;
 	int err2;
 	int error;
-	bool is_dir = (lookup_flags & LOOKUP_DIRECTORY);
 
-	/*
-	 * Note that only LOOKUP_REVAL and LOOKUP_DIRECTORY matter here. Any
-	 * other flags passed in are ignored!
-	 */
-	lookup_flags &= LOOKUP_REVAL;
-
-	error = filename_parentat(dfd, name, lookup_flags, path, &last, &type);
+	error = filename_parentat(dfd, name, reval_flag, path, &last, &type);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3650,11 +3646,13 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	/* don't fail immediately if it's r/o, at least try to report other errors */
 	err2 = mnt_want_write(path->mnt);
 	/*
-	 * Do the final lookup.
+	 * Do the final lookup.  Suppress 'create' if there is a trailing
+	 * '/', and a directory wasn't requested.
 	 */
-	lookup_flags |= LOOKUP_CREATE | LOOKUP_EXCL;
+	if (last.name[last.len] && !want_dir)
+		create_flags = 0;
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
-	dentry = __lookup_hash(&last, path->dentry, lookup_flags);
+	dentry = __lookup_hash(&last, path->dentry, reval_flag | create_flags);
 	if (IS_ERR(dentry))
 		goto unlock;
 
@@ -3668,7 +3666,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	 * all is fine. Let's be bastards - you had / on the end, you've
 	 * been asking for (non-existent) directory. -ENOENT for you.
 	 */
-	if (unlikely(!is_dir && last.name[last.len])) {
+	if (unlikely(!create_flags)) {
 		error = -ENOENT;
 		goto fail;
 	}
-- 
2.35.1

