Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6D73A49AC
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 21:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhFKUBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 16:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhFKUBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 16:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 588DC60E0C;
        Fri, 11 Jun 2021 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623441546;
        bh=zGLh6jjFNwduHrvlKfYX7nEfbowtDvQIo4yr7fHtgfM=;
        h=From:To:Cc:Subject:Date:From;
        b=sU3elu28L0bjmBGcO7+SCnRLj6EPjqXtrLVKseGDVl0A/yO7ATrR9/oZ4hP97elQp
         f+biToqPmuysamBkyCkFosg9WjwCRM4U1GCc4PeG3YgumKNtQx5dpCYgLpdVz1t8ec
         XlTxTac9LVPf8kLnlCjF4r4ww8fNp50aFEOhq0wRSiP/hP7wOq+YoCw3h+2G8PH453
         OtczX6SZrBzpnKWXNJmbKvfpgxcGv1HgpgTxA4ZC1smQ3lXrJyKmEdbIM+KhsknRVw
         HofwM36cndfw/qmFBqGqwYu/A9FmLWTzAAsAU6o5U9tuW5Bz337IDEZtDc2sqgYvTd
         01TzmIgLUQkew==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, pfmeec@rit.edu, willy@infradead.org,
        dhowells@redhat.com, idryomov@gmail.com, stable@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: [PATCH] ceph: fix write_begin optimization when write is beyond EOF
Date:   Fri, 11 Jun 2021 15:59:04 -0400
Message-Id: <20210611195904.160416-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's not sufficient to skip reading when the pos is beyond the EOF.
There may be data at the head of the page that we need to fill in
before the write. Only elide the read if the pos is beyond the last page
in the file.

Cc: <stable@vger.kernel.org> # v5.10 .. v5.12
Fixes: 1cc1699070bd ("ceph: fold ceph_update_writeable_page into ceph_write_begin")
Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Note to stable maintainers: This is needed in v5.10.z - v5.12.z. In
v5.13, we've moved to using the new netfs_read_helper code so this isn't
necessary there.

I also now have a simple testcase for this that I'll submit to xfstests
early next week.

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 26e66436f005..e636fb8275e1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1353,11 +1353,11 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 		/*
 		 * In some cases we don't need to read at all:
 		 * - full page write
-		 * - write that lies completely beyond EOF
+		 * - write that lies in a page that is completely beyond EOF
 		 * - write that covers the the page from start to EOF or beyond it
 		 */
 		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
-		    (pos >= i_size_read(inode)) ||
+		    (index > (i_size_read(inode) / PAGE_SIZE)) ||
 		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
 			zero_user_segments(page, 0, pos_in_page,
 					   pos_in_page + len, PAGE_SIZE);
-- 
2.31.1

