Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70761B824E
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 01:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgDXXFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 19:05:46 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:16979 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgDXXFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 19:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587769546; x=1619305546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=lc92PcUdx5EuI78SFevdYRKQ83yVPp42OlhBd1zW4SE=;
  b=QDqtkkdyCODKhCVKBxu6Hs7xAlB3AJGuAZqXmOvP27Dzn7dE1AjdZ4df
   9efemABGPAuP+Q3CyBJlUK7KdSHHsluttcir6vFgAOzyGJ8DKutasB6RO
   xsc8fB1r+icoRXG/iwB89IvYM1IRykd97gU6e2Wnhuk6qYm/UZnidP/nZ
   0=;
IronPort-SDR: 46bVUhS1ezs1PTVZWEVbwONq5Eh6Kr7wGfuL2h79UJcp4lbz43T0t4k3PiqrXCHlBfbCVr5Tbn
 hwNTTWeIuq/Q==
X-IronPort-AV: E=Sophos;i="5.73,313,1583193600"; 
   d="scan'208";a="27215532"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 24 Apr 2020 23:05:45 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 26C95A215C;
        Fri, 24 Apr 2020 23:05:44 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 23:05:43 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.162.70) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 24 Apr 2020 23:05:43 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <sjitindarsingh@gmail.com>, <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH STABLE v4.14.y 1/2] xfs: validate sb_logsunit is a multiple of the fs blocksize
Date:   Fri, 24 Apr 2020 16:05:31 -0700
Message-ID: <20200424230532.2852-2-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424230532.2852-1-surajjs@amazon.com>
References: <20200424230532.2852-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.70]
X-ClientProxiedBy: EX13D43UWC004.ant.amazon.com (10.43.162.42) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 9c92ee208b1faa0ef2cc899b85fd0607b6fac7fe upstream.

Make sure the log stripe unit is sane before proceeding with mounting.
AFAICT this means that logsunit has to be 0, 1, or a multiple of the fs
block size.  Found this by setting the LSB of logsunit in xfs/350 and
watching the system crash as soon as we try to write to the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 fs/xfs/xfs_log.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 4e768e606998..360e32220f93 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -608,6 +608,7 @@ xfs_log_mount(
 	xfs_daddr_t	blk_offset,
 	int		num_bblks)
 {
+	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
 	int		error = 0;
 	int		min_logfsbs;
 
@@ -659,9 +660,20 @@ xfs_log_mount(
 			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
 			 XFS_MAX_LOG_BYTES);
 		error = -EINVAL;
+	} else if (mp->m_sb.sb_logsunit > 1 &&
+		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
+		xfs_warn(mp,
+		"log stripe unit %u bytes must be a multiple of block size",
+			 mp->m_sb.sb_logsunit);
+		error = -EINVAL;
+		fatal = true;
 	}
 	if (error) {
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		/*
+		 * Log check errors are always fatal on v5; or whenever bad
+		 * metadata leads to a crash.
+		 */
+		if (fatal) {
 			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
 			ASSERT(0);
 			goto out_free_log;
-- 
2.17.1

