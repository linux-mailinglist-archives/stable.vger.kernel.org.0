Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D25323CFF
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhBXNBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235417AbhBXMzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:55:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DFC864F2F;
        Wed, 24 Feb 2021 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171107;
        bh=56+ww6HVKiCAXIOYHwWgkq3AMZVIPzuPJWfd/2OqmEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLMRAqk/LVGydsL9St7e8uVNrVO4I2RljdBuRI76/8SlJbOJt43K/y+sgwJeLpS2s
         TliolTEhqryxZUNI0nG5vGDzNk6q6Az3gmslu7eN/vBCrnCze4dbCAP7yYoZ+CvvY2
         Pbe3hMwbEuCch6L5U5CWH6V2ui6/FgPwe7X8QLfieAjhv8n71YlOZqeS4WPyipMeZd
         q/wsuTWSdns0ERycVuPKyUXO4+RoJA4TBtbgLSdR9fHVCHh772EcKGUqhavgFH+kXj
         tugMkjtht+JF9CIxez4NCTSDtpNhyzdCPbay35CvN132ELryB9f7Bx5X3NkqHJRJGU
         oi1eW86wXKpUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Sasha Levin <sashal@kernel.org>,
        linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.11 60/67] erofs: fix shift-out-of-bounds of blkszbits
Date:   Wed, 24 Feb 2021 07:50:18 -0500
Message-Id: <20210224125026.481804-60-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

[ Upstream commit bde545295b710bdd13a0fcd4b9fddd2383eeeb3a ]

syzbot generated a crafted bitszbits which can be shifted
out-of-bounds[1]. So directly print unsupported blkszbits
instead of blksize.

[1] https://lore.kernel.org/r/000000000000c72ddd05b9444d2f@google.com

Link: https://lore.kernel.org/r/20210120013016.14071-1-hsiangkao@aol.com
Reported-by: syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index be10b16ea66ee..d5a6b9b888a56 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -158,8 +158,8 @@ static int erofs_read_superblock(struct super_block *sb)
 	blkszbits = dsb->blkszbits;
 	/* 9(512 bytes) + LOG_SECTORS_PER_BLOCK == LOG_BLOCK_SIZE */
 	if (blkszbits != LOG_BLOCK_SIZE) {
-		erofs_err(sb, "blksize %u isn't supported on this platform",
-			  1 << blkszbits);
+		erofs_err(sb, "blkszbits %u isn't supported on this platform",
+			  blkszbits);
 		goto out;
 	}
 
-- 
2.27.0

