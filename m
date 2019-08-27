Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33B9E130
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfH0IK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731989AbfH0ICc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:02:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26421206BF;
        Tue, 27 Aug 2019 08:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892951;
        bh=o6TnhVy76XKHESo2I+Eq2ufP6xaxURzahcd8rJR07kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcZDACrd9dF8z+dWHH7bvOdZ+qaBlV+KMb62awByeFQHqeO918fS/fYFwWJn0NWST
         wll6vingvGcJTFSetL2eXZajUgH3y25Q3q+yv8vFukDHAl4m6wLO5n6l/ZtpG04Fni
         YhX6KjxVASgYgoGI0fkJKiCxq67GrSNLjB59uB6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 072/162] NFSv4: When recovering state fails with EAGAIN, retry the same recovery
Date:   Tue, 27 Aug 2019 09:50:00 +0200
Message-Id: <20190827072740.637201173@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c34fae003c79570b6c930b425fea3f0b7b1e7056 ]

If the server returns with EAGAIN when we're trying to recover from
a server reboot, we currently delay for 1 second, but then mark the
stateid as needing recovery after the grace period has expired.

Instead, we should just retry the same recovery process immediately
after the 1 second delay. Break out of the loop after 10 retries.

Fixes: 35a61606a612 ("NFS: Reduce indentation of the switch statement...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index e2e3c4f04d3e0..556ec916846f0 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1606,6 +1606,7 @@ static int __nfs4_reclaim_open_state(struct nfs4_state_owner *sp, struct nfs4_st
 static int nfs4_reclaim_open_state(struct nfs4_state_owner *sp, const struct nfs4_state_recovery_ops *ops)
 {
 	struct nfs4_state *state;
+	unsigned int loop = 0;
 	int status = 0;
 
 	/* Note: we rely on the sp->so_states list being ordered 
@@ -1632,8 +1633,10 @@ restart:
 
 		switch (status) {
 		default:
-			if (status >= 0)
+			if (status >= 0) {
+				loop = 0;
 				break;
+			}
 			printk(KERN_ERR "NFS: %s: unhandled error %d\n", __func__, status);
 			/* Fall through */
 		case -ENOENT:
@@ -1647,6 +1650,10 @@ restart:
 			break;
 		case -EAGAIN:
 			ssleep(1);
+			if (loop++ < 10) {
+				set_bit(ops->state_flag_bit, &state->flags);
+				break;
+			}
 			/* Fall through */
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_STALE_STATEID:
-- 
2.20.1



