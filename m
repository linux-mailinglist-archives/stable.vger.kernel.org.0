Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F273679A30
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbjAXNpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbjAXNot (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:44:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E828A46D46;
        Tue, 24 Jan 2023 05:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 893DA611D7;
        Tue, 24 Jan 2023 13:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0CAC433EF;
        Tue, 24 Jan 2023 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567777;
        bh=CH9l79iRr56ZSwumfQ0VkYDiEdL5p8519TJHKvsXIuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGlRA/T9E02TYT4JRQKUvXmMpXuQD1oF3pFUU8JZlsl8jj4JpEyDYdxP4S12UmwFI
         je8igMKBwkwkyvn9T+PjZLROMGJgCEf/2sCncPHzdgJFGJByD/2pCBD1bDNpAW2Hbj
         8b7u6FJcC0AdH6MJCvkuPUeicBhUoL16LBuyVbcL4Y3iDxEIfWytxoQ3Tc9C+oOHSh
         fcnJOpoLKE2LE8cXteZCTcUIBwJ6Cv6n8fBs+GFbFR39jIRUrUV3P7m9+JqVjhjSUi
         nVXviP5Ll49fF4rWzAgUncxpQbfaNPDHuLe+737+356muFPPeGQFq7ZpOTWx6sIt1d
         rC6WEE9df7MPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>,
        Jason Donenfeld <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 35/35] ext4: deal with legacy signed xattr name hash values
Date:   Tue, 24 Jan 2023 08:41:31 -0500
Message-Id: <20230124134131.637036-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit f3bbac32475b27f49be201f896d98d4009de1562 ]

We potentially have old hashes of the xattr names generated on systems
with signed 'char' types.  Now that everybody uses '-funsigned-char',
those hashes will no longer match.

This only happens if you use xattrs names that have the high bit set,
which probably doesn't happen in practice, but the xfstest generic/454
shows it.

Instead of adding a new "signed xattr hash filesystem" bit and having to
deal with all the possible combinations, just calculate the hash both
ways if the first one fails, and always generate new hashes with the
proper unsigned char version.

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202212291509.704a11c9-oliver.sang@intel.com
Link: https://lore.kernel.org/all/CAHk-=whUNjwqZXa-MH9KMmc_CpQpoFKFjAB9ZKHuu=TbsouT4A@mail.gmail.com/
Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Theodore Ts'o <tytso@mit.edu>,
Cc: Jason Donenfeld <Jason@zx2c4.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 866772a2e068..5f57a8addcbc 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -81,6 +81,8 @@ ext4_xattr_block_cache_find(struct inode *, struct ext4_xattr_header *,
 			    struct mb_cache_entry **);
 static __le32 ext4_xattr_hash_entry(char *name, size_t name_len, __le32 *value,
 				    size_t value_count);
+static __le32 ext4_xattr_hash_entry_signed(char *name, size_t name_len, __le32 *value,
+				    size_t value_count);
 static void ext4_xattr_rehash(struct ext4_xattr_header *);
 
 static const struct xattr_handler * const ext4_xattr_handler_map[] = {
@@ -470,8 +472,21 @@ ext4_xattr_inode_verify_hashes(struct inode *ea_inode,
 		tmp_data = cpu_to_le32(hash);
 		e_hash = ext4_xattr_hash_entry(entry->e_name, entry->e_name_len,
 					       &tmp_data, 1);
-		if (e_hash != entry->e_hash)
-			return -EFSCORRUPTED;
+		/* All good? */
+		if (e_hash == entry->e_hash)
+			return 0;
+
+		/*
+		 * Not good. Maybe the entry hash was calculated
+		 * using the buggy signed char version?
+		 */
+		e_hash = ext4_xattr_hash_entry_signed(entry->e_name, entry->e_name_len,
+							&tmp_data, 1);
+		if (e_hash == entry->e_hash)
+			return 0;
+
+		/* Still no match - bad */
+		return -EFSCORRUPTED;
 	}
 	return 0;
 }
@@ -3090,6 +3105,28 @@ static __le32 ext4_xattr_hash_entry(char *name, size_t name_len, __le32 *value,
 	return cpu_to_le32(hash);
 }
 
+/*
+ * ext4_xattr_hash_entry_signed()
+ *
+ * Compute the hash of an extended attribute incorrectly.
+ */
+static __le32 ext4_xattr_hash_entry_signed(char *name, size_t name_len, __le32 *value, size_t value_count)
+{
+	__u32 hash = 0;
+
+	while (name_len--) {
+		hash = (hash << NAME_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - NAME_HASH_SHIFT)) ^
+		       (signed char)*name++;
+	}
+	while (value_count--) {
+		hash = (hash << VALUE_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - VALUE_HASH_SHIFT)) ^
+		       le32_to_cpu(*value++);
+	}
+	return cpu_to_le32(hash);
+}
+
 #undef NAME_HASH_SHIFT
 #undef VALUE_HASH_SHIFT
 
-- 
2.39.0

