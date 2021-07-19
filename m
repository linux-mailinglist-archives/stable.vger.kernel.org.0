Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC0E3CE2AC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhGSPbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347817AbhGSPVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2615611F2;
        Mon, 19 Jul 2021 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710349;
        bh=pxldUIXVyMuGTwFThAvisOSECtn2r7h0J3e2YPopYNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xkd+1TMsLgXVtdPDxMN94DlQj8WdphBwhb+NTM/i+dgTI7KnmneI+HS4QgcL4yJtO
         2vXpi10I5lOZF69rQjsYL+aZSAhf7ynrmASAD7sbF020fNJ2dme8TQsTFZ7fnY8xnq
         /SwodfaxUCT6Uz8QorNS1ZuJE/1kKUfndqXlDBz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/243] nfsd: Reduce contention for the nfsd_file nf_rwsem
Date:   Mon, 19 Jul 2021 16:53:27 +0200
Message-Id: <20210719144946.645601041@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 474bc334698df98ce07c890f1898c7e7f389b0c7 ]

When flushing out the unstable file writes as part of a COMMIT call, try
to perform most of of the data writes and waits outside the semaphore.

This means that if the client is sending the COMMIT as part of a memory
reclaim operation, then it can continue performing I/O, with contention
for the lock occurring only once the data sync is finished.

Fixes: 5011af4c698a ("nfsd: Fix stable writes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
 Tested-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 1ecaceebee13..011cd570b50d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1113,6 +1113,19 @@ out:
 }
 
 #ifdef CONFIG_NFSD_V3
+static int
+nfsd_filemap_write_and_wait_range(struct nfsd_file *nf, loff_t offset,
+				  loff_t end)
+{
+	struct address_space *mapping = nf->nf_file->f_mapping;
+	int ret = filemap_fdatawrite_range(mapping, offset, end);
+
+	if (ret)
+		return ret;
+	filemap_fdatawait_range_keep_errors(mapping, offset, end);
+	return 0;
+}
+
 /*
  * Commit all pending writes to stable storage.
  *
@@ -1143,10 +1156,11 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (err)
 		goto out;
 	if (EX_ISSYNC(fhp->fh_export)) {
-		int err2;
+		int err2 = nfsd_filemap_write_and_wait_range(nf, offset, end);
 
 		down_write(&nf->nf_rwsem);
-		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
+		if (!err2)
+			err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
 		switch (err2) {
 		case 0:
 			nfsd_copy_boot_verifier(verf, net_generic(nf->nf_net,
-- 
2.30.2



