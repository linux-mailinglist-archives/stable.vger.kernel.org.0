Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11242062D4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403798AbgFWUep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403780AbgFWUeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2082064B;
        Tue, 23 Jun 2020 20:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944483;
        bh=mNAqe4AAWuLpekWLPmDNKicXfxxl5xyq6wK1JpFziKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7Wpl64+68tRTSqtV9xy5N8uqH4LvRymwzHulO+FZnTb+yfSr2zJLQ1/4fxOUgVPE
         ZQdZczPsIfsdN3LK+1Vzvan02J/rTRZw1kPD8el+Be6lEDENg6ehSOZVepuEUXXnDJ
         hl7SamdCI2XdW6O4U8CpsybT2++Z4EFk4syusieI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 294/314] f2fs: split f2fs_d_compare() from f2fs_match_name()
Date:   Tue, 23 Jun 2020 21:58:09 +0200
Message-Id: <20200623195352.992234491@linuxfoundation.org>
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

[ Upstream commit f874fa1c7c7905c1744a2037a11516558ed00a81 ]

Sharing f2fs_ci_compare() between comparing cached dentries
(f2fs_d_compare()) and comparing on-disk dentries (f2fs_match_name())
doesn't work as well as intended, as these actions fundamentally differ
in several ways (e.g. whether the task may sleep, whether the directory
is stable, whether the casefolded name was precomputed, whether the
dentry will need to be decrypted once we allow casefold+encrypt, etc.)

Just make f2fs_d_compare() implement what it needs directly, and rework
f2fs_ci_compare() to be specialized for f2fs_match_name().

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c  | 70 +++++++++++++++++++++++++-------------------------
 fs/f2fs/f2fs.h |  5 ----
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 84280ad3786c3..594c9ad774d23 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -107,36 +107,28 @@ static struct f2fs_dir_entry *find_in_block(struct inode *dir,
 /*
  * Test whether a case-insensitive directory entry matches the filename
  * being searched for.
- *
- * Returns: 0 if the directory entry matches, more than 0 if it
- * doesn't match or less than zero on error.
  */
-int f2fs_ci_compare(const struct inode *parent, const struct qstr *name,
-				const struct qstr *entry, bool quick)
+static bool f2fs_match_ci_name(const struct inode *dir, const struct qstr *name,
+			       const struct qstr *entry, bool quick)
 {
-	const struct f2fs_sb_info *sbi = F2FS_SB(parent->i_sb);
+	const struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	const struct unicode_map *um = sbi->s_encoding;
-	int ret;
+	int res;
 
 	if (quick)
-		ret = utf8_strncasecmp_folded(um, name, entry);
+		res = utf8_strncasecmp_folded(um, name, entry);
 	else
-		ret = utf8_strncasecmp(um, name, entry);
-
-	if (ret < 0) {
-		/* Handle invalid character sequence as either an error
-		 * or as an opaque byte sequence.
+		res = utf8_strncasecmp(um, name, entry);
+	if (res < 0) {
+		/*
+		 * In strict mode, ignore invalid names.  In non-strict mode,
+		 * fall back to treating them as opaque byte sequences.
 		 */
-		if (f2fs_has_strict_mode(sbi))
-			return -EINVAL;
-
-		if (name->len != entry->len)
-			return 1;
-
-		return !!memcmp(name->name, entry->name, name->len);
+		if (f2fs_has_strict_mode(sbi) || name->len != entry->len)
+			return false;
+		return !memcmp(name->name, entry->name, name->len);
 	}
-
-	return ret;
+	return res == 0;
 }
 
 static void f2fs_fname_setup_ci_filename(struct inode *dir,
@@ -188,10 +180,10 @@ static inline bool f2fs_match_name(struct f2fs_dentry_ptr *d,
 		if (cf_str->name) {
 			struct qstr cf = {.name = cf_str->name,
 					  .len = cf_str->len};
-			return !f2fs_ci_compare(parent, &cf, &entry, true);
+			return f2fs_match_ci_name(parent, &cf, &entry, true);
 		}
-		return !f2fs_ci_compare(parent, fname->usr_fname, &entry,
-					false);
+		return f2fs_match_ci_name(parent, fname->usr_fname, &entry,
+					  false);
 	}
 #endif
 	if (fscrypt_match_name(fname, d->filename[bit_pos],
@@ -1067,17 +1059,25 @@ const struct file_operations f2fs_dir_operations = {
 static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
 			  const char *str, const struct qstr *name)
 {
-	struct qstr qstr = {.name = str, .len = len };
 	const struct dentry *parent = READ_ONCE(dentry->d_parent);
-	const struct inode *inode = READ_ONCE(parent->d_inode);
-
-	if (!inode || !IS_CASEFOLDED(inode)) {
-		if (len != name->len)
-			return -1;
-		return memcmp(str, name->name, len);
-	}
-
-	return f2fs_ci_compare(inode, name, &qstr, false);
+	const struct inode *dir = READ_ONCE(parent->d_inode);
+	const struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
+	struct qstr entry = QSTR_INIT(str, len);
+	int res;
+
+	if (!dir || !IS_CASEFOLDED(dir))
+		goto fallback;
+
+	res = utf8_strncasecmp(sbi->s_encoding, name, &entry);
+	if (res >= 0)
+		return res;
+
+	if (f2fs_has_strict_mode(sbi))
+		return -EINVAL;
+fallback:
+	if (len != name->len)
+		return 1;
+	return !!memcmp(str, name->name, len);
 }
 
 static int f2fs_d_hash(const struct dentry *dentry, struct qstr *str)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c22ca7d867ee5..03693d6b1c104 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2954,11 +2954,6 @@ int f2fs_update_extension_list(struct f2fs_sb_info *sbi, const char *name,
 							bool hot, bool set);
 struct dentry *f2fs_get_parent(struct dentry *child);
 
-extern int f2fs_ci_compare(const struct inode *parent,
-			   const struct qstr *name,
-			   const struct qstr *entry,
-			   bool quick);
-
 /*
  * dir.c
  */
-- 
2.25.1



