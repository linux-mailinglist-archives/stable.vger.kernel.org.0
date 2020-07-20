Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB912270FB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgGTVkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgGTVjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:39:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05E020717;
        Mon, 20 Jul 2020 21:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281183;
        bh=OvpeHZN2OI73IrG1M3/GUSDmqOk62H1tCVxpxfNoLDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwLNees4QXktuRpv3/Z2h0DYfXnZYk/fm9SGENqcc+J67NF4Chkfm+Qt2E/NqIgVb
         znzlK3fh6j0HkTR+TiHlYpg8YsVfYqDs4bzRTVCiSTUGpNt8ygw1N5BzacIm0MTN0K
         zg0IQLyox5SuBT+fKEwMUJ8Pg1im5GX+3u4Psy9I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 9/9] SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")
Date:   Mon, 20 Jul 2020 17:39:32 -0400
Message-Id: <20200720213932.408089-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213932.408089-1-sashal@kernel.org>
References: <20200720213932.408089-1-sashal@kernel.org>
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
index 1affdec237299..de135d2591ffb 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -379,6 +379,8 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 {
 	struct inode *inode = dreq->inode;
 
+	inode_dio_end(inode);
+
 	if (dreq->iocb) {
 		long res = (long) dreq->error;
 		if (dreq->count != 0) {
@@ -390,10 +392,7 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 
 	complete(&dreq->completion);
 
-	igrab(inode);
 	nfs_direct_req_release(dreq);
-	inode_dio_end(inode);
-	iput(inode);
 }
 
 static void nfs_direct_readpage_release(struct nfs_page *req)
@@ -535,10 +534,8 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
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
 
@@ -956,10 +953,8 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
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
index a89d2f793c1b8..1eec947c562d2 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -82,7 +82,6 @@ nfs_file_release(struct inode *inode, struct file *filp)
 	dprintk("NFS: release(%pD2)\n", filp);
 
 	nfs_inc_stats(inode, NFSIOS_VFSRELEASE);
-	inode_dio_wait(inode);
 	nfs_file_clear_open_context(filp);
 	return 0;
 }
-- 
2.25.1

