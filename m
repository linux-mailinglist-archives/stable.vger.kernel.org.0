Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A804123E0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348547AbhITS21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44429 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378767AbhITS0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 870B5632D8;
        Mon, 20 Sep 2021 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158741;
        bh=D4VPni84wF61EId2NBulzn8VIIU1JAIKWC1+gu20/mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkKBX3gUX3vX20dTOpIAH8m0knAlw08MTRutkLLJf6PC5qrhczipdvdvil9jyUmJZ
         dTtZc64kF6D8w1zi43WSEj+lZudRrz61PgbKWo+PoNxnwkK58/64Z1in5K6K+kJdd5
         5OSMSldLDv2ygRh+Rww+s0Cx5iFu8gsa8micJUrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 035/122] events: Reuse value read using READ_ONCE instead of re-reading it
Date:   Mon, 20 Sep 2021 18:43:27 +0200
Message-Id: <20210920163916.946304990@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
@@ -9973,7 +9973,7 @@ static void perf_event_addr_filters_appl
 		return;
 
 	if (ifh->nr_file_filters) {
-		mm = get_task_mm(event->ctx->task);
+		mm = get_task_mm(task);
 		if (!mm)
 			goto restart;
 


