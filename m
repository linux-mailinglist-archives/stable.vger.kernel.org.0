Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E5D2E6A36
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgL1S4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728860AbgL1S4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:56:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5EB22AEC;
        Mon, 28 Dec 2020 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181729;
        bh=JPIVqHrwI805Fv5QGEULkWZfbaFWNrc2Kf/PlJACkgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cddWmyMiZ4aPntME6wgF00kFSRnc4Boim1a/D5McIpUMOPhDHlUNixCFYwj7SccGs
         aA6jl1htDWjzpUBq8+iLhI9LRtasDJzn7z1Lh4yF9gxwdbhh23EL4YVmsJ1qbFqH3W
         l7lPIodxkWeCG+5xgjBKnaC/wMS40gDPqZGoNPfjWX9R0sgE2jBlszZkGW92ImTnqK
         N7tDK81f6dUSxh5yOK/pqgrFUCL6rzpYa14C9xm9nQ4n3tKR0BhBvrqCIQCDhREY5G
         e9/qXmxcsKLxkzR3Ms5unhxmJVjhQ84aFRHiJdkk1ZPDkTrsbYpuDJhSmmHsCY2HQR
         NescGr006WjoQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 5.4 3/4] f2fs: prevent creating duplicate encrypted filenames
Date:   Mon, 28 Dec 2020 10:54:32 -0800
Message-Id: <20201228185433.61129-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228185433.61129-1-ebiggers@kernel.org>
References: <20201228185433.61129-1-ebiggers@kernel.org>
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
index 63440abe58c42..0ddc4a74b9d43 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2998,6 +2998,8 @@ bool f2fs_empty_dir(struct inode *dir);
 
 static inline int f2fs_add_link(struct dentry *dentry, struct inode *inode)
 {
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
 	return f2fs_do_add_link(d_inode(dentry->d_parent), &dentry->d_name,
 				inode, inode->i_ino, inode->i_mode);
 }
-- 
2.29.2

