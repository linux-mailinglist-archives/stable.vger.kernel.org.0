Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D8B8C8EE
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfHNCfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbfHNCNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455D320844;
        Wed, 14 Aug 2019 02:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748820;
        bh=IWXx57Z3+ilWL0grl7SoS/dfxG4s6BcA1pj0NScVWL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMD+aYnOZzrBmD3L/pU0J4Z7NdpFuaRXrJmh4mxMgsBGMIFKNsuWgwJ0VSsrvk/x3
         yqSGaOlUE9P72WHcx9DyACNddcMNNlyi1FhmyPJPUBPrHgUmKWMHBoZfkycTBdTCuh
         m3UyTllXv836ztfh8TchiWvlZtniyBTLtF2yQYU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 081/123] NFSv4: When recovering state fails with EAGAIN, retry the same recovery
Date:   Tue, 13 Aug 2019 22:10:05 -0400
Message-Id: <20190814021047.14828-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

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
@@ -1632,8 +1633,10 @@ static int nfs4_reclaim_open_state(struct nfs4_state_owner *sp, const struct nfs
 
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
@@ -1647,6 +1650,10 @@ static int nfs4_reclaim_open_state(struct nfs4_state_owner *sp, const struct nfs
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

