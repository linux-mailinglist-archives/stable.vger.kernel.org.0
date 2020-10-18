Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CFA291D34
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgJRTXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730352AbgJRTXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F49222C8;
        Sun, 18 Oct 2020 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049013;
        bh=wJwhpOpT0aGnuO0elWpDnNZThYlsBBbNvZLv5xmIEN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilZFoIkKt9yzkvIdC93guZt/1ZDNm1epolI+NgFQ7a8/1qcibGDSgb5iqBQeNs8cb
         xZ6UGuF0zdSEjUIG2K0kwa2bo9yHP/DHuFmOtCbLceHYcjd/HPSB8hnoPHhhwIAjn8
         OvGznmLdGiiHgfKJX2vF2/1VkNaXOFd/k0rW9S1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        syzbot+187510916eb6a14598f7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 48/80] reiserfs: only call unlock_new_inode() if I_NEW
Date:   Sun, 18 Oct 2020 15:21:59 -0400
Message-Id: <20201018192231.4054535-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 8859bf2b1278d064a139e3031451524a49a56bd0 ]

unlock_new_inode() is only meant to be called after a new inode has
already been inserted into the hash table.  But reiserfs_new_inode() can
call it even before it has inserted the inode, triggering the WARNING in
unlock_new_inode().  Fix this by only calling unlock_new_inode() if the
inode has the I_NEW flag set, indicating that it's in the table.

This addresses the syzbot report "WARNING in unlock_new_inode"
(https://syzkaller.appspot.com/bug?extid=187510916eb6a14598f7).

Link: https://lore.kernel.org/r/20200628070057.820213-1-ebiggers@kernel.org
Reported-by: syzbot+187510916eb6a14598f7@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 6419e6dacc394..3126d23e9f3cc 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2165,7 +2165,8 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 out_inserted_sd:
 	clear_nlink(inode);
 	th->t_trans_id = 0;	/* so the caller can't use this handle later */
-	unlock_new_inode(inode); /* OK to do even if we hadn't locked it */
+	if (inode->i_state & I_NEW)
+		unlock_new_inode(inode);
 	iput(inode);
 	return err;
 }
-- 
2.25.1

