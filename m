Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CB92C0B21
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbgKWNUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732258AbgKWMj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:39:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9983D2065E;
        Mon, 23 Nov 2020 12:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135167;
        bh=x0ma248pKXSEleGhWtFR0nwOC4ICNS/QVbSg1K+RNbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vjN533+99fyxx9QcksuCtr7Qpcmp0VmUk5ossZzZH/uOtJlDj/EXk3vX1JrvQnVF
         z2+lLch8kfKich0FTGefJ7wZGYkctZaNprq5+xbI+wvv7GVJKJi9ZtprpmhezMJDLW
         6ny1Lh3/z2h5BpVA2wPiy3pVoh8/eVV5iqpBzRBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.4 129/158] ext4: fix bogus warning in ext4_update_dx_flag()
Date:   Mon, 23 Nov 2020 13:22:37 +0100
Message-Id: <20201123121826.149725257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
@@ -2496,7 +2496,8 @@ void ext4_insert_dentry(struct inode *in
 			struct ext4_filename *fname);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
-	if (!ext4_has_feature_dir_index(inode->i_sb)) {
+	if (!ext4_has_feature_dir_index(inode->i_sb) &&
+	    ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) {
 		/* ext4_iget() should have caught this... */
 		WARN_ON_ONCE(ext4_has_feature_metadata_csum(inode->i_sb));
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);


