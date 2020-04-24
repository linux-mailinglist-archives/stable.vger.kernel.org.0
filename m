Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25B71B74DB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgDXM3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbgDXMYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 272DF21582;
        Fri, 24 Apr 2020 12:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731040;
        bh=RWfCogi8yjlqHKJ1QYuqiErJGN7ddKARRjGXT+Srvhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMlWZEQW2HKQ7vt1CRTKieuGylhW7lADe5j3q52XTiHpW/eaKqzJytI4rUHbmr+oc
         13lLDMfw+40+HmkQLJFKfdDIeuU/BZxmJSOCb9IwKkUTVoPADjKHUFFYs69ZLI9QNG
         DmM7fTV09U3j7kC5rOgyvVykVijRK8RJINasWo3M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Paul Furtado <paulfurtado91@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/18] xfs: acquire superblock freeze protection on eofblocks scans
Date:   Fri, 24 Apr 2020 08:23:40 -0400
Message-Id: <20200424122355.10453-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 4b674b9ac852937af1f8c62f730c325fb6eadcdb ]

The filesystem freeze sequence in XFS waits on any background
eofblocks or cowblocks scans to complete before the filesystem is
quiesced. At this point, the freezer has already stopped the
transaction subsystem, however, which means a truncate or cowblock
cancellation in progress is likely blocked in transaction
allocation. This results in a deadlock between freeze and the
associated scanner.

Fix this problem by holding superblock write protection across calls
into the block reapers. Since protection for background scans is
acquired from the workqueue task context, trylock to avoid a similar
deadlock between freeze and blocking on the write lock.

Fixes: d6b636ebb1c9f ("xfs: halt auto-reclamation activities while rebuilding rmap")
Reported-by: Paul Furtado <paulfurtado91@gmail.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_icache.c | 10 ++++++++++
 fs/xfs/xfs_ioctl.c  |  5 ++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 245483cc282ba..901f27ac94abc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -902,7 +902,12 @@ xfs_eofblocks_worker(
 {
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 				struct xfs_mount, m_eofblocks_work);
+
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
 	xfs_icache_free_eofblocks(mp, NULL);
+	sb_end_write(mp->m_super);
+
 	xfs_queue_eofblocks(mp);
 }
 
@@ -929,7 +934,12 @@ xfs_cowblocks_worker(
 {
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 				struct xfs_mount, m_cowblocks_work);
+
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
 	xfs_icache_free_cowblocks(mp, NULL);
+	sb_end_write(mp->m_super);
+
 	xfs_queue_cowblocks(mp);
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bad90479ade2a..6ffb53edf1b4a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2182,7 +2182,10 @@ xfs_file_ioctl(
 		if (error)
 			return error;
 
-		return xfs_icache_free_eofblocks(mp, &keofb);
+		sb_start_write(mp->m_super);
+		error = xfs_icache_free_eofblocks(mp, &keofb);
+		sb_end_write(mp->m_super);
+		return error;
 	}
 
 	default:
-- 
2.20.1

