Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05178A916C
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390478AbfIDSPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390456AbfIDSPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60442087E;
        Wed,  4 Sep 2019 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620921;
        bh=nDjyrpOByM6yY5SDXXalE77u9RzjwGi6LBtIAPqrq+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AH33CiOyq2wR14QKuT8uPOY383Lngl6AYklG+v6z3zy/8fRixOmdkdD5A022Gzr9/
         ch/7UNX40AfIvj7Li8iwEICN7y+xAWfHH69FGMSbkAbkVlniBLK3s4O4FsQcpXv8Ha
         ApQQtkt5gvHt1z8XKo4/5ig6AvWd3qPODLwL8ka4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.2 105/143] NFS: Ensure O_DIRECT reports an error if the bytes read/written is 0
Date:   Wed,  4 Sep 2019 19:54:08 +0200
Message-Id: <20190904175318.483862880@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit eb2c50da9e256dbbb3ff27694440e4c1900cfef8 upstream.

If the attempt to resend the I/O results in no bytes being read/written,
we must ensure that we report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Fixes: 0a00b77b331a ("nfs: mirroring support for direct io")
Cc: stable@vger.kernel.org # v3.20+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/direct.c   |   27 ++++++++++++++++++---------
 fs/nfs/pagelist.c |    1 +
 2 files changed, 19 insertions(+), 9 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -401,15 +401,21 @@ static void nfs_direct_read_completion(s
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
@@ -782,16 +788,19 @@ static void nfs_direct_write_completion(
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
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1268,6 +1268,7 @@ int nfs_pageio_resend(struct nfs_pageio_
 	if (!list_empty(&pages)) {
 		int err = desc->pg_error < 0 ? desc->pg_error : -EIO;
 		hdr->completion_ops->error_cleanup(&pages, err);
+		nfs_set_pgio_error(hdr, err, hdr->io_start);
 		return err;
 	}
 	return 0;


