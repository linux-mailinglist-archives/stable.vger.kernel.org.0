Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA3A257DA4
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgHaPjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728531AbgHaPaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD863214D8;
        Mon, 31 Aug 2020 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887807;
        bh=EIDdbwiV7I3/UvfbBAlS1QNVUgyFXb53fT0NauxxnSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBDVHeU58ZlK3PWD/zPuCf+acmwQ/hysdo+5U5DMhrdXThNz/6ENZLjbgSL9F+x4z
         /7iBtytC2OqLhYz95KBXpru+dexTn29ukpWi9YMv4FEfZ4PlB7S+L6/N85L1FI1OmI
         mpVasiW9MbBcQz50WZvwmt1P4NSpp28OnLjOAGHI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.8 22/42] gfs2: add some much needed cleanup for log flushes that fail
Date:   Mon, 31 Aug 2020 11:29:14 -0400
Message-Id: <20200831152934.1023912-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 462582b99b6079a6fbcdfc65bac49f5c2a27cfff ]

When a log flush fails due to io errors, it signals the failure but does
not clean up after itself very well. This is because buffers are added to
the transaction tr_buf and tr_databuf queue, but the io error causes
gfs2_log_flush to bypass the "after_commit" functions responsible for
dequeueing the bd elements. If the bd elements are added to the ail list
before the error, function ail_drain takes care of dequeueing them.
But if they haven't gotten that far, the elements are forgotten and
make the transactions unable to be freed.

This patch introduces new function trans_drain which drains the bd
elements from the transaction so they can be freed properly.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c   | 31 +++++++++++++++++++++++++++++++
 fs/gfs2/trans.c |  1 +
 2 files changed, 32 insertions(+)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index a76e55bc28ebf..27f467a0f008e 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -901,6 +901,36 @@ static void empty_ail1_list(struct gfs2_sbd *sdp)
 	}
 }
 
+/**
+ * drain_bd - drain the buf and databuf queue for a failed transaction
+ * @tr: the transaction to drain
+ *
+ * When this is called, we're taking an error exit for a log write that failed
+ * but since we bypassed the after_commit functions, we need to remove the
+ * items from the buf and databuf queue.
+ */
+static void trans_drain(struct gfs2_trans *tr)
+{
+	struct gfs2_bufdata *bd;
+	struct list_head *head;
+
+	if (!tr)
+		return;
+
+	head = &tr->tr_buf;
+	while (!list_empty(head)) {
+		bd = list_first_entry(head, struct gfs2_bufdata, bd_list);
+		list_del_init(&bd->bd_list);
+		kmem_cache_free(gfs2_bufdata_cachep, bd);
+	}
+	head = &tr->tr_databuf;
+	while (!list_empty(head)) {
+		bd = list_first_entry(head, struct gfs2_bufdata, bd_list);
+		list_del_init(&bd->bd_list);
+		kmem_cache_free(gfs2_bufdata_cachep, bd);
+	}
+}
+
 /**
  * gfs2_log_flush - flush incore transaction(s)
  * @sdp: the filesystem
@@ -1005,6 +1035,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl, u32 flags)
 
 out:
 	if (gfs2_withdrawn(sdp)) {
+		trans_drain(tr);
 		/**
 		 * If the tr_list is empty, we're withdrawing during a log
 		 * flush that targets a transaction, but the transaction was
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index a3dfa3aa87ad9..d897dd73c5999 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -52,6 +52,7 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 		tr->tr_reserved += gfs2_struct2blk(sdp, revokes);
 	INIT_LIST_HEAD(&tr->tr_databuf);
 	INIT_LIST_HEAD(&tr->tr_buf);
+	INIT_LIST_HEAD(&tr->tr_list);
 	INIT_LIST_HEAD(&tr->tr_ail1_list);
 	INIT_LIST_HEAD(&tr->tr_ail2_list);
 
-- 
2.25.1

