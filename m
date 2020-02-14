Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A317315EAEC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388156AbgBNRRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391070AbgBNQLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15404246A2;
        Fri, 14 Feb 2020 16:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696684;
        bh=HX1sH3xP4I5yGM42z+4OP78uM3vNefqII84YLQA3uZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2+zzoVh0mzD0aZZn2/VnkI9uFarGU7cINP4Zt89XA4LNN7eQoI1aP1dJ76jrMGKE
         jo/oMBHfW5Cs+L/9SY5oAu/YmR+uGgMFIO2ULrFD2NNTE64Og6IRY2Vs3r7yYnnce0
         /rqkG0xbUqMMHHlAa0cIBBQNikwMiyn337vNmdaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Milkowski <rmilkowski@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 452/459] NFSv4: try lease recovery on NFS4ERR_EXPIRED
Date:   Fri, 14 Feb 2020 11:01:42 -0500
Message-Id: <20200214160149.11681-452-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Milkowski <rmilkowski@gmail.com>

[ Upstream commit 924491f2e476f7234d722b24171a4daff61bbe13 ]

Currently, if an nfs server returns NFS4ERR_EXPIRED to open(),
we return EIO to applications without even trying to recover.

Fixes: 272289a3df72 ("NFSv4: nfs4_do_handle_exception() handle revoke/expiry of a single stateid")
Signed-off-by: Robert Milkowski <rmilkowski@gmail.com>
Reviewed-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f26d714f9f28a..5abb3195658a9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3187,6 +3187,11 @@ static struct nfs4_state *nfs4_do_open(struct inode *dir,
 			exception.retry = 1;
 			continue;
 		}
+		if (status == -NFS4ERR_EXPIRED) {
+			nfs4_schedule_lease_recovery(server->nfs_client);
+			exception.retry = 1;
+			continue;
+		}
 		if (status == -EAGAIN) {
 			/* We must have found a delegation */
 			exception.retry = 1;
-- 
2.20.1

