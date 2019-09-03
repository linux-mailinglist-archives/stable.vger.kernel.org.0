Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56ADA6F5F
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbfICQcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730214AbfICQcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:32:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BADE6238C7;
        Tue,  3 Sep 2019 16:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528334;
        bh=yruG6zYRqI5FfoP6ioRKtGvCg1Enlfzh6rJyvHXfJSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVTi4ZV/E9IaigAGJOtcWfATBHZ3GB19otH+z+A9B1fgyKUYjAvxbisOoyaE6E+f7
         I4zisdWzHUrq3tBI/sWm1MMCkE0dXt+qtWVeEzv0fTAs/TLUrWEyQSG7FzOUw5bATT
         jPakjaABNZpX245JXAHcM/1DU8tBO9Eef4N7wBbc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Dan Rue <dan.rue@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 164/167] ext4: don't perform block validity checks on the journal inode
Date:   Tue,  3 Sep 2019 12:25:16 -0400
Message-Id: <20190903162519.7136-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 0a944e8a6c66ca04c7afbaa17e22bf208a8b37f0 ]

Since the journal inode is already checked when we added it to the
block validity's system zone, if we check it again, we'll just trigger
a failure.

This was causing failures like this:

[   53.897001] EXT4-fs error (device sda): ext4_find_extent:909: inode
#8: comm jbd2/sda-8: pblk 121667583 bad header/extent: invalid extent entries - magic f30a, entries 8, max 340(340), depth 0(0)
[   53.931430] jbd2_journal_bmap: journal block not found at offset 49 on sda-8
[   53.938480] Aborting journal on device sda-8.

... but only if the system was under enough memory pressure that
logical->physical mapping for the journal inode gets pushed out of the
extent cache.  (This is why it wasn't noticed earlier.)

Fixes: 345c0dbf3a30 ("ext4: protect journal inode's blocks using block_validity")
Reported-by: Dan Rue <dan.rue@linaro.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 45aea792d22a0..00bf0b67aae87 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -518,10 +518,14 @@ __read_extent_tree_block(const char *function, unsigned int line,
 	}
 	if (buffer_verified(bh) && !(flags & EXT4_EX_FORCE_CACHE))
 		return bh;
-	err = __ext4_ext_check(function, line, inode,
-			       ext_block_hdr(bh), depth, pblk);
-	if (err)
-		goto errout;
+	if (!ext4_has_feature_journal(inode->i_sb) ||
+	    (inode->i_ino !=
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum))) {
+		err = __ext4_ext_check(function, line, inode,
+				       ext_block_hdr(bh), depth, pblk);
+		if (err)
+			goto errout;
+	}
 	set_buffer_verified(bh);
 	/*
 	 * If this is a leaf block, cache all of its entries
-- 
2.20.1

