Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3DED9EF0
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392117AbfJPWDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438483AbfJPV7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:23 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2CB021928;
        Wed, 16 Oct 2019 21:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263161;
        bh=1ClfNOh3eb/EmAJBnG40vwDJgu0OrUH0YwbE5epnFwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0ER1pHydNA0yq41SyxGOVdBmcLESPwWeOzdFwksNqmx1ZteHnD2Y7eRTrAU8FrZI
         Mg5PcH/6HsoWOXcEuGsmfhSXVF7T004mdrD1yZcu+klI2lz8whVxI0D49O5UNJ3idr
         YpPI++P4ubmiB2HQ4FDrFzu8rMBGwK44SnWUgOv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.3 089/112] NFS: Fix O_DIRECT accounting of number of bytes read/written
Date:   Wed, 16 Oct 2019 14:51:21 -0700
Message-Id: <20191016214905.332900647@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 031d73ed768a40684f3ca21992265ffdb6a270bf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/direct.c |   78 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -123,32 +123,49 @@ static inline int put_dreq(struct nfs_di
 }
 
 static void
-nfs_direct_good_bytes(struct nfs_direct_req *dreq, struct nfs_pgio_header *hdr)
+nfs_direct_handle_truncated(struct nfs_direct_req *dreq,
+			    const struct nfs_pgio_header *hdr,
+			    ssize_t dreq_len)
+{
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
+
+static void
+nfs_direct_count_bytes(struct nfs_direct_req *dreq,
+		       const struct nfs_pgio_header *hdr)
 {
-	int i;
-	ssize_t count;
+	struct nfs_direct_mirror *mirror = &dreq->mirrors[hdr->pgio_mirror_idx];
+	loff_t hdr_end = hdr->io_start + hdr->good_bytes;
+	ssize_t dreq_len = 0;
 
-	WARN_ON_ONCE(dreq->count >= dreq->max_count);
+	if (hdr_end > dreq->io_start)
+		dreq_len = hdr_end - dreq->io_start;
 
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
+	nfs_direct_handle_truncated(dreq, hdr, dreq_len);
 
-		for (i = 1; i < dreq->mirror_count; i++)
-			count = min(count, dreq->mirrors[i].count);
+	if (dreq_len > dreq->max_count)
+		dreq_len = dreq->max_count;
 
-		dreq->count = count;
-	}
+	if (mirror->count < dreq_len)
+		mirror->count = dreq_len;
+	if (dreq->count < dreq_len)
+		dreq->count = dreq_len;
 }
 
 /*
@@ -402,20 +419,12 @@ static void nfs_direct_read_completion(s
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
@@ -652,6 +661,9 @@ static void nfs_direct_write_reschedule(
 	nfs_direct_write_scan_commit_list(dreq->inode, &reqs, &cinfo);
 
 	dreq->count = 0;
+	dreq->max_count = 0;
+	list_for_each_entry(req, &reqs, wb_list)
+		dreq->max_count += req->wb_bytes;
 	dreq->verf.committed = NFS_INVALID_STABLE_HOW;
 	nfs_clear_pnfs_ds_commit_verifiers(&dreq->ds_cinfo);
 	for (i = 0; i < dreq->mirror_count; i++)
@@ -791,17 +803,13 @@ static void nfs_direct_write_completion(
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


