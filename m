Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01D1282C2F
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJDSEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgJDSEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:04:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF29C0613CE;
        Sun,  4 Oct 2020 11:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=lcDrPyve8ZGqJ4GdFbmYERQ0EctUPUpm2VwVCWrS8pU=; b=b/hQUZP816I2ZPcyTtYJrK0hPU
        eTT6yKyUGxFh7cmzFamPce4SyXe30LGUt/w2KAnHF4rWLPsDPz8qLwoSZihNO4XGJ225/rAL9xCPp
        eJT3Hw5qpYqLVINHcgEZEPjKCvuMYoTcdJp3VKRm2OVr4YjlY4vrGvPOuWRnw9PHt32Bp//fi7Dzb
        PvCfP5kaSZXNQAoYhUAtkkrE3t1AzsweMP5UROoIeF71zOfo1kQoHfYts7prtHfRLVFCx2/hKVDuy
        S70qOhDWnAi0pZzDyNBy4V2Ivu9/nA75VcvlC/styaN6bzFWKDrsAystUNHqLn6AHosJiPwxNLG5K
        sMNpzx4g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kP8N5-0003mY-6K; Sun, 04 Oct 2020 18:04:31 +0000
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
Subject: [PATCH 1/7] 9P: Cast to loff_t before multiplying
Date:   Sun,  4 Oct 2020 19:04:22 +0100
Message-Id: <20201004180428.14494-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 32-bit systems, this multiplication will overflow for files larger
than 4GB.

Cc: stable@vger.kernel.org
Fixes: fb89b45cdfdc ("9P: introduction of a new cache=mmap model.")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/9p/vfs_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 3576123d8299..6d97b6b4d34b 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -612,9 +612,9 @@ static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
 		.sync_mode = WB_SYNC_ALL,
-		.range_start = vma->vm_pgoff * PAGE_SIZE,
+		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
 		 /* absolute end, byte at end included */
-		.range_end = vma->vm_pgoff * PAGE_SIZE +
+		.range_end = (loff_t)vma->vm_pgoff * PAGE_SIZE +
 			(vma->vm_end - vma->vm_start - 1),
 	};
 
-- 
2.28.0

