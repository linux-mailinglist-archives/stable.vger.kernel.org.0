Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26BA19AE88
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 17:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732633AbgDAPHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 11:07:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60989 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732623AbgDAPHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 11:07:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C3BC45C042E;
        Wed,  1 Apr 2020 11:07:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 01 Apr 2020 11:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=39T3kY
        odlomywZbuExMg7MwuQ9+rZ7YZE0/pSwwS8i8=; b=2UnZK6WzJeOzG5N8+0/v3G
        yGER/xXEs0/0eX1DPAXTiHVXdH2egmu6M6zUlcT8Unj4EU09rNS10fgHXXf9XO/B
        c90qznZVuYTaD9RUJN7naNrhgbS6RUqwkQP/W6t2Rgy405gXTsHlfFzYzQ/Uh2Aq
        zZPgKxkzUoQcwKKSI3VOGavsuU7aXCPOXiWog+2UgRUmA1luCRgw9yrnJk7fwvpv
        WFtFtagjCbjL4xZjNY9u0OjSSv+vYSYhi7U+eggqeImcBxanpDcvUE5t0wrThIT8
        Xc/EmUDqj+rmowDhMp1Yd1qGsyalVqzTEQjxBgVAUHEeU92F7YZCwySuizJJtQbw
        ==
X-ME-Sender: <xms:KK6EXufk-vPisT2eQLDm0Zs4ewLkdWzUNBOjwe7QN04tMakWlqr4Jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtddvgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:KK6EXq0gNz6ebKesLKaoL3EU_7goJW9cYcw6npV7YC5qsBt-iUaiaw>
    <xmx:KK6EXkcdpWMweTOy44nqNMzv7z4zFL_vkZuC9Q9K4DMc0Cgd0PCHhA>
    <xmx:KK6EXu6OfsfNm5_X6kiU3_bjZd0bVLI4IKQGwJJzCG_nY0QanP_eNQ>
    <xmx:KK6EXs_GB3qBWgdDoDRLo5TVcqlcfKEGHy7ni5wvWK7yqsP8KM5Cgg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 632FD3280065;
        Wed,  1 Apr 2020 11:07:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] libceph: fix alloc_msg_with_page_vector() memory leaks" failed to apply to 4.9-stable tree
To:     idryomov@gmail.com, rpenyaev@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 01 Apr 2020 17:07:17 +0200
Message-ID: <1585753637146155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e886274031200bb60965c1b9c49b7acda56a93bd Mon Sep 17 00:00:00 2001
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 10 Mar 2020 16:19:01 +0100
Subject: [PATCH] libceph: fix alloc_msg_with_page_vector() memory leaks

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

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index c4458dc6a757..76371aaae2d1 100644
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
@@ -356,8 +357,8 @@ extern void ceph_con_keepalive(struct ceph_connection *con);
 extern bool ceph_con_keepalive_expired(struct ceph_connection *con,
 				       unsigned long interval);
 
-extern void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-				size_t length, size_t alignment);
+void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
+			     size_t length, size_t alignment, bool own_pages);
 extern void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
 				struct ceph_pagelist *pagelist);
 #ifdef CONFIG_BLOCK
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5b4bd8261002..f8ca5edc5f2c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3248,12 +3248,16 @@ static struct ceph_msg_data *ceph_msg_data_add(struct ceph_msg *msg)
 
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
 
@@ -3265,6 +3269,7 @@ void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
 	data->pages = pages;
 	data->length = length;
 	data->alignment = alignment & ~PAGE_MASK;
+	data->own_pages = own_pages;
 
 	msg->data_length += length;
 }
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b68b376d8c2f..af868d3923b9 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -962,7 +962,7 @@ static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
 		BUG_ON(length > (u64) SIZE_MAX);
 		if (length)
 			ceph_msg_data_add_pages(msg, osd_data->pages,
-					length, osd_data->alignment);
+					length, osd_data->alignment, false);
 	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
 		BUG_ON(!length);
 		ceph_msg_data_add_pagelist(msg, osd_data->pagelist);
@@ -4436,9 +4436,7 @@ static void handle_watch_notify(struct ceph_osd_client *osdc,
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
@@ -5506,9 +5504,6 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	return m;
 }
 
-/*
- * TODO: switch to a msg-owned pagelist
- */
 static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 {
 	struct ceph_msg *m;
@@ -5522,7 +5517,6 @@ static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 
 	if (data_len) {
 		struct page **pages;
-		struct ceph_osd_data osd_data;
 
 		pages = ceph_alloc_page_vector(calc_pages_for(0, data_len),
 					       GFP_NOIO);
@@ -5531,9 +5525,7 @@ static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
 			return NULL;
 		}
 
-		ceph_osd_data_pages_init(&osd_data, pages, data_len, 0, false,
-					 false);
-		ceph_osdc_msg_data_add(m, &osd_data);
+		ceph_msg_data_add_pages(m, pages, data_len, 0, true);
 	}
 
 	return m;

