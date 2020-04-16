Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC041ACCA6
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636744AbgDPQD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895247AbgDPN0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:26:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA95921BE5;
        Thu, 16 Apr 2020 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043569;
        bh=oFfPQ6Bf8DAZRs7NqaUhktac5dENLO/XxhR2sJb2B4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm2wyzMjONM7LOq3lUDk6Yyw1dYDu+pXC8vnFQxZ6VhmQ8BYPQUSkdYKItIOdVkzw
         J34j0WpxDabcqR5MOfoWQhvWSdVjd+6No9IeB/68OrFZZj6GigirpyhO+6S9OHNpxV
         2xkvlCXzMW5gxet2x6W3lzy2hxdt0TwTD+jxSfCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/146] rxrpc: Abstract out the calculation of whether theres Tx space
Date:   Thu, 16 Apr 2020 15:22:24 +0200
Message-Id: <20200416131242.886803103@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 158fe6665389964a1de212818b4a5c52b7f7aff4 ]

Abstract out the calculation of there being sufficient Tx buffer space.
This is reproduced several times in the rxrpc sendmsg code.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 250d3dae8af4d..7ee72053037a3 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -21,6 +21,21 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
+/*
+ * Return true if there's sufficient Tx queue space.
+ */
+static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_tx_win)
+{
+	unsigned int win_size =
+		min_t(unsigned int, call->tx_winsize,
+		      call->cong_cwnd + call->cong_extra);
+	rxrpc_seq_t tx_win = READ_ONCE(call->tx_hard_ack);
+
+	if (_tx_win)
+		*_tx_win = tx_win;
+	return call->tx_top - tx_win < win_size;
+}
+
 /*
  * Wait for space to appear in the Tx queue or a signal to occur.
  */
@@ -30,9 +45,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 {
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (call->tx_top - call->tx_hard_ack <
-		    min_t(unsigned int, call->tx_winsize,
-			  call->cong_cwnd + call->cong_extra))
+		if (rxrpc_check_tx_space(call, NULL))
 			return 0;
 
 		if (call->state >= RXRPC_CALL_COMPLETE)
@@ -72,9 +85,7 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
 		tx_win = READ_ONCE(call->tx_hard_ack);
-		if (call->tx_top - tx_win <
-		    min_t(unsigned int, call->tx_winsize,
-			  call->cong_cwnd + call->cong_extra))
+		if (rxrpc_check_tx_space(call, &tx_win))
 			return 0;
 
 		if (call->state >= RXRPC_CALL_COMPLETE)
@@ -305,9 +316,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			_debug("alloc");
 
-			if (call->tx_top - call->tx_hard_ack >=
-			    min_t(unsigned int, call->tx_winsize,
-				  call->cong_cwnd + call->cong_extra)) {
+			if (!rxrpc_check_tx_space(call, NULL)) {
 				ret = -EAGAIN;
 				if (msg->msg_flags & MSG_DONTWAIT)
 					goto maybe_error;
-- 
2.20.1



