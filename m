Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6408BD925E
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404153AbfJPNWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:22:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38109 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729306AbfJPNWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:22:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2652620F25;
        Wed, 16 Oct 2019 09:22:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 09:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=utPBxA
        UD1Z678Dcb9EZToiS+M1RF82eJ4ByZ2rN+IF4=; b=HBxF19HjYIBQi/1qQYEVTz
        y0hGXX97JHdy144O6CLzHhD38BiBfh0NDCuTXEN3cwEtWZxvJgvBGAWxAHTG9yyV
        B6ATA6YlqcpbPhrQFeBDSM9J3deMqK7SnP3I/a86GPozXkNQql5c/jLeQ6eER5gR
        jyUnJNrr4Hq9ISXlprKxktK4sfYzusEWQUHbhUP/A38i5hvaz8hPd23vVO9OUdao
        Nz3OOxqzpEBGgmod2H1KfR6U4JMFCzFzC2+Gp6ngp2a7OOxBr39Lfg/YGQRMzomE
        2t+MAZuC+34yOFWRJGEN7H7rhnO/EENOPsIa1Aele/ELztodMUZ+Fe+pLvAMVEOA
        ==
X-ME-Sender: <xms:qhmnXTL4eEKt9JEVnax1C3qg0DLOJ4Xa6PWjPeCMafRXJNTD5Y_nbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrudefiedrvdefiedrleegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:qhmnXTNKlSOCFZ85woekQCbrDXL7txImpH-CdgrXqI3dFUnIW69JMg>
    <xmx:qhmnXXBfrUG8XsAj750PTP5hR8s6A3L0800IagDtFo97ucUUmcZrqA>
    <xmx:qhmnXbWfPNofTN1APg6DoXo_OmGk5Ea-802dF1K81Z2mlnus5sq_1w>
    <xmx:qhmnXS9sZPSiISQmBmlNP9APckESugCObotpDx_Ziz9BzxiINY0HLw>
Received: from localhost (unknown [209.136.236.94])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D8DF8005B;
        Wed, 16 Oct 2019 09:22:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFS: Fix O_DIRECT accounting of number of bytes read/written" failed to apply to 4.9-stable tree
To:     trondmy@gmail.com, Anna.Schumaker@Netapp.com,
        suyj.fnst@cn.fujitsu.com, trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Oct 2019 06:22:40 -0700
Message-ID: <157123216023152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 031d73ed768a40684f3ca21992265ffdb6a270bf Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trondmy@gmail.com>
Date: Mon, 30 Sep 2019 14:02:56 -0400
Subject: [PATCH] NFS: Fix O_DIRECT accounting of number of bytes read/written

When a series of O_DIRECT reads or writes are truncated, either due to
eof or due to an error, then we should return the number of contiguous
bytes that were received/sent starting at the offset specified by the
application.

Currently, we are failing to correctly check contiguity, and so we're
failing the generic/465 in xfstests when the race between the read
and write RPCs causes the file to get extended while the 2 reads are
outstanding. If the first read RPC call wins the race and returns with
eof set, we should treat the second read RPC as being truncated.

Reported-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Fixes: 1ccbad9f9f9bd ("nfs: fix DIO good bytes calculation")
Cc: stable@vger.kernel.org # 4.1+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 222d7115db71..98a9a0bcdf38 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -123,32 +123,49 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
 }
 
 static void
-nfs_direct_good_bytes(struct nfs_direct_req *dreq, struct nfs_pgio_header *hdr)
+nfs_direct_handle_truncated(struct nfs_direct_req *dreq,
+			    const struct nfs_pgio_header *hdr,
+			    ssize_t dreq_len)
 {
-	int i;
-	ssize_t count;
+	struct nfs_direct_mirror *mirror = &dreq->mirrors[hdr->pgio_mirror_idx];
+
+	if (!(test_bit(NFS_IOHDR_ERROR, &hdr->flags) ||
+	      test_bit(NFS_IOHDR_EOF, &hdr->flags)))
+		return;
+	if (dreq->max_count >= dreq_len) {
+		dreq->max_count = dreq_len;
+		if (dreq->count > dreq_len)
+			dreq->count = dreq_len;
+
+		if (test_bit(NFS_IOHDR_ERROR, &hdr->flags))
+			dreq->error = hdr->error;
+		else /* Clear outstanding error if this is EOF */
+			dreq->error = 0;
+	}
+	if (mirror->count > dreq_len)
+		mirror->count = dreq_len;
+}
 
