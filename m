Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF36919B43D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 19:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732943AbgDAQUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732973AbgDAQUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:20:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A52D20857;
        Wed,  1 Apr 2020 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758028;
        bh=FpWX8SHLlaQT86YJFerINs9rWgVAxYwa00BIgmCAzbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0LP5V80pJA0/s1Lwc2WjuQQg7mFJWgYUGX3V1tedp47SDgSr1F/tDqecn7DNUJzU
         PfaocjgfNXPtIdYtq0RnMRfuxovq5YDj5ny5yQIWs+WYgOtTBXu+vLW0ySGuOfp2t2
         dAyoNz3S3c/GB+isAiQ0aPUWl7j6cN/ZwxQMoIa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Penyaev <rpenyaev@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.5 20/30] libceph: fix alloc_msg_with_page_vector() memory leaks
Date:   Wed,  1 Apr 2020 18:17:24 +0200
Message-Id: <20200401161431.088388652@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

commit e886274031200bb60965c1b9c49b7acda56a93bd upstream.

Make it so that CEPH_MSG_DATA_PAGES data item can own pages,
fixing a bunch of memory leaks for a page vector allocated in
alloc_msg_with_page_vector().  Currently, only watch-notify
messages trigger this allocation, and normally the page vector
is freed either in handle_watch_notify() or by the caller of
ceph_osdc_notify().  But if the message is freed before that
(e.g. if the session faults while reading in the message or
if the notify is stale), we leak the page vector.

This was supposed to be fixed by switching to a message-owned
pagelist, but that never happened.

Fixes: 1907920324f1 ("libceph: support for sending notifies")
Reported-by: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ceph/messenger.h |    7 ++++---
 net/ceph/messenger.c           |    9 +++++++--
 net/ceph/osd_client.c          |   14 +++-----------
 3 files changed, 14 insertions(+), 16 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -175,9 +175,10 @@ struct ceph_msg_data {
 #endif /* CONFIG_BLOCK */
 		struct ceph_bvec_iter	bvec_pos;
 		struct {
-			struct page	**pages;	/* NOT OWNER. */
+			struct page	**pages;
 			size_t		length;		/* total # bytes */
 			unsigned int	alignment;	/* first page */
+			bool		own_pages;
 		};
 		struct ceph_pagelist	*pagelist;
 	};
@@ -356,8 +357,8 @@ extern void ceph_con_keepalive(struct ce
 extern bool ceph_con_keepalive_expired(struct ceph_connection *con,
 				       unsigned long interval);
 
-extern void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-				size_t length, size_t alignment);
+void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
+			     size_t length, size_t alignment, bool own_pages);
 extern void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
 				struct ceph_pagelist *pagelist);
 #ifdef CONFIG_BLOCK
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3248,12 +3248,16 @@ static struct ceph_msg_data *ceph_msg_da
 
 static void ceph_msg_data_destroy(struct ceph_msg_data *data)
 {
-	if (data->type == CEPH_MSG_DATA_PAGELIST)
+	if (data->type == CEPH_MSG_DATA_PAGES && data->own_pages) {
+		int num_pages = calc_pages_for(data->alignment, data->length);
+		ceph_release_page_vector(data->pages, num_pages);
+	} else if (data->type == CEPH_MSG_DATA_PAGELIST) {
 		ceph_pagelist_release(data->pagelist);
+	}
 }
 
 void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-		size_t length, size_t alignment)
+			     size_t length, size_t alignment, bool own_pages)
 {
 	struct ceph_msg_data *data;
 
@@ -3265,6 +3269,7 @@ void ceph_msg_data_add_pages(struct ceph
 	data->pages = pages;
 	data->length = length;
 	data->alignment = alignment & ~PAGE_MASK;
+	data->own_pages = own_pages;
 
 	msg->data_length += length;
 }
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -962,7 +962,7 @@ static void ceph_osdc_msg_data_add(struc
 		BUG_ON(length > (u64) SIZE_MAX);
 		if (length)
 			ceph_msg_data_add_pages(msg, osd_data->pages,
-					length, osd_data->alignment);
+					length, osd_data->alignment, false);
 	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
 		BUG_ON(!length);
 		ceph_msg_data_add_pagelist(msg, osd_data->pagelist);
@@ -4436,9 +4436,7 @@ static void handle_watch_notify(struct c
 							CEPH_MSG_DATA_PAGES);
 					*lreq->preply_pages = data->pages;
 					*lreq->preply_len = data->length;
-				} else {
-					ceph_release_page_vector(data->pages,
-					       calc_pages_for(0, data->length));
+					data->own_pages = false;
 				}
 			}
 			lreq->notify_finish_error = return_code;
@@ -5500,9 +5498,6 @@ out_unlock_osdc:
 	return m;
 }
 
-/*
- * TODO: switch to a msg-owned pagelist
- */
 static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 {
 	struct ceph_msg *m;
@@ -5516,7 +5511,6 @@ static struct ceph_msg *alloc_msg_with_p
 
 	if (data_len) {
 		struct page **pages;
-		struct ceph_osd_data osd_data;
 
 		pages = ceph_alloc_page_vector(calc_pages_for(0, data_len),
 					       GFP_NOIO);
@@ -5525,9 +5519,7 @@ static struct ceph_msg *alloc_msg_with_p
 			return NULL;
 		}
 
-		ceph_osd_data_pages_init(&osd_data, pages, data_len, 0, false,
-					 false);
-		ceph_osdc_msg_data_add(m, &osd_data);
+		ceph_msg_data_add_pages(m, pages, data_len, 0, true);
 	}
 
 	return m;


