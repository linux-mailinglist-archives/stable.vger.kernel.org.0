Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B32C093A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388469AbgKWNFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387582AbgKWMuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D02C520888;
        Mon, 23 Nov 2020 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135814;
        bh=j1HFqd628AStAzVrXpngrtWq2f2+SJdkMjNvoLvOPr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQUJj71fy9iSDXnGDfMDJdNiBx5npb1OBjvciunkUSjdLgewfcqwHaGDyzUV33+vi
         2i9wnWW7jKXFPw18R5W5KRNz/WO2z7Jly0zHwPp+G4D8unOamCEvAF9Mn4MpItSl5A
         J5PP6dTQYeu4HMsOeNUG85sCL+fAeYwPidg9LURA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.9 205/252] ext4: fix bogus warning in ext4_update_dx_flag()
Date:   Mon, 23 Nov 2020 13:22:35 +0100
Message-Id: <20201123121845.459540549@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit f902b216501094495ff75834035656e8119c537f upstream.

The idea of the warning in ext4_update_dx_flag() is that we should warn
when we are clearing EXT4_INODE_INDEX on a filesystem with metadata
checksums enabled since after clearing the flag, checksums for internal
htree nodes will become invalid. So there's no need to warn (or actually
do anything) when EXT4_INODE_INDEX is not set.

Link: https://lore.kernel.org/r/20201118153032.17281-1-jack@suse.cz
Fixes: 48a34311953d ("ext4: fix checksum errors with indexed dirs")
Reported-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2622,7 +2622,8 @@ void ext4_insert_dentry(struct inode *in
 			struct ext4_filename *fname);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
-	if (!ext4_has_feature_dir_index(inode->i_sb)) {
+	if (!ext4_has_feature_dir_index(inode->i_sb) &&
+	    ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) {
 		/* ext4_iget() should have caught this... */
 		WARN_ON_ONCE(ext4_has_feature_metadata_csum(inode->i_sb));
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);