-	WARN_ON_ONCE(dreq->count >= dreq->max_count);
+static void
+nfs_direct_count_bytes(struct nfs_direct_req *dreq,
+		       const struct nfs_pgio_header *hdr)
+{
+	struct nfs_direct_mirror *mirror = &dreq->mirrors[hdr->pgio_mirror_idx];
+	loff_t hdr_end = hdr->io_start + hdr->good_bytes;
+	ssize_t dreq_len = 0;
 
-	if (dreq->mirror_count == 1) {
-		dreq->mirrors[hdr->pgio_mirror_idx].count += hdr->good_bytes;
-		dreq->count += hdr->good_bytes;
-	} else {
-		/* mirrored writes */
-		count = dreq->mirrors[hdr->pgio_mirror_idx].count;
-		if (count + dreq->io_start < hdr->io_start + hdr->good_bytes) {
-			count = hdr->io_start + hdr->good_bytes - dreq->io_start;
-			dreq->mirrors[hdr->pgio_mirror_idx].count = count;
-		}
-		/* update the dreq->count by finding the minimum agreed count from all
-		 * mirrors */
-		count = dreq->mirrors[0].count;
+	if (hdr_end > dreq->io_start)
+		dreq_len = hdr_end - dreq->io_start;
 
-		for (i = 1; i < dreq->mirror_count; i++)
-			count = min(count, dreq->mirrors[i].count);
+	nfs_direct_handle_truncated(dreq, hdr, dreq_len);
 
-		dreq->count = count;
-	}
+	if (dreq_len > dreq->max_count)
+		dreq_len = dreq->max_count;
+
+	if (mirror->count < dreq_len)
+		mirror->count = dreq_len;
+	if (dreq->count < dreq_len)
+		dreq->count = dreq_len;
 }
 
 /*
@@ -402,20 +419,12 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
 	struct nfs_direct_req *dreq = hdr->dreq;
 
 	spin_lock(&dreq->lock);
-	if (test_bit(NFS_IOHDR_ERROR, &hdr->flags))
-		dreq->error = hdr->error;
-
 	if (test_bit(NFS_IOHDR_REDO, &hdr->flags)) {
 		spin_unlock(&dreq->lock);
 		goto out_put;
 	}
 
-	if (hdr->good_bytes != 0)
-		nfs_direct_good_bytes(dreq, hdr);
-
-	if (test_bit(NFS_IOHDR_EOF, &hdr->flags))
-		dreq->error = 0;
-
+	nfs_direct_count_bytes(dreq, hdr);
 	spin_unlock(&dreq->lock);
 
 	while (!list_empty(&hdr->pages)) {
@@ -652,6 +661,9 @@ static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 	nfs_direct_write_scan_commit_list(dreq->inode, &reqs, &cinfo);
 
 	dreq->count = 0;
+	dreq->max_count = 0;
+	list_for_each_entry(req, &reqs, wb_list)
+		dreq->max_count += req->wb_bytes;
 	dreq->verf.committed = NFS_INVALID_STABLE_HOW;
 	nfs_clear_pnfs_ds_commit_verifiers(&dreq->ds_cinfo);
 	for (i = 0; i < dreq->mirror_count; i++)
@@ -791,17 +803,13 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	nfs_init_cinfo_from_dreq(&cinfo, dreq);
 
 	spin_lock(&dreq->lock);
-
-	if (test_bit(NFS_IOHDR_ERROR, &hdr->flags))
-		dreq->error = hdr->error;
-
 	if (test_bit(NFS_IOHDR_REDO, &hdr->flags)) {
 		spin_unlock(&dreq->lock);
 		goto out_put;
 	}
 
+	nfs_direct_count_bytes(dreq, hdr);
 	if (hdr->good_bytes != 0) {
-		nfs_direct_good_bytes(dreq, hdr);
 		if (nfs_write_need_commit(hdr)) {
 			if (dreq->flags == NFS_ODIRECT_RESCHED_WRITES)
 				request_commit = true;

