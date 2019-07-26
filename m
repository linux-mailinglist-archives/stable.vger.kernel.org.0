Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6073A76980
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbfGZNwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388305AbfGZNnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:43:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55D522CD2;
        Fri, 26 Jul 2019 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148627;
        bh=xDfCWhVDseD5mMcFkZluXYrX2Kjuu5L7Kf1DwzxIokc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMWNxyLd/QnOnPY7+ZZTp0tZVmfUNx70S5RQ908opU4/xaOeWcA+yj0YvNVkwO8bl
         Y04VC+dEUC1zm489eJBGKsT27LWYie18PFQKcuqc79RFKgpojjV4NJ3Hg5SA2+fOyN
         JJ4oF9X3S2PtEqN6j8XmzA7Kwm+sI6pvO5Zvxerk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 10/37] fs/adfs: super: fix use-after-free bug
Date:   Fri, 26 Jul 2019 09:43:05 -0400
Message-Id: <20190726134332.12626-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 5808b14a1f52554de612fee85ef517199855e310 ]

Fix a use-after-free bug during filesystem initialisation, where we
access the disc record (which is stored in a buffer) after we have
released the buffer.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/adfs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index c9fdfb112933..e42c30001509 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -368,6 +368,7 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct buffer_head *bh;
 	struct object_info root_obj;
 	unsigned char *b_data;
+	unsigned int blocksize;
 	struct adfs_sb_info *asb;
 	struct inode *root;
 	int ret = -EINVAL;
@@ -419,8 +420,10 @@ static int adfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto error_free_bh;
 	}
 
+	blocksize = 1 << dr->log2secsize;
 	brelse(bh);
-	if (sb_set_blocksize(sb, 1 << dr->log2secsize)) {
+
+	if (sb_set_blocksize(sb, blocksize)) {
 		bh = sb_bread(sb, ADFS_DISCRECORD / sb->s_blocksize);
 		if (!bh) {
 			adfs_error(sb, "couldn't read superblock on "
-- 
2.20.1

