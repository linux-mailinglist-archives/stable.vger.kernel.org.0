Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AF74CF6F7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbiCGJnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbiCGJln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9CF5BE42;
        Mon,  7 Mar 2022 01:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E0AAB810BD;
        Mon,  7 Mar 2022 09:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E43C340E9;
        Mon,  7 Mar 2022 09:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645932;
        bh=np/VDDuSzK0U7l3ywkzyCKXrtcwvE2mSNRZWXCFH3oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcxYnBHMOOcFKCUaZreVlVcOaV8GiigyfFlbbWi14nMM0kvmwwOfWkyD+tcUl404l
         bmFPPxWeDnZvr9D8LYdoA7XnG1q2oX4AAjOOoPlAS6iSk7LbZ6mdwueIEO8kOBhDCP
         lp5nQ6TG5zgC8qfDfFnth2ajJ5SoVJ/1IV+8smUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/262] NFSD: Fix zero-length NFSv3 WRITEs
Date:   Mon,  7 Mar 2022 10:16:28 +0100
Message-Id: <20220307091703.765871345@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6a2f774424bfdcc2df3e17de0cefe74a4269cad5 ]

The Linux NFS server currently responds to a zero-length NFSv3 WRITE
request with NFS3ERR_IO. It responds to a zero-length NFSv4 WRITE
with NFS4_OK and count of zero.

RFC 1813 says of the WRITE procedure's @count argument:

count
         The number of bytes of data to be written. If count is
         0, the WRITE will succeed and return a count of 0,
         barring errors due to permissions checking.

RFC 8881 has similar language for NFSv4, though NFSv4 removed the
explicit @count argument because that value is already contained in
the opaque payload array.

The synthetic client pynfs's WRT4 and WRT15 tests do emit zero-
length WRITEs to exercise this spec requirement. Commit fdec6114ee1f
("nfsd4: zero-length WRITE should succeed") addressed the same
problem there with the same fix.

But interestingly the Linux NFS client does not appear to emit zero-
length WRITEs, instead squelching them. I'm not aware of a test that
can generate such WRITEs for NFSv3, so I wrote a naive C program to
generate a zero-length WRITE and test this fix.

Fixes: 8154ef2776aa ("NFSD: Clean up legacy NFS WRITE argument XDR decoders")
Reported-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 6 +-----
 fs/nfsd/nfsproc.c  | 5 -----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 354bbfcd96aae..b540489ea240d 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -211,15 +211,11 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
 	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
-	if (!nvecs) {
-		resp->status = nfserr_io;
-		goto out;
-	}
+
 	resp->status = nfsd_write(rqstp, &resp->fh, argp->offset,
 				  rqstp->rq_vec, nvecs, &cnt,
 				  resp->committed, resp->verf);
 	resp->count = cnt;
-out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index de282f3273c50..312fd289be583 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -235,10 +235,6 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		argp->len, argp->offset);
 
 	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
-	if (!nvecs) {
-		resp->status = nfserr_io;
-		goto out;
-	}
 
 	resp->status = nfsd_write(rqstp, fh_copy(&resp->fh, &argp->fh),
 				  argp->offset, rqstp->rq_vec, nvecs,
@@ -247,7 +243,6 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
 		return rpc_drop_reply;
-out:
 	return rpc_success;
 }
 
-- 
2.34.1



