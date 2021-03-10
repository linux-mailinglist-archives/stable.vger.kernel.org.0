Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4CD333B8C
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhCJLhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhCJLf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:35:29 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DE2C0613D8
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:59 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c76-20020a1c9a4f0000b029010c94499aedso10797021wme.0
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JCtKQy15zflAuiK4ea0MNzRFxqYEeFBJ73NPBIh48DU=;
        b=g3TB8rNGrsAkudYLtRZa4nuZ4DzF7/FjVbf9a/AZPJaOmNm5zaIeErxPxgCEm3U+mn
         8xc5yapPHVoMMVMd6D9uBm1PxQ4W3T0WfW1Jhg/onV80WPWG2ANX8lLrFkjFu2f0hZlV
         zubrxi/kuap63JNDpjIxXtwASEO2t6ttls5USdiKfQeL5EbHGpBjKp/IZ83WEV9QPtIo
         YR3kuO6dTJ6d7iOhKO1okRbXieSqv4KcMj8U7yx4Pb4IwNBlJzKQpm214sriVCloA1ij
         c1ZZ9rLSMuuChY5ebbOZNR1aurSNX3zc4xpv8c3Chbw975v5eGw0125OTKdNSdzfzrE7
         iaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JCtKQy15zflAuiK4ea0MNzRFxqYEeFBJ73NPBIh48DU=;
        b=B+aIHU5YrXbqlBdbwD63x+KhIj8imD6M/+yKIpnhfEMKm/AT2sqv8YZ/WOPxMz3uz9
         +Hokis7oy13xNb6/ackpD90+KHgMiqnDluC4jbfCkTXoNTuyz3t1sNx1vr1KuMxXF7eT
         c9GzBC1/lZmdb7uN7rxqOoftngVB13oGlMfVwvv8gI0sxqFqgDZrD+dW73qnivBz/KJH
         LObpZjlRQ6GSeBQ/tHXMMIXG85LbtNYxXNeQf+Zp2tBELWNim8C+52DTDCAKK8mQq0pd
         +bZioJZ5rgtPk7j9WZjbR65WjflotU+vZRLJEhkt38pXAFxufw4WWq7xOYCp3+KFJ11V
         mYMQ==
X-Gm-Message-State: AOAM53214P1c4inZ8g8nlxAQWDTigmKplQPyexbXBjcEkvVKti4RpBs0
        PS3kIEzhJ90bdPDwUHXCTV1l8gxXX9qZkw==
X-Google-Smtp-Source: ABdhPJxI7htNtNxWwf2ptwwNB4mqQusjTSEZnfMQgwPUmdsUWWrF6tGlEjWROQ0Nve2G/S+yjQ0YdQ==
X-Received: by 2002:a1c:f701:: with SMTP id v1mr2929521wmh.182.1615376098295;
        Wed, 10 Mar 2021 03:34:58 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring/io-wq: kill off now unused IO_WQ_WORK_NO_CANCEL
Date:   Wed, 10 Mar 2021 11:30:43 +0000
Message-Id: <0a53f04021951888af40f5e487d593c4ac39b244.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 4014d943cb62db892eb023d385a966a3fce5ee4c upstream

It's no longer used as IORING_OP_CLOSE got rid for the need of flagging
it as uncancelable, kill it of.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    | 1 -
 fs/io-wq.h    | 1 -
 fs/io_uring.c | 5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a564f36e260c..2e2f14f42bf2 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -944,7 +944,6 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	 */
 	spin_lock_irqsave(&worker->lock, flags);
 	if (worker->cur_work &&
-	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL) &&
 	    match->fn(worker->cur_work, match->data)) {
 		send_sig(SIGINT, worker->task, 1);
 		match->nr_running++;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index b158f8addcf3..e1ffb80a4a1d 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -9,7 +9,6 @@ enum {
 	IO_WQ_WORK_CANCEL	= 1,
 	IO_WQ_WORK_HASHED	= 2,
 	IO_WQ_WORK_UNBOUND	= 4,
-	IO_WQ_WORK_NO_CANCEL	= 8,
 	IO_WQ_WORK_CONCURRENT	= 16,
 
 	IO_WQ_WORK_FILES	= 32,
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d03689d0e47..5ebc05f41c19 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6388,11 +6388,8 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
-	/* if NO_CANCEL is set, we must still run the work */
-	if ((work->flags & (IO_WQ_WORK_CANCEL|IO_WQ_WORK_NO_CANCEL)) ==
-				IO_WQ_WORK_CANCEL) {
+	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
-	}
 
 	if (!ret) {
 		do {
-- 
2.24.0

