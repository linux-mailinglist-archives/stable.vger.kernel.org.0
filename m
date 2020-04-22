Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9CA1B3F56
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgDVKW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgDVKW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 691662075A;
        Wed, 22 Apr 2020 10:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550977;
        bh=uM8RYOThTOAePXpnhO/MjXiLuve+HcAfoAQLYud7kjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksrfLgHYBxP94+GZl9eb+cvhLyg1mELZ1dWGN9O4w2Kr6Kc/ITldWcT64yJGfgUdu
         SYmAQeywO2h0bDFsy+59RdJ/H7AJ2n4IbkJMEpl0fa32skgmERiOOzhexj+hs2OMTM
         lNNocwzy4bjGzNanz2WZ8/8CR+oDXQSQSVAjN5EM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 050/166] xfs: fix iclog release error check race with shutdown
Date:   Wed, 22 Apr 2020 11:56:17 +0200
Message-Id: <20200422095054.425468418@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



