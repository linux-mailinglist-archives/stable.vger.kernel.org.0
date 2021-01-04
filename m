Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD04C2E99CE
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbhADQD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729138AbhADQD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5A4D21D93;
        Mon,  4 Jan 2021 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776193;
        bh=IeqvedZQoajx3onpyRqj2gX75TbOTpThd76FhbG/QN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBrRKnF2/ioxJWfpJYiVaxS3TuH7agORQLj9sMZ5hOmNSASFhXV+cdxpPBXWYw+7A
         LYY8SMHQoAyIsgABNk3lRPVjRA2rvD3i9aAvyFv9Ar15bmvdYybAZ+Nm119Ljci0EA
         +fugmAG9P9i8m2EvmFOuTDsqti1wOLhfCY5JRaj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        syzbot+345b75652b1d24227443@syzkaller.appspotmail.com
Subject: [PATCH 5.10 36/63] ext4: check for invalid block size early when mounting a file system
Date:   Mon,  4 Jan 2021 16:57:29 +0100
Message-Id: <20210104155710.573205321@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit c9200760da8a728eb9767ca41a956764b28c1310 upstream.

Check for valid block size directly by validating s_log_block_size; we
were doing this in two places.  First, by calculating blocksize via
BLOCK_SIZE << s_log_block_size, and then checking that the blocksize
was valid.  And then secondly, by checking s_log_block_size directly.

The first check is not reliable, and can trigger an UBSAN warning if
s_log_block_size on a maliciously corrupted superblock is greater than
22.  This is harmless, since the second test will correctly reject the
maliciously fuzzed file system, but to make syzbot shut up, and
because the two checks are duplicative in any case, delete the
blocksize check, and move the s_log_block_size earlier in
ext4_fill_super().

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+345b75652b1d24227443@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4186,18 +4186,25 @@ static int ext4_fill_super(struct super_
 	 */
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
-	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
-
-	if (blocksize == PAGE_SIZE)
-		set_opt(sb, DIOREAD_NOLOCK);
-
-	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
-	    blocksize > EXT4_MAX_BLOCK_SIZE) {
+	if (le32_to_cpu(es->s_log_block_size) >
+	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
 		ext4_msg(sb, KERN_ERR,
-		       "Unsupported filesystem blocksize %d (%d log_block_size)",
-			 blocksize, le32_to_cpu(es->s_log_block_size));
+			 "Invalid log block size: %u",
+			 le32_to_cpu(es->s_log_block_size));
 		goto failed_mount;
 	}
+	if (le32_to_cpu(es->s_log_cluster_size) >
+	    (EXT4_MAX_CLUSTER_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Invalid log cluster size: %u",
+			 le32_to_cpu(es->s_log_cluster_size));
+		goto failed_mount;
+	}
+
+	blocksize = EXT4_MIN_BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
+
+	if (blocksize == PAGE_SIZE)
+		set_opt(sb, DIOREAD_NOLOCK);
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
 		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
@@ -4416,21 +4423,6 @@ static int ext4_fill_super(struct super_
 	if (!ext4_feature_set_ok(sb, (sb_rdonly(sb))))
 		goto failed_mount;
 
-	if (le32_to_cpu(es->s_log_block_size) >
-	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Invalid log block size: %u",
-			 le32_to_cpu(es->s_log_block_size));
-		goto failed_mount;
-	}
-	if (le32_to_cpu(es->s_log_cluster_size) >
-	    (EXT4_MAX_CLUSTER_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Invalid log cluster size: %u",
-			 le32_to_cpu(es->s_log_cluster_size));
-		goto failed_mount;
-	}
-
 	if (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) > (blocksize / 4)) {
 		ext4_msg(sb, KERN_ERR,
 			 "Number of reserved GDT blocks insanely large: %d",


