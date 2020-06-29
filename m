Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB45620E39A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390139AbgF2VPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729951AbgF2SzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:55:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ACB225299;
        Mon, 29 Jun 2020 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446119;
        bh=S08nYrekJmBOyeiTsbZtC3oLsNMFUCdDZY8lMIQKECY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tg8c7WLq1bbc5FuszN/URA+GWyDvgdjF3cPTUUZLbNlQKhAN/W6zbQ0Zo8kNbhfXU
         1qYl+Tsi2dDl28Kqp/2Myu3xUGBJ7p+XK2AusV/OLWzqDlvun14XmKISR/MdU0GVOB
         74F8c0YCmOzdMmFMrdebH0Rs8aNOZQaZ0ZLIEJdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 110/135] cifs/smb3: Fix data inconsistent when zero file range
Date:   Mon, 29 Jun 2020 11:52:44 -0400
Message-Id: <20200629155309.2495516-111-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 6b69040247e14b43419a520f841f2b3052833df9 ]

CIFS implements the fallocate(FALLOC_FL_ZERO_RANGE) with send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
remote file to zero, but local page cache not update, then the data
inconsistent with server, which leads the xfstest generic/008 failed.

So we need to remove the local page caches before send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. After next read, it will
re-cache it.

Fixes: 30175628bf7f5 ("[SMB3] Enable fallocate -z support for SMB3 mounts")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Cc: stable@vger.kernel.org # v3.17
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 870b7e763bab9..087261ca6d463 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1145,6 +1145,12 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	inode = d_inode(cfile->dentry);
 	cifsi = CIFS_I(inode);
 
+	/*
+	 * We zero the range through ioctl, so we need remove the page caches
+	 * first, otherwise the data may be inconsistent with the server.
+	 */
+	truncate_pagecache_range(inode, offset, offset + len - 1);
+
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
 		if (keep_size == false)
-- 
2.25.1

