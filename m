Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB184A43FF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350919AbiAaLZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56054 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377602AbiAaLXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97C8E60ED0;
        Mon, 31 Jan 2022 11:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BC5C340E8;
        Mon, 31 Jan 2022 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628190;
        bh=ZOL6rUN3wT1gBttG/d1EVyzJDAYDIoRciQx+cPr5nZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szAaO1r31LGCd//5g4PfT1CCAUN9c1wrX7bNXdawJDMFBIQnuQlRt/wrCkxjdt0nt
         KFiEsErAUykWAmyz1cMV29VYmT2OqCpmHLWr7S4244KA14O9BDE5O9R0WFog/5Y3lC
         HmPeov43AM8oD26JN6PeVa7lMGNWdQ6UQUkWjYFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Yudaken <dylany@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 153/200] io_uring: fix bug in slow unregistering of nodes
Date:   Mon, 31 Jan 2022 11:56:56 +0100
Message-Id: <20220131105238.710162802@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
index 15f303180d70c..698db7fb62e06 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7761,10 +7761,15 @@ static __cold void io_rsrc_node_ref_zero(struct percpu_ref *ref)
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
@@ -7777,7 +7782,7 @@ static __cold void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (first_add)
-		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
+		mod_delayed_work(system_wq, &ctx->rsrc_put_work, delay);
 }
 
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-- 
2.34.1



