Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB70750F658
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbiDZIzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347167AbiDZIvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:51:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B89174F56;
        Tue, 26 Apr 2022 01:39:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00B83B81D18;
        Tue, 26 Apr 2022 08:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9CEC385A0;
        Tue, 26 Apr 2022 08:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962373;
        bh=NTFmc6yUB3G/+inTJha6H7dnjf/aU7LUIJdiD7wZZfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Wha1JePcisWwDcSf3RWyFjQOfr3IxvjuF5nD5wK/ysW3ma2Ve3nGseoY51TVDgX6
         C+aNzXMj334g0SwEQSbFip5tYgcYhkOHqPhR05569Kfha62uqoeZj91NMKoCAh8au9
         HB1/2irR3v9ZmiRq1CWthZIORInWPBEF9dW/5QEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Jeff Layton <jlayton@kernel.org>, NeilBrown <neilb@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/124] VFS: filename_create(): fix incorrect intent.
Date:   Tue, 26 Apr 2022 10:21:14 +0200
Message-Id: <20220426081749.377215935@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



