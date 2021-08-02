Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C253DDA03
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhHBOF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236941AbhHBOE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 825A261248;
        Mon,  2 Aug 2021 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912673;
        bh=fDY5j7NozrVdR1l8mdgAIegFL1bpeX6/1+UgZgfM908=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j65OqFPPU7anIdEvPBxxr99hlHMkfDmhLoxZ3HlSc0+MjTR0aAsOXmjJCkVJMQbFm
         I+SsAJ7k100o7etnQ2nsjkdbnUtDUwpTRZr1JM86e+vH1Tbm1A2xgPuLefXyuUxDks
         gv3wwcQnFSAutfmkRiqpDcDIgr+yIHtLqRBhdCuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Forza <forza@tnonline.net>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 100/104] io_uring: fix race in unified task_work running
Date:   Mon,  2 Aug 2021 15:45:37 +0200
Message-Id: <20210802134347.295977332@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 110aa25c3ce417a44e35990cf8ed22383277933a upstream.

We use a bit to manage if we need to add the shared task_work, but
a list + lock for the pending work. Before aborting a current run
of the task_work we check if the list is empty, but we do so without
grabbing the lock that protects it. This can lead to races where
we think we have nothing left to run, where in practice we could be
racing with a task adding new work to the list. If we do hit that
race condition, we could be left with work items that need processing,
but the shared task_work is not active.

Ensure that we grab the lock before checking if the list is empty,
so we know if it's safe to exit the run or not.

Link: https://lore.kernel.org/io-uring/c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net/
Cc: stable@vger.kernel.org # 5.11+
Reported-by: Forza <forza@tnonline.net>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1899,7 +1899,7 @@ static void tctx_task_work(struct callba
 
 	clear_bit(0, &tctx->task_state);
 
-	while (!wq_list_empty(&tctx->task_list)) {
+	while (true) {
 		struct io_ring_ctx *ctx = NULL;
 		struct io_wq_work_list list;
 		struct io_wq_work_node *node;
@@ -1909,6 +1909,9 @@ static void tctx_task_work(struct callba
 		INIT_WQ_LIST(&tctx->task_list);
 		spin_unlock_irq(&tctx->task_lock);
 
+		if (wq_list_empty(&list))
+			break;
+
 		node = list.first;
 		while (node) {
 			struct io_wq_work_node *next = node->next;


