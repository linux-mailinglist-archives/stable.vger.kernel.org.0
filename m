Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63847411C7D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbhITRKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238404AbhITRH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 298EE61205;
        Mon, 20 Sep 2021 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156952;
        bh=Agg3vYpoBwOvnbNhr7OJidNa9a79zLnmyMSVN8MkVqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO3b4bl4rDNUt8rDLzC/APB2zoQrmDr0N6kuqk7ouAiZgNnjHGeprXTLbBp020hDO
         DwK5YcOP/Ur1KZ8LXUMvL6iQUDnGIVMw2a0EZGQ9sHK/w5KGM7A6ltHdWbN5vP1I3T
         2eZ+PBhzwyWb7cppVz2LtOJ2vHmSHp/nY+u4BNFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.9 161/175] events: Reuse value read using READ_ONCE instead of re-reading it
Date:   Mon, 20 Sep 2021 18:43:30 +0200
Message-Id: <20210920163923.332064010@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baptiste Lepers <baptiste.lepers@gmail.com>

commit b89a05b21f46150ac10a962aa50109250b56b03b upstream.

In perf_event_addr_filters_apply, the task associated with
the event (event->ctx->task) is read using READ_ONCE at the beginning
of the function, checked, and then re-read from event->ctx->task,
voiding all guarantees of the checks. Reuse the value that was read by
READ_ONCE to ensure the consistency of the task struct throughout the
function.

Fixes: 375637bc52495 ("perf/core: Introduce address range filtering")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210906015310.12802-1-baptiste.lepers@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8115,7 +8115,7 @@ static void perf_event_addr_filters_appl
 	if (task == TASK_TOMBSTONE)
 		return;
 
-	mm = get_task_mm(event->ctx->task);
+	mm = get_task_mm(task);
 	if (!mm)
 		goto restart;
 


