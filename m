Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF72364C59
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbhDSUud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 16:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243119AbhDSUsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 16:48:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D6B6613C5;
        Mon, 19 Apr 2021 20:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865153;
        bh=5ZcHCJZs08nASXkYcwsWOrqtzik80cVFmrMQvm/bBOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVQUubggCXv6ZB6pjVf3Sx8/A3LB2mZY/X0XXbPTFQ7Dq1TKXCqa4UtciYlKJquXm
         bjBoMtpaSJR29ug7XS4XoRB2LuXtnvF6HN/dO9Y23RVjfbwhTiOYzazj9gaYy11Q52
         dEk32AdgQSlrYmwGULZWQij7Lwg9VBKJhzcgpm1IDu1gnT2zQD6SVXbVFEq+KqSXVZ
         PvGeqxAmCjFIQ88Wy47y2huv8F2V5CJZ+5mqVaRlzM97aeNPkngp9D8qoxueeqQrcV
         gOEr7rtd38psuqGeRoRvnUVLBaYejZl2xuzI9uyZrRDw47wbBZLP2wZhQ8gzxA+4q/
         E+4tCKk0Qyaog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/11] readdir: make sure to verify directory entry for legacy interfaces too
Date:   Mon, 19 Apr 2021 16:45:36 -0400
Message-Id: <20210419204536.6924-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204536.6924-1-sashal@kernel.org>
References: <20210419204536.6924-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 0c93ac69407d63a85be0129aa55ffaec27ffebd3 ]

This does the directory entry name verification for the legacy
"fillonedir" (and compat) interface that goes all the way back to the
dark ages before we had a proper dirent, and the readdir() system call
returned just a single entry at a time.

Nobody should use this interface unless you still have binaries from
1991, but let's do it right.

This came up during discussions about unsafe_copy_to_user() and proper
checking of all the inputs to it, as the networking layer is looking to
use it in a few new places.  So let's make sure the _old_ users do it
all right and proper, before we add new ones.

See also commit 8a23eb804ca4 ("Make filldir[64]() verify the directory
entry filename is valid") which did the proper modern interfaces that
people actually use. It had a note:

    Note that I didn't bother adding the checks to any legacy interfaces
    that nobody uses.

which this now corrects.  Note that we really don't care about POSIX and
the presense of '/' in a directory entry, but verify_dirent_name() also
ends up doing the proper name length verification which is what the
input checking discussion was about.

[ Another option would be to remove the support for this particular very
  old interface: any binaries that use it are likely a.out binaries, and
  they will no longer run anyway since we removed a.out binftm support
  in commit eac616557050 ("x86: Deprecate a.out support").

  But I'm not sure which came first: getdents() or ELF support, so let's
  pretend somebody might still have a working binary that uses the
  legacy readdir() case.. ]

Link: https://lore.kernel.org/lkml/CAHk-=wjbvzCAhAtvG0d81W5o0-KT5PPTHhfJ5ieDFq+bGtgOYg@mail.gmail.com/
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/readdir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/readdir.c b/fs/readdir.c
index 0c357663e33a..e6f4c7b8884b 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -133,6 +133,9 @@ static int fillonedir(struct dir_context *ctx, const char *name, int namlen,
 
 	if (buf->result)
 		return -EINVAL;
+	buf->result = verify_dirent_name(name, namlen);
+	if (buf->result < 0)
+		return buf->result;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
@@ -392,6 +395,9 @@ static int compat_fillonedir(struct dir_context *ctx, const char *name,
 
 	if (buf->result)
 		return -EINVAL;
+	buf->result = verify_dirent_name(name, namlen);
+	if (buf->result < 0)
+		return buf->result;
 	d_ino = ino;
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
-- 
2.30.2

