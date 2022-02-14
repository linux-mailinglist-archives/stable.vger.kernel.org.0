Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05864B45F9
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243133AbiBNJ2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243041AbiBNJ2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C2B60AB8;
        Mon, 14 Feb 2022 01:28:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE94B80DCE;
        Mon, 14 Feb 2022 09:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5F3C340E9;
        Mon, 14 Feb 2022 09:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830911;
        bh=wzTFj+0Mwr65hL4KdCPB/QhA7XSUNn1oZCkfP8JhOV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkaLMHtl+KtWv2Ch+h/bTXQPTFoAV6FcLl0ZiQ53ps+dQ4Cx+l4c1DoXsxyjuh3bl
         vzjqdhuqYpk1ZoWhaeoyKiWA8naQ+G7bjUU0quTCc4GtrKstOuKR9edbSt3YKSaE8w
         t54M+49eqGiJA98ta77spd1ib5RRq4NB1OeMUa2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.9 04/34] NFSD: Clamp WRITE offsets
Date:   Mon, 14 Feb 2022 10:25:30 +0100
Message-Id: <20220214092446.088940343@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
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
@@ -191,6 +191,11 @@ nfsd3_proc_write(struct svc_rqst *rqstp,
 				(unsigned long long) argp->offset,
 				argp->stable? " stable" : "");
 
+	resp->status = nfserr_fbig;
+	if (argp->offset > (u64)OFFSET_MAX ||
+	    argp->offset + argp->len > (u64)OFFSET_MAX)
+		return rpc_success;
+
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
 	nfserr = nfsd_write(rqstp, &resp->fh, NULL,
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -982,8 +982,9 @@ nfsd4_write(struct svc_rqst *rqstp, stru
 	unsigned long cnt;
 	int nvecs;
 
-	if (write->wr_offset >= OFFSET_MAX)
-		return nfserr_inval;
+	if (write->wr_offset > (u64)OFFSET_MAX ||
+	    write->wr_offset + write->wr_buflen > (u64)OFFSET_MAX)
+		return nfserr_fbig;
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 						stateid, WR_STATE, &filp, NULL);


