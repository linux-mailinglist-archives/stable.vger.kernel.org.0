Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F3B65BBF2
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbjACIQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbjACIQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:16:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19445D74
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA592611F0
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA62C433D2;
        Tue,  3 Jan 2023 08:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733788;
        bh=aBm3ApcZI9UFeIsD9Lq0LSq5qH09kJkU4tFJlLuRHpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PSUeWtQURN0tykpalR6b8ogwqES6+ivs1KSjxyfhcGO9GMjyft1w6wOEhwu/qLQp
         MjgAkA/WzR27g+2WQo7WwpL6pMKAYoIlA5SCQgz7mtfeS7GXAx0pjOzbyKtyaVsk9Y
         euCyK8UP5UfdQJqfFp/6xo7JCbmqt5KLsJSwiJuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 12/63] fs: make do_renameat2() take struct filename
Date:   Tue,  3 Jan 2023 09:13:42 +0100
Message-Id: <20230103081309.296158854@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit e886663cfd029b64a1d8da7efae7014526d884e9 ]

Pass in the struct filename pointers instead of the user string, and
update the three callers to do the same.

This behaves like do_unlinkat(), which also takes a filename struct and
puts it when it is done. Converting callers is then trivial.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/internal.h |    2 ++
 fs/namei.c    |   40 ++++++++++++++++++++++------------------
 2 files changed, 24 insertions(+), 18 deletions(-)

--- a/fs/internal.h
+++ b/fs/internal.h
@@ -77,6 +77,8 @@ extern int vfs_path_lookup(struct dentry
 long do_rmdir(int dfd, struct filename *name);
 long do_unlinkat(int dfd, struct filename *name);
 int may_linkat(struct path *link);
+int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
+		 struct filename *newname, unsigned int flags);
 
 /*
  * namespace.c
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4353,8 +4353,8 @@ out:
 }
 EXPORT_SYMBOL(vfs_rename);
 
-static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
-			const char __user *newname, unsigned int flags)
+int do_renameat2(int olddfd, struct filename *from, int newdfd,
+		 struct filename *to, unsigned int flags)
 {
 	struct dentry *old_dentry, *new_dentry;
 	struct dentry *trap;
@@ -4362,32 +4362,30 @@ static int do_renameat2(int olddfd, cons
 	struct qstr old_last, new_last;
 	int old_type, new_type;
 	struct inode *delegated_inode = NULL;
-	struct filename *from;
-	struct filename *to;
 	unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
 	bool should_retry = false;
-	int error;
+	int error = -EINVAL;
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
-		return -EINVAL;
+		goto put_both;
 
 	if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
 	    (flags & RENAME_EXCHANGE))
-		return -EINVAL;
+		goto put_both;
 
 	if (flags & RENAME_EXCHANGE)
 		target_flags = 0;
 
 retry:
-	from = filename_parentat(olddfd, getname(oldname), lookup_flags,
-				&old_path, &old_last, &old_type);
+	from = filename_parentat(olddfd, from, lookup_flags, &old_path,
+					&old_last, &old_type);
 	if (IS_ERR(from)) {
 		error = PTR_ERR(from);
-		goto exit;
+		goto put_new;
 	}
 
-	to = filename_parentat(newdfd, getname(newname), lookup_flags,
-				&new_path, &new_last, &new_type);
+	to = filename_parentat(newdfd, to, lookup_flags, &new_path, &new_last,
+				&new_type);
 	if (IS_ERR(to)) {
 		error = PTR_ERR(to);
 		goto exit1;
@@ -4480,34 +4478,40 @@ exit2:
 	if (retry_estale(error, lookup_flags))
 		should_retry = true;
 	path_put(&new_path);
-	putname(to);
 exit1:
 	path_put(&old_path);
-	putname(from);
 	if (should_retry) {
 		should_retry = false;
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
-exit:
+put_both:
+	if (!IS_ERR(from))
+		putname(from);
+put_new:
+	if (!IS_ERR(to))
+		putname(to);
 	return error;
 }
 
 SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname, unsigned int, flags)
 {
-	return do_renameat2(olddfd, oldname, newdfd, newname, flags);
+	return do_renameat2(olddfd, getname(oldname), newdfd, getname(newname),
+				flags);
 }
 
 SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
-	return do_renameat2(olddfd, oldname, newdfd, newname, 0);
+	return do_renameat2(olddfd, getname(oldname), newdfd, getname(newname),
+				0);
 }
 
 SYSCALL_DEFINE2(rename, const char __user *, oldname, const char __user *, newname)
 {
-	return do_renameat2(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
+	return do_renameat2(AT_FDCWD, getname(oldname), AT_FDCWD,
+				getname(newname), 0);
 }
 
 int readlink_copy(char __user *buffer, int buflen, const char *link)


