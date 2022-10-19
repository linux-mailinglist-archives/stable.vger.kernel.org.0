Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D5A603CDF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiJSIxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiJSIwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19C1AE7E;
        Wed, 19 Oct 2022 01:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3547B6183D;
        Wed, 19 Oct 2022 08:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495A3C433C1;
        Wed, 19 Oct 2022 08:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169299;
        bh=dwIXOdJuAOxWz/PyHB5qv9pOyyCPiOmAk1+VNTWtVYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTLcXNzAASNw+OX2HSB1GetBFfvz831WG52b2HIDlKYsJExEb5fKwCpJBd36l7Cuc
         nsgvNXSZHFErcH3jlGl1rq0B6PiiFkzIznsP2nXKm77+k7/gKGmnuplVA3ybMDoA62
         nCMEjsBI8mBZU1C1sWioo7Jmz62Zr0R+lMN+YfxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Fields <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 225/862] NFSD: Fix handling of oversized NFSv4 COMPOUND requests
Date:   Wed, 19 Oct 2022 10:25:12 +0200
Message-Id: <20221019083259.992110907@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7518a3dc5ea249d4112156ce71b8b184eb786151 ]

If an NFS server returns NFS4ERR_RESOURCE on the first operation in
an NFSv4 COMPOUND, there's no way for a client to know where the
problem is and then simplify the compound to make forward progress.

So instead, make NFSD process as many operations in an oversized
COMPOUND as it can and then return NFS4ERR_RESOURCE on the first
operation it did not process.

pynfs NFSv4.0 COMP6 exercises this case, but checks only for the
COMPOUND status code, not whether the server has processed any
of the operations.

pynfs NFSv4.1 SEQ6 and SEQ7 exercise the NFSv4.1 case, which detects
too many operations per COMPOUND by checking against the limits
negotiated when the session was created.

Suggested-by: Bruce Fields <bfields@fieldses.org>
Fixes: 0078117c6d91 ("nfsd: return RESOURCE not GARBAGE_ARGS on too many ops")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 19 +++++++++++++------
 fs/nfsd/nfs4xdr.c  | 12 +++---------
 fs/nfsd/xdr4.h     |  3 ++-
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 0437210b9898..22de5e0249ea 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2633,9 +2633,6 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	status = nfserr_minor_vers_mismatch;
 	if (nfsd_minorversion(nn, args->minorversion, NFSD_TEST) <= 0)
 		goto out;
-	status = nfserr_resource;
-	if (args->opcnt > NFSD_MAX_OPS_PER_COMPOUND)
-		goto out;
 
 	status = nfs41_check_op_ordering(args);
 	if (status) {
@@ -2648,10 +2645,20 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 
 	rqstp->rq_lease_breaker = (void **)&cstate->clp;
 
-	trace_nfsd_compound(rqstp, args->opcnt);
+	trace_nfsd_compound(rqstp, args->client_opcnt);
 	while (!status && resp->opcnt < args->opcnt) {
 		op = &args->ops[resp->opcnt++];
 
+		if (unlikely(resp->opcnt == NFSD_MAX_OPS_PER_COMPOUND)) {
+			/* If there are still more operations to process,
+			 * stop here and report NFS4ERR_RESOURCE. */
+			if (cstate->minorversion == 0 &&
+			    args->client_opcnt > resp->opcnt) {
+				op->status = nfserr_resource;
+				goto encode_op;
+			}
+		}
+
 		/*
 		 * The XDR decode routines may have pre-set op->status;
 		 * for example, if there is a miscellaneous XDR error
@@ -2727,8 +2734,8 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 			status = op->status;
 		}
 
-		trace_nfsd_compound_status(args->opcnt, resp->opcnt, status,
-					   nfsd4_op_name(op->opnum));
+		trace_nfsd_compound_status(args->client_opcnt, resp->opcnt,
+					   status, nfsd4_op_name(op->opnum));
 
 		nfsd4_cstate_clear_replay(cstate);
 		nfsd4_increment_op_stats(op->opnum);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1e9690a061ec..ac1b03cf05a5 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2357,16 +2357,10 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 
 	if (xdr_stream_decode_u32(argp->xdr, &argp->minorversion) < 0)
 		return false;
-	if (xdr_stream_decode_u32(argp->xdr, &argp->opcnt) < 0)
+	if (xdr_stream_decode_u32(argp->xdr, &argp->client_opcnt) < 0)
 		return false;
-
-	/*
-	 * NFS4ERR_RESOURCE is a more helpful error than GARBAGE_ARGS
-	 * here, so we return success at the xdr level so that
-	 * nfsd4_proc can handle this is an NFS-level error.
-	 */
-	if (argp->opcnt > NFSD_MAX_OPS_PER_COMPOUND)
-		return true;
+	argp->opcnt = min_t(u32, argp->client_opcnt,
+			    NFSD_MAX_OPS_PER_COMPOUND);
 
 	if (argp->opcnt > ARRAY_SIZE(argp->iops)) {
 		argp->ops = kzalloc(argp->opcnt * sizeof(*argp->ops), GFP_KERNEL);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 96267258e629..466e2786fc97 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -717,9 +717,10 @@ struct nfsd4_compoundargs {
 	struct svcxdr_tmpbuf		*to_free;
 	struct svc_rqst			*rqstp;
 
-	u32				taglen;
 	char *				tag;
+	u32				taglen;
 	u32				minorversion;
+	u32				client_opcnt;
 	u32				opcnt;
 	struct nfsd4_op			*ops;
 	struct nfsd4_op			iops[8];
-- 
2.35.1



