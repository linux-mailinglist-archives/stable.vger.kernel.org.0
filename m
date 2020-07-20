Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320A922714C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgGTVmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbgGTViu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:38:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4605022CB3;
        Mon, 20 Jul 2020 21:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281129;
        bh=hyoWTlXaRJHz9u15BbwMpNHvU6B/qEq0Zc3o3cyjtOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlSdhg/BEh5G5sEuTfae3MCcynrZcNNYCl1Zy1Zeerqh7ydb+7wzQ0RZzeNAATw67
         60wc1D7PMXXHHyVr/rqTcb/Wy17dgITPSg77sH4A1WpfLYLNXlhciynRAIZSkoVB48
         mBmxpoBXDxc/HA5IM+AGfuFyYj9DYnAaD5V0GxIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/34] SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")
Date:   Mon, 20 Jul 2020 17:38:07 -0400
Message-Id: <20200720213807.407380-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213807.407380-1-sashal@kernel.org>
References: <20200720213807.407380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 65caafd0d2145d1dd02072c4ced540624daeab40 ]

Reverting commit d03727b248d0 "NFSv4 fix CLOSE not waiting for
direct IO compeletion". This patch made it so that fput() by calling
inode_dio_done() in nfs_file_release() would wait uninterruptably
for any outstanding directIO to the file (but that wait on IO should
be killable).

The problem the patch was also trying to address was REMOVE returning
ERR_ACCESS because the file is still opened, is supposed to be resolved
by server returning ERR_FILE_OPEN and not ERR_ACCESS.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 13 ++++---------
 fs/nfs/file.c   |  1 -
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 70cf8c5760c73..6b0bf4ebd8124 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -367,6 +367,8 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 {
 	struct inode *inode = dreq->inode;
 
+	inode_dio_end(inode);
+
 	if (dreq->iocb) {
 		long res = (long) dreq->error;
 		if (dreq->count != 0) {
@@ -378,10 +380,7 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 
 	complete(&dreq->completion);
 
-	igrab(inode);
 	nfs_direct_req_release(dreq);
-	inode_dio_end(inode);
-	iput(inode);
 }
 
 static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
@@ -511,10 +510,8 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	 * generic layer handle the completion.
 	 */
 	if (requested_bytes == 0) {
-		igrab(inode);
-		nfs_direct_req_release(dreq);
 		inode_dio_end(inode);
-		iput(inode);
+		nfs_direct_req_release(dreq);
 		return result < 0 ? result : -EIO;
 	}
 
@@ -926,10 +923,8 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 	 * generic layer handle the completion.
 	 */
 	if (requested_bytes == 0) {
-		igrab(inode);
-		nfs_direct_req_release(dreq);
 		inode_dio_end(inode);
-		iput(inode);
+		nfs_direct_req_release(dreq);
 		return result < 0 ? result : -EIO;
 	}
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 7b31367532054..95dc90570786c 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -83,7 +83,6 @@ nfs_file_release(struct inode *inode, struct file *filp)
 	dprintk("NFS: release(%pD2)\n", filp);
 
 	nfs_inc_stats(inode, NFSIOS_VFSRELEASE);
-	inode_dio_wait(inode);
 	nfs_file_clear_open_context(filp);
 	return 0;
 }
-- 
2.25.1

