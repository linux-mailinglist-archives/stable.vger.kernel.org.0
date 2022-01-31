Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1444A4396
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376826AbiAaLWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378567AbiAaLUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7972CC0604E0;
        Mon, 31 Jan 2022 03:13:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 423EFB82A68;
        Mon, 31 Jan 2022 11:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A03CC340EF;
        Mon, 31 Jan 2022 11:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627584;
        bh=sma2kF7fZ2hrPJD51josc/hmml8bvTprpLz0JUxpocc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xV/uhD06eMmvU/ablT9+I5JI/vi4qnaOnhsmbQpWLhC9BhKuJbvwz9z0A7zCHXyqm
         4Dg8D94JQolJB+257sUBbII3agy6+CLkzZ9ZAiC8FloJ27vf+DoziEs7njoanaNcb7
         IXgcP6YoY/JR+4a30Gol61mplXjYAqkHRQCjVTR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/171] io_uring: fix bug in slow unregistering of nodes
Date:   Mon, 31 Jan 2022 11:56:35 +0100
Message-Id: <20220131105234.408836669@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@fb.com>

[ Upstream commit b36a2050040b2d839bdc044007cdd57101d7f881 ]

In some cases io_rsrc_ref_quiesce will call io_rsrc_node_switch_start,
and then immediately flush the delayed work queue &ctx->rsrc_put_work.

However the percpu_ref_put does not immediately destroy the node, it
will be called asynchronously via RCU. That ends up with
io_rsrc_node_ref_zero only being called after rsrc_put_work has been
flushed, and so the process ends up sleeping for 1 second unnecessarily.

This patch executes the put code immediately if we are busy
quiescing.

Fixes: 4a38aed2a0a7 ("io_uring: batch reap of dead file registrations")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220121123856.3557884-1-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f713b91537f41..993913c585fbf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7718,10 +7718,15 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
 	unsigned long flags;
 	bool first_add = false;
+	unsigned long delay = HZ;
 
 	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done = true;
 
+	/* if we are mid-quiesce then do not delay */
+	if (node->rsrc_data->quiesce)
+		delay = 0;
+
 	while (!list_empty(&ctx->rsrc_ref_list)) {
 		node = list_first_entry(&ctx->rsrc_ref_list,
 					    struct io_rsrc_node, node);
@@ -7734,7 +7739,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-- 
2.34.1



