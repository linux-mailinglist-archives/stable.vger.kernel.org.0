Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD45323DA8
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbhBXNOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235806AbhBXNHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:07:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C63C564F8A;
        Wed, 24 Feb 2021 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171265;
        bh=ZDSGtqQMqznruC3i1uHg8aXjYRDodJFZt8lPSkU8j7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkgAEiNwQ9F2FAriAhKX0p1/O5aCmio35m9N3dDMCL4ZF3f5y3z/a//9uw/wbsI28
         IMsSCrbjKo2xa/C2C/9QIQ0VzmJwcHdmAitl79Hrb8Yt+vUaLu2d8+ADYIOgsLmrWL
         FVYHUmIqG3TqjH/gU8eZU1j+b8RnGLGQltJMhLno5CNcEZBE3oXIpL9wHQnKSo3BFq
         R+qn4gTVSi7QmHqTeQYuYg0DRfMdwuYXvEJZbSsuBaaH5iWHtYP3JQHVjm9iB6N5hn
         PhD6MMpm6bnEK6ae4fafNL+CeRmMdzbytFAA1mSWOsKZz9TcuWvAyuG9Vwj+4EQnla
         hWGZGUEtljrrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        syzbot+c68f467cd7c45860e8d4@syzkaller.appspotmail.com,
        Chao Yu <yuchao0@huawei.com>, Sasha Levin <sashal@kernel.org>,
        linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 34/40] erofs: fix shift-out-of-bounds of blkszbits
Date:   Wed, 24 Feb 2021 07:53:34 -0500
Message-Id: <20210224125340.483162-34-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
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
index 0e369494f2f2c..22e059b4f745c 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -124,8 +124,8 @@ static int erofs_read_superblock(struct super_block *sb)
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

