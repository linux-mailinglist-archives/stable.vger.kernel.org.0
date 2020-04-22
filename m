Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4E51B3DCB
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbgDVKSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbgDVKSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:18:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EC622070B;
        Wed, 22 Apr 2020 10:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550709;
        bh=ZwYuWogEoMguMqy8IBBG5/+pe0y6k0fPBiOgbUr18LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxieqCrvFU1VTeESXIGqquyAjb8hFIFQr/YDXDYVZ02t/W0wSo7er4CxJoP96UJku
         QUfPewUo5mTL+mul2wjPeXyLIZNEL9eNAi5MJ2uux34Rw0Wy1mm1SUfX2+lsbUVuLK
         rRm7vLAgZPsDCgnLVmewvuI+VCOqzBwKX2tBHPvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Domenico Andreoli <domenico.andreoli@linux.com>,
        Marian Klein <mkleinsoft@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/118] hibernate: Allow uswsusp to write to swap
Date:   Wed, 22 Apr 2020 11:57:02 +0200
Message-Id: <20200422095042.013796362@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Domenico Andreoli <domenico.andreoli@linux.com>

[ Upstream commit 56939e014a6c212b317414faa307029e2e80c3b9 ]

It turns out that there is one use case for programs being able to
write to swap devices, and that is the userspace hibernation code.

Quick fix: disable the S_SWAPFILE check if hibernation is configured.

Fixes: dc617f29dbe5 ("vfs: don't allow writes to swap files")
Reported-by: Domenico Andreoli <domenico.andreoli@linux.com>
Reported-by: Marian Klein <mkleinsoft@gmail.com>
Signed-off-by: Domenico Andreoli <domenico.andreoli@linux.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/block_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index d612468ee66bf..34644ce4b5025 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -34,6 +34,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/falloc.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 #include "internal.h"
 
 struct bdev_inode {
@@ -1975,7 +1976,8 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (bdev_read_only(I_BDEV(bd_inode)))
 		return -EPERM;
 
-	if (IS_SWAPFILE(bd_inode))
+	/* uswsusp needs write permission to the swap */
+	if (IS_SWAPFILE(bd_inode) && !hibernation_available())
 		return -ETXTBSY;
 
 	if (!iov_iter_count(from))
-- 
2.20.1



