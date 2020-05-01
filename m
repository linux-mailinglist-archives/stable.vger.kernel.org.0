Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D161C15D0
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgEANee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730579AbgEANed (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EEB42173E;
        Fri,  1 May 2020 13:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340072;
        bh=34PwhXMO6WlPQvzAomV0MV8ud2ziFyS4VfpXW95+D7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INXuxAO9dGgeTGnvA4o/+yVBciCLGN3oSZnNwf8m17d68l/CVIjhp7fhkRoKyF08K
         EsEDENHSI/sqoqCl8fni7xTe7J7WIwOoY3XeHTqwWUaI3N+PaEl4PyZdH/3AufIMPa
         tONP9kX+dAi2Oa52q63cG08dSSoMl+exTSmoQswU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.14 083/117] xfs: validate sb_logsunit is a multiple of the fs blocksize
Date:   Fri,  1 May 2020 15:21:59 +0200
Message-Id: <20200501131554.637574672@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

commit 9c92ee208b1faa0ef2cc899b85fd0607b6fac7fe upstream.

Make sure the log stripe unit is sane before proceeding with mounting.
AFAICT this means that logsunit has to be 0, 1, or a multiple of the fs
block size.  Found this by setting the LSB of logsunit in xfs/350 and
watching the system crash as soon as we try to write to the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

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


