Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B680F2E6A5F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 20:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgL1TOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 14:14:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729000AbgL1TN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 14:13:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A51022B2C;
        Mon, 28 Dec 2020 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609182797;
        bh=IXmvQye9ZM3vzPLg/kY4jseJxfvpVBcbyPuNjzHTWF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQya9WijPGAu5QKp6aRvs3aDB653D8Hv76AV5phKUMDyWFMiaAg4MHTwjj1RBt+7M
         iyq/ZgVltry9M+5t2oZs30wMF/G6NKjpDSCP1XT4ZmTnB067VauLZvLoC91sIZm7iw
         rkxpkiOCBwKY6rs/hwNhLjIlse4VYM8/FyBwuFDsCrFl3caRxhXwwvflQNIoNXRn5N
         ZDtjg/qlyXGK7W8/kndpbTOxYKbUJvmR7QFeuUdu+YQ1SZCDndIiP2EQkHPrLdN9kJ
         gfuDSlv09IpTCUmUEzasmBHTocNpQCUBmrVFqWHIx7yE7hUOJk8jOcu73YMA8+60hO
         KxlKk0BLmhKuA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 4.19 3/4] f2fs: prevent creating duplicate encrypted filenames
Date:   Mon, 28 Dec 2020 11:12:10 -0800
Message-Id: <20201228191211.138300-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228191211.138300-1-ebiggers@kernel.org>
References: <20201228191211.138300-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit bfc2b7e8518999003a61f91c1deb5e88ed77b07d upstream.

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on f2fs by rejecting no-key dentries in f2fs_add_link().

Note that the weird check for the current task in f2fs_do_add_link()
seems to make this bug difficult to reproduce on f2fs.

Fixes: 9ea97163c6da ("f2fs crypto: add filename encryption for f2fs_add_link")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/f2fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 53ffa6fe207a3..aacd8e11758ca 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2857,6 +2857,8 @@ bool f2fs_empty_dir(struct inode *dir);
 
 static inline int f2fs_add_link(struct dentry *dentry, struct inode *inode)
 {
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
 	return f2fs_do_add_link(d_inode(dentry->d_parent), &dentry->d_name,
 				inode, inode->i_ino, inode->i_mode);
 }
-- 
2.29.2

