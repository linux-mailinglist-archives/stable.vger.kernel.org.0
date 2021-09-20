Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759164120B5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbhITR5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355534AbhITRzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:55:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF34630EB;
        Mon, 20 Sep 2021 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158038;
        bh=ro9eXygaxziXoFPjRZWajSkH9K2s6i0v54gIEpP8jck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kZcUm2al2sPikzb/Qtbh0/JOB9ncgBWKT9o6/+IqCNxjfYS8cdDnq8wPw8UjgoZG
         sTdFsF3ClAjhAaSTSMFfyAwv7B7Cv1TeyjNoVYoQMmfrEaMJoYTS4wAMkhBw9GM3v0
         ZcF3LnHCbtFUEMMZ/91zdmzK6TiYJnMk8FormREU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 4.19 266/293] events: Reuse value read using READ_ONCE instead of re-reading it
Date:   Mon, 20 Sep 2021 18:43:48 +0200
Message-Id: <20210920163942.508457426@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -8914,7 +8914,7 @@ static void perf_event_addr_filters_appl
 		return;
 
 	if (ifh->nr_file_filters) {
-		mm = get_task_mm(event->ctx->task);
+		mm = get_task_mm(task);
 		if (!mm)
 			goto restart;
 


