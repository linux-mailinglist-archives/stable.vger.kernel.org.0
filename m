Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B5D4B46BE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbiBNJi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:38:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243437AbiBNJhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:37:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014C725C50;
        Mon, 14 Feb 2022 01:35:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F0A6115C;
        Mon, 14 Feb 2022 09:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD207C340E9;
        Mon, 14 Feb 2022 09:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831311;
        bh=wrvm4BiHxqFYlSJd6mG0nwoaKK3QAzJNgyYN2bgRj74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWEhoB+gmtnNHCZ8tVAtndshYQcwhiCYLS3aWxQS59aBNCNM9t2dNiHoi2PzfKWSA
         qUvI7Tt/+l22t7X2cKILLTJuleAIrk0f6OMjSWvpLfJQL9hLhWfQujWp2Ss3DBjmvp
         hvVHH4ozxIQBaDEMJ0t5a8oQpvhc7HoqQGpv5+sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, rtm@csail.mit.edu,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/71] NFSv4.1: Fix uninitialised variable in devicenotify
Date:   Mon, 14 Feb 2022 10:25:42 +0100
Message-Id: <20220214092452.504846039@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index fc775b0b5194f..b8a7b223b5b18 100644
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
index 73a5a5ea29766..90b5511c4c440 100644
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



