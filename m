Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDD1676E94
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjAVPMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjAVPMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:12:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996B521955
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:12:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E2D760C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE97C433EF;
        Sun, 22 Jan 2023 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400319;
        bh=LRp9/HvJhqNRzsDfyAIVIb42UnLc2RXTLgWhD5XWebo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNpbVKloEz+o3LRx+Lk36dTKiZye32JeQwH0pbs+HWg7U1+ya0zn2MrjPHBPlDkJx
         P1tSh6XuF0qo52STAJMJgGD+NkeUUb6YPDEX/8xYMoGdf7X1yR56f9lAqxmpV48SE6
         ZemoTAHF5yNquBMzLw0wPttbkUfF1wPoLav7E8+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Homin Rhee <hominlab@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/98] io_uring: ensure that cached task references are always put on exit
Date:   Sun, 22 Jan 2023 16:03:46 +0100
Message-Id: <20230122150230.744584618@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit e775f93f2ab976a2cdb4a7b53063cbe890904f73 upstream.

io_uring caches task references to avoid doing atomics for each of them
per request. If a request is put from the same task that allocated it,
then we can maintain a per-ctx cache of them. This obviously relies
on io_uring always pruning caches in a reliable way, and there's
currently a case off io_uring fd release where we can miss that.

One example is a ring setup with IOPOLL, which relies on the task
polling for completions, which will free them. However, if such a task
submits a request and then exits or closes the ring without reaping
the completion, then ring release will reap and put. If release happens
from that very same task, the completed request task refs will get
put back into the cache pool. This is problematic, as we're now beyond
the point of pruning caches.

Manually drop these caches after doing an IOPOLL reap. This releases
references from the current task, which is enough. If another task
happens to be doing the release, then the caching will not be
triggered and there's no issue.

Cc: stable@vger.kernel.org
Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
Reported-by: Homin Rhee <hominlab@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8852d56b1ec..f8a0d228d799 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -9513,6 +9513,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
 
+	/* drop cached put refs after potentially doing completions */
+	if (current->io_uring)
+		io_uring_drop_tctx_refs(current);
+
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
 	 * Use system_unbound_wq to avoid spawning tons of event kworkers
-- 
2.39.0



