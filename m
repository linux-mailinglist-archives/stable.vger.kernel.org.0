Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CFBB2054
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390649AbfIMNUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390644AbfIMNUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:49 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3089920CC7;
        Fri, 13 Sep 2019 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380848;
        bh=qYVMk1Hx+6nEgYmyCC8RINbJ2qHv93AeLhQL+41kAmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHyQdZPRaq+Yjnr5Ke2BwOih76zQZa5Qui8htFXBPtV2WRGLQeMb8xMyUL0e0yvuE
         FfhJPiMD+syPJHQXQQ6u2q4/GDqDFs77T6nKvm5mdEp4hMw9JTk7WV/Lay8FoWKSiB
         dq4tX7lqU8UTR1q1KjHn2HyBq7XRjWA5G7v/9q3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/190] ext4: fix block validity checks for journal inodes using indirect blocks
Date:   Fri, 13 Sep 2019 14:07:19 +0100
Message-Id: <20190913130614.571217202@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 170417c8c7bb2cbbdd949bf5c443c0c8f24a203b ]

Commit 345c0dbf3a30 ("ext4: protect journal inode's blocks using
block_validity") failed to add an exception for the journal inode in
ext4_check_blockref(), which is the function used by ext4_get_branch()
for indirect blocks.  This caused attempts to read from the ext3-style
journals to fail with:

[  848.968550] EXT4-fs error (device sdb7): ext4_get_branch:171: inode #8: block 30343695: comm jbd2/sdb7-8: invalid block

Fix this by adding the missing exception check.

Fixes: 345c0dbf3a30 ("ext4: protect journal inode's blocks using block_validity")
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/block_validity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 9409b1e11a22e..cd7129b622f85 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -275,6 +275,11 @@ int ext4_check_blockref(const char *function, unsigned int line,
 	__le32 *bref = p;
 	unsigned int blk;
 
+	if (ext4_has_feature_journal(inode->i_sb) &&
+	    (inode->i_ino ==
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+		return 0;
+
 	while (bref < p+max) {
 		blk = le32_to_cpu(*bref++);
 		if (blk &&
-- 
2.20.1



