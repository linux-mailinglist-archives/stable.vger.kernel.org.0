Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5570411B743
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387925AbfLKQGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731188AbfLKPMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5505824658;
        Wed, 11 Dec 2019 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077156;
        bh=kMz5Hlskb+3Ccn7JSBWgf+CnZI018BZIOAQqSiDaWVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UC37h/QG9fEaxoU+zyKmchRfa0ExQpBwGyEpTMVgj24h7fdHDxEerwoCDWh2iTQBU
         Cm/Ia2liutalHX+nFQ++35OCDREVMw9iz2LyVTMyuiusqFdHwM47WpVTJkjDhttyDh
         2D7fg8WqNPhVQ7lrKUWYVWjE2eoAXDdEA75bSpX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 042/134] ext4: iomap that extends beyond EOF should be marked dirty
Date:   Wed, 11 Dec 2019 10:10:18 -0500
Message-Id: <20191211151150.19073-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Bobrowski <mbobrowski@mbobrowski.org>

[ Upstream commit 2e9b51d78229d5145725a481bb5464ebc0a3f9b2 ]

This patch addresses what Dave Chinner had discovered and fixed within
commit: 7684e2c4384d. This changes does not have any user visible
impact for ext4 as none of the current users of ext4_iomap_begin()
that extend files depend on IOMAP_F_DIRTY.

When doing a direct IO that spans the current EOF, and there are
written blocks beyond EOF that extend beyond the current write, the
only metadata update that needs to be done is a file size extension.

However, we don't mark such iomaps as IOMAP_F_DIRTY to indicate that
there is IO completion metadata updates required, and hence we may
fail to correctly sync file size extensions made in IO completion when
O_DSYNC writes are being used and the hardware supports FUA.

Hence when setting IOMAP_F_DIRTY, we need to also take into account
whether the iomap spans the current EOF. If it does, then we need to
mark it dirty so that IO completion will call generic_write_sync() to
flush the inode size update to stable storage correctly.

Signed-off-by: Matthew Bobrowski <mbobrowski@mbobrowski.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/8b43ee9ee94bee5328da56ba0909b7d2229ef150.1572949325.git.mbobrowski@mbobrowski.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 207b8c23e53d9..02313f10e8897 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3523,8 +3523,14 @@ retry:
 			return ret;
 	}
 
+	/*
+	 * Writes that span EOF might trigger an I/O size update on completion,
+	 * so consider them to be dirty for the purposes of O_DSYNC, even if
+	 * there is no other metadata changes being made or are pending here.
+	 */
 	iomap->flags = 0;
-	if (ext4_inode_datasync_dirty(inode))
+	if (ext4_inode_datasync_dirty(inode) ||
+	    offset + length > i_size_read(inode))
 		iomap->flags |= IOMAP_F_DIRTY;
 	iomap->bdev = inode->i_sb->s_bdev;
 	iomap->dax_dev = sbi->s_daxdev;
-- 
2.20.1

