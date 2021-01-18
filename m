Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18122F9EA4
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390948AbhARLrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390768AbhARLql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 017CD22D6D;
        Mon, 18 Jan 2021 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970380;
        bh=ojR4t/mAT3JA9J1G/0MD/Csf5oOzfNgyvMT45KsYCdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haOxmQPw8fV8XUuROPXupv5QNLTsWf/o3a5ccd6SGPJO1aklg5yKGASHDirDzfJSq
         oTmnkjlMB4GsSA8leCyyQTHW3O1E+d47SYq6ywkkI2dcgm6ZZSbFBMC4/6NnMKSUgy
         w407Hq89uImdAKU7Iw//qkY2L7sOA5ezrLqb7RDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 138/152] umount(2): move the flag validity checks first
Date:   Mon, 18 Jan 2021 12:35:13 +0100
Message-Id: <20210118113359.337215714@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit a0a6df9afcaf439a6b4c88a3b522e3d05fdef46f upstream.

Unfortunately, there's userland code that used to rely upon these
checks being done before anything else to check for UMOUNT_NOFOLLOW
support.  That broke in 41525f56e256 ("fs: refactor ksys_umount").
Separate those from the rest of checks and move them to ksys_umount();
unlike everything else in there, this can be sanely done there.

Reported-by: Sargun Dhillon <sargun@sargun.me>
Fixes: 41525f56e256 ("fs: refactor ksys_umount")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1713,8 +1713,6 @@ static int can_umount(const struct path
 {
 	struct mount *mnt = real_mount(path->mnt);
 
-	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
-		return -EINVAL;
 	if (!may_mount())
 		return -EPERM;
 	if (path->dentry != path->mnt->mnt_root)
@@ -1728,6 +1726,7 @@ static int can_umount(const struct path
 	return 0;
 }
 
+// caller is responsible for flags being sane
 int path_umount(struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
@@ -1749,6 +1748,10 @@ static int ksys_umount(char __user *name
 	struct path path;
 	int ret;
 
+	// basic validity checks done first
+	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
+		return -EINVAL;
+
 	if (!(flags & UMOUNT_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
 	ret = user_path_at(AT_FDCWD, name, lookup_flags, &path);


