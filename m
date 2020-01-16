Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF313E8C4
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404547AbgAPRd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404369AbgAPRaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:30:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5613724716;
        Thu, 16 Jan 2020 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195817;
        bh=aVw7llPP2uOmAWMx+HCjjjmnRiUI6NrQlaItB9136P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gi8XqS2a8/Ffo9VegZeZ8BTnAqDZX02oBKElnpvNmMRLLvFRDzCFySpDlTP4Q3E/D
         4Vv4MNdI9VEIYEPUJPVe7dg4OUNTx5QU3oJ4oSyZIQa6LLra6q8rG5/aDWZhFZGCHZ
         /V3BmzPiQh6zH/764GEpkD2MZi/dA/r9iYemXpAA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 327/371] afs: Fix large file support
Date:   Thu, 16 Jan 2020 12:23:19 -0500
Message-Id: <20200116172403.18149-270-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit b485275f1aca8a9da37fd35e4fad673935e827da ]

By default s_maxbytes is set to MAX_NON_LFS, which limits the usable
file size to 2GB, enforced by the vfs.

Commit b9b1f8d5930a ("AFS: write support fixes") added support for the
64-bit fetch and store server operations, but did not change this value.
As a result, attempts to write past the 2G mark result in EFBIG errors:

 $ dd if=/dev/zero of=foo bs=1M count=1 seek=2048
 dd: error writing 'foo': File too large

Set s_maxbytes to MAX_LFS_FILESIZE.

Fixes: b9b1f8d5930a ("AFS: write support fixes")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 689173c0a682..f8529ddbd587 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -359,6 +359,7 @@ static int afs_fill_super(struct super_block *sb,
 	/* fill in the superblock */
 	sb->s_blocksize		= PAGE_SIZE;
 	sb->s_blocksize_bits	= PAGE_SHIFT;
+	sb->s_maxbytes		= MAX_LFS_FILESIZE;
 	sb->s_magic		= AFS_FS_MAGIC;
 	sb->s_op		= &afs_super_ops;
 	sb->s_xattr		= afs_xattr_handlers;
-- 
2.20.1

