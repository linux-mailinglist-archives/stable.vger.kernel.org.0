Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87B91FE708
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgFRCiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbgFRBN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED39E221E6;
        Thu, 18 Jun 2020 01:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442806;
        bh=sbGwC6NhDmYEFi7b4f6rPFlvOBAV0L/Avk5C5yKYsRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSShlrtQ2GDLZKADpQlGaoe9G6hk3uh2y9JoV6j8aakROp7QSg/HnrsZCcyQleSNB
         2xXXuMwvMML+AL3xWi2VcsiPhUK5CHK3FqnXJH02FontTqamt9OOaHXwuxJqF971Ul
         T65pDPHivubPtjvS/T30ftER6hLWqRVwvRKhmZU8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 246/388] fuse: copy_file_range should truncate cache
Date:   Wed, 17 Jun 2020 21:05:43 -0400
Message-Id: <20200618010805.600873-246-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
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
index d58324198b7a..e3afceecaa6b 100644
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

