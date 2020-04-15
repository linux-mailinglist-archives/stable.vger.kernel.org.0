Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA561AA355
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505972AbgDONHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897089AbgDOLfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D85AE21707;
        Wed, 15 Apr 2020 11:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950553;
        bh=vEzWw+t++McwV7z+x0GXmR2vXdqjpx3hTiJQ1o5LGiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Cfu84ocq8/Ea8ibOtSMcB6ugwHM8dF9AdQY/Xs8g5nVgEY1YgD+b8OQ3u59ZnFFU
         MXbK11qO0DQ2Kkj5wcPo6uvTlphnyRd/q6Onxz6hM0fzw61LvpDBI5pGqrMSt5ygw8
         Ge5Qa53ol7VghgV5DN/fM92QR/8zcmXz3mH7WdJw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Triplett <josh@joshtriplett.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 059/129] ext4: fix incorrect inodes per group in error message
Date:   Wed, 15 Apr 2020 07:33:34 -0400
Message-Id: <20200415113445.11881-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit b9c538da4e52a7b79dfcf4cfa487c46125066dfb ]

If ext4_fill_super detects an invalid number of inodes per group, the
resulting error message printed the number of blocks per group, rather
than the number of inodes per group. Fix it to print the correct value.

Fixes: cd6bb35bf7f6d ("ext4: use more strict checks for inodes_per_block on mount")
Link: https://lore.kernel.org/r/8be03355983a08e5d4eed480944613454d7e2550.1585434649.git.josh@joshtriplett.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7d35f9a993d6a..e87008ac7be08 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4158,7 +4158,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
 	    sbi->s_inodes_per_group > blocksize * 8) {
 		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
-			 sbi->s_blocks_per_group);
+			 sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
 	sbi->s_itb_per_group = sbi->s_inodes_per_group /
-- 
2.20.1

