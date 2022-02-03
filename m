Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FD74A8EA9
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbiBCUiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:38:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38454 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354815AbiBCUgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:36:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12C5AB835B5;
        Thu,  3 Feb 2022 20:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DACC340EF;
        Thu,  3 Feb 2022 20:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920578;
        bh=bai/vVg0+Sd0GkjYwKHHvpvysjdO9TLTFG2KhA14s1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EM6QkvVdADu6bPOfSAXkiK5iShg3vF0WmWx1u5y3RKhYPmAyormwW5AuWRsXRQpF+
         N/QbxbS2aPnfuPKrnrxqWh6utV8s7qEN0swmD8iOSp/6fthfFMrq/MapgcsEpRYahW
         7qhI8xw52w2jCt1RdOYsT9X97rTM2LbjsQZlF0vTBtvycJvsObJmbip1RXF6lE/3or
         ugK/SBlYj/8c8t45Bwo4KSCoNgA+z44Bo756ml2wb0lqAtF7WWJcBojAThvHmvoF7+
         uz1mAv+et7aTosR9NXrcoueL2hdt2g9Pjx2T9uIh2dVkSHArMbRrvOLhgiGICqnS4H
         0+Bb12C43/y/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        rtm@csail.mit.edu, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, anna.schumaker@netapp.com,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/10] NFSv4.1: Fix uninitialised variable in devicenotify
Date:   Thu,  3 Feb 2022 15:36:06 -0500
Message-Id: <20220203203613.4165-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203613.4165-1-sashal@kernel.org>
References: <20220203203613.4165-1-sashal@kernel.org>
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
index 8f34daf85f703..5d5227ce4d91e 100644
--- a/fs/nfs/callback.h
+++ b/fs/nfs/callback.h
@@ -168,7 +168,7 @@ struct cb_devicenotifyitem {
 };
 
 struct cb_devicenotifyargs {
-	int				 ndevs;
+	uint32_t			 ndevs;
 	struct cb_devicenotifyitem	 *devs;
 };
 
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index bcc51f131a496..868d66ed8bcf6 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -364,7 +364,7 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 				  struct cb_process_state *cps)
 {
 	struct cb_devicenotifyargs *args = argp;
-	int i;
+	uint32_t i;
 	__be32 res = 0;
 	struct nfs_client *clp = cps->clp;
 	struct nfs_server *server = NULL;
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 57558a8d92e9b..76aa1b456c524 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -268,11 +268,9 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
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
 	p = read_buf(xdr, sizeof(uint32_t));
@@ -281,7 +279,7 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 		goto out;
 	}
 	n = ntohl(*p++);
-	if (n <= 0)
+	if (n == 0)
 		goto out;
 	if (n > ULONG_MAX / sizeof(*args->devs)) {
 		status = htonl(NFS4ERR_BADXDR);
@@ -339,19 +337,21 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
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

