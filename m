Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E72232E30
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgG3IIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729150AbgG3IIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:08:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 795ED2083E;
        Thu, 30 Jul 2020 08:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096525;
        bh=PO98IxXYDBqn674cEJXk8rqRkVdotQu0HmgKd61RnH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyG2vd4LRBt/6fjc2wTBTXyRNwiqpdVXJ9XeAcIm1R8kXoDR+L6zY+CWfmNB8wJyw
         2IUSvyO0C7uA74bNa9sY8pkNHLD8ZUtOmQqgnZyve5oJnbUvvwjXG9JxgYxk5/QXgo
         rvjnFBOAWKeIVDnkcjd1Q9ABOJOaKi0OCv9SzRic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.9 09/61] SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")
Date:   Thu, 30 Jul 2020 10:04:27 +0200
Message-Id: <20200730074421.272533071@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit 65caafd0d2145d1dd02072c4ced540624daeab40 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/direct.c |   13 ++++---------
 fs/nfs/file.c   |    1 -
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -379,6 +379,8 @@ static void nfs_direct_complete(struct n
 {
 	struct inode *inode = dreq->inode;
 
+	inode_dio_end(inode);
+
 	if (dreq->iocb) {
 		long res = (long) dreq->error;
 		if (dreq->count != 0) {
@@ -390,10 +392,7 @@ static void nfs_direct_complete(struct n
 
 	complete(&dreq->completion);
 
-	igrab(inode);
 	nfs_direct_req_release(dreq);
-	inode_dio_end(inode);
-	iput(inode);
 }
 
 static void nfs_direct_readpage_release(struct nfs_page *req)
@@ -535,10 +534,8 @@ static ssize_t nfs_direct_read_schedule_
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
 
@@ -956,10 +953,8 @@ static ssize_t nfs_direct_write_schedule
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
 
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -82,7 +82,6 @@ nfs_file_release(struct inode *inode, st
 	dprintk("NFS: release(%pD2)\n", filp);
 
 	nfs_inc_stats(inode, NFSIOS_VFSRELEASE);
-	inode_dio_wait(inode);
 	nfs_file_clear_open_context(filp);
 	return 0;
 }


