Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E0224AAC1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgHTAEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgHTAEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:04:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E7521744;
        Thu, 20 Aug 2020 00:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881853;
        bh=Eg9nDMoUgxhBqbsefQgTOQ4752a8CjLlzYcD2awEVxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zekS23QTYLxHz/Yegzan6U6KspMWZqjvzul7MTZE7PXhVP/FGEuETkHf2ogvWURGv
         lZWJD1hk9bVCzh4/BV8bC/K3MGTRwr6NgHSRe0p9KP+cy6mqp2GmHY4zzDLE5Ghy0m
         JWTPu1oRXJJrO4kNldu0mToB2itF8U0YbSc3qXec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/10] xfs: fix inode quota reservation checks
Date:   Wed, 19 Aug 2020 20:04:01 -0400
Message-Id: <20200820000406.216050-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000406.216050-1-sashal@kernel.org>
References: <20200820000406.216050-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit f959b5d037e71a4d69b5bf71faffa065d9269b4a ]

xfs_trans_dqresv is the function that we use to make reservations
against resource quotas.  Each resource contains two counters: the
q_core counter, which tracks resources allocated on disk; and the dquot
reservation counter, which tracks how much of that resource has either
been allocated or reserved by threads that are working on metadata
updates.

For disk blocks, we compare the proposed reservation counter against the
hard and soft limits to decide if we're going to fail the operation.
However, for inodes we inexplicably compare against the q_core counter,
not the incore reservation count.

Since the q_core counter is always lower than the reservation count and
we unlock the dquot between reservation and transaction commit, this
means that multiple threads can reserve the last inode count before we
hit the hard limit, and when they commit, we'll be well over the hard
limit.

Fix this by checking against the incore inode reservation counter, since
we would appear to maintain that correctly (and that's what we report in
GETQUOTA).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_trans_dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ce78534a047ee..bb8de2dddabe2 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -662,7 +662,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
+			total_count = dqp->q_res_icount + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
-- 
2.25.1

