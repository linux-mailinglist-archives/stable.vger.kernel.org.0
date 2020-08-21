Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F414E24DCAD
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgHURGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728236AbgHUQSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:18:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7CB022CF7;
        Fri, 21 Aug 2020 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026681;
        bh=elvDjLrnrqs1OM3ytOF/zCgOCd3yDTYMsXe65nhtah4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReuU5OQjLeldzwDlmk97A0wW64cEBEuPGKVPgcQvr1kAjQw1Dzl1F2iXYbEHmSBAD
         h0wXbRZUlxOQ11FziDQRtRydb/iomgn0gvR2zi9b2nxDphmOJcoixxJeq8vz9OtEyM
         fNFAto7WO5CxtD3mCnSlYkPSJP1con+28ZTjyNt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 45/48] ceph: do not access the kiocb after aio requests
Date:   Fri, 21 Aug 2020 12:17:01 -0400
Message-Id: <20200821161704.348164-45-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161704.348164-1-sashal@kernel.org>
References: <20200821161704.348164-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit d1d9655052606fd9078e896668ec90191372d513 ]

In aio case, if the completion comes very fast just before the
ceph_read_iter() returns to fs/aio.c, the kiocb will be freed in
the completion callback, then if ceph_read_iter() access again
we will potentially hit the use-after-free bug.

[ jlayton: initialize direct_lock early, and use it everywhere ]

URL: https://tracker.ceph.com/issues/45649
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ce54a1b12819b..4a6b14a2bd7f9 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1260,6 +1260,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct page *pinned_page = NULL;
+	bool direct_lock = iocb->ki_flags & IOCB_DIRECT;
 	ssize_t ret;
 	int want, got = 0;
 	int retry_op = 0, read = 0;
@@ -1268,7 +1269,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	dout("aio_read %p %llx.%llx %llu~%u trying to get caps on %p\n",
 	     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len, inode);
 
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_start_io_direct(inode);
 	else
 		ceph_start_io_read(inode);
@@ -1325,7 +1326,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	}
 	ceph_put_cap_refs(ci, got);
 
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_end_io_direct(inode);
 	else
 		ceph_end_io_read(inode);
-- 
2.25.1

