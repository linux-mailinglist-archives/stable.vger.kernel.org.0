Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0811D0E6B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbgEMKAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387798AbgEMJw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E9B20740;
        Wed, 13 May 2020 09:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363548;
        bh=8BrPbkyC/yqgOYLEP9Es204DPM/VFXPE8zBaObCClVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqU8ZfnzMUgVJuXZOn0SDnVaJ3nV129cK7gGYrpOeJf6PebCVGXpnboTHPofYs5bk
         aoxVHROuwENgFWWNga9W7NKfTupS7byJXGE+7fOrou342YydxnRw02kzFX9U9ccs2I
         62boPoERjsNQsqHtWH/DkqVEgo1N7TB4xNo8t0+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.6 007/118] ext4: dont set dioread_nolock by default for blocksize < pagesize
Date:   Wed, 13 May 2020 11:43:46 +0200
Message-Id: <20200513094418.289827916@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 626b035b816b61a7a7b4d2205a6807e2f11a18c1 upstream.

Currently on calling echo 3 > drop_caches on host machine, we see
FS corruption in the guest. This happens on Power machine where
blocksize < pagesize.

So as a temporary workaound don't enable dioread_nolock by default
for blocksize < pagesize until we identify the root cause.

Also emit a warning msg in case if this mount option is manually
enabled for blocksize < pagesize.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20200327200744.12473-1-riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 446158ab507dd..70796de7c4682 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2181,6 +2181,14 @@ static int parse_options(char *options, struct super_block *sb,
 		}
 	}
 #endif
+	if (test_opt(sb, DIOREAD_NOLOCK)) {
+		int blocksize =
+			BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
+		if (blocksize < PAGE_SIZE)
+			ext4_msg(sb, KERN_WARNING, "Warning: mounting with an "
+				 "experimental mount option 'dioread_nolock' "
+				 "for blocksize < PAGE_SIZE");
+	}
 	return 1;
 }
 
@@ -3787,7 +3795,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, NO_UID32);
 	/* xattr user namespace & acls are now defaulted on */
 	set_opt(sb, XATTR_USER);
-	set_opt(sb, DIOREAD_NOLOCK);
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
@@ -3837,6 +3844,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
+
+	if (blocksize == PAGE_SIZE)
+		set_opt(sb, DIOREAD_NOLOCK);
+
 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
 		ext4_msg(sb, KERN_ERR,
-- 
2.20.1



