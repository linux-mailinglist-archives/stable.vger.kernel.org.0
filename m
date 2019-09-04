Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34329A8F93
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388748AbfIDSEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388779AbfIDSEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:04:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D16672339E;
        Wed,  4 Sep 2019 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620273;
        bh=tP8I2ZaoMloWQlVziD5FUF5Ro94e9196WHs3Dd3Fk6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1oy6HCu/OWT6IK6kWxtATn1Vsc2YF7ZbUsH+knmZtYOBzdXkE4Jv3sZQs9tYX51L
         GTMd2x9wHOwP5rY1A3hxQA/7xIRwBSHhkHnrdfS3grOOFPvk2vHY8wBq2GICnuD/mb
         I5E+/eu+EWpot40wvsjlZ+sU6qkby4ZTWdiLeaR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 55/57] NFS: Ensure O_DIRECT reports an error if the bytes read/written is 0
Date:   Wed,  4 Sep 2019 19:54:23 +0200
Message-Id: <20190904175307.283207287@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eb2c50da9e256dbbb3ff27694440e4c1900cfef8 ]

If the attempt to resend the I/O results in no bytes being read/written,
we must ensure that we report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Fixes: 0a00b77b331a ("nfs: mirroring support for direct io")
Cc: stable@vger.kernel.org # v3.20+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c   | 27 ++++++++++++++++++---------
 fs/nfs/pagelist.c |  1 +
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 2256ea4394d3a..614ce1f8b4ac5 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -400,15 +400,21 @@ static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
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
@@ -774,16 +780,19 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
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
index 16d7f9068c7ae..132e568524dff 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -1247,6 +1247,7 @@ int nfs_pageio_resend(struct nfs_pageio_descriptor *desc,
 	if (!list_empty(&pages)) {
 		int err = desc->pg_error < 0 ? desc->pg_error : -EIO;
 		hdr->completion_ops->error_cleanup(&pages, err);
+		nfs_set_pgio_error(hdr, err, hdr->io_start);
 		return err;
 	}
 	return 0;
-- 
2.20.1



