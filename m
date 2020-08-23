Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D48024EF0E
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 19:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHWRfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 13:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgHWRfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 13:35:38 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17845C061573;
        Sun, 23 Aug 2020 10:35:38 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so2650081edn.8;
        Sun, 23 Aug 2020 10:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhZn5iplZfVv2iHxZYHx5EH11yZHLF/xgxbFt5zcxMI=;
        b=czjVz3Qpf9F2LM3ydzqJAaOb6tQSum6uy2cnKW1j9Da2zRoKaBiThKyltRNi46GFUO
         9RZWw1FBl0ScBM1myJmWdjjJpz500DBF13lJkqO9gKFMGz6zi1krW3WWcHWTRzTw30rN
         kEhMDDAdG4Ozi5L0Ki5ziNUo30VuyiatQaVOWnSeSuM/bdiBzJ1fFuaJr8WzTrlXUbWX
         5R+kE9WuqzO4kbtw9wW3M97Vkj0G66li0aKbPkxaA1UCr1s/blqos4kNwJmGauyWyhrU
         kjWz8X9TPTg1HdM5XYhtECxfF2D0RgLB0dwd1GTS5RJByLuStWcr9VkHdPxrAUf0ChTB
         R3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhZn5iplZfVv2iHxZYHx5EH11yZHLF/xgxbFt5zcxMI=;
        b=I0ohBwX7H+WV0G0m6DNuLFsW9GTqUYvThx4bkhj2Ad12odaHifzSYAXFosldC74pa/
         8KQNY2eP4mrPB1KlZmjSwjf2scwcgxEzpPUAmfpFv5dN4bWeG7HvFoNe5LRVf1ds5oCK
         bICZivGGS6ngooP5+xYPh5Pr+ZViHgIYjkbslCvFsiTKKDwGHy0vK0OPcmZGF5z//EAx
         893RONUg/6n9NBFiQYP+PGZz2A/JoEQlvFhmXOmHPqdxFoZEvARzouwnziTIpBT6EoHG
         0c+K+dBOhIDxzxgBR5u2EMsZbSoTd0Nlhg7ci+nOtz8g46K8OWqY9F4nq0hOG7adkD4d
         WogA==
X-Gm-Message-State: AOAM531D3zx2dD/zbih2h3GPBH8IA3/h7viD12shLRWWAXzL1tYrwjca
        NuSOnToUNNgtYu0lmDWWlCw=
X-Google-Smtp-Source: ABdhPJy34JwBoWwr4MdQaUs03XiTpdmjQAqKazkDmarJFZlEVtw7P8myNj3zZ8+PvyPvSFbxzrB7GQ==
X-Received: by 2002:aa7:d293:: with SMTP id w19mr2077998edq.119.1598204136794;
        Sun, 23 Aug 2020 10:35:36 -0700 (PDT)
Received: from localhost.localdomain ([5.100.200.56])
        by smtp.gmail.com with ESMTPSA id s4sm7004086ejx.94.2020.08.23.10.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 10:35:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Dmitry Shulyak <yashulyak@gmail.com>
Subject: [PATCH] io-wq: fix hang after cancelling pending work
Date:   Sun, 23 Aug 2020 20:33:10 +0300
Message-Id: <c62b225cc7019d0a8ef686d0f87dd1612d9768ab.1598203901.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Don't forget to update wqe->hash_tail after cancelling a pending work.

Cc: stable@vger.kernel.org # 5.7+
Reported-by: Dmitry Shulyak <yashulyak@gmail.com>
Fixes: 86f3cd1b589a1 ("io-wq: handle hashed writes in chains")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e92c4724480c..414beb543883 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -925,6 +925,24 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
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
@@ -938,8 +956,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-
-		wq_list_del(&wqe->work_list, node, prev);
+		io_wqe_remove_pending(wqe, work, prev);
 		spin_unlock_irqrestore(&wqe->lock, flags);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
-- 
2.24.0

