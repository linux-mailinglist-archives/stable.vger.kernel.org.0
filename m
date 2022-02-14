Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C332F4B4A45
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346390AbiBNKSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347973AbiBNKRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:17:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90318CD9E;
        Mon, 14 Feb 2022 01:54:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCE460F31;
        Mon, 14 Feb 2022 09:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D80C340E9;
        Mon, 14 Feb 2022 09:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832445;
        bh=7wu8b6agGOA1q3qTSBxQDmnk8+fRPmC6y+mRFVQk5vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVgAlQcaHclp010hvq6QHy8Bpynd9e5A306Obx+Yh+cBD6T+sa/t3X43gbDlXI4+8
         MYMN3hyeM2jRdl7dmonaHZ+8pJqzen83/Jqe8xnfwzPFXZXbQCxjnD23NEgYvlXaIg
         iE7xInLNbrTIwvEskTiePJeW9QMYNyOoMERR7/Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.16 017/203] NFSD: Clamp WRITE offsets
Date:   Mon, 14 Feb 2022 10:24:21 +0100
Message-Id: <20220214092510.806006366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 6260d9a56ab352b54891ec66ab0eced57d55abc6 upstream.

Ensure that a client cannot specify a WRITE range that falls in a
byte range outside what the kernel's internal types (such as loff_t,
which is signed) can represent. The kiocb iterators, invoked in
nfsd_vfs_write(), should properly limit write operations to within
the underlying file system's s_maxbytes.

Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3proc.c |    5 +++++
 fs/nfsd/nfs4proc.c |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -199,6 +199,11 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 				(unsigned long long) argp->offset,
 				argp->stable? " stable" : "");
 
+	resp->status = nfserr_fbig;
+	if (argp->offset > (u64)OFFSET_MAX ||
+	    argp->offset + argp->len > (u64)OFFSET_MAX)
+		return rpc_success;
+
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
 	nvecs = svc_fill_write_vector(rqstp, &argp->payload);
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1018,8 +1018,9 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 	unsigned long cnt;
 	int nvecs;
 
-	if (write->wr_offset >= OFFSET_MAX)
-		return nfserr_inval;
+	if (write->wr_offset > (u64)OFFSET_MAX ||
+	    write->wr_offset + write->wr_buflen > (u64)OFFSET_MAX)
+		return nfserr_fbig;
 
 	cnt = write->wr_buflen;
 	trace_nfsd_write_start(rqstp, &cstate->current_fh,


