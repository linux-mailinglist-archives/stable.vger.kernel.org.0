Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B81261639
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbgIHRGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731820AbgIHQT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4FF23C40;
        Tue,  8 Sep 2020 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579367;
        bh=EIDdbwiV7I3/UvfbBAlS1QNVUgyFXb53fT0NauxxnSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZ78xiHrBnFig14OqOD2FklVPJ8yLj/aS0RinV6Iv3EreVYvmmCJCvJz7BP8o8bhd
         SnMITorbCKICZC6dqfj0HycK/A6fIzjvhZwTaWM8BSu+8fPh/rS5D+/vgBR77r22Zm
         BuGCF/5Jtkle4w54Pj3Ha0vGnV8XULwwgiFkoNRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 019/186] gfs2: add some much needed cleanup for log flushes that fail
Date:   Tue,  8 Sep 2020 17:22:41 +0200
Message-Id: <20200908152242.591180763@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



