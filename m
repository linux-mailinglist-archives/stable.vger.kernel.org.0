Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A8420A883
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 01:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406182AbgFYXAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 19:00:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:29966 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgFYXAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jun 2020 19:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593126030; x=1624662030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=C22IGVcT9eGE1qdsfL9In4SLrNzaF/Q8ZCZXjLtdlSQ=;
  b=D/vuoO9VK3nVbqmtn5RIl0oOGwRLRhAGp6o6z6LK09Tu3thRlAMSO0yi
   P3adrJkHJ2NAb9x8vkILcPSQTZ5yfqe1/hbJr+bjjNiLSWC2fDl023Eoq
   akCzwkCAK4tfvt8PfxDdim80DAED7m6oKIVoBYxULeNtTZRFE1C5Pz2hA
   k=;
IronPort-SDR: ibJBBy7IKRfnoK++AZGnFr07bWLmO3vkekKxVsIRt5xwt+fVstt52YvG8IoSmqBRXYrH+zBUpa
 08i9axyu/81Q==
X-IronPort-AV: E=Sophos;i="5.75,280,1589241600"; 
   d="scan'208";a="54023192"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 25 Jun 2020 23:00:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 8D299A1C0D;
        Thu, 25 Jun 2020 23:00:24 +0000 (UTC)
Received: from EX13D42UWB004.ant.amazon.com (10.43.161.99) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 23:00:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D42UWB004.ant.amazon.com (10.43.161.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 25 Jun 2020 23:00:24 +0000
Received: from dev-dsk-yishache-2a-0a3e7335.us-west-2.amazon.com
 (172.19.44.166) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2 via Frontend Transport; Thu, 25 Jun 2020 23:00:23
 +0000
From:   <yishache@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Zheng Bin <zhengbin13@huawei.com>,
        Ren Xudong <renxudong1@huawei.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: add agf freeblocks verify in xfs_agf_verify
Date:   Thu, 25 Jun 2020 22:59:35 +0000
Message-ID: <20200625225935.16844-2-yishache@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200625225935.16844-1-yishache@amazon.com>
References: <20200625225935.16844-1-yishache@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

We recently used fuzz(hydra) to test XFS and automatically generate
tmp.img(XFS v5 format, but some metadata is wrong)

xfs_repair information(just one AG):
agf_freeblks 0, counted 3224 in ag 0
agf_longest 536874136, counted 3224 in ag 0
sb_fdblocks 613, counted 3228

Test as follows:
mount tmp.img tmpdir
cp file1M tmpdir
sync

In 4.19-stable, sync will stuck, the reason is:
xfs_mountfs
  xfs_check_summary_counts
    if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
       XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
       !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
	return 0;  -->just return, incore sb_fdblocks still be 613
    xfs_initialize_perag_data

cp file1M tmpdir -->ok(write file to pagecache)
sync -->stuck(write pagecache to disk)
xfs_map_blocks
  xfs_iomap_write_allocate
    while (count_fsb != 0) {
      nimaps = 0;
      while (nimaps == 0) { --> endless loop
         nimaps = 1;
         xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again
xfs_bmapi_write
  xfs_bmap_alloc
    xfs_bmap_btalloc
      xfs_alloc_vextent
        xfs_alloc_fix_freelist
          xfs_alloc_space_available -->fail(agf_freeblks is 0)

In linux-next, sync not stuck, cause commit c2b3164320b5 ("xfs:
use the latest extent at writeback delalloc conversion time") remove
the above while, dmesg is as follows:
[   55.250114] XFS (loop0): page discard on page ffffea0008bc7380, inode 0x1b0c, offset 0.

Users do not know why this page is discard, the better soultion is:
1. Like xfs_repair, make sure sb_fdblocks is equal to counted
(xfs_initialize_perag_data did this, who is not called at this mount)
2. Add agf verify, if fail, will tell users to repair

This patch use the second soultion.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Ren Xudong <renxudong1@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
(cherry picked from commit d0c7feaf87678371c2c09b3709400be416b2dc62)
---
 fs/xfs/libxfs/xfs_alloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 516e0c57cf9c..43c87cb5a747 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2529,6 +2529,13 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
 		return false;
 
+	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
+		return __this_address;
+
+	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
+	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
@@ -2540,6 +2547,10 @@ xfs_agf_verify(
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
 		return false;
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2553,6 +2564,11 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_blocks) >
+	    be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
-- 
2.16.6

