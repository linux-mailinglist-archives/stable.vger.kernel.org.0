Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E281E8E16
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 08:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgE3GD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 02:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgE3GD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 May 2020 02:03:57 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 433992074B;
        Sat, 30 May 2020 06:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590818636;
        bh=ZjvXFGk6rT4s5wC0wE1lNel4D/QY9srvqLSKGJm/CMQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lrrRsyP3m82WxwlvHO9HOUuF4RzTghWlEE3l0OFetv2TQkg7uhz4TVNe0Bk6xs2VI
         4CMZL/fywTNgYXdJLGngqdLfOz88VTgM3TcUTvC6d2FVhertFysLnyOoMAIan8eqST
         bmxOUtL38U5flFgxIvL1i8zsdpWJSVBHNcBujMjM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH] ext4: avoid utf8_strncasecmp() with unstable name
Date:   Fri, 29 May 2020 23:02:16 -0700
Message-Id: <20200530060216.221456-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
it may be concurrently modified by a rename.  This can cause undefined
behavior (possibly out-of-bounds memory accesses or crashes) in
utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
that may be concurrently modified.

Fix this by first copying the filename to a stack buffer if needed.
This way we get a stable snapshot of the filename.

Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
Cc: <stable@vger.kernel.org> # v5.2+
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/dir.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index c654205f648dd..19aef8328bb18 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -675,6 +675,7 @@ static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
 	struct qstr qstr = {.name = str, .len = len };
 	const struct dentry *parent = READ_ONCE(dentry->d_parent);
 	const struct inode *inode = READ_ONCE(parent->d_inode);
+	char strbuf[DNAME_INLINE_LEN];
 
 	if (!inode || !IS_CASEFOLDED(inode) ||
 	    !EXT4_SB(inode->i_sb)->s_encoding) {
@@ -683,6 +684,22 @@ static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
 		return memcmp(str, name->name, len);
 	}
 
+	/*
+	 * If the dentry name is stored in-line, then it may be concurrently
+	 * modified by a rename.  If this happens, the VFS will eventually retry
+	 * the lookup, so it doesn't matter what ->d_compare() returns.
+	 * However, it's unsafe to call utf8_strncasecmp() with an unstable
+	 * string.  Therefore, we have to copy the name into a temporary buffer.
+	 */
+	if (len <= DNAME_INLINE_LEN - 1) {
+		unsigned int i;
+
+		for (i = 0; i < len; i++)
+			strbuf[i] = READ_ONCE(str[i]);
+		strbuf[len] = 0;
+		qstr.name = strbuf;
+	}
+
 	return ext4_ci_compare(inode, name, &qstr, false);
 }
 
-- 
2.26.2

