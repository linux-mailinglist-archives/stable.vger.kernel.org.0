Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9159168D
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 23:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiHLVD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 17:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiHLVD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 17:03:26 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C08B3B3C
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:03:25 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id 130so1665528pfy.6
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=7p6Y8/i9Zud4dD3OXaD9CJ5omkHnOmb9qmsVs/S95A0=;
        b=oXmA5dsXWPDC9YFZxkW7FIgE1a9kV5mGcvIHeIbbEMy0NMC5eqFIing14YgcCt5AXU
         uvAUafO5ACiZAnZ7zeBMURM84yWUxVODkC/Y6cGLlrGW9GOGACz+zb74y3oAXraQRxSN
         Vcn01fOLT5q9GSyQHzm+uNx4TlJPKw+TEljeYYOYzLFGNDefNB1Ndky/vJpNWcI6YTXV
         vmMYp195OUgRoQR/6bazXf/IkU1p/jji/nSaEx7w1H6qommQgvFTezu6EUQhpDH6N12o
         IIU5Q6JEVqet5EnuP6V6KGd3HMgt7ItLIc4QFLl9M0rxlmV7XZNVS6tKx8ZMkClhkLag
         ciSw==
X-Gm-Message-State: ACgBeo1FdyJfGSNZ8iXg3OyKpJst4AnPvaZe1YndWLJRsjyd9UJw+O0P
        ELYPw1+gvP6gWZMtjepDsrYPKWo+uFM=
X-Google-Smtp-Source: AA6agR4b5Ebg4rl6xrMSIlbgQQL0EZIjjsnB9+lkTLwQZYDbUX76R/E8Vsv737QCf36Da0U4cXUdbg==
X-Received: by 2002:a05:6a00:2185:b0:520:7276:6570 with SMTP id h5-20020a056a00218500b0052072766570mr5644987pfi.84.1660338205210;
        Fri, 12 Aug 2022 14:03:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2414:9f13:41de:d21d])
        by smtp.gmail.com with ESMTPSA id c13-20020a170903234d00b0016c1a1c1405sm2218519plh.222.2022.08.12.14.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 14:03:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
Subject: [PATCH] nvmet: Fix a use-after-free
Date:   Fri, 12 Aug 2022 14:03:17 -0700
Message-Id: <20220812210317.2252051-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the following use-after-free complaint triggered by blktests nvme/004:

BUG: KASAN: user-memory-access in blk_mq_complete_request_remote+0xac/0x350
Read of size 4 at addr 0000607bd1835943 by task kworker/13:1/460
Workqueue: nvmet-wq nvme_loop_execute_work [nvme_loop]
Call Trace:
 show_stack+0x52/0x58
 dump_stack_lvl+0x49/0x5e
 print_report.cold+0x36/0x1e2
 kasan_report+0xb9/0xf0
 __asan_load4+0x6b/0x80
 blk_mq_complete_request_remote+0xac/0x350
 nvme_loop_queue_response+0x1df/0x275 [nvme_loop]
 __nvmet_req_complete+0x132/0x4f0 [nvmet]
 nvmet_req_complete+0x15/0x40 [nvmet]
 nvmet_execute_io_connect+0x18a/0x1f0 [nvmet]
 nvme_loop_execute_work+0x20/0x30 [nvme_loop]
 process_one_work+0x56e/0xa70
 worker_thread+0x2d1/0x640
 kthread+0x183/0x1c0
 ret_from_fork+0x1f/0x30

Cc: stable@vger.kernel.org
Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/nvme/target/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index a1345790005f..7f4083cf953a 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -735,6 +735,8 @@ static void nvmet_set_error(struct nvmet_req *req, u16 status)
 
 static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_ns *ns = req->ns;
+
 	if (!req->sq->sqhd_disabled)
 		nvmet_update_sq_head(req);
 	req->cqe->sq_id = cpu_to_le16(req->sq->qid);
@@ -745,9 +747,9 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 	trace_nvmet_req_complete(req);
 
-	if (req->ns)
-		nvmet_put_namespace(req->ns);
 	req->ops->queue_response(req);
+	if (ns)
+		nvmet_put_namespace(ns);
 }
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
