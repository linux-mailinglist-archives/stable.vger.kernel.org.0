Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA928B81E
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389771AbgJLNtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F24A922266;
        Mon, 12 Oct 2020 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510466;
        bh=ByvkiNcjRBSEt3jkPzxUI6DAEmvBmxBKc8xsQN8Qfh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IW0/2IhpfD+toxywF60fSKQU0RIfMmiK89a4f0WmyqhllU9QrlTiILOe5OtLwVWxB
         MPEklbRubLpNajVtd7tP2XyTZIwqIqqioN5sECx5FDmQemp6lSGsP89pJvU0uwGf6K
         QPuZFzVQqYBaOyx9LKrXeCClc1aLE4l2HgmTSGF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
        Andres Freund <andres@anarazel.de>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 111/124] mm: validate inode in mapping_set_error()
Date:   Mon, 12 Oct 2020 15:31:55 +0200
Message-Id: <20201012133152.226106025@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

commit 8b7b2eb131d3476062ffd34358785b44be25172f upstream.

The swap address_space doesn't have host. Thus, it makes kernel crash once
swap write meets error. Fix it.

Fixes: 735e4ae5ba28 ("vfs: track per-sb writeback errors and report them to syncfs")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Jeff Layton <jlayton@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Andres Freund <andres@anarazel.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201010000650.750063-1-minchan@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pagemap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -54,7 +54,8 @@ static inline void mapping_set_error(str
 	__filemap_set_wb_err(mapping, error);
 
 	/* Record it in superblock */
-	errseq_set(&mapping->host->i_sb->s_wb_err, error);
+	if (mapping->host)
+		errseq_set(&mapping->host->i_sb->s_wb_err, error);
 
 	/* Record it in flags for now, for legacy callers */
 	if (error == -ENOSPC)


