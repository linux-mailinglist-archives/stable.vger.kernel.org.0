Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE2AA72FD
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfICS7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:59:31 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50769 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbfICS7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:59:31 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 952B72227B;
        Tue,  3 Sep 2019 14:59:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jjS1+r
        OPVUGfGtrlHjjvrXjuzr1T1lcN+ax3i1GR18c=; b=F0Cg03LqRw8DKmyTJVAXO1
        b991CPFpunCX6HZHhtPXoguPLITXAO0TU27svxI83/X7mI4BZV0krvZIfpRn1bcg
        jjVFDXXqNdow/F9S5N9/0mANuF/o0iWqNoKupoT0SE0kbL9MIALA5kDa6ZZ8/bzM
        q9mR//F5MDomMR6yn1m8aTm4spxT70bdHblBT0mRGkZh1ExjjW2ov9snQVlSJ2+Y
        BONf+S+v2Rl7PVIMhBxhssna9DBkmD/5yJjyYHUUu45W8DUMRH6ks6LhEnTS1eGK
        bXJyjR5uMNBo4ZkSu0NO5Ga+D4+12WZ9Y485++i4x8svElAnN/3SLEZa2SR+RR8A
        ==
X-ME-Sender: <xms:ErhuXcXFI2c-fr_euTeFdveR31JDz4Rh_71wcy8QXSeCQeqQrmPH0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:ErhuXasEV5gpOwogqRc7kLdChMQgvbIRWDFlSr5WTaP-UPdcZu4Cog>
    <xmx:ErhuXVYoNbWNPSBUTPLQ2wZ_72Iu34OP30tPfLU-3LYgJ51xnq0LvA>
    <xmx:ErhuXfd7bLQxJjxxlvBA9v34gsft41etOqcnSsF3ATo0bNSocevsmg>
    <xmx:ErhuXUM9a3uPt3rJhXoGIRoi53amqrivfHAH5HeeGnPLO30qzntAEQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B62F80060;
        Tue,  3 Sep 2019 14:59:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] NFS: Ensure O_DIRECT reports an error if the bytes" failed to apply to 4.14-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:59:18 +0200
Message-ID: <1567537158172168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb2c50da9e256dbbb3ff27694440e4c1900cfef8 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Mon, 12 Aug 2019 18:04:36 -0400
Subject: [PATCH] NFS: Ensure O_DIRECT reports an error if the bytes
 read/written is 0

If the attempt to resend the I/O results in no bytes being read/written,
we must ensure that we report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Fixes: 0a00b77b331a ("nfs: mirroring support for direct io")
Cc: stable@vger.kernel.org # v3.20+

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0cb442406168..222d7115db71 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -401,15 +401,21 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
 	unsigned long bytes = 0;
 	struct nfs_direct_req *dreq = hdr->dreq;
 
-	if (test_bit(NFS_IOHDR_REDO, &hdr->flags))
-		goto out_put;
-
 	spin_lock(&dreq->lock);
-	if (test_bit(NFS_IOHDR_ERROR, &hdr->flags) && (hdr->good_bytes == 0))
+	if (test_bit(NFS_IOHDR_ERROR, &hdr->flags))
 		dreq->error = hdr->error;
-	else
+
+	if (test_bit(NFS_IOHDR_REDO, &hdr->flags)) {
+		spin_unlock(&dreq->lock);
+		goto out_put;
+	}
+
+	if (hdr->good_bytes != 0)
 		nfs_direct_good_bytes(dreq, hdr);
 
+	if (test_bit(NFS_IOHDR_EOF, &hdr->flags))
+		dreq->error = 0;
+
 	spin_unlock(&dreq->lock);
 
 	while (!list_empty(&hdr->pages)) {
@@ -782,16 +788,19 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	bool request_commit = false;
 	struct nfs_page *req = nfs_list_entry(hdr->pages.next);
 
-	if (test_bit(NFS_IOHDR_REDO, &hdr->flags))
-		goto out_put;
-
 	nfs_init_cinfo_from_dreq(&cinfo, dreq);
 
 	spin_lock(&dreq->lock);
 
 	if (test_bit(NFS_IOHDR_ERROR, &hdr->flags))
 		dreq->error = hdr->error;
-	if (dreq->error == 0) {
+
+	if (test_bit(NFS_IOHDR_REDO, &hdr->flags)) {
+		spin_unlock(&dreq->lock);
+		goto out_put;
+	}
+
+	if (hdr->good_bytes != 0) {
 		nfs_direct_good_bytes(dreq, hdr);
 		if (nfs_write_need_commit(hdr)) {
 			if (dreq->flags == NFS_ODIRECT_RESCHED_WRITES)
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 15c254753f88..56cefa0ab804 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1266,6 +1266,7 @@ int nfs_pageio_resend(struct nfs_pageio_descriptor *desc,
 	if (!list_empty(&pages)) {
 		int err = desc->pg_error < 0 ? desc->pg_error : -EIO;
 		hdr->completion_ops->error_cleanup(&pages, err);
+		nfs_set_pgio_error(hdr, err, hdr->io_start);
 		return err;
 	}
 	return 0;

