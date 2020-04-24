Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83431B73F4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgDXMXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbgDXMXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C18E2168B;
        Fri, 24 Apr 2020 12:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731011;
        bh=BCcp275qjQIXPW0o3zvH9C5ORQ7jeCgV04Kiark2N5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4kojxZDdNVSXlNLBG+Zx9xEXh2q2xa2GqIWYNUlp7P60GNkWJJYYCeDdSQXx1Ugk
         HPISZ0crKHhBUNkj0Tc3WVG2DPAqdt0XR0sZkkJcB9hVWvx3KCYAfpmAKltW17da4B
         2s9b4ITH9p5TtebSBMwlRxwRkHZL1ezGmHpXt7DI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Paul Furtado <paulfurtado91@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/26] xfs: acquire superblock freeze protection on eofblocks scans
Date:   Fri, 24 Apr 2020 08:23:03 -0400
Message-Id: <20200424122323.10194-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
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
index 944add5ff8e09..d95dc9b0f0bba 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -907,7 +907,12 @@ xfs_eofblocks_worker(
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
 
@@ -934,7 +939,12 @@ xfs_cowblocks_worker(
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
index 2a1909397cb4d..c93c4b7328ef7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2401,7 +2401,10 @@ xfs_file_ioctl(
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

