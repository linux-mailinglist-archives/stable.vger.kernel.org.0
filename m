Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293E91AA447
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506356AbgDONWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408882AbgDOLfA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 816E82078A;
        Wed, 15 Apr 2020 11:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950500;
        bh=uM8RYOThTOAePXpnhO/MjXiLuve+HcAfoAQLYud7kjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AptoPI5UUuxPPUt6e+DVzYSG85R51t2DFmxZbd3ItlUS4pLc3pi3I8FHivBBbMROh
         EpffLXeyMo3aCGzrHV4YoZZXCLipQxSscrMf2Ux0E82yZBPjiE6jkQu8OLUMNrUXl8
         687GBGgfM2my/LCGtC33G75d8F/NQ+me5/vfvEcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Zorro Lang <zlang@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 012/129] xfs: fix iclog release error check race with shutdown
Date:   Wed, 15 Apr 2020 07:32:47 -0400
Message-Id: <20200415113445.11881-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 6b789c337a5963ae57cbc7fe9e41488c40a9b014 ]

Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
l_icloglock held"), xlog_state_release_iclog() always performed a
locked check of the iclog error state before proceeding into the
sync state processing code. As of this commit, part of
xlog_state_release_iclog() was open-coded into
xfs_log_release_iclog() and as a result the locked error state check
was lost.

The lockless check still exists, but this doesn't account for the
possibility of a race with a shutdown being performed by another
task causing the iclog state to change while the original task waits
on ->l_icloglock. This has reproduced very rarely via generic/475
and manifests as an assert failure in __xlog_state_release_iclog()
due to an unexpected iclog state.

Restore the locked error state check in xlog_state_release_iclog()
to ensure that an iclog state update via shutdown doesn't race with
the iclog release state processing code.

Fixes: df732b29c807 ("xfs: call xlog_state_release_iclog with l_icloglock held")
Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6006d94a581e..796ff37d5bb5b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -605,18 +605,23 @@ xfs_log_release_iclog(
 	struct xlog		*log = mp->m_log;
 	bool			sync;
 
-	if (iclog->ic_state == XLOG_STATE_IOERROR) {
-		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
-		return -EIO;
-	}
+	if (iclog->ic_state == XLOG_STATE_IOERROR)
+		goto error;
 
 	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
+		if (iclog->ic_state == XLOG_STATE_IOERROR) {
+			spin_unlock(&log->l_icloglock);
+			goto error;
+		}
 		sync = __xlog_state_release_iclog(log, iclog);
 		spin_unlock(&log->l_icloglock);
 		if (sync)
 			xlog_sync(log, iclog);
 	}
 	return 0;
+error:
+	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+	return -EIO;
 }
 
 /*
-- 
2.20.1

