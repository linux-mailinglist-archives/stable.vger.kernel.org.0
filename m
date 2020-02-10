Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DD21574FD
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgBJMhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbgBJMhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:36 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9246220838;
        Mon, 10 Feb 2020 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338255;
        bh=pvXCsyRHbU9tNVQZSuxGdamKCzJLEeukXOM06HFnp1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWv49gHZ3+4airTnkPXvaXWzOW0gDkXWt1n5Kzulu1dRpEA5iOv8UjQuuLGlISJPW
         4GdzPMsVKIHdugvHmdMU+E1p1Gagqfez8QwkaC6ElB+07xcnkZS+9S+iAF7uCLlBsk
         nPG0ZTcV9r9JVWSU2r3PD0aPG7aWq5s/mqJ6aseU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 122/309] f2fs: fix race conditions in ->d_compare() and ->d_hash()
Date:   Mon, 10 Feb 2020 04:31:18 -0800
Message-Id: <20200210122418.192001310@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 80f2388afa6ef985f9c5c228e36705c4d4db4756 upstream.

Since ->d_compare() and ->d_hash() can be called in RCU-walk mode,
->d_parent and ->d_inode can be concurrently modified, and in
particular, ->d_inode may be changed to NULL.  For f2fs_d_hash() this
resulted in a reproducible NULL dereference if a lookup is done in a
directory being deleted, e.g. with:

	int main()
	{
		if (fork()) {
			for (;;) {
				mkdir("subdir", 0700);
				rmdir("subdir");
			}
		} else {
			for (;;)
				access("subdir/file", 0);
		}
	}

... or by running the 't_encrypted_d_revalidate' program from xfstests.
Both repros work in any directory on a filesystem with the encoding
feature, even if the directory doesn't actually have the casefold flag.

I couldn't reproduce a crash in f2fs_d_compare(), but it appears that a
similar crash is possible there.

Fix these bugs by reading ->d_parent and ->d_inode using READ_ONCE() and
falling back to the case sensitive behavior if the inode is NULL.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/dir.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -1068,24 +1068,27 @@ static int f2fs_d_compare(const struct d
 			  const char *str, const struct qstr *name)
 {
 	struct qstr qstr = {.name = str, .len = len };
+	const struct dentry *parent = READ_ONCE(dentry->d_parent);
+	const struct inode *inode = READ_ONCE(parent->d_inode);
 
-	if (!IS_CASEFOLDED(dentry->d_parent->d_inode)) {
+	if (!inode || !IS_CASEFOLDED(inode)) {
 		if (len != name->len)
 			return -1;
 		return memcmp(str, name->name, len);
 	}
 
-	return f2fs_ci_compare(dentry->d_parent->d_inode, name, &qstr, false);
+	return f2fs_ci_compare(inode, name, &qstr, false);
 }
 
 static int f2fs_d_hash(const struct dentry *dentry, struct qstr *str)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
 	const struct unicode_map *um = sbi->s_encoding;
+	const struct inode *inode = READ_ONCE(dentry->d_inode);
 	unsigned char *norm;
 	int len, ret = 0;
 
-	if (!IS_CASEFOLDED(dentry->d_inode))
+	if (!inode || !IS_CASEFOLDED(inode))
 		return 0;
 
 	norm = f2fs_kmalloc(sbi, PATH_MAX, GFP_ATOMIC);


