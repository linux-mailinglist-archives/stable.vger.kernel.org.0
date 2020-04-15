Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656FA1AA19F
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370133AbgDOMoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897515AbgDOLn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 161832173E;
        Wed, 15 Apr 2020 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951007;
        bh=SFHvZtCLZ6EPWmNWrCEP+2BJ94BANmVoF5rF+9ZXu9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PxJKXtamoTt0K0pGqmhfFAR1gYGAh2lXgTHdFGOgHGZ8hb2KUkTZJ2pgHIIbM7H0
         R2+6dxMBNPNx6PzegL35huYkN1rR1M8XHmylb/SrQM3fQa8IKYMEFuCGA7laPkLBQl
         BICose1KHGVan8r7n/GaM+0QDXGNgBQEgYtq5+4g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.5 052/106] cifs: Allocate encryption header through kmalloc
Date:   Wed, 15 Apr 2020 07:41:32 -0400
Message-Id: <20200415114226.13103-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 3946d0d04bb360acca72db5efe9ae8440012d9dc ]

When encryption is used, smb2_transform_hdr is defined on the stack and is
passed to the transport. This doesn't work with RDMA as the buffer needs to
be DMA'ed.

Fix it by using kmalloc.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index cb3ee916f5275..c97570eb2c180 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -466,7 +466,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	      struct smb_rqst *rqst, int flags)
 {
 	struct kvec iov;
-	struct smb2_transform_hdr tr_hdr;
+	struct smb2_transform_hdr *tr_hdr;
 	struct smb_rqst cur_rqst[MAX_COMPOUND];
 	int rc;
 
@@ -476,28 +476,34 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	if (num_rqst > MAX_COMPOUND - 1)
 		return -ENOMEM;
 
-	memset(&cur_rqst[0], 0, sizeof(cur_rqst));
-	memset(&iov, 0, sizeof(iov));
-	memset(&tr_hdr, 0, sizeof(tr_hdr));
-
-	iov.iov_base = &tr_hdr;
-	iov.iov_len = sizeof(tr_hdr);
-	cur_rqst[0].rq_iov = &iov;
-	cur_rqst[0].rq_nvec = 1;
-
 	if (!server->ops->init_transform_rq) {
 		cifs_server_dbg(VFS, "Encryption requested but transform "
 				"callback is missing\n");
 		return -EIO;
 	}
 
+	tr_hdr = kmalloc(sizeof(*tr_hdr), GFP_NOFS);
+	if (!tr_hdr)
+		return -ENOMEM;
+
+	memset(&cur_rqst[0], 0, sizeof(cur_rqst));
+	memset(&iov, 0, sizeof(iov));
+	memset(tr_hdr, 0, sizeof(*tr_hdr));
+
+	iov.iov_base = tr_hdr;
+	iov.iov_len = sizeof(*tr_hdr);
+	cur_rqst[0].rq_iov = &iov;
+	cur_rqst[0].rq_nvec = 1;
+
 	rc = server->ops->init_transform_rq(server, num_rqst + 1,
 					    &cur_rqst[0], rqst);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = __smb_send_rqst(server, num_rqst + 1, &cur_rqst[0]);
 	smb3_free_compound_rqst(num_rqst, &cur_rqst[1]);
+out:
+	kfree(tr_hdr);
 	return rc;
 }
 
-- 
2.20.1

