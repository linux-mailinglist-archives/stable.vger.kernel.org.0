Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33114F7F26
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfKKSeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbfKKSef (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:34:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9254222C5;
        Mon, 11 Nov 2019 18:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497275;
        bh=j1227qPE8Hj0hT9pr0IYy4IV8VS1IsyFc3vDGB7EdNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1h8pf4Z9g08yo0Xr5XW6FaFbMEqP+iKB73AlKr0tvsF+t0vVrTCdv7zdXEbrEFtrt
         +s4wd0rxTFhgb3mD9jzgtKhHe0yMVEWNOiMQIdehzvXLxyegEtYC+GaTirD18TiTeT
         lRrat3HGFx+6YyKbu2J0WphKuA9cZSAX2xs1iLI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 64/65] mm/filemap.c: dont initiate writeback if mapping has no dirty pages
Date:   Mon, 11 Nov 2019 19:29:04 +0100
Message-Id: <20191111181356.611049234@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

commit c3aab9a0bd91b696a852169479b7db1ece6cbf8c upstream.

Functions like filemap_write_and_wait_range() should do nothing if inode
has no dirty pages or pages currently under writeback.  But they anyway
construct struct writeback_control and this does some atomic operations if
CONFIG_CGROUP_WRITEBACK=y - on fast path it locks inode->i_lock and
updates state of writeback ownership, on slow path might be more work.
Current this path is safely avoided only when inode mapping has no pages.

For example generic_file_read_iter() calls filemap_write_and_wait_range()
at each O_DIRECT read - pretty hot path.

This patch skips starting new writeback if mapping has no dirty tags set.
If writeback is already in progress filemap_write_and_wait_range() will
wait for it.

Link: http://lkml.kernel.org/r/156378816804.1087.8607636317907921438.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -383,7 +383,8 @@ int __filemap_fdatawrite_range(struct ad
 		.range_end = end,
 	};
 
-	if (!mapping_cap_writeback_dirty(mapping))
+	if (!mapping_cap_writeback_dirty(mapping) ||
+	    !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
 	wbc_attach_fdatawrite_inode(&wbc, mapping->host);


