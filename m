Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6571320DDA2
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731774AbgF2TZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732146AbgF2TZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DFD425459;
        Mon, 29 Jun 2020 15:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445408;
        bh=NreF01LoI6c9QfXFcdFmk5Yu4R8Y/7nG3te/iilV4QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWtBbDTgSMHDKFNHsCABoEPXlHvKXHKR4NUUtpTwWavMFqWArXwtNoLacXKfgydzg
         wEKMklVr5W42vFDd30E4g1luSxlLdU4Dz3ogQ6GtVwkCnfYnuViN7yVM16KsTrSIak
         bgc+qUT0ZkS0wZWBf82ookX0/e5FUZnmtxThrgs0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 159/191] cifs/smb3: Fix data inconsistent when punch hole
Date:   Mon, 29 Jun 2020 11:39:35 -0400
Message-Id: <20200629154007.2495120-160-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit acc91c2d8de4ef46ed751c5f9df99ed9a109b100 ]

When punch hole success, we also can read old data from file:
  # strace -e trace=pread64,fallocate xfs_io -f -c "pread 20 40" \
           -c "fpunch 20 40" -c"pread 20 40" file
  pread64(3, " version 5.8.0-rc1+"..., 40, 20) = 40
  fallocate(3, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 20, 40) = 0
  pread64(3, " version 5.8.0-rc1+"..., 40, 20) = 40

CIFS implements the fallocate(FALLOCATE_FL_PUNCH_HOLE) with send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
remote file to zero, but local page caches not updated, then the
local page caches inconsistent with server.

Also can be found by xfstests generic/316.

So, we need to remove the page caches before send the SMB
ioctl(FSCTL_SET_ZERO_DATA) to server.

Fixes: 31742c5a33176 ("enable fallocate punch hole ("fallocate -p") for SMB3")
Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: stable@vger.kernel.org # v3.17
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 67d9b7a277a3b..9c29317deef56 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1276,6 +1276,12 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse))
 		return -EOPNOTSUPP;
 
+	/*
+	 * We implement the punch hole through ioctl, so we need remove the page
+	 * caches first, otherwise the data may be inconsistent with the server.
+	 */
+	truncate_pagecache_range(inode, offset, offset + len - 1);
+
 	cifs_dbg(FYI, "offset %lld len %lld", offset, len);
 
 	fsctl_buf.FileOffset = cpu_to_le64(offset);
-- 
2.25.1

