Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DEAB20F7
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391565AbfIMNan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388620AbfIMNQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:07 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A6DF206BB;
        Fri, 13 Sep 2019 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380566;
        bh=oLoLxCVWm85R5cD/wQVd3KJk46KFO1TqXFUdQI5TVY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXcQ47xlt/O3UJSI3iwQJlH53xu069pHGXPRKBOYDof4dT0fhcgdVQXCllymLhy6q
         IxceGzY47jJJMsC04hGnhHb6yB7g1DN9BvZ6ftkfCuL2NPy5DK/t5/qmdwXzKe/UFy
         f8oABAkJ9u5cdTtEdCBvZpXnLtK9TRWQ1PUEXnBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/190] CIFS: Fix error paths in writeback code
Date:   Fri, 13 Sep 2019 14:06:01 +0100
Message-Id: <20190913130608.148793825@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9a66396f1857cc1de06f4f4771797315e1a4ea56 ]

This patch aims to address writeback code problems related to error
paths. In particular it respects EINTR and related error codes and
stores and returns the first error occurred during writeback.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h | 19 +++++++++++++++++++
 fs/cifs/cifssmb.c  |  7 ++++---
 fs/cifs/file.c     | 29 +++++++++++++++++++++++------
 fs/cifs/inode.c    | 10 ++++++++++
 4 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6f227cc781e5d..0ee0072c1f362 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1563,6 +1563,25 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 	kfree(param);
 }
 
+static inline bool is_interrupt_error(int error)
+{
+	switch (error) {
+	case -EINTR:
+	case -ERESTARTSYS:
+	case -ERESTARTNOHAND:
+	case -ERESTARTNOINTR:
+		return true;
+	}
+	return false;
+}
+
+static inline bool is_retryable_error(int error)
+{
+	if (is_interrupt_error(error) || error == -EAGAIN)
+		return true;
+	return false;
+}
+
 #define   MID_FREE 0
 #define   MID_REQUEST_ALLOCATED 1
 #define   MID_REQUEST_SUBMITTED 2
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 269471c8f42bf..a5cb7b2d1ac5d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2042,7 +2042,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 
 		for (j = 0; j < nr_pages; j++) {
 			unlock_page(wdata2->pages[j]);
-			if (rc != 0 && rc != -EAGAIN) {
+			if (rc != 0 && !is_retryable_error(rc)) {
 				SetPageError(wdata2->pages[j]);
 				end_page_writeback(wdata2->pages[j]);
 				put_page(wdata2->pages[j]);
@@ -2051,7 +2051,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 
 		if (rc) {
 			kref_put(&wdata2->refcount, cifs_writedata_release);
-			if (rc == -EAGAIN)
+			if (is_retryable_error(rc))
 				continue;
 			break;
 		}
@@ -2060,7 +2060,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 		i += nr_pages;
 	} while (i < wdata->nr_pages);
 
-	mapping_set_error(inode->i_mapping, rc);
+	if (rc != 0 && !is_retryable_error(rc))
+		mapping_set_error(inode->i_mapping, rc);
 	kref_put(&wdata->refcount, cifs_writedata_release);
 }
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 23cee91ed442e..933013543edab 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -749,7 +749,8 @@ reopen_success:
 
 	if (can_flush) {
 		rc = filemap_write_and_wait(inode->i_mapping);
-		mapping_set_error(inode->i_mapping, rc);
+		if (!is_interrupt_error(rc))
+			mapping_set_error(inode->i_mapping, rc);
 
 		if (tcon->unix_ext)
 			rc = cifs_get_inode_info_unix(&inode, full_path,
@@ -2137,6 +2138,7 @@ static int cifs_writepages(struct address_space *mapping,
 	pgoff_t end, index;
 	struct cifs_writedata *wdata;
 	int rc = 0;
+	int saved_rc = 0;
 
 	/*
 	 * If wsize is smaller than the page cache size, default to writing
@@ -2163,8 +2165,10 @@ retry:
 
 		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
 						   &wsize, &credits);
-		if (rc)
+		if (rc != 0) {
+			done = true;
 			break;
+		}
 
 		tofind = min((wsize / PAGE_SIZE) - 1, end - index) + 1;
 
@@ -2172,6 +2176,7 @@ retry:
 						  &found_pages);
 		if (!wdata) {
 			rc = -ENOMEM;
+			done = true;
 			add_credits_and_wake_if(server, credits, 0);
 			break;
 		}
@@ -2200,7 +2205,7 @@ retry:
 		if (rc != 0) {
 			add_credits_and_wake_if(server, wdata->credits, 0);
 			for (i = 0; i < nr_pages; ++i) {
-				if (rc == -EAGAIN)
+				if (is_retryable_error(rc))
 					redirty_page_for_writepage(wbc,
 							   wdata->pages[i]);
 				else
@@ -2208,7 +2213,7 @@ retry:
 				end_page_writeback(wdata->pages[i]);
 				put_page(wdata->pages[i]);
 			}
-			if (rc != -EAGAIN)
+			if (!is_retryable_error(rc))
 				mapping_set_error(mapping, rc);
 		}
 		kref_put(&wdata->refcount, cifs_writedata_release);
@@ -2218,6 +2223,15 @@ retry:
 			continue;
 		}
 
+		/* Return immediately if we received a signal during writing */
+		if (is_interrupt_error(rc)) {
+			done = true;
+			break;
+		}
+
+		if (rc != 0 && saved_rc == 0)
+			saved_rc = rc;
+
 		wbc->nr_to_write -= nr_pages;
 		if (wbc->nr_to_write <= 0)
 			done = true;
@@ -2235,6 +2249,9 @@ retry:
 		goto retry;
 	}
 
+	if (saved_rc != 0)
+		rc = saved_rc;
+
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
@@ -2266,8 +2283,8 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 	set_page_writeback(page);
 retry_write:
 	rc = cifs_partialpagewrite(page, 0, PAGE_SIZE);
-	if (rc == -EAGAIN) {
-		if (wbc->sync_mode == WB_SYNC_ALL)
+	if (is_retryable_error(rc)) {
+		if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN)
 			goto retry_write;
 		redirty_page_for_writepage(wbc, page);
 	} else if (rc != 0) {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 1fadd314ae7f9..53f3d08898af8 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2261,6 +2261,11 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	 * the flush returns error?
 	 */
 	rc = filemap_write_and_wait(inode->i_mapping);
+	if (is_interrupt_error(rc)) {
+		rc = -ERESTARTSYS;
+		goto out;
+	}
+
 	mapping_set_error(inode->i_mapping, rc);
 	rc = 0;
 
@@ -2404,6 +2409,11 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	 * the flush returns error?
 	 */
 	rc = filemap_write_and_wait(inode->i_mapping);
+	if (is_interrupt_error(rc)) {
+		rc = -ERESTARTSYS;
+		goto cifs_setattr_exit;
+	}
+
 	mapping_set_error(inode->i_mapping, rc);
 	rc = 0;
 
-- 
2.20.1



