Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC032E7CBF
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 22:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgL3Vif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 16:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgL3Vif (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 16:38:35 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD602C061799;
        Wed, 30 Dec 2020 13:37:54 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d13so18598281wrc.13;
        Wed, 30 Dec 2020 13:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SpluLSb5M+s3NGcaOf+w4QUNgjHtRfWcRhl5lA1mGO0=;
        b=MQGuEDYfeeXmG5WHDZYEwkJhaBzpF56PSfQz9oW31Vi+jBa3ddvwvyrwt2jP/n+dBM
         kSCIaxiYv0HFR7qmmmrBUitN/ebJbigxHdwc/tWukGzY7kw7ScaMrw5RUW53B+LVIpog
         MhU6LXsQBcKcXEGVKTICWDHE4b3TeLi/PpXyLhcg6qHld/fcj1iZIBauL4E8wscKUNdH
         JFbhJWj1J99YmbaKGZQ309H7ktlkI6PGGJl7QDuE+YNsnNzu0l32TulfEG4TcfBQd50b
         jUxaHAt56dJVL6k96O2540/m9QDPtEdmTNOAh47UGJrfa5XoN73pydO2CDhJaCbf2Bhm
         Qd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SpluLSb5M+s3NGcaOf+w4QUNgjHtRfWcRhl5lA1mGO0=;
        b=p5BsUDwDcUPwi75z6aw+JnIW/EE7D1n9FKXv4knN8MJTlOpPPOyX3tXU9NvU9MIL4w
         N7kcSGuxunSt7up0nbHlg4QnNyQ6obmfxea7czj5mT5myMBEov1XjrsgfnuGYxyI5gti
         rlYalxyYcK6ybTLsIiUiHXjkemSwPs+e19MG+xaC1wJU48b/7mj5XzHJXA9Mr1nd4Hok
         WfG+eJVy911IG8+BM0CZfTlADn74TVVT4CAxEfWsuvRZfc6VoECUvoxX63rvqJtSx+3v
         6ejhevaBYMdTLHTrGybHVrRaVaaTTBEKMbpie+8M3KsxoxTYkgT8AYpc+nOqG/9+lYMs
         U7sw==
X-Gm-Message-State: AOAM531AYfkmwlyQEyKVqgUU9t5sQPeK0alGfRoCILFbH69kq4GEZ2Ef
        ga9C+v4zfxno73wvLIwDIWt3vLE9JRI=
X-Google-Smtp-Source: ABdhPJz5e4Ng3i/51XVWbbzNkZ213MZT5wIFYMrOkE+nXsuYWXvNZEatqNWoTkDoXYk48bE1GvZg8A==
X-Received: by 2002:a5d:5387:: with SMTP id d7mr60779758wrv.417.1609364273399;
        Wed, 30 Dec 2020 13:37:53 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.61])
        by smtp.gmail.com with ESMTPSA id 125sm8823626wmc.27.2020.12.30.13.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 13:37:52 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/4] io_uring: fix io_sqe_files_unregister() hangs
Date:   Wed, 30 Dec 2020 21:34:15 +0000
Message-Id: <9b74cd49be3e72b9b4026e98a61706348e3fcc29.1609361865.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609361865.git.asml.silence@gmail.com>
References: <cover.1609361865.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

io_sqe_files_unregister() uninterruptibly waits for enqueued ref nodes,
however requests keeping them may never complete, e.g. because of some
userspace dependency. Make sure it's interruptible otherwise it would
hang forever.

Cc: stable@vger.kernel.org # 5.6+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6372aba8d0c2..ca46f314640b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -992,6 +992,10 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node);
+static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
+			struct io_ring_ctx *ctx);
+
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     struct io_comp_state *cs);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
@@ -7244,11 +7248,15 @@ static void io_sqe_files_set_node(struct fixed_file_data *file_data,
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *ref_node = NULL;
+	struct fixed_file_ref_node *backup_node, *ref_node = NULL;
 	unsigned nr_tables, i;
+	int ret;
 
 	if (!data)
 		return -ENXIO;
+	backup_node = alloc_fixed_file_ref_node(ctx);
+	if (!backup_node)
+		return -ENOMEM;
 
 	spin_lock_bh(&data->lock);
 	ref_node = data->node;
@@ -7260,7 +7268,18 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 	/* wait for all refs nodes to complete */
 	flush_delayed_work(&ctx->file_put_work);
-	wait_for_completion(&data->done);
+	do {
+		ret = wait_for_completion_interruptible(&data->done);
+		if (!ret)
+			break;
+		ret = io_run_task_work_sig();
+		if (ret < 0) {
+			percpu_ref_resurrect(&data->refs);
+			reinit_completion(&data->done);
+			io_sqe_files_set_node(data, backup_node);
+			return ret;
+		}
+	} while (1);
 
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
@@ -7271,6 +7290,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
+	destroy_fixed_file_ref_node(backup_node);
 	return 0;
 }
 
-- 
2.24.0

