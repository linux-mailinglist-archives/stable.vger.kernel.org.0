Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2852A881F
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 21:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732133AbgKEUbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 15:31:34 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:30731 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732083AbgKEUbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 15:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1604608294; x=1636144294;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=b9e9d8usP8qz9BAkGTsfoN8FhB0ge8Xnu4KuxNy+QQA=;
  b=SwncX4xer2VePXclMp9bmZULUiLMJQzL6GzDbQCKyixoR0N1FrVGan09
   wKNTlOXiJNNzoPX4Px7U9iMfJubHqyGWrebbxQ6jmyEyIyKAdP15ZfuJ9
   z4ybS/nazrc7jx43m19wQBco4bstqfQXQGDvJSL4g+LEGELER+t7tCpY3
   8=;
X-IronPort-AV: E=Sophos;i="5.77,454,1596499200"; 
   d="scan'208";a="91091268"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 Nov 2020 20:31:25 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 530E0A1E72;
        Thu,  5 Nov 2020 20:31:24 +0000 (UTC)
Received: from EX13D35UWC004.ant.amazon.com (10.43.162.180) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 5 Nov 2020 20:31:23 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D35UWC004.ant.amazon.com (10.43.162.180) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 5 Nov 2020 20:31:22 +0000
Received: from dev-dsk-astroh-2c-c797f0e8.us-west-2.amazon.com (172.22.47.82)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 5 Nov 2020 20:31:22 +0000
Received: by dev-dsk-astroh-2c-c797f0e8.us-west-2.amazon.com (Postfix, from userid 11196724)
        id 36BD921B0A; Thu,  5 Nov 2020 20:31:22 +0000 (UTC)
From:   Andy Strohman <astroh@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <dchinner@redhat.com>, <darrick.wong@oracle.com>,
        <astroh@amazon.com>
Subject: [PATCH 5.4] xfs: flush for older, xfs specific ioctls
Date:   Thu, 5 Nov 2020 20:28:50 +0000
Message-ID: <20201105202850.20216-1-astroh@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

837a6e7f5cdb ("fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers") changed
ioctls XFS_IOC_UNRESVSP XFS_IOC_UNRESVSP64 and XFS_IOC_ZERO_RANGE to be generic
instead of xfs specific.

Because of this change, 36f11775da75 ("xfs: properly serialise fallocate against
AIO+DIO") needed adaptation, as 5.4 still uses the xfs specific ioctls.

Without this, xfstests xfs/242 and xfs/290 fail. Both of these tests test
XFS_IOC_ZERO_RANGE.

Fixes: 36f11775da75 ("xfs: properly serialise fallocate against AIO+DIO")
Tested-by: Andy Strohman <astroh@amazon.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bf0435dbec43..b3021d9b34a5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -622,7 +622,6 @@ xfs_ioc_space(
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
 		goto out_unlock;
-	inode_dio_wait(inode);
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
@@ -668,6 +667,31 @@ xfs_ioc_space(
 		goto out_unlock;
 	}
 
+	/*
+	 * Must wait for all AIO to complete before we continue as AIO can
+	 * change the file size on completion without holding any locks we
+	 * currently hold. We must do this first because AIO can update both
+	 * the on disk and in memory inode sizes, and the operations that follow
+	 * require the in-memory size to be fully up-to-date.
+	 */
+	inode_dio_wait(inode);
+
+	/*
+	 * Now that AIO and DIO has drained we can flush and (if necessary)
+	 * invalidate the cached range over the first operation we are about to
+	 * run. We include zero range here because it starts with a hole punch
+	 * over the target range.
+	 */
+	switch (cmd) {
+	case XFS_IOC_ZERO_RANGE:
+	case XFS_IOC_UNRESVSP:
+	case XFS_IOC_UNRESVSP64:
+		error = xfs_flush_unmap_range(ip, bf->l_start, bf->l_len);
+		if (error)
+			goto out_unlock;
+		break;
+	}
+
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
 		flags |= XFS_PREALLOC_SET;
-- 
2.16.6

