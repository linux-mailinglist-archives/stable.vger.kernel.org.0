Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A887412535
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349278AbhITSmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382299AbhITSkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F48663336;
        Mon, 20 Sep 2021 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159061;
        bh=2GJuYlt5+/+RNZzlYfYMWvApPEszUcLLoEHpH35uNAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWUDfWlDB53nf7c5j000sQIWOK8v0pq+LcUaluoJwdXXt4TOGm9YiplWPyviHuGYs
         uHVtoJ0TG6zHLjyuwZB8mOaeho0YRmbpKnbYoSSgCtYUycQulTXCOS4BO+MTErJHJK
         /ui3NH5oWBq1KNHc8r7dj/Yd2XFvr9nW1Kdc9vVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.14 057/168] events: Reuse value read using READ_ONCE instead of re-reading it
Date:   Mon, 20 Sep 2021 18:43:15 +0200
Message-Id: <20210920163923.518240867@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -10192,7 +10192,7 @@ static void perf_event_addr_filters_appl
 		return;
 
 	if (ifh->nr_file_filters) {
-		mm = get_task_mm(event->ctx->task);
+		mm = get_task_mm(task);
 		if (!mm)
 			goto restart;
 


