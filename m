Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E62B259710
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbgIAQKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgIAPiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:38:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDDC205F4;
        Tue,  1 Sep 2020 15:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974694;
        bh=A79YNt3Fa9agDiik2WpZMP7seaohW15QMcOdJCbsuD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCqLKQFDS563+WzNYngyipNFEPLQjqkjopH2wcHK4fpgJzN7qWzqWiDKXu51uy03E
         tLvQNFyXsdRpjknqxAuSFlOugKeRm0Mv4GptISOCNTYue/5i4+sCiAX3XXKNu8v4O0
         AENQkyt2Q6OeGkBKZxWkmJbd2IiQD9owtMg1c1lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 059/255] ceph: do not access the kiocb after aio requests
Date:   Tue,  1 Sep 2020 17:08:35 +0200
Message-Id: <20200901151003.553449558@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 160644ddaeed7..d51c3f2fdca02 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1538,6 +1538,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct page *pinned_page = NULL;
+	bool direct_lock = iocb->ki_flags & IOCB_DIRECT;
 	ssize_t ret;
 	int want, got = 0;
 	int retry_op = 0, read = 0;
@@ -1546,7 +1547,7 @@ again:
 	dout("aio_read %p %llx.%llx %llu~%u trying to get caps on %p\n",
 	     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len, inode);
 
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_start_io_direct(inode);
 	else
 		ceph_start_io_read(inode);
@@ -1603,7 +1604,7 @@ again:
 	}
 	ceph_put_cap_refs(ci, got);
 
-	if (iocb->ki_flags & IOCB_DIRECT)
+	if (direct_lock)
 		ceph_end_io_direct(inode);
 	else
 		ceph_end_io_read(inode);
-- 
2.25.1



