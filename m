Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D082594E9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgIAPo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731720AbgIAPo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7031E206EB;
        Tue,  1 Sep 2020 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975066;
        bh=elElysi5AWnvOx0nSNxsFv/Vt9iDaXe7GLWl5V9OhjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqflsHRGTNYZwK99KyJItHliqA11koCRFWnxsLKxD0mjhHxL2cAv6Pf+JqKLVsE6m
         cOa/pmvJWl9jB6Pcgg2P3Lyb80m2IMmMiffg4zQZm2MZRcbr5M4okrZg32p0jiw5Jw
         r+xHEr4ufHXyX4RhQdHnC6IsGAn2rnUhGOzxnUFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Shulyak <yashulyak@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 197/255] io-wq: fix hang after cancelling pending hashed work
Date:   Tue,  1 Sep 2020 17:10:53 +0200
Message-Id: <20200901151010.126562760@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 204361a77f4018627addd4a06877448f088ddfc0 upstream.

Don't forget to update wqe->hash_tail after cancelling a pending work
item, if it was hashed.

Cc: stable@vger.kernel.org # 5.7+
Reported-by: Dmitry Shulyak <yashulyak@gmail.com>
Fixes: 86f3cd1b589a1 ("io-wq: handle hashed writes in chains")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io-wq.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -929,6 +929,24 @@ static bool io_wq_worker_cancel(struct i
 	return match->nr_running && !match->cancel_all;
 }
 
+static inline void io_wqe_remove_pending(struct io_wqe *wqe,
+					 struct io_wq_work *work,
+					 struct io_wq_work_node *prev)
+{
+	unsigned int hash = io_get_work_hash(work);
+	struct io_wq_work *prev_work = NULL;
+
+	if (io_wq_is_hashed(work) && work == wqe->hash_tail[hash]) {
+		if (prev)
+			prev_work = container_of(prev, struct io_wq_work, list);
+		if (prev_work && io_get_work_hash(prev_work) == hash)
+			wqe->hash_tail[hash] = prev_work;
+		else
+			wqe->hash_tail[hash] = NULL;
+	}
+	wq_list_del(&wqe->work_list, &work->list, prev);
+}
+
 static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
@@ -942,8 +960,7 @@ retry:
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-
-		wq_list_del(&wqe->work_list, node, prev);
+		io_wqe_remove_pending(wqe, work, prev);
 		spin_unlock_irqrestore(&wqe->lock, flags);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;


