Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87712064BB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391064AbgFWV0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389592AbgFWURr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF1E32137B;
        Tue, 23 Jun 2020 20:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943467;
        bh=aOUdI9uRoCxAKootm2RDpqEy5nNznUOHDF9tGkse2iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIOJS2o/btazfsd6IMzkDz4jPs256F3SRvg1/rRsKCpenM4SdEXF7P3P2dkiFnI62
         Zw3y7qpyrZboX2hU0Rsp1cjVVS4UEnZUbQosdf+i8qmO2s+lYBa3MXYyHT2MMMy2RQ
         rXVRnFMGBR+74Iuf/gnEAJakOJdHcyjDC8T6YlEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 373/477] NFS: Fix direct WRITE throughput regression
Date:   Tue, 23 Jun 2020 21:56:10 +0200
Message-Id: <20200623195425.160972368@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ba838a75e73f55a780f1ee896b8e3ecb032dba0f ]

I measured a 50% throughput regression for large direct writes.

The observed on-the-wire behavior is that the client sends every
NFS WRITE twice: once as an UNSTABLE WRITE plus a COMMIT, and once
as a FILE_SYNC WRITE.

This is because the nfs_write_match_verf() check in
nfs_direct_commit_complete() fails for every WRITE.

Buffered writes use nfs_write_completion(), which sets req->wb_verf
correctly. Direct writes use nfs_direct_write_completion(), which
does not set req->wb_verf at all. This leaves req->wb_verf set to
all zeroes for every direct WRITE, and thus
nfs_direct_commit_completion() always sets NFS_ODIRECT_RESCHED_WRITES.

This fix appears to restore nearly all of the lost performance.

Fixes: 1f28476dcb98 ("NFS: Fix O_DIRECT commit verifier handling")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index a57e7c72c7f47..d49b1d1979084 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -731,6 +731,8 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 		nfs_list_remove_request(req);
 		if (request_commit) {
 			kref_get(&req->wb_kref);
+			memcpy(&req->wb_verf, &hdr->verf.verifier,
+			       sizeof(req->wb_verf));
 			nfs_mark_request_commit(req, hdr->lseg, &cinfo,
 				hdr->ds_commit_idx);
 		}
-- 
2.25.1



