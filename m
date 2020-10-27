Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F7829B2C9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763900AbgJ0Op2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763892AbgJ0Op1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:45:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F342225E;
        Tue, 27 Oct 2020 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809926;
        bh=f+GTbl0pKb9hkZ+SMutdzDj8ZJsIrhD8MfsYjapkD1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5FYV/xR8x5AT4xZS27b83TLqDoGR/H5M2xIZiW2NYoZPziHWR+E6wK0LLTsqmOHy
         F5g3R1C/yiWUJicOIG5lPSua30VhLRDx++9OAWFfrO5BsFzAbbAfVjCSIsQZjh58UM
         G4MBNyuh28P0AfzinhzOTboLNCUhi7d+XLhZf6kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+187510916eb6a14598f7@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 368/408] reiserfs: only call unlock_new_inode() if I_NEW
Date:   Tue, 27 Oct 2020 14:55:06 +0100
Message-Id: <20201027135512.082929769@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 70387650436cf..ac35ddf0dd603 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2161,7 +2161,8 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
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



