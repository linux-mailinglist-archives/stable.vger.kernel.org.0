Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7272282C43
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgJDSFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgJDSE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:04:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB153C0613CF;
        Sun,  4 Oct 2020 11:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OeP+UYbpor66DMaW4dlQOBaRsqMPKoK+SZyjuLcZuzs=; b=qmpfmOl3qTJbpxI7uNRkLqzkX+
        o71mA9C5U9VRYEWc5KEwJBkP9Y97+/NQU162gn9znTiYisHqdCdn4VuiXZwCAIGB587PaeLQy3FXp
        XC8xOv3dJ3fROxKoPixtR8p35Z0mviJUJp+cs6gAHSUfmJcXl8S4+TkJ6KZjWs3se8xwZf6/yzktZ
        T4LacZutqbncYoL1xQoZ2f0D9GvWC+LdYt3zXAtz/qee9YC+fQIX0+9EzCgcH/bz3ScYQPgLSc0OU
        DShVL8PPkfWDLQb1ihe5zYa87QYdS91QEjq1/VJKAoQfE8Ji5VtkljNvyANJ7SyZJfQThLV1TxIic
        SSXtL4bg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kP8N5-0003mc-D3; Sun, 04 Oct 2020 18:04:31 +0000
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
Subject: [PATCH 2/7] buffer: Promote to unsigned long long before shifting
Date:   Sun,  4 Oct 2020 19:04:23 +0100
Message-Id: <20201004180428.14494-3-willy@infradead.org>
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
Fixes: 5417169026c3 ("[FS] Implement block_page_mkwrite.")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 50bbc99e3d96..66f4765e60ee 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2515,7 +2515,7 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	}
 
 	/* page is wholly or partially inside EOF */
-	if (((page->index + 1) << PAGE_SHIFT) > size)
+	if (((page->index + 1ULL) << PAGE_SHIFT) > size)
 		end = size & ~PAGE_MASK;
 	else
 		end = PAGE_SIZE;
-- 
2.28.0

