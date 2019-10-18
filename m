Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39D4DD34E
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393236AbfJRWRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387418AbfJRWHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AE12205F4;
        Fri, 18 Oct 2019 22:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436475;
        bh=WHX65/AoIFRyii84i/q6+u2Bw9cdOY7501KBf1Lu+rQ=;
        h=From:To:Cc:Subject:Date:From;
        b=aRVyiRteedN3fziJZ/CIECe9t3VOs3k8b9v0TxGLG4Q5cDI0MC8+0z9AFNFZMAF2N
         owZGaTkf+pG97RnBVJNh4Crzzf21LVGD58imoMF9Gpvguv6Xbkae+Y5MrF0/NcBZmH
         2HsRF9cxCN9F0m8s5rOJNdPTOlaO8uWyT2p3moi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 01/56] f2fs: flush quota blocks after turnning it off
Date:   Fri, 18 Oct 2019 18:06:58 -0400
Message-Id: <20191018220753.10002-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 0e0667b625cf64243df83171bff61f9d350b9ca5 ]

After quota_off, we'll get some dirty blocks. If put_super don't have a chance
to flush them by checkpoint, it causes NULL pointer exception in end_io after
iput(node_inode). (e.g., by checkpoint=disable)

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 344aa861774bd..1ff0659d53d01 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1523,6 +1523,12 @@ void f2fs_quota_off_umount(struct super_block *sb)
 			set_sbi_flag(F2FS_SB(sb), SBI_NEED_FSCK);
 		}
 	}
+	/*
+	 * In case of checkpoint=disable, we must flush quota blocks.
+	 * This can cause NULL exception for node_inode in end_io, since
+	 * put_super already dropped it.
+	 */
+	sync_filesystem(sb);
 }
 
 int f2fs_get_projid(struct inode *inode, kprojid_t *projid)
-- 
2.20.1

