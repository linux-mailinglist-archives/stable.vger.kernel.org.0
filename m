Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E93E205D58
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbgFWUMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388951AbgFWUMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF4020707;
        Tue, 23 Jun 2020 20:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943133;
        bh=7Thpm2MmBZLAZ4L6jYZKxmE7WJLaWJ/y0lMlIs9q/cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYEHsG6jbdrxp7zlGJC62A7418m3Vk1UN72YT3qXoDZuAKDO22Snrqskb6Eaf3smD
         FA+XRCkejWFHYkaQkz8NYa+EN2BHv0Meih6Lk2+AFKpGVO7/Ve0I+ms/kgKqsSu7C7
         Y/EkVjrVfZndDPHaqaUn9kHnz/USkXaOo4wO9ohc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 242/477] fuse: copy_file_range should truncate cache
Date:   Tue, 23 Jun 2020 21:53:59 +0200
Message-Id: <20200623195419.015058319@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d58324198b7a7..e3afceecaa6b1 100644
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



