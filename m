Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02122323D94
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhBXNNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233995AbhBXNCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:02:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23F5664F65;
        Wed, 24 Feb 2021 12:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171198;
        bh=56+ww6HVKiCAXIOYHwWgkq3AMZVIPzuPJWfd/2OqmEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTBdEF4h+z8OlIbJJ6sfWTISbTN8Rc+lKnzlYplmw+MwYjpxuMjza3WZIxgW1C1b3
         1dTbkLhEA9jKrzc5SOSPvB4H/tcvZqf2CgwP96A8jawtNqXgJdeyrzc3Ow5vFPnpKj
         3eti4mn8zPmRBlEVhIubCSfTmYUwMY7PFI6/IvQ7wuKByxKuP4nFa//MAC1C7HmBlI
         PRc+RrkyxmuSYqxLnmta7AlB9LE/kfII7tz/93vOULoZOWlJNYBbB0pm4DPat3PBBx
         BbwgFutsvf0mgEdPVGN1Uu8LNM61dgEdg7SZhqao8wcwY3S81aot9PcKnCq0Lx1jnu
         hGmUhbPJ5jmzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Sasha Levin <sashal@kernel.org>,
        linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 49/56] erofs: fix shift-out-of-bounds of blkszbits
Date:   Wed, 24 Feb 2021 07:52:05 -0500
Message-Id: <20210224125212.482485-49-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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

