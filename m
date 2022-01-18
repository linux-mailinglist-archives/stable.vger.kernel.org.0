Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE84920E8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiARIHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343699AbiARIHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:07:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF02C06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:07:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A20613F9
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F8CC00446;
        Tue, 18 Jan 2022 08:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642493221;
        bh=G+e9Bsrk4owBvQrtbaiebRqvGZ6QTOcvOUbejhngzDI=;
        h=Subject:To:Cc:From:Date:From;
        b=TqTxgzUDAL9u/vqsiRxw1G3o+EcAdXkK7wQeDm3pSXWBGBhLvw8zcz4IkuL53NY8q
         WddPM/9BOCWJIBIsGc2S+8qJa9/MVhRuEkNazK1M50W+b713Wl/G+pMlAQnte+hZ1W
         1v4n0xQLhzi+gx0UxTB9daWQ2hZZoguMUtzyZLqs=
Subject: FAILED: patch "[PATCH] NFSD: Fix zero-length NFSv3 WRITEs" failed to apply to 5.15-stable tree
To:     chuck.lever@oracle.com, trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 09:06:45 +0100
Message-ID: <1642493205231189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6a2f774424bfdcc2df3e17de0cefe74a4269cad5 Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 21 Dec 2021 11:52:06 -0500
Subject: [PATCH] NFSD: Fix zero-length NFSv3 WRITEs

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

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 4418517f6f12..2c681785186f 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -202,15 +202,11 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
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
index eea5b59b6a6c..1743ed04197e 100644
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
 

