Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14E8205F73
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391376AbgFWUdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391370AbgFWUdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:33:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1957E206C3;
        Tue, 23 Jun 2020 20:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944381;
        bh=378uOhPw4trf/EYBvinGEcHsXnmJkRgo2SeAskqxB0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z40so3pc4HWYzB2CVLjVepYaKOaoQnjpKzqzU5BXUVrTT+V8sJb9Anu6DI3d0Tm29
         lbJQzCMY0LAigDq3FGwRteiKEVpzByC2Z1s2MnyJ5KMHj2QRYnp13McYifCttH+TQk
         KJh3AMwrJwaUfMQmHyXRuEhZyY70iC1udqwvlkFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 282/314] ext4: avoid utf8_strncasecmp() with unstable name
Date:   Tue, 23 Jun 2020 21:57:57 +0200
Message-Id: <20200623195352.429875944@linuxfoundation.org>
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

commit 2ce3ee931a097e9720310db3f09c01c825a4580c upstream.

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
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20200601200543.59417-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/dir.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -677,6 +677,7 @@ static int ext4_d_compare(const struct d
 	struct qstr qstr = {.name = str, .len = len };
 	const struct dentry *parent = READ_ONCE(dentry->d_parent);
 	const struct inode *inode = READ_ONCE(parent->d_inode);
+	char strbuf[DNAME_INLINE_LEN];
 
 	if (!inode || !IS_CASEFOLDED(inode) ||
 	    !EXT4_SB(inode->i_sb)->s_encoding) {
@@ -685,6 +686,21 @@ static int ext4_d_compare(const struct d
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
+		memcpy(strbuf, str, len);
+		strbuf[len] = 0;
+		qstr.name = strbuf;
+		/* prevent compiler from optimizing out the temporary buffer */
+		barrier();
+	}
+
 	return ext4_ci_compare(inode, name, &qstr, false);
 }
 


