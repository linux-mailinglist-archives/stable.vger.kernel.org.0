Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3975226EF8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbfEVTZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbfEVTZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 002D3217D9;
        Wed, 22 May 2019 19:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553143;
        bh=aU4CXQ1D+LlLoIV1mmGR+NNarxByWPbHFnIBHyz5C9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enJDO+kb2GKPbQbcZI3C4IEVISQaE2+mPHYbhG8lVDiiRw25WasNNxX8uxvcgsv87
         TyqF5RlnNB1UbY7GgrPxcOz41fgEIjM3aiDomxB9UY6JZ8mGc3FMMjkxyS13Ak0257
         2jCP32KXALZ8aXP9uLCkrP9DHY+NSSioY6R8HrTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoli Feng <fengxiaoli0714@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 073/317] Fix nfs4.2 return -EINVAL when do dedupe operation
Date:   Wed, 22 May 2019 15:19:34 -0400
Message-Id: <20190522192338.23715-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoli Feng <fengxiaoli0714@gmail.com>

[ Upstream commit ce96e888fe48ecfa868c9a39adc03292c78a80ff ]

dedupe_file_range operations is combiled into remap_file_range.
But in nfs42_remap_file_range, it's skiped for dedupe operations.
Before this patch:
  # dd if=/dev/zero of=nfs/file bs=1M count=1
  # xfs_io -c "dedupe nfs/file 4k 64k 4k" nfs/file
  XFS_IOC_FILE_EXTENT_SAME: Invalid argument
After this patch:
  # dd if=/dev/zero of=nfs/file bs=1M count=1
  # xfs_io -c "dedupe nfs/file 4k 64k 4k" nfs/file
  deduped 4096/4096 bytes at offset 65536
  4 KiB, 1 ops; 0.0046 sec (865.988 KiB/sec and 216.4971 ops/sec)

Signed-off-by: Xiaoli Feng <fengxiaoli0714@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 00d17198ee12a..f10b660805fc4 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -187,7 +187,7 @@ static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 	bool same_inode = false;
 	int ret;
 
-	if (remap_flags & ~REMAP_FILE_ADVISORY)
+	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
 	/* check alignment w.r.t. clone_blksize */
-- 
2.20.1

