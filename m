Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7DF540E31
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348485AbiFGSxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353702AbiFGSrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37ADE64E6;
        Tue,  7 Jun 2022 11:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE28618DF;
        Tue,  7 Jun 2022 18:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74F6C36B06;
        Tue,  7 Jun 2022 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624983;
        bh=VkynZOA0h323SuSUYQNwDkvDWJx5DvoY1YLda+2W2KE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1GQSPLtn1vZs71wirpGVBiCvvU3C1PLBl2VaLBYtgyObSHBECXPnPdE5JW46y1vZ
         YwMyxWDJlCjFYXieCtzr4QF91kYn2LpgMj1U6vEulUs0HBDUgEOb09YVYiO9055SOC
         GkkY8CFhFYf5Uwo95rzlfX1vTe5NKldRGYxqZp8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 522/667] f2fs: dont use casefolded comparison for "." and ".."
Date:   Tue,  7 Jun 2022 19:03:07 +0200
Message-Id: <20220607164950.358800824@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit b5639bb4313b9d455fc9fc4768d23a5e4ca8cb9d upstream.

Tryng to rename a directory that has all following properties fails with
EINVAL and triggers the 'WARN_ON_ONCE(!fscrypt_has_encryption_key(dir))'
in f2fs_match_ci_name():

    - The directory is casefolded
    - The directory is encrypted
    - The directory's encryption key is not yet set up
    - The parent directory is *not* encrypted

The problem is incorrect handling of the lookup of ".." to get the
parent reference to update.  fscrypt_setup_filename() treats ".." (and
".") specially, as it's never encrypted.  It's passed through as-is, and
setting up the directory's key is not attempted.  As the name isn't a
no-key name, f2fs treats it as a "normal" name and attempts a casefolded
comparison.  That breaks the assumption of the WARN_ON_ONCE() in
f2fs_match_ci_name() which assumes that for encrypted directories,
casefolded comparisons only happen when the directory's key is set up.

We could just remove this WARN_ON_ONCE().  However, since casefolding is
always a no-op on "." and ".." anyway, let's instead just not casefold
these names.  This results in the standard bytewise comparison.

Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c  |    3 ++-
 fs/f2fs/f2fs.h |   10 +++++-----
 fs/f2fs/hash.c |   11 ++++++-----
 3 files changed, 13 insertions(+), 11 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -82,7 +82,8 @@ int f2fs_init_casefolded_name(const stru
 #ifdef CONFIG_UNICODE
 	struct super_block *sb = dir->i_sb;
 
-	if (IS_CASEFOLDED(dir)) {
+	if (IS_CASEFOLDED(dir) &&
+	    !is_dot_dotdot(fname->usr_fname->name, fname->usr_fname->len)) {
 		fname->cf_name.name = f2fs_kmem_cache_alloc(f2fs_cf_name_slab,
 					GFP_NOFS, false, F2FS_SB(sb));
 		if (!fname->cf_name.name)
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -488,11 +488,11 @@ struct f2fs_filename {
 #ifdef CONFIG_UNICODE
 	/*
 	 * For casefolded directories: the casefolded name, but it's left NULL
-	 * if the original name is not valid Unicode, if the directory is both
-	 * casefolded and encrypted and its encryption key is unavailable, or if
-	 * the filesystem is doing an internal operation where usr_fname is also
-	 * NULL.  In all these cases we fall back to treating the name as an
-	 * opaque byte sequence.
+	 * if the original name is not valid Unicode, if the original name is
+	 * "." or "..", if the directory is both casefolded and encrypted and
+	 * its encryption key is unavailable, or if the filesystem is doing an
+	 * internal operation where usr_fname is also NULL.  In all these cases
+	 * we fall back to treating the name as an opaque byte sequence.
 	 */
 	struct fscrypt_str cf_name;
 #endif
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -91,7 +91,7 @@ static u32 TEA_hash_name(const u8 *p, si
 /*
  * Compute @fname->hash.  For all directories, @fname->disk_name must be set.
  * For casefolded directories, @fname->usr_fname must be set, and also
- * @fname->cf_name if the filename is valid Unicode.
+ * @fname->cf_name if the filename is valid Unicode and is not "." or "..".
  */
 void f2fs_hash_filename(const struct inode *dir, struct f2fs_filename *fname)
 {
@@ -110,10 +110,11 @@ void f2fs_hash_filename(const struct ino
 		/*
 		 * If the casefolded name is provided, hash it instead of the
 		 * on-disk name.  If the casefolded name is *not* provided, that
-		 * should only be because the name wasn't valid Unicode, so fall
-		 * back to treating the name as an opaque byte sequence.  Note
-		 * that to handle encrypted directories, the fallback must use
-		 * usr_fname (plaintext) rather than disk_name (ciphertext).
+		 * should only be because the name wasn't valid Unicode or was
+		 * "." or "..", so fall back to treating the name as an opaque
+		 * byte sequence.  Note that to handle encrypted directories,
+		 * the fallback must use usr_fname (plaintext) rather than
+		 * disk_name (ciphertext).
 		 */
 		WARN_ON_ONCE(!fname->usr_fname->name);
 		if (fname->cf_name.name) {


