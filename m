Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C714A8D40
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354087AbiBCU37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:29:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35198 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354059AbiBCU3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:29:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E0261A6A;
        Thu,  3 Feb 2022 20:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4ADC340F0;
        Thu,  3 Feb 2022 20:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920194;
        bh=A7U1HkB2a885FrWTHJAWjetyqmCy4MwdfkCVXx5gPTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFMjwkvd6IfcRF5isyBS/ljREGto7clWXt91KyhNTg9fPzYBz5ojG8EbY7Kh2F6xl
         jNIfOMGI152vaWX/MVxrY5/jwP5Xx2uWUuPcvies1bYAUQfp6vDEEEzc6WGRhoU/Q3
         3Dgb7CuNelR+EWal2QBMnZtf5eYIBZ3i3KIKXwgrowMu0uFvG9gNnVEDufe82R60kF
         au/bz5U11CMXA/cYOn6gNcPYaWWxcFZ3ff55DUz6NaOtzEa7YkyEGXq27eV/UnAxhB
         3IfPowhI6Cni2IEsd0PSwAI0Pi1dusrtMvNmySZVGwhpvQfT/ojMct5ONKqusAiXiy
         HSW0qz5FYOeIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        rtm@csail.mit.edu, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 04/52] NFSv4.1: Fix uninitialised variable in devicenotify
Date:   Thu,  3 Feb 2022 15:28:58 -0500
Message-Id: <20220203202947.2304-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b05bf5c63b326ce1da84ef42498d8e0e292e694c ]

When decode_devicenotify_args() exits with no entries, we need to
ensure that the struct cb_devicenotifyargs is initialised to
{ 0, NULL } in order to avoid problems in
nfs4_callback_devicenotify().

Reported-by: <rtm@csail.mit.edu>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback.h      |  2 +-
 fs/nfs/callback_proc.c |  2 +-
 fs/nfs/callback_xdr.c  | 18 +++++++++---------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/callback.h b/fs/nfs/callback.h
index 6a2033131c068..ccd4f245cae24 100644
--- a/fs/nfs/callback.h
+++ b/fs/nfs/callback.h
@@ -170,7 +170,7 @@ struct cb_devicenotifyitem {
 };
 
 struct cb_devicenotifyargs {
-	int				 ndevs;
+	uint32_t			 ndevs;
 	struct cb_devicenotifyitem	 *devs;
 };
 
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 09c5b1cb3e075..c343666d9a428 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -358,7 +358,7 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 				  struct cb_process_state *cps)
 {
 	struct cb_devicenotifyargs *args = argp;
-	int i;
+	uint32_t i;
 	__be32 res = 0;
 	struct nfs_client *clp = cps->clp;
 	struct nfs_server *server = NULL;
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index a67c41ec545fd..f90de8043b0f9 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -258,11 +258,9 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 				void *argp)
 {
 	struct cb_devicenotifyargs *args = argp;
+	uint32_t tmp, n, i;
 	__be32 *p;
 	__be32 status = 0;
-	u32 tmp;
-	int n, i;
-	args->ndevs = 0;
 
 	/* Num of device notifications */
 	p = xdr_inline_decode(xdr, sizeof(uint32_t));
@@ -271,7 +269,7 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 		goto out;
 	}
 	n = ntohl(*p++);
-	if (n <= 0)
+	if (n == 0)
 		goto out;
 	if (n > ULONG_MAX / sizeof(*args->devs)) {
 		status = htonl(NFS4ERR_BADXDR);
@@ -330,19 +328,21 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 			dev->cbd_immediate = 0;
 		}
 
-		args->ndevs++;
-
 		dprintk("%s: type %d layout 0x%x immediate %d\n",
 			__func__, dev->cbd_notify_type, dev->cbd_layout_type,
 			dev->cbd_immediate);
 	}
+	args->ndevs = n;
+	dprintk("%s: ndevs %d\n", __func__, args->ndevs);
+	return 0;
+err:
+	kfree(args->devs);
 out:
+	args->devs = NULL;
+	args->ndevs = 0;
 	dprintk("%s: status %d ndevs %d\n",
 		__func__, ntohl(status), args->ndevs);
 	return status;
-err:
-	kfree(args->devs);
-	goto out;
 }
 
 static __be32 decode_sessionid(struct xdr_stream *xdr,
-- 
2.34.1

