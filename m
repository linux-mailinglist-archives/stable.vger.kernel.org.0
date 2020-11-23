Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A632C06B9
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbgKWMdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:33:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730692AbgKWMdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:33:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D88D921D81;
        Mon, 23 Nov 2020 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134830;
        bh=37b9SwBXqdn7aBCirDJE6xJiEpowKTByt76BKdgsQGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNEZEcouHXDEvQxoDS1Da6d5RagbMnv8VcKoXCXi2Q927LQxEI5/2O22SzX2jfCBr
         DmgVN1HMZGxVNMvckPCdRpZjbepCQgw1rPI/scCk1sPm0iF09z1TsvJQLKPQ+U7P1K
         Jq8RcnbyOa2wKQDdA2nvIfcb03Y8YforAfAPipuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 75/91] ext4: fix bogus warning in ext4_update_dx_flag()
Date:   Mon, 23 Nov 2020 13:22:35 +0100
Message-Id: <20201123121812.968882108@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
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
@@ -2427,7 +2427,8 @@ void ext4_insert_dentry(struct inode *in
 			struct ext4_filename *fname);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
-	if (!ext4_has_feature_dir_index(inode->i_sb)) {
+	if (!ext4_has_feature_dir_index(inode->i_sb) &&
+	    ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) {
 		/* ext4_iget() should have caught this... */
 		WARN_ON_ONCE(ext4_has_feature_metadata_csum(inode->i_sb));
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);


