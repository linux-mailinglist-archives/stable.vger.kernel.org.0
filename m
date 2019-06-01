Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFFE31E60
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfFANgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbfFANXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:23:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DFBF2733E;
        Sat,  1 Jun 2019 13:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395389;
        bh=lnFW5gG9551imywQnGt9DprAJTR1VWSR1iju52s88k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJr4qGTRwdv2JCfXCoAuTB7TfPdj9MX/NuO4r2Qif1JoFeiBv/CY+QF6f6CxFJoVv
         FOY0LKwUge8EZAO/3TWsWdt4pjFW8eMmZxU8mhxGGoVMBCqJCxhXgIOwpygrgFewTk
         EFSJU2qpz5ntpcWoHVwrOI3lvKxdOt0B+CdiDaig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/141] NFS4: Fix v4.0 client state corruption when mount
Date:   Sat,  1 Jun 2019 09:20:06 -0400
Message-Id: <20190601132158.25821-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit f02f3755dbd14fb935d24b14650fff9ba92243b8 ]

stat command with soft mount never return after server is stopped.

When alloc a new client, the state of the client will be set to
NFS4CLNT_LEASE_EXPIRED.

When the server is stopped, the state manager will work, and accord
the state to recover. But the state is NFS4CLNT_LEASE_EXPIRED, it
will drain the slot table and lead other task to wait queue, until
the client recovered. Then the stat command is hung.

When discover server trunking, the client will renew the lease,
but check the client state, it lead the client state corruption.

So, we need to call state manager to recover it when detect server
ip trunking.

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index d2f645d34eb13..3ba2087469ac8 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -159,6 +159,10 @@ int nfs40_discover_server_trunking(struct nfs_client *clp,
 		/* Sustain the lease, even if it's empty.  If the clientid4
 		 * goes stale it's of no use for trunking discovery. */
 		nfs4_schedule_state_renewal(*result);
+
+		/* If the client state need to recover, do it. */
+		if (clp->cl_state)
+			nfs4_schedule_state_manager(clp);
 	}
 out:
 	return status;
-- 
2.20.1

