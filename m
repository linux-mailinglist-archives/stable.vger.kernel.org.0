Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF6928A5E0
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 08:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgJKGQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 02:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgJKGQi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Oct 2020 02:16:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D26912083B;
        Sun, 11 Oct 2020 06:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602396998;
        bh=/jBoQHF6+uKt9xaUS5ej7YQdb15rbvaKqFleiTRfnhk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Gym8XFs1zPOFdkFRzwXXHVZc9gd8m/FI2M+c2Q0ZOT9Wfx5U4X9YN7FxyZ2zkoZBn
         Fg8jl5FWcj4PGorQH+9QyqwCot6tJOcRL/NvPn44+990ObxTLNJXqngm4IoYeJvnmF
         qzJFddbw1Kbe5xj7Z1K0gIgbR1NVejihvFCyMWNo=
Date:   Sat, 10 Oct 2020 23:16:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andres@anarazel.de, david@fromorbit.com,
        dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
        jlayton@kernel.org, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 4/5] mm: validate inode in mapping_set_error()
Message-ID: <20201011061637.E_t0y98Vu%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: mm: validate inode in mapping_set_error()

The swap address_space doesn't have host. Thus, it makes kernel crash once
swap write meets error. Fix it.

Link: https://lkml.kernel.org/r/20201010000650.750063-1-minchan@kernel.org
Fixes: 735e4ae5ba28 ("vfs: track per-sb writeback errors and report them to syncfs")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jeff Layton <jlayton@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Andres Freund <andres@anarazel.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h~mm-validate-inode-in-mapping_set_error
+++ a/include/linux/pagemap.h
@@ -54,7 +54,8 @@ static inline void mapping_set_error(str
 	__filemap_set_wb_err(mapping, error);
 
 	/* Record it in superblock */
-	errseq_set(&mapping->host->i_sb->s_wb_err, error);
+	if (mapping->host)
+		errseq_set(&mapping->host->i_sb->s_wb_err, error);
 
 	/* Record it in flags for now, for legacy callers */
 	if (error == -ENOSPC)
_
