Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB51282C4E
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgJDSEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgJDSEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:04:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A546EC0613CE;
        Sun,  4 Oct 2020 11:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=O+GazgI/0xP6Dkm5fRqJzqqdOxWJi4HKwI9NOqmx0qg=; b=VhN9v/xFPFu2bLILuvb2SViDvn
        8txRRfkJZfL9lZ+ezUktQtM07eImKNitiKTlQuVwLt09CSdNjFllQTxWmTQXxeDZmT4oyuFRMwMIu
        5v+8lIM3NgNVJ+CqW2DlRuyfdLCV0/tv7e0mks1P9uv8E2dYuwHPr6QubBlWrRmmmJaBanXkNSubO
        GRvDIiITVSvcWycoFaQypYP0Gc3bGRq0zRFIMFR98JIRBZMcv0640XyFBuId5fUJWXk3qaMIXKdoj
        idBOaEkkoL7tklgWLdKkMWyqcFTC1cZkPcuvtxfO6m6JdH3kW2HSFuFqDpF5hcsrImENV+lcD47za
        U+/5T9lQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kP8N5-0003mg-Jf; Sun, 04 Oct 2020 18:04:31 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com,
        lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org,
        idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Subject: [PATCH 3/7] ceph: Promote to unsigned long long before shifting
Date:   Sun,  4 Oct 2020 19:04:24 +0100
Message-Id: <20201004180428.14494-4-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 32-bit systems, this shift will overflow for files larger than 4GB.

Cc: stable@vger.kernel.org
Fixes: 61f68816211e ("ceph: check caps in filemap_fault and page_mkwrite")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6ea761c84494..970e5a094035 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1522,7 +1522,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_info *fi = vma->vm_file->private_data;
 	struct page *pinned_page = NULL;
-	loff_t off = vmf->pgoff << PAGE_SHIFT;
+	loff_t off = (loff_t)vmf->pgoff << PAGE_SHIFT;
 	int want, got, err;
 	sigset_t oldset;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
-- 
2.28.0

