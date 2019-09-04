Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AE0A91AB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387916AbfIDSWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389094AbfIDSEb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:04:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324842339E;
        Wed,  4 Sep 2019 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620270;
        bh=p3mS5M2VL2WP7HU7xDfcmCo78rfdX99EhmyzDEcf49Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxNHoHJHQEXknvIQRdGWCj8MpWXMtQy0Ed7SD1mtaswPaUwt7fXKgcW0N2wW3+mnS
         7kD0Bqeei6WxLI8TlQWmxez9sLdvZST/gvrWdbkX13kJqVOy5s5/BYIx0HSrE4ilZJ
         sGW7WqlOZs0aSnuqyuqKUy4M7IMCm/izraU3Zi1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 54/57] NFS: Pass error information to the pgio error cleanup routine
Date:   Wed,  4 Sep 2019 19:54:22 +0200
Message-Id: <20190904175307.166577781@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit df3accb849607a86278a37c35e6b313635ccc48b ]

Allow the caller to pass error information when cleaning up a failed
I/O request so that we can conditionally take action to cancel the
request altogether if the error turned out to be fatal.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c         |  4 ++--
 fs/nfs/pagelist.c       |  5 +++--
 fs/nfs/read.c           |  2 +-
 fs/nfs/write.c          | 11 +++++++++--
 include/linux/nfs_xdr.h |  2 +-
 5 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0c5e56702b19e..2256ea4394d3a 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -428,7 +428,7 @@ out_put:
 	hdr->release(hdr);
 }
 
-static void nfs_read_sync_pgio_error(struct list_head *head)
+static void nfs_read_sync_pgio_error(struct list_head *head, int error)
 {
 	struct nfs_page *req;
 
@@ -820,7 +820,7 @@ out_put:
 	hdr->release(hdr);
 }
 
-static void nfs_write_sync_pgio_error(struct list_head *head)
+static void nfs_write_sync_pgio_error(struct list_head *head, int error)
 {
 	struct nfs_page *req;
 
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index ae598e45b2df0..16d7f9068c7ae 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -993,7 +993,7 @@ nfs_pageio_cleanup_request(struct nfs_pageio_descriptor *desc,
 	LIST_HEAD(head);
 
 	nfs_list_move_request(req, &head);
-	desc->pg_completion_ops->error_cleanup(&head);
+	desc->pg_completion_ops->error_cleanup(&head, desc->pg_error);
 }
 
 /**
@@ -1129,7 +1129,8 @@ static void nfs_pageio_error_cleanup(struct nfs_pageio_descriptor *desc)
 
 	for (midx = 0; midx < desc->pg_mirror_count; midx++) {
 		mirror = &desc->pg_mirrors[midx];
-		desc->pg_completion_ops->error_cleanup(&mirror->pg_list);
+		desc->pg_completion_ops->error_cleanup(&mirror->pg_list,
+				desc->pg_error);
 	}
 }
 
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 48d7277c60a97..09d5c282f50e9 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -205,7 +205,7 @@ static void nfs_initiate_read(struct nfs_pgio_header *hdr,
 }
 
 static void
-nfs_async_read_error(struct list_head *head)
+nfs_async_read_error(struct list_head *head, int error)
 {
 	struct nfs_page	*req;
 
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 50ed3944d1830..3c1e46f4bce32 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1397,20 +1397,27 @@ static void nfs_redirty_request(struct nfs_page *req)
 	nfs_release_request(req);
 }
 
-static void nfs_async_write_error(struct list_head *head)
+static void nfs_async_write_error(struct list_head *head, int error)
 {
 	struct nfs_page	*req;
 
 	while (!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		nfs_list_remove_request(req);
+		if (nfs_error_is_fatal(error)) {
+			nfs_context_set_write_error(req->wb_context, error);
+			if (nfs_error_is_fatal_on_server(error)) {
+				nfs_write_error_remove_page(req);
+				continue;
+			}
+		}
 		nfs_redirty_request(req);
 	}
 }
 
 static void nfs_async_write_reschedule_io(struct nfs_pgio_header *hdr)
 {
-	nfs_async_write_error(&hdr->pages);
+	nfs_async_write_error(&hdr->pages, 0);
 }
 
 static const struct nfs_pgio_completion_ops nfs_async_write_completion_ops = {
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 6959968dc36a7..373fb26b5fed1 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1520,7 +1520,7 @@ struct nfs_commit_data {
 };
 
 struct nfs_pgio_completion_ops {
-	void	(*error_cleanup)(struct list_head *head);
+	void	(*error_cleanup)(struct list_head *head, int);
 	void	(*init_hdr)(struct nfs_pgio_header *hdr);
 	void	(*completion)(struct nfs_pgio_header *hdr);
 	void	(*reschedule_io)(struct nfs_pgio_header *hdr);
-- 
2.20.1



