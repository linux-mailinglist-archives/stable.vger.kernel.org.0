Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33F041230E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346445AbhITSUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377344AbhITSSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F20D61A71;
        Mon, 20 Sep 2021 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158577;
        bh=o3UecA5NoXInC+2F7XnJOOzYfdBMDOub+0YzEM8KmZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWLSkSkEeqtRA7ZD16wM3L8kZPz+UFDzP6HWjLy/50SitS3AaKIoomJo54GCw/l+z
         HzrrjHXNsQFmSQdL181Zq8i6vSaZh8Z4WVw60KpxdAIlfU/Vy/aJy1x7jwNefBzQJu
         5Fhm7Pt+jTT59SSX5Itb4FU+4gkr0h3r01UDIooc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 219/260] events: Reuse value read using READ_ONCE instead of re-reading it
Date:   Mon, 20 Sep 2021 18:43:57 +0200
Message-Id: <20210920163938.552568331@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
@@ -9259,7 +9259,7 @@ static void perf_event_addr_filters_appl
 		return;
 
 	if (ifh->nr_file_filters) {
-		mm = get_task_mm(event->ctx->task);
+		mm = get_task_mm(task);
 		if (!mm)
 			goto restart;
 


