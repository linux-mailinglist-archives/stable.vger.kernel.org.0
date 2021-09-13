Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C614095E5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346127AbhIMOqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347635AbhIMOoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12DEB63218;
        Mon, 13 Sep 2021 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541453;
        bh=13A01LPjfB4eZPKnfQC7GBgeot9w4T5Qi5wyGWRiV/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz+d404ZeSfU2CWtbSOyxOK055Lf0wKiKPwIDBrSKpCBFnHk5UimzAA/qwaqtgvR7
         vGx319CT1a9Bv+HIC7hi0vNlu+ypvRoLomaLtx8D/h0Swn0Fa1fLzR4cTSuyZWSZ6I
         vpKNNALQpAmWYc0FlCfcVYTqGtFcJj2VWbWf7y+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 302/334] io_uring: io_uring_complete() trace should take an integer
Date:   Mon, 13 Sep 2021 15:15:56 +0200
Message-Id: <20210913131123.628995207@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 2fc2a7a62eb58650e71b4550cf6fa6cc0a75b2d2 upstream.

It currently takes a long, and while that's normally OK, the io_uring
limit is an int. Internally in io_uring it's an int, but sometimes it's
passed as a long. That can yield confusing results where a completions
seems to generate a huge result:

ou-sqp-1297-1298    [001] ...1   788.056371: io_uring_complete: ring 000000000e98e046, user_data 0x0, result 4294967171, cflags 0

which is due to -ECANCELED being stored in an unsigned, and then passed
in as a long. Using the right int type, the trace looks correct:

iou-sqp-338-339     [002] ...1    15.633098: io_uring_complete: ring 00000000e0ac60cf, user_data 0x0, result -125, cflags 0

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/io_uring.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -295,14 +295,14 @@ TRACE_EVENT(io_uring_fail_link,
  */
 TRACE_EVENT(io_uring_complete,
 
-	TP_PROTO(void *ctx, u64 user_data, long res, unsigned cflags),
+	TP_PROTO(void *ctx, u64 user_data, int res, unsigned cflags),
 
 	TP_ARGS(ctx, user_data, res, cflags),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
 		__field(  u64,		user_data	)
-		__field(  long,		res		)
+		__field(  int,		res		)
 		__field(  unsigned,	cflags		)
 	),
 
@@ -313,7 +313,7 @@ TRACE_EVENT(io_uring_complete,
 		__entry->cflags		= cflags;
 	),
 
-	TP_printk("ring %p, user_data 0x%llx, result %ld, cflags %x",
+	TP_printk("ring %p, user_data 0x%llx, result %d, cflags %x",
 			  __entry->ctx, (unsigned long long)__entry->user_data,
 			  __entry->res, __entry->cflags)
 );


