Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACF442B194
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhJMA7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237111AbhJMA63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6675E6101D;
        Wed, 13 Oct 2021 00:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086587;
        bh=5mM8GkEHYMUJjg/Px3DlT/KvNoDQPHUyWaTc1Okbq8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S52C3QHrBcth5X9Gd46cp/U++7+y6lUI7QYuACrQJrVFrOrMKB3ZioejDi7hnup2M
         A2JFIk9T7Kb70InQDd+Nq56awEbNE06spBM1O9gTJ7j5hK/BXEzA825o/jNDMzBU0C
         8A+hId7D7labN7L/MbhdI6KuCiDYdsohbFh/ty5b1yHCXapsD1NmwrkFmZDZxcKX2L
         3+ExF1t72r/ta8dOruczdpRcQDbth36WQurX22b5HWOS9Mn/xw0NFRQsy2edUncf/e
         qxifPxwvv9avahB+EMP/+kqA5mDhWu3gGfuT7fUK69UvnfRQ+VVt/68xisyz1B1Zxe
         ZJCj37eMXnKtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/5] NFSD: Keep existing listeners on portlist error
Date:   Tue, 12 Oct 2021 20:56:17 -0400
Message-Id: <20211013005619.700553-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005619.700553-1-sashal@kernel.org>
References: <20211013005619.700553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit c20106944eb679fa3ab7e686fe5f6ba30fbc51e5 ]

If nfsd has existing listening sockets without any processes, then an error
returned from svc_create_xprt() for an additional transport will remove
those existing listeners.  We're seeing this in practice when userspace
attempts to create rpcrdma transports without having the rpcrdma modules
present before creating nfsd kernel processes.  Fix this by checking for
existing sockets before calling nfsd_destroy().

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index cb69660d0779..ff9899cc9913 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -788,7 +788,10 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net)
 		svc_xprt_put(xprt);
 	}
 out_err:
-	nfsd_destroy(net);
+	if (!list_empty(&nn->nfsd_serv->sv_permsocks))
+		nn->nfsd_serv->sv_nrthreads--;
+	 else
+		nfsd_destroy(net);
 	return err;
 }
 
-- 
2.33.0

