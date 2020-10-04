Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82322282C55
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgJDSEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgJDSEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:04:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1B8C0613CE;
        Sun,  4 Oct 2020 11:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NrJVJoU7OMcJTi9hemuonuG11U70LFwuvk1JhdPC5Fs=; b=HgdhaaLkSWbHyStH+GfRtwmrjD
        zS+k9uEIcP9s39jdejViPI1JvnhxyzwZPpVJKU1j5iBxZ4ih/AyNUB1QLTnnWokEIJfLCHiP5EUa1
        JcPctgY13Hxx7EAOYy6dcJcPaM1neGdFw71nzv9yVKq3gz2mtjN5PQ4WdtEpW8tiNpNQU4srjSzMt
        bxFsQ6DkBQd2iSJ/TykKd8P5kIuE66LPRjburFcXQVv+MGhOT5PHySwIkGireyH5e8FRbwOhT98ZP
        Bb/NARhnYvMRRfVaKlUWmfFOUpbPwVMG7gNLDfxH26OdknC+b0xqdDaG756OSNgKtJ6SfGhfUa0aG
        WCHHvbow==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kP8N5-0003mk-R4; Sun, 04 Oct 2020 18:04:31 +0000
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
Subject: [PATCH 4/7] ocfs2: Promote to unsigned long long before shifting
Date:   Sun,  4 Oct 2020 19:04:25 +0100
Message-Id: <20201004180428.14494-5-willy@infradead.org>
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
Fixes: 35edec1d52c0 ("ocfs2: update truncate handling of partial clusters")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4c1b90442d6f..26eff79ecb50 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6867,7 +6867,7 @@ static void ocfs2_zero_cluster_pages(struct inode *inode, loff_t start,
 		ocfs2_map_and_dirty_page(inode, handle, from, to, page, 1,
 					 &phys);
 
-		start = (page->index + 1) << PAGE_SHIFT;
+		start = (page->index + 1ULL) << PAGE_SHIFT;
 	}
 out:
 	if (pages)
-- 
2.28.0

