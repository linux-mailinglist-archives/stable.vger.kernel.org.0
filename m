Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5631FE43A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732111AbgFRCQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgFRBUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E661521D80;
        Thu, 18 Jun 2020 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443211;
        bh=4JyrHkTxJQCWKgw1uCe76MclNU1kd8vc5gEAb79+BY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zm2tHrx54TCIQf8cA0/Mgcn7MpML0t88z86SvQF93WCCy+3CoPWBUQqXyxk6Qd0VZ
         y2ShmBAOWCwwt5EqbsEkD1v6bLfuCk6a9VJIJXdeS5mZfLQN4a724CiM9iOjFT4BWj
         9I/YlC2uryKHDdUMl1kO+L0uTgo1d/3LqPTMm4K8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 168/266] fuse: copy_file_range should truncate cache
Date:   Wed, 17 Jun 2020 21:14:53 -0400
Message-Id: <20200618011631.604574-168-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 9b46418c40fe910e6537618f9932a8be78a3dd6c ]

After the copy operation completes the cache is not up-to-date.  Truncate
all pages in the interval that has successfully been copied.

Truncating completely copied dirty pages is okay, since the data has been
overwritten anyway.  Truncating partially copied dirty pages is not okay;
add a comment for now.

Fixes: 88bc7d5097a1 ("fuse: add support for copy_file_range()")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e730e3d8ad99..66214707a945 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3292,6 +3292,24 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (err)
 		goto out;
 
+	/*
+	 * Write out dirty pages in the destination file before sending the COPY
+	 * request to userspace.  After the request is completed, truncate off
+	 * pages (including partial ones) from the cache that have been copied,
+	 * since these contain stale data at that point.
+	 *
+	 * This should be mostly correct, but if the COPY writes to partial
+	 * pages (at the start or end) and the parts not covered by the COPY are
+	 * written through a memory map after calling fuse_writeback_range(),
+	 * then these partial page modifications will be lost on truncation.
+	 *
+	 * It is unlikely that someone would rely on such mixed style
+	 * modifications.  Yet this does give less guarantees than if the
+	 * copying was performed with write(2).
+	 *
+	 * To fix this a i_mmap_sem style lock could be used to prevent new
+	 * faults while the copy is ongoing.
+	 */
 	err = fuse_writeback_range(inode_out, pos_out, pos_out + len - 1);
 	if (err)
 		goto out;
@@ -3315,6 +3333,10 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (err)
 		goto out;
 
+	truncate_inode_pages_range(inode_out->i_mapping,
+				   ALIGN_DOWN(pos_out, PAGE_SIZE),
+				   ALIGN(pos_out + outarg.size, PAGE_SIZE) - 1);
+
 	if (fc->writeback_cache) {
 		fuse_write_update_size(inode_out, pos_out + outarg.size);
 		file_update_time(file_out);
-- 
2.25.1

