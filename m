Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785312F3AB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfE3Ea4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbfE3DNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:51 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE2723D14;
        Thu, 30 May 2019 03:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186030;
        bh=5RLysbjutLyy0H2j0S6gLUuxbUtDMbuWmcgwqXBZXwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+9+dZFgrQDaGsQK4nX9Lu9VSfWUZsO/D+mT/Vip/kHYnh6ub1MdJzUWf7FyuZ4pl
         ikEGHzSMjZnIoUsuv46530wmrlSRs+fSE2OUYtu9KB62bO0RNaSU94yO1lQs2UHvyG
         sNdmGOoGggtrTRi/TvjTLo29gR85twxcsiJWAaPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoli Feng <fengxiaoli0714@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 108/346] Fix nfs4.2 return -EINVAL when do dedupe operation
Date:   Wed, 29 May 2019 20:03:01 -0700
Message-Id: <20190530030546.576648554@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



