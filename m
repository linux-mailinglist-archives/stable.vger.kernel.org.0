Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7E9353F46
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbhDEJKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239448AbhDEJKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 530D561393;
        Mon,  5 Apr 2021 09:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613843;
        bh=uW6oDUm5OGgrAlcJAqE/N3uUNnNkdl5IGSMnsyGW+o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/MbzaQ+CzbQgj1vJYdbLipyPBXX7jIaLoS54WHrFbessS8MmElBQx1HWrba71MyG
         fHxB5ZZodFk49lpXHeKUNjuBwqjEMHu9wp1OxfvEW+aG+6HJDdYomQNbUuAzMe2J+3
         RVFjUfLPe1e74+caoAFZvGNOWaUC67wo82rjSZDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot <syzbot+690cb1e51970435f9775@syzkaller.appspotmail.com>
Subject: [PATCH 5.10 076/126] reiserfs: update reiserfs_xattrs_initialized() condition
Date:   Mon,  5 Apr 2021 10:53:58 +0200
Message-Id: <20210405085033.584694955@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 5e46d1b78a03d52306f21f77a4e4a144b6d31486 upstream.

syzbot is reporting NULL pointer dereference at reiserfs_security_init()
[1], for commit ab17c4f02156c4f7 ("reiserfs: fixup xattr_root caching")
is assuming that REISERFS_SB(s)->xattr_root != NULL in
reiserfs_xattr_jcreate_nblocks() despite that commit made
REISERFS_SB(sb)->priv_root != NULL && REISERFS_SB(s)->xattr_root == NULL
case possible.

I guess that commit 6cb4aff0a77cc0e6 ("reiserfs: fix oops while creating
privroot with selinux enabled") wanted to check xattr_root != NULL
before reiserfs_xattr_jcreate_nblocks(), for the changelog is talking
about the xattr root.

  The issue is that while creating the privroot during mount
  reiserfs_security_init calls reiserfs_xattr_jcreate_nblocks which
  dereferences the xattr root. The xattr root doesn't exist, so we get
  an oops.

Therefore, update reiserfs_xattrs_initialized() to check both the
privroot and the xattr root.

Link: https://syzkaller.appspot.com/bug?id=8abaedbdeb32c861dc5340544284167dd0e46cde # [1]
Reported-and-tested-by: syzbot <syzbot+690cb1e51970435f9775@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 6cb4aff0a77c ("reiserfs: fix oops while creating privroot with selinux enabled")
Acked-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Jan Kara <jack@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/reiserfs/xattr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/reiserfs/xattr.h
+++ b/fs/reiserfs/xattr.h
@@ -43,7 +43,7 @@ void reiserfs_security_free(struct reise
 
 static inline int reiserfs_xattrs_initialized(struct super_block *sb)
 {
-	return REISERFS_SB(sb)->priv_root != NULL;
+	return REISERFS_SB(sb)->priv_root && REISERFS_SB(sb)->xattr_root;
 }
 
 #define xattr_size(size) ((size) + sizeof(struct reiserfs_xattr_header))


