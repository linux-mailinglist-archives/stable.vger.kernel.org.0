Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7472A2062F6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391430AbgFWUdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387641AbgFWUdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:33:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6059320836;
        Tue, 23 Jun 2020 20:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944431;
        bh=XwauqFNRoODA/WZXCoHKKjOuoIsjFMp1p3aBUa8Ss2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7F01gtIngVthzuYlq3kijI+xvbz0XtpmHWHh+4HK0gSZd+Z/WCL8Tzkj6o/gPEX+
         5mGuFD58xzcTgmGB833G5feEBI23mxh0haspPrSrjkyNTVfvN6zlrN+S8SL/1wr6f6
         hM0qvrNYCEWyXVmbbo5tPQ4I2pGxnOFAz1OBj+/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 295/314] f2fs: avoid utf8_strncasecmp() with unstable name
Date:   Tue, 23 Jun 2020 21:58:10 +0200
Message-Id: <20200623195353.041110423@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit fc3bb095ab02b9e7d89a069ade2cead15c64c504 ]

If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
it may be concurrently modified by a rename.  This can cause undefined
behavior (possibly out-of-bounds memory accesses or crashes) in
utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
that may be concurrently modified.

Fix this by first copying the filename to a stack buffer if needed.
This way we get a stable snapshot of the filename.

Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 594c9ad774d23..e9af46dc06f72 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -1063,11 +1063,27 @@ static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
 	const struct inode *dir = READ_ONCE(parent->d_inode);
 	const struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
 	struct qstr entry = QSTR_INIT(str, len);
+	char strbuf[DNAME_INLINE_LEN];
 	int res;
 
 	if (!dir || !IS_CASEFOLDED(dir))
 		goto fallback;
 
+	/*
+	 * If the dentry name is stored in-line, then it may be concurrently
+	 * modified by a rename.  If this happens, the VFS will eventually retry
+	 * the lookup, so it doesn't matter what ->d_compare() returns.
+	 * However, it's unsafe to call utf8_strncasecmp() with an unstable
+	 * string.  Therefore, we have to copy the name into a temporary buffer.
+	 */
+	if (len <= DNAME_INLINE_LEN - 1) {
+		memcpy(strbuf, str, len);
+		strbuf[len] = 0;
+		entry.name = strbuf;
+		/* prevent compiler from optimizing out the temporary buffer */
+		barrier();
+	}
+
 	res = utf8_strncasecmp(sbi->s_encoding, name, &entry);
 	if (res >= 0)
 		return res;
-- 
2.25.1



