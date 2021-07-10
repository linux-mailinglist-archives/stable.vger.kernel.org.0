Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03893C2E9E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhGJC1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233733AbhGJC1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F11613DC;
        Sat, 10 Jul 2021 02:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883854;
        bh=mwAXzCQTCpeyzRqdPBQBVEoSYtdysFiIiiFsm4R9IlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7Evs/+pbglol+0Kf3ocr+//kSrwXvtjNN0YgOYhWzeIhXeztDLXr/ryaRJuYjyMt
         +/VpXeh+1poic+tIQTg/z5ymESI3eVPuANfv6kxbkRa8UM3lVZyr7g0OwXlqI6VlZE
         9W2UVxYOTkiFQZGwaT3PhEhBMkgs1eYcDhpRm/vIAZpSPfrppVT7fm+UamwPrxLOw3
         63m6DzO5exRGx6+KE2UV9rvUSH7iDpve7kif6mIHcnF0g5BEEYmjegFilm3ZxgPKRU
         aN0UI+dNZjj2xX7tV1U3pzD3fu2KqNQjOWDbzb47yq/GucvmUv7HWRvaein+VocUnK
         4KIWNMu12yLEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+0a89a7b56db04c21a656@syzkaller.appspotmail.com,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.12 097/104] jfs: fix GPF in diFree
Date:   Fri,  9 Jul 2021 22:21:49 -0400
Message-Id: <20210710022156.3168825-97-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 9d574f985fe33efd6911f4d752de6f485a1ea732 ]

Avoid passing inode with
JFS_SBI(inode->i_sb)->ipimap == NULL to
diFree()[1]. GFP will appear:

	struct inode *ipimap = JFS_SBI(ip->i_sb)->ipimap;
	struct inomap *imap = JFS_IP(ipimap)->i_imap;

JFS_IP() will return invalid pointer when ipimap == NULL

Call Trace:
 diFree+0x13d/0x2dc0 fs/jfs/jfs_imap.c:853 [1]
 jfs_evict_inode+0x2c9/0x370 fs/jfs/inode.c:154
 evict+0x2ed/0x750 fs/inode.c:578
 iput_final fs/inode.c:1654 [inline]
 iput.part.0+0x3fe/0x820 fs/inode.c:1680
 iput+0x58/0x70 fs/inode.c:1670

Reported-and-tested-by: syzbot+0a89a7b56db04c21a656@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 6f65bfa9f18d..b0eb9c85eea0 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -151,7 +151,8 @@ void jfs_evict_inode(struct inode *inode)
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			diFree(inode);
+			if (JFS_SBI(inode->i_sb)->ipimap)
+				diFree(inode);
 
 			/*
 			 * Free the inode from the quota allocation.
-- 
2.30.2

