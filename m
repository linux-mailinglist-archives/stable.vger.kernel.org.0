Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E703C60034A
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 22:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJPUfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 16:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJPUfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 16:35:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7DE36DF0
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:41 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k2so20877532ejr.2
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 13:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/XTxTx296mPahVjfKrCEKXWZOpc8BOdYHP5fra/6L4=;
        b=Okq189H//qwOHYKkbFy9/GVfMmdLseDyhj5zDcLonO4qKcApPpmQOlBARUxPFgVDzN
         a1i5Mlbp2yk+j67c+PZKszHWG+HhcJsChIt7WTLDog21smEj9c6TWbSIxVcHLRLCmMqI
         uTut1WsDnarWGa/Rv/FEbYPtlVADNCUE+W/hSg/E/UFafTVUNTesfmL8as7uww/s3uop
         7ffKFohq/qvVU0jmz0xTJ3vNCX04CAOtOZgDQM4cz9YBrwWWb+QOsT/vs9NRzj7idNZk
         /Ac7PuiTH8LrnT4YOJfuJZiL2GhFk7ZaX2bTPGc5J4dmYFS6v0Q5/e4a3klbWa33yo7u
         ZyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/XTxTx296mPahVjfKrCEKXWZOpc8BOdYHP5fra/6L4=;
        b=zKml2CIt8pWgYDyCwsYMXe6QKsuji6bpn4WBFuY5NoyhBn/nDBBl1xd/ZV3CUbg7Sa
         xYWfNTJUrSoOwTIHl0IszFI1yaBklFaMObVtvRxPBAT0b8wsMFqeQP31i9OjTX5rHzPC
         OCpRTPVmyc55IRP22FTRSKatAa/Ovb5lfAoA+JRbIN0KkJv34+QN2cwfA7AlkHgK80ex
         aSSW/RP7g3d2CNp+fziYhlbhdHJWwbZ4ASxr2EfZvYQNuwM433dqZQYRMHVTCW5tx/Ax
         s24NItPqvdf9VuShnxBk7qbdUQTiInBeYbf8mM8u6LBA2bpgcbP5XGsUsWhwInJajzSA
         CHTA==
X-Gm-Message-State: ACrzQf0l7QevnwXB1gleF0BbnHBgS/x4TaLwe6zXzYf69vvrQeSvU/l1
        DTfYRVg9o99yi9s0IYNkviXHG/6NVew=
X-Google-Smtp-Source: AMsMyM45danj5cuMD+ERT4yJhIgfFgoqB6nh8SWpeoYYaigp2R8mBHloUs8wW9fj6TFsoO5j7XJA9Q==
X-Received: by 2002:a17:906:2bc7:b0:72f:dc70:a3c6 with SMTP id n7-20020a1709062bc700b0072fdc70a3c6mr6270772ejg.645.1665952539318;
        Sun, 16 Oct 2022 13:35:39 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id m3-20020a170906160300b0078194737761sm5008083ejd.124.2022.10.16.13.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:35:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-6.0 3/6] io_uring/net: don't lose partial send_zc on fail
Date:   Sun, 16 Oct 2022 21:33:27 +0100
Message-Id: <3493fc0ee75f3cf8a111e2e8e1a35f833f29aaf2.1665951939.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665951939.git.asml.silence@gmail.com>
References: <cover.1665951939.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 5693bcce892d7b8b15a7a92b011d3d40a023b53c ]

Partial zc send may end up in io_req_complete_failed(), which not only
would return invalid result but also mask out the notification leading
to lifetime issues.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5673285b5e83e6ceca323727b4ddaa584b5cc91e.1663668091.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 16 ++++++++++++++++
 io_uring/net.h   |  1 +
 io_uring/opdef.c |  1 +
 3 files changed, 18 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3e9ab7a1abec..83cb8f1f6672 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1089,6 +1089,22 @@ void io_sendrecv_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+void io_send_zc_fail(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int res = req->cqe.res;
+
+	if (req->flags & REQ_F_PARTIAL_IO) {
+		if (req->flags & REQ_F_NEED_CLEANUP) {
+			io_notif_flush(sr->notif);
+			sr->notif = NULL;
+			req->flags &= ~REQ_F_NEED_CLEANUP;
+		}
+		res = sr->done_io;
+	}
+	io_req_set_res(req, res, req->cqe.flags);
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
diff --git a/io_uring/net.h b/io_uring/net.h
index 109ffb3a1a3f..e7366aac335c 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -58,6 +58,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_sendzc_cleanup(struct io_kiocb *req);
+void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
 #else
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 5768620b075d..7f85e0fbd60b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -488,6 +488,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_sendzc,
 		.prep_async		= io_sendzc_prep_async,
 		.cleanup		= io_sendzc_cleanup,
+		.fail			= io_send_zc_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.38.0

